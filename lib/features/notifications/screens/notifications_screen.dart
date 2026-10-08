import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/notifications/presentation/notification_providers.dart';
import 'package:planpal/features/notifications/widgets/notification_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Notifications screen with tabs
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final filters = [null, 'unread', 'tasks', 'mentions'];
    ref.read(notificationFilterProvider.notifier).state = filters[_tabController.index];
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => _markAllAsRead(context),
            tooltip: 'Mark all as read',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(
              child: unreadCountAsync.when(
                data: (count) => count > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Unread'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text('Unread'),
                loading: () => const Text('Unread'),
                error: (_, __) => const Text('Unread'),
              ),
            ),
            Tab(text: 'Tasks'),
            Tab(text: 'Mentions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(notificationsAsync),
          _buildNotificationsList(notificationsAsync),
          _buildNotificationsList(notificationsAsync),
          _buildNotificationsList(notificationsAsync),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(AsyncValue<List<dynamic>> notificationsAsync) {
    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No notifications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re all caught up!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final filter = ref.read(notificationFilterProvider);
            await ref.read(notificationRepositoryProvider).syncNotifications(filter: filter);
          },
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading notifications'),
            TextButton(
              onPressed: () => ref.invalidate(notificationsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAllAsRead(BuildContext context) async {
    try {
      await ref.read(notificationActionsProvider).markAllAsRead();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark as read: $e')),
        );
      }
    }
  }

  void _handleNotificationTap(dynamic notification) {
    // Mark as read
    if (notification.readAt == null) {
      ref.read(notificationActionsProvider).markAsRead(notification.id);
    }

    // Navigate to entity (S11.7)
    if (notification.entityType != null && notification.entityId != null) {
      final workspaceId = notification.workspaceId;
      if (workspaceId == null) return;

      switch (notification.entityType) {
        case 'task':
          context.push('/workspaces/$workspaceId/tasks/${notification.entityId}');
          break;
        case 'event':
          context.push('/workspaces/$workspaceId/calendar/${notification.entityId}');
          break;
        case 'channel':
          context.push('/workspaces/$workspaceId/chat/${notification.entityId}');
          break;
        case 'document':
          context.push('/workspaces/$workspaceId/documents/${notification.entityId}');
          break;
      }
    }
  }
}
