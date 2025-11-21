import 'package:flutter/material.dart';

class KawaiiTheme {
  static const Color primaryPink = Color(0xFFFFB5D6);
  static const Color lightPink = Color(0xFFFFD4E5);
  static const Color pastelPink = Color(0xFFFFF0F5);
  static const Color pastelBlue = Color(0xFFD4E5FF);
  static const Color pastelYellow = Color(0xFFFFFACD);
  static const Color pastelMint = Color(0xFFD4F5E5);
  static const Color pastelLavender = Color(0xFFE5D4FF);
  static const Color softWhite = Color(0xFFFFFFFD);
  static const Color creamWhite = Color(0xFFFFFBF5);
  static const Color darkGray = Color(0xFF6B5B5B);
  static const Color mediumGray = Color(0xFFB8A8A8);
  static const Color lightGray = Color(0xFFEFE5E5);

  static ThemeData getTheme() {
    return ThemeData(
      scaffoldBackgroundColor: creamWhite,
      primaryColor: primaryPink,
      colorScheme: ColorScheme.light(
        primary: primaryPink,
        secondary: lightPink,
        surface: softWhite,
        error: Color(0xFFFF6B9D),
        onPrimary: Colors.white,
        onSecondary: darkGray,
        onSurface: darkGray,
        onError: Colors.white,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: softWhite,
        foregroundColor: primaryPink,
        iconTheme: IconThemeData(color: primaryPink),
        titleTextStyle: TextStyle(
          color: primaryPink,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: softWhite,
        shadowColor: lightPink.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: pastelPink, width: 2),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          shadowColor: lightPink.withValues(alpha: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: pastelPink, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: pastelPink, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryPink, width: 2.5),
        ),
        labelStyle: TextStyle(color: mediumGray, fontSize: 16),
        hintStyle: TextStyle(color: lightGray, fontSize: 14),
        prefixIconColor: primaryPink,
        suffixIconColor: primaryPink,
      ),
    );
  }
}
