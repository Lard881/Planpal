# Notification Settings Guide

## Overview

PlanPal provides **granular control** over notification preferences, allowing users to customize exactly which notifications they want to receive and when.

## Features

### Global Controls
- **Push Notifications** - Master switch to enable/disable all notifications
- **Sound** - Toggle notification sounds
- **Vibration** - Toggle vibration (mobile only)

### Quiet Hours
- **Enable/Disable** - Automatically pause notifications during specified hours
- **Start Time** - When quiet hours begin (default: 10:00 PM)
- **End Time** - When quiet hours end (default: 7:00 AM)
- **Overnight Support** - Handles quiet hours that span midnight (e.g., 10 PM to 7 AM)

### Per-Type Controls

Users can enable/disable each notification type individually:

**Task Notifications** (6 types):
- Task Assigned
- Task Completed
- Task Overdue
- Task Due Soon
- New Comments
- Status Changed

**Project Notifications** (3 types):
- Project Invitations
- Project Updates
- Project Deadlines

**Event Notifications** (4 types):
- Event Reminders
- Event Starting Soon
- Event Updates
- Event Cancelled

**Chat Notifications** (2 types):
- New Messages
- Mentions

**Workspace Notifications** (2 types):
- Workspace Invitations
- Role Changes

**System Notifications** (1 type):
- System Messages

**Total**: 18 configurable notification types

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│              NotificationSettings (Model)                        │
│  • Freezed data class with all preferences                       │
│  • Extension methods for checking enabled states                 │
│  • JSON serialization for persistence                            │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│        NotificationSettingsService (Persistence)                 │
│  • Load/save settings to SharedPreferences                       │
│  • JSON encoding/decoding                                        │
│  • Reset to defaults                                             │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│      NotificationSettingsNotifier (State Management)             │
│  • Riverpod StateNotifier                                        │
│  • Toggle methods for all settings                               │
│  • Automatic persistence on changes                              │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│         NotificationSettingsScreen (UI)                          │
│  • Settings organized by category                                │
│  • Switch tiles for each option                                  │
│  • Time pickers for quiet hours                                  │
│  • Bulk actions (Enable All, Disable All, Reset)                │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│          Notification Services (Enforcement)                     │
│  • WindowsNotificationService checks before showing              │
│  • FirebaseMessagingService checks before showing                │
│  • Respect quiet hours and type preferences                      │
└─────────────────────────────────────────────────────────────────┘
```

## Usage

### Access Settings Screen

```dart
// Navigate to settings
context.push('/notifications/settings');
```

### Check if Notification Should Show

```dart
final settings = ref.watch(notificationSettingsProvider);

// Check specific type
if (settings.isTypeEnabled('task_assigned')) {
  // Show notification
}

// Check if in quiet hours
if (!settings.isInQuietHours) {
  // Show notification
}

// Check everything (recommended)
if (settings.shouldShowNotification('task_assigned')) {
  // This checks:
  // - pushEnabled
  // - isInQuietHours
  // - isTypeEnabled
}
```

### Update Settings Programmatically

```dart
final notifier = ref.read(notificationSettingsProvider.notifier);

// Toggle push notifications
await notifier.togglePushEnabled();

// Toggle specific type
await notifier.toggleNotificationType('task_assigned', true);

// Set quiet hours
await notifier.setQuietHours(22, 7); // 10 PM to 7 AM

// Enable all types
await notifier.enableAllTypes();

// Disable all types
await notifier.disableAllTypes();

// Reset to defaults
await notifier.resetToDefaults();
```

## Data Model

### NotificationSettings

```dart
class NotificationSettings {
  // Global
  final bool pushEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  
  // Per-type (18 fields)
  final bool taskAssignedEnabled;
  final bool taskCompletedEnabled;
  // ... etc
  
  // Quiet hours
  final bool quietHoursEnabled;
  final int quietHoursStart;
  final int quietHoursEnd;
}
```

### Extension Methods

```dart
// Check if type is enabled
bool isTypeEnabled(String type)

// Check if in quiet hours
bool get isInQuietHours

// Check if should show (respects all settings)
bool shouldShowNotification(String type)

// Get count of enabled types
int get enabledTypesCount

// Check if all/none enabled
bool get allTypesEnabled
bool get noTypesEnabled
```

## Persistence

Settings are stored in **SharedPreferences** as JSON:

```json
{
  "pushEnabled": true,
  "soundEnabled": true,
  "vibrationEnabled": true,
  "taskAssignedEnabled": true,
  "taskCompletedEnabled": false,
  "quietHoursEnabled": true,
  "quietHoursStart": 22,
  "quietHoursEnd": 7
}
```

**Storage Location:**
- Android: `/data/data/com.yourcompany.planpal/shared_prefs/`
- iOS: `NSUserDefaults`
- Windows: Registry or local file
- Web: localStorage

**Key:** `notification_settings`

## UI Components

### Sections

1. **General** - Global switches (push, sound, vibration)
2. **Quiet Hours** - Enable/disable and time range
3. **Task Notifications** - 6 task-related switches
4. **Project Notifications** - 3 project-related switches
5. **Event Notifications** - 4 event-related switches
6. **Chat Notifications** - 2 chat-related switches
7. **Workspace Notifications** - 2 workspace-related switches
8. **System Notifications** - 1 system switch
9. **Summary** - Count of enabled types and current quiet hours

### Actions Menu

- **Enable All** - Turns on all 18 notification types
- **Disable All** - Turns off all 18 notification types
- **Reset to Defaults** - Restores original settings (all enabled)

### Dependencies

Disabled controls:
- When `pushEnabled` is false, all other switches are disabled
- Sound and vibration depend on push being enabled
- Quiet hours time pickers only show when quiet hours are enabled

## Integration with Services

### Windows Notifications

```dart
// In WindowsNotificationService
Future<void> showNotification(AppNotification notification) async {
  // Check settings before showing
  if (_settings != null) {
    if (!_settings!.shouldShowNotification(notification.type.value)) {
      return; // Don't show
    }
  }
  
  // Show notification...
}
```

### Firebase Cloud Messaging

Similar pattern - check settings before showing foreground notifications.

### Notification Display

Filter notifications in UI based on settings:

```dart
// In notification list
final settings = ref.watch(notificationSettingsProvider);
final filteredNotifications = notifications.where((n) {
  return settings.isTypeEnabled(n.type.value);
}).toList();
```

## Testing

### Manual Testing

1. **Open Settings**
   - Navigate to Notifications > Settings
   - Verify all 18 types are listed
   - Toggle each switch
   - Settings should persist after app restart

2. **Test Quiet Hours**
   - Enable quiet hours
   - Set to current time + 1 minute
   - Wait for notification
   - Verify it's suppressed

3. **Test Type Filtering**
   - Disable "Task Assigned"
   - Trigger task assignment
   - Verify no notification shown

4. **Test Bulk Actions**
   - Tap "Disable All"
   - Verify all switches turn off
   - Tap "Enable All"
   - Verify all switches turn on
   - Tap "Reset"
   - Verify defaults restored

### Automated Testing

```dart
testWidgets('Settings screen renders', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: NotificationSettingsScreen(),
      ),
    ),
  );
  
  expect(find.text('Push Notifications'), findsOneWidget);
  expect(find.text('Task Notifications'), findsOneWidget);
});

test('shouldShowNotification respects all settings', () {
  final settings = NotificationSettings(
    pushEnabled: true,
    taskAssignedEnabled: true,
    quietHoursEnabled: false,
  );
  
  expect(settings.shouldShowNotification('task_assigned'), true);
  
  final disabledSettings = settings.copyWith(pushEnabled: false);
  expect(disabledSettings.shouldShowNotification('task_assigned'), false);
});
```

## Best Practices

### When to Check Settings

✅ **Do check:**
- Before showing local notifications
- Before playing notification sounds
- Before triggering vibration
- In notification list filters (optional)

❌ **Don't check:**
- When syncing from backend (always sync all)
- When storing in local database (store everything)
- For unread counts (count all, not just enabled types)

### Performance

- Settings are cached in memory (Riverpod state)
- Only reload from SharedPreferences on app start
- Changes are written to disk immediately
- No network calls required

### User Experience

- Provide clear descriptions for each type
- Show current quiet hours in the toggle subtitle
- Display summary of enabled types count
- Offer bulk enable/disable for convenience
- Confirm before bulk actions (optional)

## Quiet Hours Examples

### Example 1: Overnight (22:00 to 07:00)

```dart
NotificationSettings(
  quietHoursEnabled: true,
  quietHoursStart: 22, // 10 PM
  quietHoursEnd: 7,    // 7 AM
)

// At 23:00 (11 PM): isInQuietHours = true
// At 03:00 (3 AM): isInQuietHours = true
// At 06:00 (6 AM): isInQuietHours = true
// At 08:00 (8 AM): isInQuietHours = false
```

### Example 2: Lunch Break (12:00 to 14:00)

```dart
NotificationSettings(
  quietHoursEnabled: true,
  quietHoursStart: 12, // 12 PM
  quietHoursEnd: 14,   // 2 PM
)

// At 11:00 (11 AM): isInQuietHours = false
// At 12:30 (12:30 PM): isInQuietHours = true
// At 15:00 (3 PM): isInQuietHours = false
```

## Localization

Add to `app_en.arb`:

```json
{
  "notificationSettings": "Notification Settings",
  "notificationSettingsPush": "Push Notifications",
  "notificationSettingsSound": "Sound",
  "notificationSettingsVibration": "Vibration",
  "notificationSettingsQuietHours": "Quiet Hours",
  "notificationSettingsEnableAll": "Enable All",
  "notificationSettingsDisableAll": "Disable All",
  "notificationSettingsReset": "Reset to Defaults"
}
```

## Troubleshooting

### Settings Not Persisting

**Problem:** Changes don't persist after app restart

**Solution:**
- Check SharedPreferences initialization
- Verify JSON serialization works
- Check device storage permissions

### Notifications Still Showing When Disabled

**Problem:** Notifications appear even when type is disabled

**Solution:**
- Verify `shouldShowNotification()` is called
- Check settings are loaded correctly
- Ensure services have latest settings

### Quiet Hours Not Working

**Problem:** Notifications show during quiet hours

**Solution:**
- Verify `isInQuietHours` calculation
- Check device time/timezone
- Test with different hour ranges

## Future Enhancements

- [ ] Per-workspace notification settings
- [ ] Different quiet hours for weekdays/weekends
- [ ] Notification priority levels
- [ ] Smart quiet hours (auto-detect based on usage)
- [ ] Sync settings across devices (backend storage)
- [ ] Custom notification sounds per type
- [ ] Notification grouping preferences
- [ ] Do Not Disturb integration (OS level)

## Summary

Notification settings in PlanPal:
- ✅ 18 configurable notification types
- ✅ Global enable/disable switch
- ✅ Sound and vibration controls
- ✅ Quiet hours with overnight support
- ✅ Persisted in SharedPreferences
- ✅ Checked before showing notifications
- ✅ Bulk actions (enable all, disable all, reset)
- ✅ Clean, organized UI by category
- ✅ Real-time updates (Riverpod reactive)
- ✅ Works offline (local storage)
- ✅ Extensible for new notification types
