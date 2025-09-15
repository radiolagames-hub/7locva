
import 'package:flutter/material.dart';
import 'package:myapp/services/settings_service.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;
  String _sound = 'bell.mp3'; // Default sound

  SettingsController(this._settingsService);

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  String get sound => _sound;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.getThemeMode();
    _fontSize = await _settingsService.getFontSize();
    _sound = await _settingsService.getSound();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    await _settingsService.setThemeMode(newThemeMode);
    notifyListeners();
  }

  Future<void> updateFontSize(double newSize) async {
    if (newSize == _fontSize) return;

    _fontSize = newSize;
    await _settingsService.setFontSize(newSize);
    notifyListeners();
  }

  Future<void> updateSound(String? newSound) async {
    if (newSound == null || newSound == _sound) return;

    _sound = newSound;
    await _settingsService.setSound(newSound);
    notifyListeners();
  }
}
