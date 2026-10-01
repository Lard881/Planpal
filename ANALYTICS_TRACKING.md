# Analytics Tracking Service - Stage 13 Task 5

## Overview
The Analytics Tracking Service provides automatic event tracking with intelligent batching, offline queue management, and a simple API for tracking user behavior throughout the PlanPal app.

## Features

### 1. Automatic Batching
- **Queue System**: Events are queued in memory before sending
- **Batch Size**: Max 100 events per batch
- **Batch Interval**: 30 seconds automatic flush
- **Smart Flushing**: Auto-flushes when queue reaches max size

### 2. Offline Support
- **Queue Persistence**: Events queued when offline
- **Automatic Retry**: Failed batches re-queued
- **Queue Limits**: Max 300 events (3 batches) to prevent memory issues
- **Graceful Degradation**: Drops oldest events if queue exceeds limit

### 3. Privacy Controls
- **Enable/Disable**: Global tracking toggle
- **Selective Tracking**: Choose which events to track
- **User Consent**: Respect user preferences

## Architecture

### Service Structure
```
AnalyticsTrackingService
├─ Event Queue (List<AnalyticsEventBatch>)
├─ Batch Timer (30s interval)
├─ Repository (API calls)
└─ Enabled Flag (privacy control)
```

### Event Flow
```
User Action
    ↓
trackEvent() called
    ↓
Event added to queue
    ↓
Queue size check
    ├─ < 100 events → Wait for timer
    └─ ≥ 100 events → Flush immediately
    ↓
_flushQueue()
    ↓
repository.logEventsBatch()
    ├─ Success → Events logged
    └─ Failure → Re-queue events
```

## Usage

### Basic Setup

#### 1. Provider Integration
The service is automatically initialized via Riverpod:

```dart
final analyticsTrackingServiceProvider = Provider<AnalyticsTrackingService>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  final service = AnalyticsTrackingService(repository: repository);
  
  service.initialize(); // Auto-start batching
  ref.onDispose(() => service.dispose()); // Auto-cleanup
  
  return service;
});
```

#### 2. Using Helpers (Recommended)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/features/analytics/utils/analytics_helpers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Track task completion
        await AnalyticsHelpers.trackTaskCompleted(
          ref,
          taskId: 'task-123',
          workspaceId: 'workspace-456',
          createdAt: DateTime(2024, 1, 1),
          priority: 'high',
        );
      },
      child: Text('Complete Task'),
    );
  }
}
```

#### 3. Direct Service Usage
```dart
final service = ref.read(analyticsTrackingServiceProvider);

await service.trackTaskCreated(
  taskId: 'task-123',
  workspaceId: 'workspace-456',
  priority: 'high',
  dueDate: DateTime.now().add(Duration(days: 7)),
);
```

## Tracking Methods

### Task Events

#### Track Task Created
```dart
await service.trackTaskCreated(
  taskId: 'task-123',
  workspaceId: 'workspace-456',
  priority: 'high', // optional
  dueDate: DateTime.now(), // optional
);
```

**Event Data**:
- `task_id`: String
- `priority`: String (optional)
- `due_date`: ISO 8601 string (optional)
- `created_at`: ISO 8601 string (auto-added)

#### Track Task Completed
```dart
await service.trackTaskCompleted(
  taskId: 'task-123',
  workspaceId: 'workspace-456',
  createdAt: DateTime(2024, 1, 1),
  priority: 'high', // optional
);
```

**Event Data**:
- `task_id`: String
- `created_at`: ISO 8601 string
- `completion_time_hours`: int (auto-calculated)
- `priority`: String (optional)

#### Track Task Updated
```dart
await service.trackTaskUpdated(
  taskId: 'task-123',
  workspaceId: 'workspace-456',
  changedFields: ['title', 'priority'], // optional
);
```

#### Track Task Deleted
```dart
await service.trackTaskDeleted(
  taskId: 'task-123',
  workspaceId: 'workspace-456',
);
```

### Search Events

```dart
await service.trackSearchPerformed(
  query: 'project meeting',
  resultsCount: 15,
  workspaceId: 'workspace-456', // optional
  filterType: 'tasks', // optional
);
```

### Attachment Events

```dart
await service.trackAttachmentUploaded(
  attachmentId: 'attach-123',
  taskId: 'task-456',
  workspaceId: 'workspace-789',
  fileType: 'pdf',
  fileSizeBytes: 1024000,
);
```

### Comment Events

```dart
await service.trackCommentAdded(
  commentId: 'comment-123',
  taskId: 'task-456',
  workspaceId: 'workspace-789',
);
```

### Label Events

```dart
await service.trackLabelApplied(
  labelId: 'label-123',
  taskId: 'task-456',
  workspaceId: 'workspace-789',
);
```

### Project Events

```dart
await service.trackProjectCreated(
  projectId: 'project-123',
  workspaceId: 'workspace-456',
);
```

### Workspace Events

```dart
await service.trackWorkspaceJoined(
  workspaceId: 'workspace-123',
  role: 'member',
);
```

### Reminder Events

```dart
await service.trackReminderSet(
  reminderId: 'reminder-123',
  taskId: 'task-456',
  workspaceId: 'workspace-789',
  reminderTime: DateTime.now().add(Duration(hours: 24)),
);
```

### Filter Events

```dart
await service.trackFilterApplied(
  filterType: 'status',
  workspaceId: 'workspace-456', // optional
  filterValues: {'status': 'in_progress'}, // optional
);
```

### Export Events

```dart
await service.trackExportPerformed(
  exportType: 'csv',
  itemCount: 50,
  workspaceId: 'workspace-456', // optional
);
```

### Notification Events

```dart
await service.trackNotificationClicked(
  notificationId: 'notif-123',
  notificationType: 'task_assigned',
  workspaceId: 'workspace-456', // optional
);
```

### Page View Events

```dart
await service.trackPageViewed(
  pageName: 'task_detail',
  workspaceId: 'workspace-456', // optional
  pageMetadata: {'task_id': 'task-123'}, // optional
);
```

## Advanced Features

### Manual Flush
Force immediate event submission:

```dart
await service.flush();
```

**Use Cases**:
- User logging out
- App going to background
- Critical events that need immediate tracking

### Enable/Disable Tracking
Respect user privacy preferences:

```dart
// Disable tracking
service.setEnabled(false);

// Enable tracking
service.setEnabled(true);

// Check status
if (service.isEnabled) {
  // Tracking is active
}
```

**Behavior When Disabled**:
- All track methods become no-ops
- Event queue is cleared
- Batch timer is stopped
- No network requests made

### Queue Status
Monitor queue size:

```dart
final queueSize = service.queueSize;
print('Events pending: $queueSize');
```

## Best Practices

### 1. Track Meaningful Actions
✅ **Do Track**:
- Task created, completed, updated, deleted
- Search queries and results
- Feature usage (filters, exports, etc.)
- User engagement (page views, clicks)

❌ **Don't Track**:
- Every UI interaction (button hovers, scrolls)
- Personal data (task content, comments)
- Sensitive information (passwords, tokens)

### 2. Use Workspace Context
Always include `workspaceId` when action is workspace-specific:

```dart
// Good - workspace context
await service.trackTaskCreated(
  taskId: taskId,
  workspaceId: currentWorkspaceId, // ✅
);

// Acceptable - global context
await service.trackPageViewed(
  pageName: 'settings',
  // No workspaceId - this is app-level
);
```

### 3. Include Relevant Metadata
Add context that helps understand user behavior:

```dart
// Good - rich context
await service.trackTaskCompleted(
  taskId: taskId,
  workspaceId: workspaceId,
  createdAt: task.createdAt, // ✅ Enables completion time calculation
  priority: task.priority, // ✅ Helps analyze priority patterns
);

// Poor - minimal context
await service.trackTaskCompleted(
  taskId: taskId,
  workspaceId: workspaceId,
);
```

### 4. Error Handling
Tracking methods don't throw errors by design (fire-and-forget):

```dart
// No try-catch needed
await AnalyticsHelpers.trackTaskCreated(ref, ...);

// Errors are logged internally
// App continues normally even if tracking fails
```

### 5. Performance Considerations
- **Async Operations**: All tracking is non-blocking
- **Batching**: Reduces network overhead
- **Memory**: Queue limited to 300 events max
- **No UI Impact**: Tracking doesn't affect user experience

## Integration Examples

### Task Creation Flow
```dart
Future<void> createTask(WidgetRef ref, Task task) async {
  // Create the task
  final createdTask = await taskRepository.createTask(task);
  
  // Track analytics (fire-and-forget)
  AnalyticsHelpers.trackTaskCreated(
    ref,
    taskId: createdTask.id,
    workspaceId: createdTask.workspaceId,
    priority: createdTask.priority,
    dueDate: createdTask.dueAt,
  );
  
  return createdTask;
}
```

### Search Flow
```dart
Future<void> performSearch(WidgetRef ref, String query) async {
  final results = await searchRepository.search(query: query);
  
  // Track search analytics
  AnalyticsHelpers.trackSearchPerformed(
    ref,
    query: query,
    resultsCount: results.totalCount,
    workspaceId: currentWorkspaceId,
    filterType: results.type,
  );
  
  return results;
}
```

### App Lifecycle Integration
```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: AppLifecycleObserver(
        onPause: () {
          // Flush analytics when app goes to background
          final service = ref.read(analyticsTrackingServiceProvider);
          service.flush();
        },
        child: HomeScreen(),
      ),
    );
  }
}
```

## Configuration

### Batch Settings
Modify constants in `analytics_tracking_service.dart`:

```dart
// Maximum events per batch
static const int _maxBatchSize = 100;

// Automatic flush interval
static const Duration _batchInterval = Duration(seconds: 30);
```

### Queue Limits
```dart
// Maximum queue size (in _flushQueue method)
if (_eventQueue.length > _maxBatchSize * 3) {
  // Drop oldest events
}
```

## Troubleshooting

### Events Not Being Logged

**Check 1**: Is tracking enabled?
```dart
if (!service.isEnabled) {
  print('Tracking is disabled');
}
```

**Check 2**: Check queue size
```dart
print('Queue size: ${service.queueSize}');
```

**Check 3**: Check logs
```
// Look for these log messages:
[DEBUG] Event queued: task_created (queue size: 1)
[DEBUG] Flushing 10 events to backend
[INFO] Successfully logged 10 analytics events
```

### Events Being Dropped

**Cause**: Queue size exceeded limit (300 events)

**Solution**:
- Check network connectivity
- Verify backend is accessible
- Reduce batch interval for faster flushing
- Check for persistent network errors

### High Memory Usage

**Cause**: Large queue due to offline mode

**Monitor**:
```dart
print('Queue size: ${service.queueSize}');
// Should be < 300
```

**Solution**: Events automatically dropped after 300

## Testing

### Mock Service for Tests
```dart
class MockAnalyticsTrackingService extends AnalyticsTrackingService {
  final List<Map<String, dynamic>> trackedEvents = [];
  
  @override
  Future<void> trackEvent({
    required AnalyticsEventType eventType,
    String? workspaceId,
    Map<String, dynamic>? eventData,
  }) async {
    trackedEvents.add({
      'type': eventType,
      'workspace': workspaceId,
      'data': eventData,
    });
  }
}
```

### Verify Tracking in Tests
```dart
test('should track task creation', () async {
  final mockService = MockAnalyticsTrackingService();
  
  await createTask(taskData);
  
  expect(mockService.trackedEvents.length, 1);
  expect(mockService.trackedEvents[0]['type'], AnalyticsEventType.taskCreated);
});
```

## Privacy & Compliance

### Data Collected
- **User Actions**: Event types and timestamps
- **Metadata**: Task IDs, workspace IDs, counts
- **NO Personal Data**: Task content, comments, usernames

### User Rights
- **Opt-Out**: Users can disable tracking
- **Data Access**: Users can view their analytics
- **Data Deletion**: Handled by backend retention policies

### Compliance
- **GDPR**: Respects do-not-track preferences
- **CCPA**: Users can opt out
- **Transparency**: Clear about what's tracked

## Status
✅ **Task 5 Complete** - Analytics event tracking service with batching, offline queue, and 15 event types implemented
