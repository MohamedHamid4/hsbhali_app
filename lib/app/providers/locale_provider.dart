import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';
import 'preferences_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final PreferencesService _prefs;

  LocaleNotifier(this._prefs) : super(_codeToLocale(_prefs.getLocaleCode()));

  Future<void> setLocale(Locale locale) async {
    if (state.languageCode == locale.languageCode) return;
    state = locale;
    await _prefs.setLocaleCode(locale.languageCode);
  }

  static Locale _codeToLocale(String code) {
    return code == 'en' ? const Locale('en', 'US') : const Locale('ar', 'EG');
  }
}
