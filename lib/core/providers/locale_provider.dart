// app/lib/core/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kLocaleKey = 'planpal_locale';

const _supportedLocales = [
  Locale('en'),
  Locale('es'),
  Locale('fr'),
  Locale('zh'),
  Locale('ko'),
];

class LocaleNotifier extends Notifier<Locale?> {
  static const _storage = FlutterSecureStorage();

  @override
  Locale? build() {
    _loadSaved();
    return null; // null = use device locale
  }

  Future<void> _loadSaved() async {
    final saved = await _storage.read(key: _kLocaleKey);
    if (saved != null) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.write(key: _kLocaleKey, value: locale.languageCode);
  }

  Future<void> clearLocale() async {
    state = null;
    await _storage.delete(key: _kLocaleKey);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

List<Locale> get supportedLocales => _supportedLocales;
