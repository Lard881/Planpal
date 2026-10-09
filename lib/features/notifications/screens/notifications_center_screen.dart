import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../repositories/notification_repository.dart';

class NotificationsCenterScreen extends ConsumerStatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  ConsumerState<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState
    extends ConsumerState<NotificationsCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            const SizedBox(width: 8),
            unreadCountAsync.when(
              data: (count) => count > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Mentions'),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 12),
                    Text('Clear all'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Notification settings'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              } else if (value == 'clear_all') {
                _clearAll();
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings/notifications');
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationsTab(filter: NotificationFilter.all),
          _NotificationsTab(filter: NotificationFilter.unread),
          _NotificationsTab(filter: NotificationFilter.mentions),
        ],
      ),
    );
  }

  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark as read: $e')),
        );
      }
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'This will permanently delete all notifications. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(notificationRepositoryProvider).clearAll();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All notifications cleared')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear notifications: $e')),
          );
        }
      }
    }
  }
}

class _NotificationsTab extends ConsumerWidget {
  final NotificationFilter filter;

  const _NotificationsTab({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider(filter));

    return notificationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(notificationsProvider(filter)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _getEmptyMessage(filter),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re all caught up',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          );
        }

        // Group notifications by date
        final groupedNotifications = _groupByDate(notifications);

        return ListView.builder(
          itemCount: groupedNotifications.length,
          itemBuilder: (context, index) {
            final entry = groupedNotifications.entries.elementAt(index);
            final dateLabel = entry.key;
            final dateNotifications = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // Notifications for this date
                ...dateNotifications.map((notification) {
                  return _NotificationItem(notification: notification);
                }),
              ],
            );
          },
        );
      },
    );
  }

  String _getEmptyMessage(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return 'No notifications';
      case NotificationFilter.unread:
        return 'No unread notifications';
      case NotificationFilter.mentions:
        return 'No mentions';
    }
  }

  Map<String, List<AppNotification>> _groupByDate(
      List<AppNotification> notifications) {
    final Map<String, List<AppNotification>> grouped = {};
    final now = DateTime.now();

    for (final notification in notifications) {
      final date = notification.createdAt;
      final diff = now.difference(date);

      String dateLabel;
      if (diff.inDays == 0) {
        dateLabel = 'Today';
      } else if (diff.inDays == 1) {
        dateLabel = 'Yesterday';
      } else if (diff.inDays < 7) {
        dateLabel = '${diff.inDays} days ago';
      } else {
        dateLabel = '${date.day}/${date.month}/${date.year}';
      }

      grouped.putIfAbsent(dateLabel, () => []);
      grouped[dateLabel]!.add(notification);
    }

    return grouped;
  }
}

class _NotificationItem extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await ref
            .read(notificationRepositoryProvider)
            .deleteNotification(notification.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification deleted')),
          );
        }
      },
      child: InkWell(
        onTap: () => _handleNotificationTap(context, ref),
        child: Container(
          color: notification.isRead
              ? null
              : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight:
                            notification.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleNotificationTap(BuildContext context, WidgetRef ref) async {
    // Mark as read
    if (!notification.isRead) {
      await ref
          .read(notificationRepositoryProvider)
          .markAsRead(notification.id);
    }

    // Navigate based on notification type
    if (context.mounted) {
      switch (notification.type) {
        case 'task':
          Navigator.pushNamed(context, '/tasks/detail',
              arguments: notification.relatedId);
          break;
        case 'comment':
          Navigator.pushNamed(context, '/tasks/detail',
              arguments: notification.relatedId);
          break;
        case 'mention':
          Navigator.pushNamed(context, '/chat/conversation',
              arguments: {'channelId': notification.relatedId});
          break;
        case 'workspace':
          Navigator.pushNamed(context, '/workspaces');
          break;
        default:
          // Do nothing
          break;
      }
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt;
      case 'comment':
        return Icons.comment;
      case 'mention':
        return Icons.alternate_email;
      case 'workspace':
        return Icons.workspaces;
      case 'reminder':
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'task':
        return Colors.blue;
      case 'comment':
        return Colors.green;
      case 'mention':
        return Colors.orange;
      case 'workspace':
        return Colors.purple;
      case 'reminder':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

// Enums and Providers
enum NotificationFilter { all, unread, mentions }

final notificationsProvider =
    StreamProvider.family<List<AppNotification>, NotificationFilter>(
  (ref, filter) {
    final repository = ref.watch(notificationRepositoryProvider);
    switch (filter) {
      case NotificationFilter.all:
        return repository.watchAllNotifications();
      case NotificationFilter.unread:
        return repository.watchUnreadNotifications();
      case NotificationFilter.mentions:
        return repository.watchMentions();
    }
  },
);

final unreadNotificationsCountProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.watchUnreadCount();
});

// Placeholder model
class AppNotification {
  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final int? relatedId;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.relatedId,
    required this.createdAt,
  });
}
