import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';
import 'preferences_provider.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return ThemeNotifier(prefs);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final PreferencesService _prefs;

  ThemeNotifier(this._prefs) : super(_prefs.getThemeMode());

  Future<void> setTheme(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await _prefs.setThemeMode(mode);
  }
}
