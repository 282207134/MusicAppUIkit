import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/music_store.dart';
import 'screens/account_screens.dart';
import 'screens/auth_screens.dart';
import 'screens/browse_screens.dart';
import 'screens/player_screen.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key, required this.store, this.initialRoute});
  final MusicStore store;
  final String? initialRoute;
  @override
  Widget build(BuildContext context) => MusicScope(
    store: store,
    child: MaterialApp(
      title: 'Music',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: initialRoute ?? (store.signedIn ? '/home' : '/onboarding'),
      onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
      onGenerateRoute: _route,
    ),
  );

  Route<void> _route(RouteSettings settings) {
    final page = switch (settings.name) {
      '/onboarding' => const OnboardingScreen(),
      '/login' => const AuthScreen(),
      '/register' => const AuthScreen(register: true),
      '/otp' => VerificationScreen(reset: settings.arguments == 'reset'),
      '/forgot_password' => const PasswordScreen(),
      '/reset_password' => const PasswordScreen(reset: true),
      '/home' => const HomeScreen(),
      '/upcoming' => const UpcomingScreen(),
      '/music' => const MusicScreen(),
      '/music_list' => const MusicScreen(expanded: true),
      '/artist' => ArtistScreen(artist: settings.arguments as String?),
      '/now_playing' => const PlayerScreen(),
      '/categories' => const CategoriesScreen(),
      '/profile' => const ProfileScreen(),
      '/following' => const FollowingScreen(),
      '/settings' => const SettingsScreen(),
      '/language' => const LanguageScreen(),
      '/cards' => const CardsScreen(),
      '/privacy' => const PrivacyScreen(),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
