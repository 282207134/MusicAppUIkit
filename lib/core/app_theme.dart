import 'package:flutter/material.dart';

abstract final class AppColors {
  static const pink = Color(0xFFFF2464), coral = Color(0xFFFF8D57);
  static const muted = Color(0xFF90959B), surface = Color(0xFF303030);
  static const gradient = LinearGradient(colors: [coral, pink]);
}

ThemeData appTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.pink,
    secondary: AppColors.pink,
    secondaryContainer: AppColors.pink,
    onSecondaryContainer: Colors.white,
    surface: AppColors.surface,
  ),
  fontFamily: 'Roboto',
  splashFactory: InkRipple.splashFactory,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    surfaceTintColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.muted),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.pink),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.surface,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);
