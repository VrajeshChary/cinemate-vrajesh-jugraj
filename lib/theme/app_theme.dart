import 'package:flutter/material.dart';

/// AppTheme defines the dark cinematic styling for CINEMATE.
/// 
/// Demonstrates:
/// - Consistent colour palette constants
/// - Custom ThemeData configuration
/// - Typography and button styling
class AppTheme {
  // Required palette constants
  static const Color background = Color(0xFF101014);
  static const Color secondaryBackground = Color(0xFF1A1A22);
  static const Color primaryAccent = Color(0xFFE50914);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFA0A0AA);
  static const Color cardColor = Color(0xFF22222B);
  static const Color starRatingColor = Color(0xFFFFB800);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryAccent,
      cardColor: cardColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBackground,
        hintStyle: const TextStyle(color: secondaryText, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: primaryText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        surface: cardColor,
        background: background,
      ),
    );
  }
}
