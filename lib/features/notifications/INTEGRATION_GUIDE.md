# Notifications Integration Guide

## Overview
This guide shows how to integrate the notification system with real-time updates into your app screens.

## Components Available

### 1. NotificationBellIcon
Basic bell icon with unread badge for app bars.

```dart
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';

AppBar(
  title: const Text('My App'),
  actions: [
    // Simple bell icon with unread count
    NotificationBellIcon(
      workspaceId: currentWorkspaceId, // Optional: filter by workspace
    ),
  ],
)
```

### 2. AnimatedNotificationBellIcon
Bell icon with pulse animation when new notifications arrive.

```dart
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';

AppBar(
  title: const Text('My App'),
  actions: [
    // Animated bell icon with pulse effect
    AnimatedNotificationBellIcon(
      workspaceId: currentWorkspaceId,
      iconColor: Colors.white, // Optional: customize color
      iconSize: 24, // Optional: customize size
    ),
  ],
)
```

### 3. NotificationBadge
Standalone badge showing unread count (no icon).

```dart
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';

// In a navigation rail or bottom nav
NavigationRailDestination(
  icon: Stack(
    children: [
      const Icon(Icons.notifications),
      Positioned(
        right: 0,
        top: 0,
        child: NotificationBadge(workspaceId: workspaceId),
      ),
    ],
  ),
  label: const Text('Notifications'),
)
```

### 4. NotificationDot
Minimal indicator dot (just shows presence of unread).

```dart
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';

// Minimal indicator
Stack(
  children: [
    const Icon(Icons.notifications_outlined),
    Positioned(
      right: 2,
      top: 2,
      child: NotificationDot(workspaceId: workspaceId),
    ),
  ],
)
```

## Complete Example: App Bar Integration

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/providers/app_providers.dart';
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';

class MyAppScreen extends ConsumerWidget {
  const MyAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current workspace ID for filtering
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Notification bell with real-time updates
          AnimatedNotificationBellIcon(
            workspaceId: workspaceId,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: YourContent(),
    );
  }
}
```

## Bottom Navigation Integration

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/features/notifications/widgets/notification_bell_icon.dart';
import 'package:planpal/features/notifications/presentation/notification_providers.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(
      unreadNotificationCountProvider(null),
    );

    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: unreadCountAsync.when(
              data: (count) => count > 0 ? Text('$count') : null,
              loading: () => null,
              error: (_, __) => null,
            ),
            isLabelVisible: unreadCountAsync.maybeWhen(
              data: (count) => count > 0,
              orElse: () => false,
            ),
            child: const Icon(Icons.notifications),
          ),
          label: 'Notifications',
        ),
      ],
      onTap: (index) {
        if (index == 2) {
          context.push('/notifications');
        }
      },
    );
  }
}
```

## Real-time Features

### Automatic Updates
The notification bell icon automatically updates in real-time when:
- New notifications are created (backend push or manual creation)
- Notifications are marked as read/unread
- Notifications are deleted

This works because:
1. `notificationRealtimeServiceProvider` is watched by the bell icon
2. The service subscribes to Supabase Realtime changes
3. Changes are automatically synced to local Drift database
4. `unreadNotificationCountProvider` streams from local database
5. UI updates reactively via Riverpod

### No Manual Refresh Needed
You don't need to:
- Call `fetchNotifications()` periodically
- Use timers or polling
- Manually update the count

The Supabase Realtime channel handles everything automatically.

## Workspace Filtering

### Filter by Current Workspace
```dart
// Show only notifications for current workspace
final workspaceId = ref.watch(currentWorkspaceIdProvider);

AnimatedNotificationBellIcon(
  workspaceId: workspaceId,
)
```

### Show All Workspaces
```dart
// Show notifications across all workspaces
AnimatedNotificationBellIcon(
  workspaceId: null, // null = all workspaces
)
```

## Customization

### Custom Colors
```dart
AnimatedNotificationBellIcon(
  iconColor: Theme.of(context).colorScheme.primary,
  iconSize: 28,
)
```

### Custom Badge Styling
The badge automatically adapts to the theme, but you can customize by extending the widgets.

## Testing Real-time Updates

### Manual Testing
1. Open app on Device A
2. Note the unread count in bell icon
3. Create a new notification via backend API or Device B
4. Observe bell icon on Device A updates immediately
5. Verify animation plays (if using AnimatedNotificationBellIcon)

### Backend API Testing
```bash
# Create a test notification
curl -X POST http://localhost:3000/api/v1/notifications \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user-123",
    "workspace_id": "ws-456",
    "type": "system",
    "title": "Test Notification",
    "body": "Testing real-time updates"
  }'
```

### Verify Realtime Connection
```dart
// Check if realtime service is active
final service = ref.read(notificationRealtimeServiceProvider);
print('Realtime active: ${service?.isListening}');
```

## Performance Considerations

### Efficient Updates
- Uses Drift streams (local database) for instant updates
- Supabase Realtime only syncs changes (not full lists)
- Badge counts are calculated efficiently with SQL COUNT queries
- No unnecessary re-renders (Riverpod caching)

### Memory Management
- Realtime service auto-disposes when provider is no longer watched
- Supabase channels are properly cleaned up
- No memory leaks from long-running streams

## Troubleshooting

### Bell Icon Not Updating
1. **Check Realtime Service Status**
   ```dart
   final service = ref.read(notificationRealtimeServiceProvider);
   if (service == null) {
     print('User not authenticated');
   } else if (!service.isListening) {
     print('Realtime service not listening');
   }
   ```

2. **Verify Supabase Realtime Configuration**
   - Ensure Realtime is enabled in Supabase project
   - Check table-level RLS policies allow reads
   - Verify user_id column filter is correct

3. **Check Local Database**
   ```dart
   final repo = ref.read(notificationRepositoryProvider);
   final count = await repo.getUnreadCount();
   print('Local unread count: $count');
   ```

### Badge Shows Wrong Count
1. **Sync with Backend**
   ```dart
   ref.invalidate(fetchNotificationsProvider);
   ```

2. **Clear and Re-sync**
   ```dart
   final repo = ref.read(notificationRepositoryProvider);
   await repo.clearAllLocal();
   ref.invalidate(fetchNotificationsProvider);
   ```

## Migration from Manual Polling

### Before (Manual Polling)
```dart
// OLD - Don't do this
Timer.periodic(Duration(seconds: 30), (timer) {
  fetchNotifications();
});
```

### After (Real-time)
```dart
// NEW - Just use the widget
AnimatedNotificationBellIcon(workspaceId: workspaceId)
// That's it! No timers, no polling.
```

## Best Practices

1. **Use AnimatedNotificationBellIcon in main screens** - Better UX with animation
2. **Use NotificationBellIcon in secondary screens** - Simpler, less distracting
3. **Filter by workspace in workspace-specific contexts** - Relevant notifications only
4. **Show all notifications in global navigation** - Don't miss anything
5. **Test real-time updates early** - Catch Supabase config issues before production

## Next Steps

- **Task 10**: Implement FCM push notifications for Android (background notifications)
- **Task 11**: Implement Windows local notifications (foreground notifications)
- **Task 12**: Add localized notification text generation
- **Task 13**: Add notification settings and preferences

## Additional Resources

- [Supabase Realtime Documentation](https://supabase.com/docs/guides/realtime)
- [Riverpod Provider Documentation](https://riverpod.dev/docs/concepts/providers)
- [Drift Streams Documentation](https://drift.simonbinder.eu/docs/getting-started/writing_queries/#select-statements)
