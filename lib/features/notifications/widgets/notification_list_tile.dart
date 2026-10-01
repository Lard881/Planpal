import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/db/app_database.dart';
import '../models/notification.dart';
import 'notification_detail_sheet.dart';

/// List tile for displaying a notification
class NotificationListTile extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;
  final VoidCallback onDelete;

  const NotificationListTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.readAt == null;
    final type = NotificationTypeExtension.fromString(notification.type);

    return Dismissible(
      key: Key(notification.id),
      background: _buildDismissBackground(context, isLeft: true),
      secondaryBackground: _buildDismissBackground(context, isLeft: false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe left = delete
          return await _confirmDelete(context);
        } else {
          // Swipe right = mark as read/unread
          if (isUnread) {
            onMarkAsRead();
          } else {
            onMarkAsUnread();
          }
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showDetailSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: isUnread
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              _buildNotificationIcon(context, type, isUnread),

              const SizedBox(width: 12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Body
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeBadgeColor(context, type),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(type),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Time
                        Text(
                          _formatTime(notification.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Actions menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (action) => _handleAction(action),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: isUnread ? 'mark_read' : 'mark_unread',
                    child: Row(
                      children: [
                        Icon(
                          isUnread ? Icons.mark_email_read : Icons.mark_email_unread,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(isUnread ? 'Mark as read' : 'Mark as unread'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(
    BuildContext context,
    NotificationType type,
    bool isUnread,
  ) {
    final icon = _getTypeIcon(type);
    final color = _getTypeColor(type);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        if (isUnread)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDismissBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      color: isLeft ? Colors.green : Colors.red,
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        isLeft ? Icons.mark_email_read : Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _handleAction(String action) {
    switch (action) {
      case 'mark_read':
        onMarkAsRead();
        break;
      case 'mark_unread':
        onMarkAsUnread();
        break;
      case 'delete':
        onDelete();
        break;
    }
  }

  void _showDetailSheet(BuildContext context) {
    NotificationDetailSheet.show(
      context,
      notification: notification,
      onMarkAsRead: onMarkAsRead,
      onMarkAsUnread: onMarkAsUnread,
      onDelete: onDelete,
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return Icons.assignment_ind;
      case NotificationType.taskUpdated:
        return Icons.edit;
      case NotificationType.taskComment:
        return Icons.comment;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.deadlineApproaching:
        return Icons.schedule;
      case NotificationType.taskOverdue:
        return Icons.warning;
      case NotificationType.eventReminder:
        return Icons.event;
      case NotificationType.chatMessage:
        return Icons.chat;
      case NotificationType.memberJoined:
        return Icons.person_add;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return Colors.blue;
      case NotificationType.taskUpdated:
        return Colors.purple;
      case NotificationType.taskComment:
        return Colors.teal;
      case NotificationType.mention:
        return Colors.orange;
      case NotificationType.deadlineApproaching:
        return Colors.amber;
      case NotificationType.taskOverdue:
        return Colors.red;
      case NotificationType.eventReminder:
        return Colors.green;
      case NotificationType.chatMessage:
        return Colors.indigo;
      case NotificationType.memberJoined:
        return Colors.cyan;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  Color _getTypeBadgeColor(BuildContext context, NotificationType type) {
    return _getTypeColor(type);
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return 'Assigned';
      case NotificationType.taskUpdated:
        return 'Updated';
      case NotificationType.taskComment:
        return 'Comment';
      case NotificationType.mention:
        return 'Mention';
      case NotificationType.deadlineApproaching:
        return 'Deadline';
      case NotificationType.taskOverdue:
        return 'Overdue';
      case NotificationType.eventReminder:
        return 'Event';
      case NotificationType.chatMessage:
        return 'Chat';
      case NotificationType.memberJoined:
        return 'New Member';
      case NotificationType.system:
        return 'System';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
