import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _taskNotifications = true;
  bool _commentNotifications = true;
  bool _mentionNotifications = true;
  bool _documentNotifications = true;
  bool _chatNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Global settings
          Text(
            'Global Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive notifications on this device'),
                  secondary: const Icon(Icons.notifications),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive notifications via email'),
                  secondary: const Icon(Icons.email),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notification types
          Text(
            'Notification Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _taskNotifications,
                  onChanged: (value) {
                    setState(() {
                      _taskNotifications = value;
                    });
                  },
                  title: const Text('Task Updates'),
                  subtitle: const Text('Assigned, completed, or due soon'),
                  secondary: const Icon(Icons.task_alt),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _commentNotifications,
                  onChanged: (value) {
                    setState(() {
                      _commentNotifications = value;
                    });
                  },
                  title: const Text('Comments'),
                  subtitle: const Text('New comments on your tasks'),
                  secondary: const Icon(Icons.comment),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _mentionNotifications,
                  onChanged: (value) {
                    setState(() {
                      _mentionNotifications = value;
                    });
                  },
                  title: const Text('Mentions'),
                  subtitle: const Text('When someone mentions you'),
                  secondary: const Icon(Icons.alternate_email),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _documentNotifications,
                  onChanged: (value) {
                    setState(() {
                      _documentNotifications = value;
                    });
                  },
                  title: const Text('Documents'),
                  subtitle: const Text('Shared or updated documents'),
                  secondary: const Icon(Icons.description),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _chatNotifications,
                  onChanged: (value) {
                    setState(() {
                      _chatNotifications = value;
                    });
                  },
                  title: const Text('Chat Messages'),
                  subtitle: const Text('New messages in channels and DMs'),
                  secondary: const Icon(Icons.chat),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sound and vibration
          Text(
            'Alerts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                  title: const Text('Sound'),
                  subtitle: const Text('Play sound for notifications'),
                  secondary: const Icon(Icons.volume_up),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                  title: const Text('Vibration'),
                  subtitle: const Text('Vibrate for notifications'),
                  secondary: const Icon(Icons.vibration),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quiet hours
          Text(
            'Quiet Hours',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mute notifications during these hours',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bedtime),
                  title: const Text('Start Time'),
                  subtitle: Text(_quietHoursStart),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectTime(context, isStart: true),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.wb_sunny),
                  title: const Text('End Time'),
                  subtitle: Text(_quietHoursEnd),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectTime(context, isStart: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _testNotification,
                  child: const Text('Test Notification'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _saveSettings,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, {required bool isStart}) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        if (isStart) {
          _quietHoursStart = timeString;
        } else {
          _quietHoursEnd = timeString;
        }
      });
    }
  }

  void _testNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }
}
