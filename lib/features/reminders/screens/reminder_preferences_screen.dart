import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/local_notifications_service.dart';
import '../../../core/providers/app_providers.dart';

/// Provider for notification preferences
final notificationPreferencesProvider = StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>((ref) {
  return NotificationPreferencesNotifier();
});

/// Notification preferences state
class NotificationPreferences {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool showPreview;
  final String defaultSnoozeMinutes;

  NotificationPreferences({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.showPreview = true,
    this.defaultSnoozeMinutes = '15',
  });

  NotificationPreferences copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? showPreview,
    String? defaultSnoozeMinutes,
  }) {
    return NotificationPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      showPreview: showPreview ?? this.showPreview,
      defaultSnoozeMinutes: defaultSnoozeMinutes ?? this.defaultSnoozeMinutes,
    );
  }
}

/// Notifier for managing notification preferences
class NotificationPreferencesNotifier extends StateNotifier<NotificationPreferences> {
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keyShowPreview = 'show_preview';
  static const String _keyDefaultSnooze = 'default_snooze_minutes';

  NotificationPreferencesNotifier() : super(NotificationPreferences()) {
    _loadPreferences();
  }

  /// Load preferences from storage
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    state = NotificationPreferences(
      notificationsEnabled: prefs.getBool(_keyNotificationsEnabled) ?? true,
      soundEnabled: prefs.getBool(_keySoundEnabled) ?? true,
      vibrationEnabled: prefs.getBool(_keyVibrationEnabled) ?? true,
      showPreview: prefs.getBool(_keyShowPreview) ?? true,
      defaultSnoozeMinutes: prefs.getString(_keyDefaultSnooze) ?? '15',
    );
  }

  /// Toggle notifications enabled/disabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  /// Toggle sound enabled/disabled
  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEnabled, enabled);
    state = state.copyWith(soundEnabled: enabled);
  }

  /// Toggle vibration enabled/disabled
  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVibrationEnabled, enabled);
    state = state.copyWith(vibrationEnabled: enabled);
  }

  /// Toggle show preview enabled/disabled
  Future<void> setShowPreview(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowPreview, enabled);
    state = state.copyWith(showPreview: enabled);
  }

  /// Set default snooze duration
  Future<void> setDefaultSnooze(String minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultSnooze, minutes);
    state = state.copyWith(defaultSnoozeMinutes: minutes);
  }
}

/// Notification preferences screen
class ReminderPreferencesScreen extends ConsumerStatefulWidget {
  const ReminderPreferencesScreen({super.key});

  @override
  ConsumerState<ReminderPreferencesScreen> createState() => _ReminderPreferencesScreenState();
}

class _ReminderPreferencesScreenState extends ConsumerState<ReminderPreferencesScreen> {
  bool _isCheckingPermissions = false;

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);
    final notifications = ref.read(localNotificationsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: ListView(
        children: [
          // General section
          _buildSectionHeader('General'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminder notifications for tasks'),
            value: preferences.notificationsEnabled,
            onChanged: (value) async {
              if (value && !_isCheckingPermissions) {
                // Check if permissions are granted
                setState(() => _isCheckingPermissions = true);
                final hasPermission = await notifications.requestPermissions();
                setState(() => _isCheckingPermissions = false);

                if (!hasPermission) {
                  if (context.mounted) {
                    _showPermissionDialog(context);
                  }
                  return;
                }
              }
              await notifier.setNotificationsEnabled(value);
            },
          ),
          
          const Divider(),

          // Sound & Vibration section
          _buildSectionHeader('Sound & Vibration'),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound when reminders trigger'),
            value: preferences.soundEnabled,
            onChanged: preferences.notificationsEnabled
                ? (value) => notifier.setSoundEnabled(value)
                : null,
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate when reminders trigger'),
            value: preferences.vibrationEnabled,
            onChanged: preferences.notificationsEnabled
                ? (value) => notifier.setVibrationEnabled(value)
                : null,
          ),

          const Divider(),

          // Privacy section
          _buildSectionHeader('Privacy'),
          SwitchListTile(
            title: const Text('Show Preview'),
            subtitle: const Text('Display task title in notification'),
            value: preferences.showPreview,
            onChanged: preferences.notificationsEnabled
                ? (value) => notifier.setShowPreview(value)
                : null,
          ),

          const Divider(),

          // Snooze section
          _buildSectionHeader('Snooze'),
          ListTile(
            title: const Text('Default Snooze Duration'),
            subtitle: Text('${preferences.defaultSnoozeMinutes} minutes'),
            trailing: DropdownButton<String>(
              value: preferences.defaultSnoozeMinutes,
              onChanged: preferences.notificationsEnabled
                  ? (value) {
                      if (value != null) {
                        notifier.setDefaultSnooze(value);
                      }
                    }
                  : null,
              items: const [
                DropdownMenuItem(value: '5', child: Text('5 min')),
                DropdownMenuItem(value: '10', child: Text('10 min')),
                DropdownMenuItem(value: '15', child: Text('15 min')),
                DropdownMenuItem(value: '30', child: Text('30 min')),
                DropdownMenuItem(value: '60', child: Text('1 hour')),
              ],
            ),
          ),

          const Divider(),

          // Testing section
          _buildSectionHeader('Testing'),
          ListTile(
            title: const Text('Send Test Notification'),
            subtitle: const Text('Test your notification settings'),
            trailing: const Icon(Icons.send),
            enabled: preferences.notificationsEnabled,
            onTap: preferences.notificationsEnabled
                ? () => _sendTestNotification(context, notifications)
                : null,
          ),

          const SizedBox(height: 16),

          // Info card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Notifications',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Reminders are delivered even when the app is closed. '
                      'Make sure notification permissions are enabled in your device settings.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'PlanPal needs notification permissions to send you task reminders. '
          'Please enable notifications in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendTestNotification(
    BuildContext context,
    LocalNotificationsService notifications,
  ) async {
    try {
      await notifications.showImmediateNotification(
        id: 999999,
        title: '✅ Test Notification',
        body: 'Your notification settings are working correctly!',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send test notification: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
