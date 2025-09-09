import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color errorRed = Colors.red;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: black,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.light(
      primary: black,
      secondary: white,
      background: white,
      surface: white,
      onPrimary: white,
      onSecondary: black,
      onBackground: black,
      onSurface: black,
      error: errorRed,
    ),
    cardColor: white,
    dividerColor: black,
    shadowColor: Colors.black.withOpacity(0.05),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: black,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      foregroundColor: white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: black),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: white,
    scaffoldBackgroundColor: black,
    colorScheme: ColorScheme.dark(
      primary: white,
      secondary: black,
      background: black,
      surface: black,
      onPrimary: black,
      onSecondary: white,
      onBackground: white,
      onSurface: white,
      error: errorRed,
    ),
    cardColor: black,
    dividerColor: white,
    shadowColor: Colors.black.withOpacity(0.2),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: white,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: black,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: white),
  );
}