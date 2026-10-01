# Notification Localization Guide

## Overview

PlanPal's notification system supports **full localization** for all notification types. This guide explains how to generate localized notification text and add support for new languages.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   NotificationTextService                        │
│  • Generates localized titles and bodies                         │
│  • Formats time-based messages                                   │
│  • Provides icons and colors                                     │
│  • Determines priority levels                                    │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                  AppLocalizations (ARB)                          │
│  • app_en.arb - English translations                             │
│  • app_es.arb - Spanish translations                             │
│  • app_fr.arb - French translations                              │
│  • app_zh.arb - Chinese translations                             │
│  • app_ko.arb - Korean translations                              │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│              NotificationDisplay Extension                       │
│  • getLocalizedTitle() - Get translated title                    │
│  • getLocalizedBody() - Get translated body                      │
│  • getDisplayTitle() - Custom or localized                       │
│  • getDisplayBody() - Custom or localized                        │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                      UI Components                               │
│  • NotificationListTile - Shows localized text                   │
│  • NotificationDetailSheet - Full localized details              │
│  • Push notifications - Localized on device                      │
└─────────────────────────────────────────────────────────────────┘
```

## Supported Notification Types

### Task Notifications
- `task_assigned` - User assigned to a task
- `task_completed` - Task marked as complete
- `task_overdue` - Task past due date
- `task_due_soon` - Task approaching due date
- `task_commented` - New comment on task
- `task_status_changed` - Task status updated

### Project Notifications
- `project_invite` - Invited to join project
- `project_updated` - Project details changed
- `project_deadline` - Project deadline approaching

### Event Notifications
- `event_reminder` - Reminder for upcoming event
- `event_starting_soon` - Event about to start
- `event_updated` - Event details changed
- `event_cancelled` - Event was cancelled

### Chat Notifications
- `chat_message` - New chat message received
- `chat_mention` - User mentioned in chat

### Workspace Notifications
- `workspace_invite` - Invited to join workspace
- `workspace_role_changed` - User role updated

### System Notifications
- `system` - General system messages

## Usage

### Basic Usage - Get Localized Text

```dart
import 'package:flutter/material.dart';
import 'package:planpal/features/notifications/models/notification_display.dart';

// In your widget
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  
  @override
  Widget build(BuildContext context) {
    // Get localized title
    final title = notification.getDisplayTitle(context);
    
    // Get localized body
    final body = notification.getDisplayBody(context);
    
    // Get icon
    final icon = notification.getIcon();
    
    // Get color
    final color = notification.getColor(context);
    
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(body),
    );
  }
}
```

### Advanced Usage - Create Notification with Builder

```dart
import 'package:planpal/features/notifications/models/notification_display.dart';

// Build a task assignment notification
final notification = NotificationBuilder(
  type: NotificationType.taskAssigned,
  userId: currentUser.id,
  workspaceId: workspace.id,
)
  .setEntity(
    type: 'task',
    id: task.id,
    name: task.title,
  )
  .setActor(assignedBy.name)
  .setDedupeKey('task_assigned:${task.id}')
  .build(context);

// Send to backend
final apiData = NotificationBuilder(/*...*/).buildApiData(context);
await apiClient.post('/notifications', body: apiData);
```

### Direct Text Generation

```dart
import 'package:planpal/features/notifications/services/notification_text_service.dart';

// Generate title
final title = NotificationTextService.generateTitle(
  context,
  NotificationType.taskDueSoon,
  entityName: 'Implement feature X',
  actorName: 'John Doe',
);

// Generate body with time formatting
final body = NotificationTextService.generateBody(
  context,
  NotificationType.taskDueSoon,
  entityName: 'Implement feature X',
  dueDate: DateTime.now().add(Duration(hours: 2)),
);
// Result: "Implement feature X" is due in 2 hours
```

## Localization Strings

### English (app_en.arb)

All notification strings follow this pattern:

```json
{
  "notificationTitleTaskAssigned": "Task Assigned",
  "notificationBodyTaskAssigned": "{actor} assigned you to \"{task}\"",
  "@notificationBodyTaskAssigned": {
    "placeholders": {
      "actor": {"type": "String"},
      "task": {"type": "String"}
    }
  }
}
```

### Placeholder Types

- **{actor}** - Name of user who performed action
- **{task}** - Task name/title
- **{project}** - Project name
- **{event}** - Event name
- **{workspace}** - Workspace name
- **{status}** - Status name (e.g., "In Progress")
- **{role}** - Role name (e.g., "Admin")
- **{time}** - Formatted time remaining/overdue
- **{days}**, **{hours}**, **{minutes}** - Time units with pluralization

### Time Formatting

Time-based notifications use special formatting:

```json
{
  "timeRemainingDays": "in {days} {days, plural, =1{day} other{days}}",
  "timeOverdueHours": "{hours} {hours, plural, =1{hour} other{hours}} overdue"
}
```

Examples:
- "in 1 day"
- "in 3 hours"
- "2 days overdue"
- "30 minutes overdue"

## Adding a New Language

### Step 1: Create ARB File

Create `app_XX.arb` file (where XX is language code):

```bash
app/lib/core/l10n/app_es.arb  # Spanish
app/lib/core/l10n/app_fr.arb  # French
app/lib/core/l10n/app_zh.arb  # Chinese
```

### Step 2: Copy English Template

Copy all notification strings from `app_en.arb`:

```json
{
  "@@locale": "es",
  "notificationTitleTaskAssigned": "Tarea Asignada",
  "notificationBodyTaskAssigned": "{actor} te asignó a \"{task}\"",
  "@notificationBodyTaskAssigned": {
    "placeholders": {
      "actor": {"type": "String"},
      "task": {"type": "String"}
    }
  }
}
```

### Step 3: Translate All Strings

Translate:
- All `notificationTitle*` strings
- All `notificationBody*` strings
- All `time*` formatting strings
- Keep placeholders unchanged: `{actor}`, `{task}`, etc.
- Keep `@` metadata unchanged

### Step 4: Update Supported Locales

In `app.dart`, add locale to `supportedLocales`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('es'), // Spanish
  Locale('fr'), // French
  Locale('zh'), // Chinese
  Locale('ko'), // Korean
  Locale('de'), // German (NEW)
],
```

### Step 5: Generate Localizations

Run code generation:

```bash
flutter gen-l10n
```

This generates `AppLocalizations` classes for all languages.

### Step 6: Test

Change device language and verify:
- Notification titles are translated
- Notification bodies are translated
- Time formatting uses correct grammar
- Pluralization works correctly

## Adding a New Notification Type

### Step 1: Add to NotificationType Enum

In `notification.dart`:

```dart
enum NotificationType {
  // ... existing types
  taskPriorityChanged,  // NEW
}
```

### Step 2: Add Localization Strings

In all `app_XX.arb` files:

```json
{
  "notificationTitleTaskPriorityChanged": "Task Priority Changed",
  "notificationBodyTaskPriorityChanged": "\"{task}\" priority changed to {priority}",
  "@notificationBodyTaskPriorityChanged": {
    "placeholders": {
      "task": {"type": "String"},
      "priority": {"type": "String"}
    }
  },
  "notificationBodyTaskPriorityChangedGeneric": "Task priority has changed"
}
```

### Step 3: Add to NotificationTextService

In `notification_text_service.dart`:

```dart
// In generateTitle()
case NotificationType.taskPriorityChanged:
  return l10n.notificationTitleTaskPriorityChanged;

// In generateBody()
case NotificationType.taskPriorityChanged:
  if (entityName != null && additionalInfo != null) {
    return l10n.notificationBodyTaskPriorityChanged(entityName, additionalInfo);
  }
  return l10n.notificationBodyTaskPriorityChangedGeneric;

// In getIcon()
case NotificationType.taskPriorityChanged:
  return Icons.priority_high_outlined;

// In getColor()
case NotificationType.taskPriorityChanged:
  return Colors.orange;

// In getPriority()
case NotificationType.taskPriorityChanged:
  return NotificationPriority.medium;
```

### Step 4: Update Backend

Add type to backend validation (if using enum there too).

### Step 5: Generate and Test

```bash
flutter gen-l10n
```

Test the new notification type in all supported languages.

## Testing Localization

### Manual Testing

1. **Change Device Language**
   - iOS: Settings > General > Language & Region
   - Android: Settings > System > Languages
   - Windows: Settings > Time & Language > Language

2. **Create Test Notifications**
   ```bash
   curl -X POST http://localhost:3000/api/notifications \
     -H "Authorization: Bearer TOKEN" \
     -d '{
       "workspaceId": "uuid",
       "type": "task_assigned",
       "title": "", 
       "body": "",
       "entityType": "task",
       "entityId": "uuid"
     }'
   ```

3. **Verify**
   - Notification appears in correct language
   - Time formatting uses correct grammar
   - Pluralization is correct (1 day vs 2 days)
   - Special characters display properly

### Automated Testing

```dart
testWidgets('Notification shows localized text', (tester) async {
  // Create test notification
  final notification = AppNotification(
    type: NotificationType.taskAssigned,
    // ...
  );
  
  // Build widget with Spanish locale
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: NotificationListTile(notification: notification),
    ),
  );
  
  // Verify Spanish text appears
  expect(find.text('Tarea Asignada'), findsOneWidget);
});
```

## Time Formatting Examples

### English
- in 1 minute
- in 30 minutes
- in 2 hours
- in 5 days
- 10 minutes overdue
- 3 hours overdue
- 2 days overdue

### Spanish
- en 1 minuto
- en 30 minutos
- en 2 horas
- en 5 días
- 10 minutos de retraso
- 3 horas de retraso
- 2 días de retraso

### French
- dans 1 minute
- dans 30 minutes
- dans 2 heures
- dans 5 jours
- en retard de 10 minutes
- en retard de 3 heures
- en retard de 2 jours

## Best Practices

### Writing Localizable Strings

✅ **Do:**
- Use placeholders: `{actor} invited you`
- Keep strings short and clear
- Use consistent terminology
- Include generic fallbacks
- Test pluralization

❌ **Don't:**
- Hardcode user-generated content
- Concatenate translated strings
- Assume word order
- Use idioms that don't translate
- Forget context metadata

### Placeholder Guidelines

```dart
// Good - Clear placeholders
"{actor} assigned {count} tasks to you"

// Bad - Concatenation
"Task " + taskName + " assigned"

// Good - Context provided
"@notificationBodyTaskAssigned": {
  "description": "Shown when user is assigned to a task",
  "placeholders": {
    "actor": {
      "type": "String",
      "description": "Name of person who assigned the task"
    }
  }
}
```

### Fallback Hierarchy

1. **Custom text** (if provided by backend)
2. **Localized with data** (actor name, task name, etc.)
3. **Generic localized** (no specific data)
4. **English default** (if translation missing)

## Troubleshooting

### Missing Translations

**Problem:** Notification shows English even though device is Spanish

**Solution:**
- Check `app_es.arb` has the notification key
- Run `flutter gen-l10n`
- Verify `supportedLocales` includes Spanish
- Check device language settings

### Incorrect Pluralization

**Problem:** "1 days remaining" instead of "1 day remaining"

**Solution:**
- Use `plural` ICU syntax:
  ```json
  "{days} {days, plural, =1{day} other{days}}"
  ```
- Test with values: 0, 1, 2, 100

### Time Not Formatting

**Problem:** Time shows as raw DateTime string

**Solution:**
- Pass `dueDate` or `eventTime` to `generateBody()`
- Verify `_formatTimeRemaining()` is called
- Check DateTime is not null

### Special Characters Display Wrong

**Problem:** Accented characters show as �

**Solution:**
- Ensure ARB file saved as UTF-8
- Check Flutter l10n settings
- Verify font supports characters

## Resources

- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [ICU Message Format](https://unicode-org.github.io/icu/userguide/format_parse/messages/)
- [Material Localization](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)

## Summary

PlanPal notification localization:
- ✅ Supports multiple languages
- ✅ Type-safe with code generation
- ✅ Handles pluralization automatically
- ✅ Formats time correctly per language
- ✅ Falls back gracefully
- ✅ Easy to add new types
- ✅ Easy to add new languages
- ✅ Testable with different locales
- ✅ Works with push notifications
- ✅ Works offline (cached translations)
