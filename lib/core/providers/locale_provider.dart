import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';

/// State notifier for application locale
class LocaleNotifier extends StateNotifier<Locale?> {
  static const String _key = 'language_code';
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(null) {
    _loadLocale();
  }

  void _loadLocale() {
    final languageCode = _prefs.getString(_key);
    if (languageCode != null && languageCode.isNotEmpty) {
      state = Locale(languageCode);
    }
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _prefs.setString(_key, languageCode);
  }

  Future<void> clearLocale() async {
    state = null;
    await _prefs.remove(_key);
  }
}

/// Provider for current application locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});
