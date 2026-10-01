# Windows Local Notifications Guide

## Overview

Windows doesn't support Firebase Cloud Messaging (FCM) push notifications when the app is closed. Instead, PlanPal uses **local notifications triggered by Supabase Realtime** when the app is running.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Supabase Backend                             │
│  • New notification created in database                          │
│  • Realtime broadcast sent to all connected clients              │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Windows Desktop                               │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │       Supabase Realtime Service (WebSocket)               │  │
│  │  • Receives INSERT events from notifications table        │  │
│  │  • Triggers onNotificationReceived callback               │  │
│  └─────────────────────┬─────────────────────────────────────┘  │
│                        │                                          │
│                        ▼                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │     Windows Notification Service                          │  │
│  │  • Shows system notification via Action Center            │  │
│  │  • Handles notification taps                              │  │
│  │  • Manages notification lifecycle                         │  │
│  └─────────────────────┬─────────────────────────────────────┘  │
│                        │                                          │
│                        ▼                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │      Flutter Local Notifications Plugin                   │  │
│  │  • Uses Windows Action Center API                         │  │
│  │  • Shows toast notifications                              │  │
│  │  • Routes taps back to app                                │  │
│  └─────────────────────┬─────────────────────────────────────┘  │
│                        │                                          │
│                        ▼                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │         PlanPal App (Flutter)                             │  │
│  │  • Syncs notifications to local DB                        │  │
│  │  • Updates UI in real-time                                │  │
│  │  • Handles navigation to entities                         │  │
│  │  • Marks notifications as read                            │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## How It Works

### 1. App Running (Foreground/Background)

When the app is running on Windows:

1. **Realtime Connection**: WebSocket connection to Supabase is active
2. **Notification Created**: Backend creates notification in database
3. **Broadcast**: Supabase broadcasts INSERT event to all subscribed clients
4. **Receive**: NotificationRealtimeService receives the event
5. **Sync**: Notification synced to local Drift database
6. **Callback**: `onNotificationReceived` callback triggered
7. **Show**: WindowsNotificationService shows Windows toast notification
8. **Update**: UI updates in real-time (notification list, badge count)

### 2. App Closed (Terminated)

When the app is closed:

- **No notifications shown** (Windows limitation - no background process)
- Notifications are queued in the backend database
- When user opens app:
  - All missed notifications are fetched and synced
  - Notification bell shows unread count
  - User can view all notifications in notification center

## Components

### WindowsNotificationService

Singleton service that manages Windows local notifications.

**Key Features:**
- Initializes flutter_local_notifications with Windows platform settings
- Shows notifications via Windows Action Center
- Handles notification taps and navigation
- Supports enable/disable toggle (user preference)
- Cancels individual or all notifications

**Key Methods:**

```dart
// Initialize Windows notifications
await WindowsNotificationService().initialize();

// Show a notification
await WindowsNotificationService().showNotification(notification);

// Enable/disable notifications
WindowsNotificationService().setEnabled(true);

// Cancel specific notification
await WindowsNotificationService().cancelNotification(notificationId);

// Cancel all notifications
await WindowsNotificationService().cancelAllNotifications();

// Check status
bool enabled = WindowsNotificationService().isEnabled;
bool initialized = WindowsNotificationService().isInitialized;
```

### NotificationRealtimeService (Enhanced)

Enhanced with callback support for platform-specific handlers.

**New Feature:**
- `onNotificationReceived` callback parameter
- Triggered when INSERT event received
- Used by Windows service to show local notifications

**Usage:**

```dart
final service = NotificationRealtimeService(
  supabase: supabase,
  repository: repository,
  userId: userId,
  onNotificationReceived: (notification) {
    // Platform-specific handling
    if (Platform.isWindows) {
      WindowsNotificationService().showNotification(notification);
    }
  },
);
```

### NotificationInitializer

Platform-aware notification initialization widget.

**Behavior:**
- **Android/iOS**: Initializes Firebase Cloud Messaging
- **Windows**: Initializes WindowsNotificationService
- **Other platforms**: No-op (graceful degradation)

**Auto-detection**: Checks `Platform.isWindows`, `Platform.isAndroid`, etc.

## Notification Flow

### Realtime Event Flow

```
Backend creates notification
          ↓
Supabase INSERT event
          ↓
NotificationRealtimeService receives event
          ↓
Syncs to local Drift database
          ↓
Triggers onNotificationReceived callback
          ↓
WindowsNotificationService.showNotification()
          ↓
flutter_local_notifications shows toast
          ↓
Windows Action Center displays notification
          ↓
User sees notification
```

### Tap Handling Flow

```
User taps notification in Action Center
          ↓
flutter_local_notifications callback
          ↓
WindowsNotificationService._handleNotificationTap()
          ↓
Parse payload (notificationId|entityType|entityId)
          ↓
Mark notification as read (repository)
          ↓
Navigate to entity (NotificationNavigationService)
          ↓
User sees task/event/project detail screen
```

## Payload Structure

Notifications include payload for tap handling:

```
Format: "notificationId|entityType|entityId"
Example: "550e8400-e29b-41d4-a716-446655440000|task|abc123"
```

This allows the app to:
- Mark the specific notification as read
- Navigate to the correct entity detail screen
- Track which notification was tapped

## Testing

### Prerequisites

- Windows 10 or later
- PlanPal app running
- Logged in with valid user account
- Internet connection (for Realtime WebSocket)

### Manual Testing

1. **Start App**: Run PlanPal on Windows
2. **Verify Initialization**: Check logs for "✓ Windows local notifications initialized"
3. **Create Notification**: Use another device/browser to trigger a notification
4. **Observe**: Toast notification should appear in Windows Action Center
5. **Tap**: Click the notification
6. **Verify**: App should navigate to the entity and mark as read

### API Testing

Use the backend API to create test notifications:

```bash
# Create a test notification
curl -X POST http://localhost:3000/api/notifications \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "workspaceId": "workspace-uuid",
    "type": "task_assigned",
    "title": "Test Notification",
    "body": "This is a test notification for Windows",
    "entityType": "task",
    "entityId": "task-uuid"
  }'
```

### Testing Scenarios

1. **App in Foreground**
   - Notification appears immediately
   - Badge updates in real-time
   - Can tap to navigate

2. **App Minimized**
   - Notification appears in Action Center
   - Tapping brings app to foreground
   - Navigates to entity

3. **App Closed**
   - No notification shown (expected)
   - On app open, unread badge shows count
   - All notifications visible in list

4. **Multiple Notifications**
   - Multiple toasts appear
   - All synced to local database
   - Badge shows total count

5. **Network Offline**
   - No real-time updates (expected)
   - On reconnect, missed notifications sync
   - Badge updates after sync

## Limitations

### No Background Notifications

Windows desktop apps **cannot show notifications when the app is closed** unless they:
- Run as a Windows service (requires admin privileges)
- Use scheduled tasks (complex setup)
- Implement UWP notifications (requires Windows Store package)

For PlanPal, we chose simplicity:
- Notifications only when app is running
- Sync missed notifications on app open
- Clear UX showing unread count

### Windows Action Center

- Notifications appear in Windows Action Center
- User can configure notification preferences in Windows Settings
- Notifications can be grouped (future enhancement)
- Rich notifications limited compared to mobile

### Realtime Dependency

Windows notifications require:
- Active internet connection
- Supabase Realtime WebSocket connection
- User must be logged in
- App must be running

If any of these fail:
- No notifications shown
- App continues to work normally
- Notifications synced on next successful connection

## User Experience

### Visual Appearance

Windows toast notifications show:
- **Title**: Notification title (e.g., "New Task Assigned")
- **Body**: Notification body (e.g., task description)
- **Icon**: PlanPal app icon
- **Sound**: System notification sound (if enabled)

### User Control

Users can:
- View all notifications in app notification center
- Disable Windows notifications in app settings (future)
- Configure Windows notification settings in OS
- Clear Action Center notifications manually

### Notification States

- **Unread**: Bold text, visible in list with unread indicator
- **Read**: Normal text, marked when user taps or views
- **Deleted**: Removed from list and Action Center
- **Expired**: Automatically cleared from Action Center after timeout

## Configuration

### Enable/Disable

```dart
// Disable Windows notifications
ref.read(windowsNotificationEnabledProvider.notifier).state = false;

// Enable Windows notifications
ref.read(windowsNotificationEnabledProvider.notifier).state = true;

// Check status
final enabled = ref.read(windowsNotificationEnabledProvider);
```

### Initialization

Automatic initialization via `NotificationInitializer` widget:

```dart
NotificationInitializer(
  child: MaterialApp.router(
    // App configuration
  ),
)
```

## Best Practices

### Performance

- Notifications are lightweight (no heavy processing)
- Database sync is asynchronous
- UI updates use streams (efficient)
- No polling or timers needed

### User Experience

- Clear notification titles and descriptions
- Immediate visual feedback (toast + badge)
- Easy navigation to relevant content
- Non-intrusive (respects Windows settings)

### Error Handling

All errors are logged and handled gracefully:
- Initialization failure: App continues without notifications
- Show notification failure: Logged but doesn't crash
- Navigation failure: Shows error message to user
- Network issues: Handled by Realtime reconnection logic

## Troubleshooting

### Notifications Not Appearing

**Check:**
1. Is app running?
2. Is user logged in?
3. Is internet connected?
4. Is Realtime service active? (check logs)
5. Are Windows notifications enabled in OS?
6. Check app logs for errors

**Solution:**
- Restart app
- Check network connection
- Verify Realtime subscription is active
- Check Windows notification settings

### Notifications Not Clearing

**Check:**
1. Is navigation working?
2. Is mark-as-read API responding?
3. Check local database state

**Solution:**
- Check backend API health
- Verify database sync is working
- Try marking as read manually

### Navigation Not Working

**Check:**
1. Is globalNavigatorKey set?
2. Is entity ID valid?
3. Is route defined for entity type?

**Solution:**
- Verify entity exists in database
- Check route configuration
- Review navigation logs

## Future Enhancements

Potential improvements:

- [ ] Rich notifications with images
- [ ] Action buttons (Mark as Read, Dismiss)
- [ ] Notification grouping by type/workspace
- [ ] Customizable notification sounds
- [ ] In-app notification preferences UI
- [ ] Background service for true push (UWP)
- [ ] Notification history retention policies
- [ ] Analytics (delivery rates, tap rates)

## Resources

- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Windows Notifications API](https://learn.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/adaptive-interactive-toasts)
- [Supabase Realtime Documentation](https://supabase.com/docs/guides/realtime)

## Files

Implementation files:

- `lib/features/notifications/data/windows_notification_service.dart`
- `lib/features/notifications/data/windows_notification_provider.dart`
- `lib/features/notifications/data/notification_realtime_service.dart` (enhanced)
- `lib/features/notifications/presentation/notification_providers.dart` (enhanced)
- `lib/core/initialization/fcm_initializer.dart` (renamed to NotificationInitializer)
- `lib/app.dart` (uses NotificationInitializer)

## Summary

Windows notifications in PlanPal:
- ✅ Work when app is running
- ✅ Real-time via Supabase
- ✅ Navigate to entities on tap
- ✅ Sync to local database
- ✅ Show in Windows Action Center
- ❌ Don't work when app is closed (Windows limitation)
- ✅ Graceful degradation (app works without them)
- ✅ Easy to test and debug
