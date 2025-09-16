
import 'package:flutter/material.dart';
import 'package:myapp/services/settings_service.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;
  String _sound = 'bell.mp3';
  bool _notificationsEnabled = false;

  SettingsController(this._settingsService);

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  String get sound => _sound;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    try {
      _themeMode = await _settingsService.getThemeMode();
      _fontSize = await _settingsService.getFontSize();
      _sound = await _settingsService.getSound();
      _notificationsEnabled = await _settingsService.getNotificationsEnabled();
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
      // Use default values if loading fails
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    await _settingsService.setThemeMode(newThemeMode);
    notifyListeners();
  }

  Future<void> setFontSize(double newSize) async {
    if (newSize == _fontSize) return;

    _fontSize = newSize;
    await _settingsService.setFontSize(newSize);
    notifyListeners();
  }

  Future<void> setSound(String? newSound) async {
    if (newSound == null || newSound == _sound) return;

    _sound = newSound;
    await _settingsService.setSound(newSound);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (value == _notificationsEnabled) return;

    _notificationsEnabled = value;
    await _settingsService.setNotificationsEnabled(value);
    notifyListeners();
  }
}
