import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/notifications/presentation/notification_providers.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Notification tile widget
class NotificationTile extends ConsumerWidget {
  final Notification notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = notification.readAt == null;

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(notificationActionsProvider).deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Container(
        color: isUnread ? AppTheme.primaryColor.withOpacity(0.05) : null,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getIconColor(notification.type).withOpacity(0.1),
            child: Icon(
              _getIcon(notification.type),
              color: _getIconColor(notification.type),
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.body.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 4),
              Text(
                timeago.format(notification.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (action) => _handleAction(context, ref, action),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: isUnread ? 'mark_read' : 'mark_unread',
                    child: Text(isUnread ? 'Mark as read' : 'Mark as unread'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'task_assigned':
        return Icons.assignment;
      case 'task_updated':
        return Icons.update;
      case 'task_comment':
        return Icons.comment;
      case 'deadline_approaching':
        return Icons.warning_amber;
      case 'task_overdue':
        return Icons.error;
      case 'mention':
        return Icons.alternate_email;
      case 'chat_message':
        return Icons.message;
      case 'event_reminder':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'task_assigned':
        return Colors.blue;
      case 'task_updated':
        return Colors.green;
      case 'task_comment':
        return Colors.purple;
      case 'deadline_approaching':
        return Colors.orange;
      case 'task_overdue':
        return Colors.red;
      case 'mention':
        return AppTheme.primaryColor;
      case 'chat_message':
        return Colors.teal;
      case 'event_reminder':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, String action) async {
    try {
      final actions = ref.read(notificationActionsProvider);

      switch (action) {
        case 'mark_read':
          await actions.markAsRead(notification.id);
          break;
        case 'mark_unread':
          await actions.markAsUnread(notification.id);
          break;
        case 'delete':
          await actions.deleteNotification(notification.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification deleted')),
            );
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }
}
