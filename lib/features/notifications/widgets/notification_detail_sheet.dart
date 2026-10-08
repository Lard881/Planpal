import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/db/app_database.dart';
import '../models/notification.dart';
import '../data/notification_navigation_service.dart';
import 'notification_actions.dart';

/// Bottom sheet showing full notification details
class NotificationDetailSheet extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;
  final VoidCallback onDelete;

  const NotificationDetailSheet({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
  });

  /// Show the notification detail sheet
  static Future<void> show(
    BuildContext context, {
    required NotificationData notification,
    required VoidCallback onMarkAsRead,
    required VoidCallback onMarkAsUnread,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationDetailSheet(
        notification: notification,
        onMarkAsRead: onMarkAsRead,
        onMarkAsUnread: onMarkAsUnread,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = notification.type; // Already a NotificationType
    final isUnread = notification.readAt == null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            width: 40,
            height: 4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                _buildNotificationIcon(context, type),
                const SizedBox(width: 12),

                // Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(type),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getTypeLabel(type),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // Unread badge
                          if (isUnread)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'UNREAD',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Close button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Body
                  Text(
                    notification.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  // Metadata
                  _buildMetadataCard(context),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Action bar
          NotificationActionBar(
            notification: notification,
            onNavigate: () {
              Navigator.of(context).pop();
              NotificationNavigationService.navigateToNotification(
                context,
                notification,
              );
            },
            onMarkAsRead: () {
              onMarkAsRead();
              Navigator.of(context).pop();
            },
            onMarkAsUnread: () {
              onMarkAsUnread();
              Navigator.of(context).pop();
            },
            onDelete: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, NotificationType type) {
    final icon = _getTypeIcon(type);
    final color = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildMetadataRow(
              context,
              'Created',
              _formatDateTime(notification.createdAt),
              Icons.access_time,
            ),
            if (notification.readAt != null) ...[
              const SizedBox(height: 8),
              _buildMetadataRow(
                context,
                'Read',
                _formatDateTime(notification.readAt!),
                Icons.mark_email_read,
              ),
            ],
            if (notification.entityType != null) ...[
              const SizedBox(height: 8),
              _buildMetadataRow(
                context,
                'Related to',
                '${notification.entityType} (${notification.entityId?.substring(0, 8)}...)',
                Icons.link,
              ),
            ],
            if (notification.workspaceId.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildMetadataRow(
                context,
                'Workspace',
                notification.workspaceId.substring(0, 8) + '...',
                Icons.workspaces,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return 'Task Assigned';
      case NotificationType.taskUpdated:
        return 'Task Updated';
      case NotificationType.taskComment:
        return 'Comment';
      case NotificationType.mention:
        return 'Mention';
      case NotificationType.deadlineApproaching:
        return 'Deadline Approaching';
      case NotificationType.taskOverdue:
        return 'Task Overdue';
      case NotificationType.eventReminder:
        return 'Event Reminder';
      case NotificationType.chatMessage:
        return 'Chat Message';
      case NotificationType.memberJoined:
        return 'Member Joined';
      case NotificationType.system:
        return 'System';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }
}
