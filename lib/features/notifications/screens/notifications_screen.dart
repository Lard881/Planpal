import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../models/notification.dart';
import '../presentation/notification_providers.dart';
import '../widgets/notification_list_tile.dart';
import '../widgets/notification_filter_sheet.dart';
import '../data/notification_navigation_service.dart';

/// Main notifications screen with tabs and filters
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationType? _selectedType;
  String? _currentWorkspaceId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Trigger initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      final filter = _buildCurrentFilter();
      await ref.read(fetchNotificationsProvider(filter).future);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  NotificationFilter _buildCurrentFilter() {
    // Tab 0 = All, Tab 1 = Unread
    final isUnreadTab = _tabController.index == 1;

    return NotificationFilter(
      read: isUnreadTab ? false : null,
      type: _selectedType,
      workspaceId: _currentWorkspaceId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          // Mark all as read
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          // More menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onMenuItemSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear all'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Column(
          children: [
            // Notification counts summary
            _buildCountsSummary(),

            // Active filters display
            if (_selectedType != null || _currentWorkspaceId != null)
              _buildActiveFilters(),

            // Tab view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All notifications
                  _buildNotificationList(filter: _buildCurrentFilter()),
                  // Unread notifications
                  _buildNotificationList(filter: _buildCurrentFilter()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(_currentWorkspaceId),
    );

    return TabBar(
      controller: _tabController,
      tabs: [
        const Tab(text: 'All'),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unread'),
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
                          count > 99 ? '99+' : count.toString(),
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
        ),
      ],
    );
  }

  Widget _buildCountsSummary() {
    final countsAsync = ref.watch(
      notificationCountsProvider(_currentWorkspaceId),
    );

    return countsAsync.when(
      data: (counts) {
        if (counts.total == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildCountCard(
                  'Total',
                  counts.total,
                  Icons.notifications,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCountCard(
                  'Unread',
                  counts.unread,
                  Icons.circle_notifications,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCountCard(
                  'Read',
                  counts.read,
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCountCard(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedType != null)
            Chip(
              label: Text(_getTypeLabel(_selectedType!)),
              onDeleted: () => setState(() => _selectedType = null),
            ),
          if (_currentWorkspaceId != null)
            Chip(
              label: const Text('Current Workspace'),
              onDeleted: () => setState(() => _currentWorkspaceId = null),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationList({required NotificationFilter filter}) {
    final notificationsAsync = ref.watch(
      notificationsStreamProvider(filter),
    );

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return EmptyState(
            icon: _tabController.index == 1
                ? Icons.mark_email_read
                : Icons.notifications_none,
            title: _tabController.index == 1
                ? 'No unread notifications'
                : 'No notifications',
            message: _tabController.index == 1
                ? 'You\'re all caught up!'
                : 'Notifications will appear here',
          );
        }

        return RefreshIndicator(
          onRefresh: _fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationListTile(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
                onMarkAsRead: () => _markAsRead(notification.id),
                onMarkAsUnread: () => _markAsUnread(notification.id),
                onDelete: () => _deleteNotification(notification.id),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => ErrorState(
        message: 'Failed to load notifications',
        error: error.toString(),
        onRetry: _fetchNotifications,
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationFilterSheet(
        selectedType: _selectedType,
        currentWorkspaceId: _currentWorkspaceId,
        onApply: (type, workspaceId) {
          setState(() {
            _selectedType = type;
            _currentWorkspaceId = workspaceId;
          });
          _fetchNotifications();
        },
      ),
    );
  }

  Future<void> _markAllAsRead() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark all as read'),
        content: const Text(
          'Are you sure you want to mark all notifications as read?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Mark all as read'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final markAllAsRead = ref.read(markAllNotificationsAsReadProvider);
        final count = await markAllAsRead(workspaceId: _currentWorkspaceId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Marked $count notifications as read'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to mark all as read: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      final markAsRead = ref.read(markNotificationAsReadProvider);
      await markAsRead(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _markAsUnread(String id) async {
    try {
      final markAsUnread = ref.read(markNotificationAsUnreadProvider);
      await markAsUnread(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as unread: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteNotification(String id) async {
    try {
      final deleteNotification = ref.read(deleteNotificationProvider);
      await deleteNotification(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete notification: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleNotificationTap(NotificationData notification) {
    // Mark as read when tapped
    if (notification.readAt == null) {
      _markAsRead(notification.id);
    }

    // Navigate to entity
    NotificationNavigationService.navigateToNotification(
      context,
      notification,
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        _fetchNotifications();
        break;
      case 'clear_all':
        _clearAllNotifications();
        break;
    }
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all notifications'),
        content: const Text(
          'This will permanently delete all notifications. This action cannot be undone.',
        ),
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
            child: const Text('Delete all'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        // Get all notification IDs
        final filter = _buildCurrentFilter();
        final notificationsAsync =
            ref.read(notificationsStreamProvider(filter).future);
        final notifications = await notificationsAsync;
        final ids = notifications.map((n) => n.id).toList();

        if (ids.isNotEmpty) {
          final bulkDelete = ref.read(bulkDeleteNotificationsProvider);
          final count = await bulkDelete(ids);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deleted $count notifications'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to clear notifications: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
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
        return 'Deadline';
      case NotificationType.taskOverdue:
        return 'Overdue';
      case NotificationType.eventReminder:
        return 'Event';
      case NotificationType.chatMessage:
        return 'Chat';
      case NotificationType.memberJoined:
        return 'Member Joined';
      case NotificationType.system:
        return 'System';
    }
  }
}
