import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/app.dart';
import 'package:music_app/core/music_store.dart';
import 'package:music_app/data/catalog.dart';

const screenNames = [
  'onboarding',
  'login',
  'register',
  'otp',
  'forgot_password',
  'reset_password',
  'home',
  'upcoming',
  'music',
  'music_list',
  'artist',
  'now_playing',
  'categories',
  'profile',
  'following',
  'settings',
  'language',
  'cards',
  'privacy',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader('Roboto')
          ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf')))
        .load();
  });
  test('favorites, following and queue controls update shared state', () async {
    final store = MusicStore(audioEnabled: false);
    store.toggleFavorite('shape');
    expect(store.favorites, contains('shape'));
    store.toggleFavorite('shape');
    expect(store.favorites, isEmpty);
    store.toggleFollow('Justin Bieber');
    expect(store.followed, isNot(contains('Justin Bieber')));
    store.queue = playlistSongs;
    await store.playSong(playlistSongs.first);
    await store.skip(-1);
    expect(store.currentSong.id, playlistSongs.last.id);
    await store.seek(.5);
    expect(store.position.inSeconds, 15);
    await store.togglePlayback();
    expect(store.playing, isFalse);
    store.dispose();
  });

  for (final width in [414.0, 320.0]) {
    for (final screen in screenNames) {
      testWidgets('$screen lays out at width $width without overflow', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, width == 414 ? 896 : 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final store = MusicStore(audioEnabled: false);
        await tester.pumpWidget(
          MusicApp(store: store, initialRoute: '/$screen'),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(ValueKey('screen_$screen')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        store.dispose();
      });
    }
  }

  testWidgets('login validates input and reaches home', (tester) async {
    tester.view.physicalSize = const Size(414, 896);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = MusicStore(audioEnabled: false);
    await tester.pumpWidget(MusicApp(store: store, initialRoute: '/login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('field_email')), 'bad');
    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('field_email')),
      'demo@example.com',
    );
    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen_home')), findsOneWidget);
    expect(store.signedIn, isTrue);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });
}
