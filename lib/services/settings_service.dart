
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static const String _themeModeKey = 'themeMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _soundKey = 'sound'; // Key for storing the sound
  static const String _notificationsEnabledKey = 'notificationsEnabled';

  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_themeModeKey);
      if (themeModeIndex != null) {
        return ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      print('Error getting theme mode: $e');
    }
    return ThemeMode.system; // Default to system theme
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);
    } catch (e) {
      print('Error setting theme mode: $e');
    }
  }

  Future<double> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 16.0;
    } catch (e) {
      print('Error getting font size: $e');
      return 16.0;
    }
  }

  Future<void> setFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
    } catch (e) {
      print('Error setting font size: $e');
    }
  }

  // Method to get the selected sound
  Future<String> getSound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_soundKey) ?? 'bell.mp3'; // Default to bell.mp3
    } catch (e) {
      print('Error getting sound: $e');
      return 'bell.mp3';
    }
  }

  // Method to set the selected sound
  Future<void> setSound(String sound) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_soundKey, sound);
    } catch (e) {
      print('Error setting sound: $e');
    }
  }

  Future<bool> getNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationsEnabledKey) ?? false;
    } catch (e) {
      print('Error getting notifications enabled: $e');
      return false;
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, value);
    } catch (e) {
      print('Error setting notifications enabled: $e');
    }
  }
}
