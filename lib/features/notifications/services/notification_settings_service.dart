import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_settings.dart';

/// Service for managing notification settings persistence
class NotificationSettingsService {
  static const String _settingsKey = 'notification_settings';

  final SharedPreferences _prefs;

  NotificationSettingsService(this._prefs);

  /// Load settings from local storage
  NotificationSettings loadSettings() {
    try {
      final json = _prefs.getString(_settingsKey);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return NotificationSettings.fromJson(map);
      }
    } catch (e) {
      // If loading fails, return defaults
      print('Error loading notification settings: $e');
    }

    return const NotificationSettings();
  }

  /// Save settings to local storage
  Future<bool> saveSettings(NotificationSettings settings) async {
    try {
      final json = jsonEncode(settings.toJson());
      return await _prefs.setString(_settingsKey, json);
    } catch (e) {
      print('Error saving notification settings: $e');
      return false;
    }
  }

  /// Clear all settings (reset to defaults)
  Future<bool> clearSettings() async {
    try {
      return await _prefs.remove(_settingsKey);
    } catch (e) {
      print('Error clearing notification settings: $e');
      return false;
    }
  }

  /// Check if settings exist
  bool hasSettings() {
    return _prefs.containsKey(_settingsKey);
  }
}
