import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Load saved theme mode
  void _loadThemeMode() {
    final savedMode = _prefs.getString(_key);
    if (savedMode != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.toString());
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized first');
});

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});
