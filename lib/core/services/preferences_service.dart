import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _kThemeMode = 'theme_mode';
  static const String _kLocaleCode = 'locale_code';
  static const String _kIsFirstTime = 'is_first_time';

  final SharedPreferences _prefs;

  const PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  ThemeMode getThemeMode() {
    final value = _prefs.getString(_kThemeMode);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_kThemeMode, value);
  }

  String getLocaleCode() => _prefs.getString(_kLocaleCode) ?? 'ar';

  Future<void> setLocaleCode(String code) async {
    await _prefs.setString(_kLocaleCode, code);
  }

  bool isFirstTime() => _prefs.getBool(_kIsFirstTime) ?? true;

  Future<void> setFirstTimeDone() async {
    await _prefs.setBool(_kIsFirstTime, false);
  }

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
}
