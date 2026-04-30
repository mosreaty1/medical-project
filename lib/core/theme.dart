import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF021C2E);
const Color kAccent = Color(0xFF1A8FE3);
const Color kSuccess = Color(0xFF27AE60);
const Color kDanger = Color(0xFFE74C3C);
const Color kWarning = Color(0xFFF39C12);
const Color kCardBg = Colors.white;
const Color kScaffoldBg = Color(0xFFF0F4F8);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kAccent,
      background: kScaffoldBg,
    ),
    scaffoldBackgroundColor: kScaffoldBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: kPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: kPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF34495E)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: kCardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFDDE3EA), width: 1),
      ),
    ),
  );
}
