
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static const String _themeModeKey = 'themeMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _soundKey = 'sound'; // Key for storing the sound
  static const String _notificationsEnabledKey = 'notificationsEnabled';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final themeModeIndex = prefs.getInt(_themeModeKey);
      if (themeModeIndex != null) {
        return ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      // Handle the case where the stored value is not an int
      await prefs.remove(_themeModeKey);
    }
    return ThemeMode.system; // Default to system theme
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);
  }

  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 16.0;
  }

  Future<void> setFontSize(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, fontSize);
  }

  // Method to get the selected sound
  Future<String> getSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_soundKey) ?? 'bell.mp3'; // Default to bell.mp3
  }

  // Method to set the selected sound
  Future<void> setSound(String sound) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_soundKey, sound);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, value);
  }
}
