import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../data/notification_navigation_service.dart';

/// Quick action buttons for notifications
class NotificationActions extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;
  final VoidCallback onDelete;

  const NotificationActions({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.readAt == null;
    final hasNavigationTarget =
        NotificationNavigationService.hasNavigationTarget(notification);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Navigate button (if applicable)
        if (hasNavigationTarget)
          OutlinedButton.icon(
            onPressed: () {
              NotificationNavigationService.navigateToNotification(
                context,
                notification,
              );
            },
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(
              NotificationNavigationService.getNavigationDescription(
                notification,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

        // Mark as read/unread button
        OutlinedButton.icon(
          onPressed: isUnread ? onMarkAsRead : onMarkAsUnread,
          icon: Icon(
            isUnread ? Icons.mark_email_read : Icons.mark_email_unread,
            size: 18,
          ),
          label: Text(isUnread ? 'Mark as read' : 'Mark as unread'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),

        // Delete button
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Delete'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}

/// Inline notification action bar (for expanded view)
class NotificationActionBar extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onNavigate;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;
  final VoidCallback onDelete;

  const NotificationActionBar({
    super.key,
    required this.notification,
    required this.onNavigate,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.readAt == null;
    final hasNavigationTarget =
        NotificationNavigationService.hasNavigationTarget(notification);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          // Navigate button
          if (hasNavigationTarget) ...[
            Expanded(
              child: FilledButton.icon(
                onPressed: onNavigate,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(
                  NotificationNavigationService.getNavigationDescription(
                    notification,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Mark as read/unread button
          IconButton(
            onPressed: isUnread ? onMarkAsRead : onMarkAsUnread,
            icon: Icon(
              isUnread ? Icons.mark_email_read : Icons.mark_email_unread,
            ),
            tooltip: isUnread ? 'Mark as read' : 'Mark as unread',
          ),

          // Delete button
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}
