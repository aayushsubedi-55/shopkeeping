import 'package:flutter/material.dart';

/// Theme manager to handle theme switching
/// Manages theme state and persistence
class ThemeManager extends ChangeNotifier {
  // Singleton
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isLight => _themeMode == ThemeMode.light;
  bool get isSystem => _themeMode == ThemeMode.system;

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      _saveThemeMode(mode);
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  void setLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  void setDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  void setSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  /// Load theme mode from storage
  Future<void> loadThemeMode() async {
    // TODO: Implement loading from SharedPreferences or SecureStorage
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // final themeModeString = prefs.getString('theme_mode') ?? 'light';
    // _themeMode = _themeModeFromString(themeModeString);
    // notifyListeners();
  }

  /// Save theme mode to storage
  Future<void> _saveThemeMode(ThemeMode mode) async {
    // TODO: Implement saving to SharedPreferences or SecureStorage
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('theme_mode', _themeModeToString(mode));
  }
}
