# Android Push Notifications Implementation

## Overview

This document describes the Android push notification implementation for PlanPal using Firebase Cloud Messaging (FCM).

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Firebase Cloud                           │
│                    (FCM Push Service)                            │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Android Device                              │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           Firebase Messaging Service                       │  │
│  │  • Receives FCM messages                                  │  │
│  │  • Handles background messages                            │  │
│  │  • Routes to local notifications                          │  │
│  └─────────────────────┬─────────────────────────────────────┘  │
│                        │                                          │
│                        ▼                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │      Flutter Local Notifications Plugin                   │  │
│  │  • Shows notifications when app is in foreground          │  │
│  │  • Handles notification taps                              │  │
│  │  • Manages notification channels                          │  │
│  └─────────────────────┬─────────────────────────────────────┘  │
│                        │                                          │
│                        ▼                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │         PlanPal App (Flutter)                             │  │
│  │  • Syncs notifications to local DB                        │  │
│  │  • Updates UI in real-time                                │  │
│  │  • Handles navigation to entities                         │  │
│  │  • Manages notification state                             │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### 1. FirebaseMessagingService (`firebase_messaging_service.dart`)

Singleton service that handles all FCM operations:

- **Initialization**: Sets up FCM, requests permissions, gets token
- **Token Management**: Registers token with backend, handles refresh
- **Message Handling**: Processes foreground, background, and terminated messages
- **Local Notifications**: Shows notifications when app is in foreground
- **Database Sync**: Syncs FCM messages to local Drift database
- **Navigation**: Routes users to entity details when tapping notifications

**Key Methods:**

```dart
// Initialize FCM
await FirebaseMessagingService().initialize();

// Get FCM token
String? token = await FirebaseMessagingService().getToken();

// Request permissions
bool granted = await FirebaseMessagingService().requestPermission();

// Check if enabled
bool enabled = await FirebaseMessagingService().areNotificationsEnabled();
```

### 2. Firebase Messaging Provider (`firebase_messaging_provider.dart`)

Riverpod providers for managing FCM state:

- `firebaseMessagingServiceProvider`: Service singleton with dependencies
- `fcmTokenProvider`: Current FCM token
- `initializeFirebaseMessagingProvider`: Initialization trigger
- `notificationPermissionProvider`: Permission status
- `requestNotificationPermissionProvider`: Permission request

### 3. FCM Initializer (`fcm_initializer.dart`)

Widget that initializes FCM after the app starts and provider scope is available.

### 4. Global Navigator Key (`global_navigator_key.dart`)

Provides navigation context for background/terminated message handling.

### 5. Background Message Handler

Top-level function that handles messages when app is terminated:

```dart
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}
```

## Message Flow

### Foreground (App Open)

1. FCM message received
2. `FirebaseMessaging.onMessage` stream triggered
3. Message synced to local database
4. Local notification shown via `flutter_local_notifications`
5. UI updates in real-time via Supabase Realtime
6. User taps notification → navigates to entity

### Background (App Minimized)

1. FCM message received
2. Android system shows notification automatically
3. User taps notification
4. `FirebaseMessaging.onMessageOpenedApp` stream triggered
5. App brought to foreground
6. Message synced to local database
7. Notification marked as read
8. User navigated to entity

### Terminated (App Closed)

1. FCM message received
2. Android system shows notification automatically
3. User taps notification
4. App launched
5. `getInitialMessage()` returns the message
6. Message processed after app initialization
7. Notification marked as read
8. User navigated to entity (pending navigation if context not ready)

## Notification Channels

Android notification channel configured:

```dart
const channel = AndroidNotificationChannel(
  'planpal_notifications',          // ID
  'PlanPal Notifications',          // Name
  description: 'Notifications for tasks, deadlines, and events',
  importance: Importance.high,      // Shows as heads-up
  enableVibration: true,
  playSound: true,
);
```

## Permissions

### Android 13+ (API 33+)

Requires runtime permission via `flutter_local_notifications`:

```dart
final granted = await plugin.requestNotificationsPermission();
```

### Android 12 and below

Notifications enabled by default.

## Token Registration

FCM tokens are registered with the backend:

```
POST /api/device-tokens
{
  "token": "fcm-token-here",
  "platform": "android"
}
```

Tokens are automatically refreshed and re-registered when they change.

## Payload Structure

FCM messages include data payload for navigation:

```json
{
  "data": {
    "notificationId": "uuid",
    "userId": "uuid",
    "workspaceId": "uuid",
    "type": "task_assigned",
    "title": "New Task Assigned",
    "body": "You have been assigned to 'Implement feature X'",
    "entityType": "task",
    "entityId": "task-uuid",
    "dedupeKey": "task_assigned:task-uuid"
  },
  "notification": {
    "title": "New Task Assigned",
    "body": "You have been assigned to 'Implement feature X'"
  }
}
```

## Testing

See `FIREBASE_SETUP.md` for complete testing instructions.

### Quick Test

1. Run app on physical Android device
2. Check logs for FCM token
3. Send test push from backend:

```bash
curl -X POST http://localhost:3000/api/push/test \
  -H "Authorization: Bearer YOUR_JWT" \
  -d '{"title":"Test","body":"Test notification"}'
```

4. Verify notification appears
5. Tap notification and verify navigation

## Production Considerations

### Security

- FCM tokens are sensitive - never log in production
- Backend service account credentials must be secure
- Validate all notification data before processing

### Performance

- Batch token registration calls
- Handle token refresh gracefully
- Clean up invalid tokens on backend
- Limit notification frequency to avoid spam

### Reliability

- Handle network failures gracefully
- Retry failed token registrations
- Store pending navigation for delayed processing
- Fall back to local notifications if FCM unavailable

### User Experience

- Request permissions at appropriate time (not on first launch)
- Show clear value proposition before requesting
- Provide settings to control notification types
- Allow users to disable specific notification categories

## Error Handling

All errors are logged and handled gracefully:

- **Initialization fails**: App continues without push (local notifications still work)
- **Token registration fails**: Retried on next launch
- **Permission denied**: User can re-enable in settings
- **Navigation context unavailable**: Stored as pending navigation

## Dependencies

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_messaging: ^15.1.5
  flutter_local_notifications: ^18.0.1
```

## Files

Core implementation files:

- `lib/features/notifications/data/firebase_messaging_service.dart`
- `lib/features/notifications/data/firebase_messaging_provider.dart`
- `lib/core/initialization/fcm_initializer.dart`
- `lib/core/navigation/global_navigator_key.dart`
- `lib/firebase_options.dart` (generated by FlutterFire CLI)
- `lib/main.dart` (Firebase initialization)
- `lib/app.dart` (FCMInitializer and global navigator key)

Backend files:

- `BACKEND/src/lib/push-worker.js` (FCM integration)
- `BACKEND/src/workers/push-scheduler.js` (Push processing)
- `BACKEND/src/routes/device-tokens.js` (Token management)
- `BACKEND/src/routes/push.js` (Push sending)

## Limitations

- Requires physical device for testing (emulator may not work reliably)
- FCM has quota limits (check Firebase console)
- Background processing is limited on some devices (battery optimization)
- iOS requires additional setup (not covered in this document)

## Future Enhancements

- [ ] Notification categories (allow users to customize)
- [ ] Notification grouping (group by type/workspace)
- [ ] Rich notifications (images, actions)
- [ ] Silent notifications (data-only updates)
- [ ] Notification analytics (track delivery, open rates)
- [ ] A/B testing for notification content
- [ ] Smart notification timing (based on user activity)
