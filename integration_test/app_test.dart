import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/app.dart';
import 'package:music_app/core/music_store.dart';
import 'package:music_app/data/local_settings.dart';
import '../test/app_test.dart' show screenNames;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('capture every implemented screen on Android', (tester) async {
    await binding.convertFlutterSurfaceToImage();
    for (final screen in screenNames) {
      final store = MusicStore(audioEnabled: false);
      await tester.pumpWidget(
        MusicApp(key: UniqueKey(), store: store, initialRoute: '/$screen'),
      );
      await tester.pumpAndSettle();
      // Wait for every bundled image to decode before capturing a lazy grid.
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final imagePaths = assetManifest.listAssets().where(
        (path) => path.startsWith('assets/images/'),
      );
      final context = tester.element(find.byKey(ValueKey('screen_$screen')));
      await tester.runAsync(
        () => Future.wait(
          imagePaths.map((path) => precacheImage(AssetImage(path), context)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('screen_$screen')), findsOneWidget);
      expect(tester.takeException(), isNull);
      // PixelCopy can briefly lose its source after a route is replaced.
      // Give Android a fresh frame and retry only the screenshot operation.
      Object? captureError;
      for (var attempt = 0; attempt < 3; attempt++) {
        try {
          await tester.pump(const Duration(milliseconds: 250));
          final bytes = await binding.takeScreenshot(screen);
          // Keep the result compact: PNG bytes as integer arrays make the
          // final driver response much larger and can outlive the connection.
          binding.reportData!.remove('screenshots');
          final images =
              binding.reportData!.putIfAbsent(
                    'screenImages',
                    () => <String, String>{},
                  )
                  as Map<String, String>;
          images[screen] = base64Encode(bytes);
          captureError = null;
          break;
        } catch (error) {
          captureError = error;
          await tester.pump(const Duration(milliseconds: 500));
        }
      }
      if (captureError != null) throw captureError;
      await tester.pumpWidget(const SizedBox());
      store.dispose();
    }
  });

  testWidgets('real audio, favorites, card selection and persistence', (
    tester,
  ) async {
    final settings = LocalSettings();
    final store = MusicStore(settings: settings);
    await tester.pumpWidget(
      MusicApp(key: UniqueKey(), store: store, initialRoute: '/now_playing'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('player_play')));
    await tester.pump(const Duration(seconds: 2));
    expect(store.playbackError, isNull);
    expect(store.playing, isTrue);
    expect(store.duration.inSeconds, 30);
    await store.seek(.5);
    await tester.pump(const Duration(milliseconds: 300));
    expect(store.position.inSeconds, greaterThanOrEqualTo(14));
    await tester.tap(find.byKey(const ValueKey('favorite')));
    await tester.pump();
    expect(store.favorites, contains('let_me_love_you'));
    await store.togglePlayback();
    expect(store.playing, isFalse);
    await store.skip(1);
    await tester.pump(const Duration(milliseconds: 500));
    expect(store.currentSong.id, 'hold_on');
    await store.signOut();
    store.setLanguage('China');
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final restored = MusicStore(settings: settings, audioEnabled: false);
      await restored.restore();
      expect(restored.language, 'China');
      expect(restored.favorites, contains('let_me_love_you'));
      restored.dispose();
    });
    await tester.pumpWidget(
      MusicApp(key: UniqueKey(), store: store, initialRoute: '/cards'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('card_0')));
    await tester.tap(find.byKey(const ValueKey('pay_now')));
    await tester.pumpAndSettle();
    expect(find.textContaining('ending 7863'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm_demo_payment')));
    await tester.pumpAndSettle();
    expect(find.textContaining('No payment was processed'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
    // Return the installation to its clean, first-launch state.
    await settings.write('music_ui', '{}');
  });
}
