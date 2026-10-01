import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/notification_settings_providers.dart';
import '../models/notification_settings.dart';

/// Screen for managing notification preferences
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'enable_all':
                  await notifier.enableAllTypes();
                  break;
                case 'disable_all':
                  await notifier.disableAllTypes();
                  break;
                case 'reset':
                  await notifier.resetToDefaults();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'enable_all',
                child: Text('Enable All'),
              ),
              const PopupMenuItem(
                value: 'disable_all',
                child: Text('Disable All'),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Text('Reset to Defaults'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // General Settings
          _buildSection(
            context,
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Enable all push notifications'),
                value: settings.pushEnabled,
                onChanged: (_) => notifier.togglePushEnabled(),
              ),
              SwitchListTile(
                title: const Text('Sound'),
                subtitle: const Text('Play sound for notifications'),
                value: settings.soundEnabled,
                onChanged: settings.pushEnabled ? (_) => notifier.toggleSound() : null,
              ),
              SwitchListTile(
                title: const Text('Vibration'),
                subtitle: const Text('Vibrate for notifications'),
                value: settings.vibrationEnabled,
                onChanged: settings.pushEnabled ? (_) => notifier.toggleVibration() : null,
              ),
            ],
          ),

          // Quiet Hours
          _buildSection(
            context,
            title: 'Quiet Hours',
            children: [
              SwitchListTile(
                title: const Text('Enable Quiet Hours'),
                subtitle: Text(
                  settings.quietHoursEnabled
                      ? 'Active from ${_formatHour(settings.quietHoursStart)} to ${_formatHour(settings.quietHoursEnd)}'
                      : 'Notifications paused during specified hours',
                ),
                value: settings.quietHoursEnabled,
                onChanged: settings.pushEnabled ? (_) => notifier.toggleQuietHours() : null,
              ),
              if (settings.quietHoursEnabled) ...[
                ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(_formatHour(settings.quietHoursStart)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTimePicker(
                    context,
                    settings.quietHoursStart,
                    (hour) => notifier.setQuietHours(hour, settings.quietHoursEnd),
                  ),
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(_formatHour(settings.quietHoursEnd)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTimePicker(
                    context,
                    settings.quietHoursEnd,
                    (hour) => notifier.setQuietHours(settings.quietHoursStart, hour),
                  ),
                ),
              ],
            ],
          ),

          // Task Notifications
          _buildSection(
            context,
            title: 'Task Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_assigned',
                title: 'Task Assigned',
                subtitle: 'When you are assigned to a task',
                value: settings.taskAssignedEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_completed',
                title: 'Task Completed',
                subtitle: 'When a task is marked as complete',
                value: settings.taskCompletedEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_overdue',
                title: 'Task Overdue',
                subtitle: 'When a task is past its due date',
                value: settings.taskOverdueEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_due_soon',
                title: 'Task Due Soon',
                subtitle: 'When a task is approaching its due date',
                value: settings.taskDueSoonEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_commented',
                title: 'New Comments',
                subtitle: 'When someone comments on a task',
                value: settings.taskCommentedEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'task_status_changed',
                title: 'Status Changed',
                subtitle: 'When a task status is updated',
                value: settings.taskStatusChangedEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // Project Notifications
          _buildSection(
            context,
            title: 'Project Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'project_invite',
                title: 'Project Invitations',
                subtitle: 'When you are invited to a project',
                value: settings.projectInviteEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'project_updated',
                title: 'Project Updates',
                subtitle: 'When project details are changed',
                value: settings.projectUpdatedEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'project_deadline',
                title: 'Project Deadlines',
                subtitle: 'When a project deadline is approaching',
                value: settings.projectDeadlineEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // Event Notifications
          _buildSection(
            context,
            title: 'Event Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'event_reminder',
                title: 'Event Reminders',
                subtitle: 'Reminders for upcoming events',
                value: settings.eventReminderEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'event_starting_soon',
                title: 'Event Starting Soon',
                subtitle: 'When an event is about to start',
                value: settings.eventStartingSoonEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'event_updated',
                title: 'Event Updates',
                subtitle: 'When event details are changed',
                value: settings.eventUpdatedEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'event_cancelled',
                title: 'Event Cancelled',
                subtitle: 'When an event is cancelled',
                value: settings.eventCancelledEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // Chat Notifications
          _buildSection(
            context,
            title: 'Chat Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'chat_message',
                title: 'New Messages',
                subtitle: 'When you receive a new chat message',
                value: settings.chatMessageEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'chat_mention',
                title: 'Mentions',
                subtitle: 'When someone mentions you in chat',
                value: settings.chatMentionEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // Workspace Notifications
          _buildSection(
            context,
            title: 'Workspace Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'workspace_invite',
                title: 'Workspace Invitations',
                subtitle: 'When you are invited to a workspace',
                value: settings.workspaceInviteEnabled,
                enabled: settings.pushEnabled,
              ),
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'workspace_role_changed',
                title: 'Role Changes',
                subtitle: 'When your workspace role is updated',
                value: settings.workspaceRoleChangedEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // System Notifications
          _buildSection(
            context,
            title: 'System Notifications',
            children: [
              _buildNotificationTypeTile(
                context,
                ref,
                type: 'system',
                title: 'System Messages',
                subtitle: 'Important system notifications',
                value: settings.systemEnabled,
                enabled: settings.pushEnabled,
              ),
            ],
          ),

          // Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${settings.enabledTypesCount} of 18 notification types enabled',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (settings.quietHoursEnabled)
                      Text(
                        'Quiet hours: ${_formatHour(settings.quietHoursStart)} - ${_formatHour(settings.quietHoursEnd)}',
                        style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildNotificationTypeTile(
    BuildContext context,
    WidgetRef ref, {
    required String type,
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
  }) {
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: enabled ? (val) => notifier.toggleNotificationType(type, val) : null,
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  Future<void> _showTimePicker(
    BuildContext context,
    int currentHour,
    Function(int) onSelected,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      onSelected(time.hour);
    }
  }
}
