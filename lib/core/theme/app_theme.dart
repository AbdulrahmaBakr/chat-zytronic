import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF075E54),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF075E54),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF25D366),
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF25D366),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF202C33),
    scaffoldBackgroundColor: const Color(0xFF121B22),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF202C33),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00A884),
      foregroundColor: Colors.black,
    ),
    colorScheme: ColorScheme.dark().copyWith(
      primary: const Color(0xFF00A884),
      secondary: const Color(0xFF00A884),
      surface: const Color(0xFF202C33),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
