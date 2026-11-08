import 'package:flutter/material.dart';

/// ThemeProvider manages application-wide light / dark theme toggle.
/// 
/// Defaults to ThemeMode.light as requested.
class ThemeProvider extends ChangeNotifier {
  // Default to light theme
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggles between light and dark mode
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// Explicitly sets the theme mode
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
