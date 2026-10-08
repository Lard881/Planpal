import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/notification_providers.dart';

/// Bell icon with unread notification badge for app bars
class NotificationBellIcon extends ConsumerWidget {
  final String? workspaceId;
  final Color? iconColor;
  final double iconSize;

  const NotificationBellIcon({
    super.key,
    this.workspaceId,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch unread count with real-time updates
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(workspaceId),
    );

    // Ensure realtime service is active
    ref.watch(notificationRealtimeServiceProvider);

    return IconButton(
      icon: _buildBellIcon(context, unreadCountAsync),
      onPressed: () => _navigateToNotifications(context),
      tooltip: 'Notifications',
    );
  }

  Widget _buildBellIcon(BuildContext context, AsyncValue<int> unreadCountAsync) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bell icon
        Icon(
          Icons.notifications_outlined,
          size: iconSize,
          color: iconColor,
        ),

        // Unread badge
        unreadCountAsync.when(
          data: (count) {
            if (count == 0) {
              return const SizedBox.shrink();
            }

            return Positioned(
              right: -2,
              top: -2,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _navigateToNotifications(BuildContext context) {
    context.push('/notifications');
  }
}

/// Animated notification bell icon with pulse animation for new notifications
class AnimatedNotificationBellIcon extends ConsumerStatefulWidget {
  final String? workspaceId;
  final Color? iconColor;
  final double iconSize;

  const AnimatedNotificationBellIcon({
    super.key,
    this.workspaceId,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  ConsumerState<AnimatedNotificationBellIcon> createState() =>
      _AnimatedNotificationBellIconState();
}

class _AnimatedNotificationBellIconState
    extends ConsumerState<AnimatedNotificationBellIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch unread count with real-time updates
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(widget.workspaceId),
    );

    // Ensure realtime service is active
    ref.watch(notificationRealtimeServiceProvider);

    // Trigger animation when count increases
    unreadCountAsync.whenData((count) {
      if (count > _previousCount && _previousCount > 0) {
        _controller.forward(from: 0);
      }
      _previousCount = count;
    });

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: _buildBellIcon(context, unreadCountAsync),
        onPressed: () => _navigateToNotifications(context),
        tooltip: 'Notifications',
      ),
    );
  }

  Widget _buildBellIcon(BuildContext context, AsyncValue<int> unreadCountAsync) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bell icon
        Icon(
          Icons.notifications_outlined,
          size: widget.iconSize,
          color: widget.iconColor,
        ),

        // Unread badge with pulse
        unreadCountAsync.when(
          data: (count) {
            if (count == 0) {
              return const SizedBox.shrink();
            }

            return Positioned(
              right: -2,
              top: -2,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _navigateToNotifications(BuildContext context) {
    context.push('/notifications');
  }
}

/// Simple unread count badge (no icon, just the badge)
class NotificationBadge extends ConsumerWidget {
  final String? workspaceId;
  final bool showZero;

  const NotificationBadge({
    super.key,
    this.workspaceId,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(workspaceId),
    );

    // Ensure realtime service is active
    ref.watch(notificationRealtimeServiceProvider);

    return unreadCountAsync.when(
      data: (count) {
        if (count == 0 && !showZero) {
          return const SizedBox.shrink();
        }

        return Container(
          constraints: const BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count > 99 ? '99+' : count.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Notification indicator dot (for minimal UI)
class NotificationDot extends ConsumerWidget {
  final String? workspaceId;
  final double size;

  const NotificationDot({
    super.key,
    this.workspaceId,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(workspaceId),
    );

    // Ensure realtime service is active
    ref.watch(notificationRealtimeServiceProvider);

    return unreadCountAsync.when(
      data: (count) {
        if (count == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 1.5,
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
