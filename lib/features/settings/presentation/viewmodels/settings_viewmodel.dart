import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/locale_provider.dart';
import '../../../../app/providers/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsViewModel {
  final Ref _ref;

  const SettingsViewModel(this._ref);

  ThemeMode get currentThemeMode => _ref.read(themeProvider);

  Future<void> setTheme(ThemeMode mode) =>
      _ref.read(themeProvider.notifier).setTheme(mode);

  Locale get currentLocale => _ref.read(localeProvider);

  Future<void> setLocale(Locale locale) =>
      _ref.read(localeProvider.notifier).setLocale(locale);

  String get appVersion => AppConstants.appVersion;
}

final settingsViewModelProvider = Provider<SettingsViewModel>((ref) {
  return SettingsViewModel(ref);
});

String themeModeLabelKey(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => 'settings_theme_light',
    ThemeMode.dark => 'settings_theme_dark',
    ThemeMode.system => 'settings_theme_system',
  };
}

String localeLabelKey(Locale locale) {
  return locale.languageCode == 'ar'
      ? 'settings_language_ar'
      : 'settings_language_en';
}
