
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class SettingsService {
  static const String _themeModeKey = 'themeMode';
  static const String _fontSizeKey = 'fontSize';
  static const String _soundKey = 'sound'; // Key for storing the sound

  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_themeModeKey);
      if (themeModeIndex != null) {
        return ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      developer.log('Error getting theme mode: $e', name: 'settings_service');
    }
    return ThemeMode.system; // Default to system theme
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);
    } catch (e) {
      developer.log('Error setting theme mode: $e', name: 'settings_service');
    }
  }

  Future<double> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 16.0;
    } catch (e) {
      developer.log('Error getting font size: $e', name: 'settings_service');
      return 16.0;
    }
  }

  Future<void> setFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
    } catch (e) {
      developer.log('Error setting font size: $e', name: 'settings_service');
    }
  }

  // Method to get the selected sound
  Future<String> getSound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_soundKey) ?? 'bell.mp3'; // Default to bell.mp3
    } catch (e) {
      developer.log('Error getting sound: $e', name: 'settings_service');
      return 'bell.mp3';
    }
  }

  // Method to set the selected sound
  Future<void> setSound(String sound) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_soundKey, sound);
    } catch (e) {
      developer.log('Error setting sound: $e', name: 'settings_service');
    }
  }
}
