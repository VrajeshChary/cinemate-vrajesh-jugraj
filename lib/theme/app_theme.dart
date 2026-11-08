import 'package:flutter/material.dart';

/// AppTheme defines both Light and Dark cinematic styling for CINEMATE.
/// 
/// Defaults to a clean, crisp Light Theme while retaining full support
/// for the Dark Cinematic Theme via a top toggle button.
class AppTheme {
  // Dark Palette
  static const Color darkBackground = Color(0xFF101014);
  static const Color darkSecondaryBackground = Color(0xFF1A1A22);
  static const Color darkCardColor = Color(0xFF22222B);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFA0A0AA);

  // Light Palette
  static const Color lightBackground = Color(0xFFF6F7F9);
  static const Color lightSecondaryBackground = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF111827);
  static const Color lightSecondaryText = Color(0xFF6B7280);
  static const Color lightBorderColor = Color(0xFFE5E7EB);

  // Shared Brand Accent Colors
  static const Color primaryAccent = Color(0xFFE50914);
  static const Color starRatingColor = Color(0xFFFFB800);

  // Convenience aliases for backward compatibility
  static const Color background = darkBackground;
  static const Color secondaryBackground = darkSecondaryBackground;
  static const Color primaryText = darkPrimaryText;
  static const Color secondaryText = darkSecondaryText;
  static const Color cardColor = darkCardColor;

  /// Dynamic color getters based on current BuildContext brightness
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getTextColor(BuildContext context) =>
      isDark(context) ? darkPrimaryText : lightPrimaryText;

  static Color getSecondaryTextColor(BuildContext context) =>
      isDark(context) ? darkSecondaryText : lightSecondaryText;

  static Color getCardColor(BuildContext context) =>
      isDark(context) ? darkCardColor : lightCardColor;

  static Color getSecondaryBg(BuildContext context) =>
      isDark(context) ? darkSecondaryBackground : lightSecondaryBackground;

  static Color getBorder(BuildContext context) =>
      isDark(context) ? const Color(0xFF2A2A36) : lightBorderColor;

  // ===========================================================================
  // LIGHT THEME (Default)
  // ===========================================================================
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryAccent,
      cardColor: lightCardColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightPrimaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: lightPrimaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSecondaryBackground,
        hintStyle: const TextStyle(color: lightSecondaryText, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
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
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        surface: lightCardColor,
      ),
    );
  }

  // ===========================================================================
  // DARK THEME
  // ===========================================================================
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryAccent,
      cardColor: darkCardColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkPrimaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: darkPrimaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSecondaryBackground,
        hintStyle: const TextStyle(color: darkSecondaryText, fontSize: 14),
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
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: darkPrimaryText,
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
        surface: darkCardColor,
      ),
    );
  }
}
