# Offline Queue

This directory contains the offline queue management system for handling operations while offline.

## Overview

The offline queue provides:
- **Operation queuing**: Persist CRUD operations while offline
- **Automatic replay**: Operations sync when connection restored
- **Local updates**: Immediate UI feedback with local database
- **Queue management**: Size limits, retry logic, error handling
- **Statistics tracking**: Monitor queue health and status

## Architecture

```
┌─────────────────────────────────────────┐
│         Application Layer                │
│   (User performs CRUD operations)        │
└─────────────────┬───────────────────────┘
                  │
                  ▼ Offline?
┌─────────────────────────────────────────┐
│     Offline Queue Manager                │
│  - Enqueue operation                     │
│  - Update local database                 │
│  - Mark as unsynced                      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Pending Operations Table             │
│  - Persists operations                   │
│  - Survives app restart                  │
│  - Ordered by timestamp                  │
└─────────────────┬───────────────────────┘
                  │
                  ▼ Online?
┌─────────────────────────────────────────┐
│         Sync Service                     │
│  - Dequeue operations                    │
│  - Push to server                        │
│  - Clear on success                      │
└─────────────────────────────────────────┘
```

## Components

### OfflineQueueManager

Core manager for queue operations.

**Methods:**
- `enqueue(operation)`: Add operation to queue
- `dequeue(id)`: Remove operation from queue
- `clearQueue()`: Clear all operations
- `getAllOperations()`: Get all pending operations
- `getQueueSize()`: Get queue size
- `getStats()`: Get queue statistics
- `processOperation(operation)`: Process and apply locally

**Specialized Methods:**
- `enqueueTaskOperation()`: Queue task operation
- `enqueueProjectOperation()`: Queue project operation
- `enqueueLabelOperation()`: Queue label operation
- `enqueueCommentOperation()`: Queue comment operation

### QueuedOperation

Represents an operation to be queued.

```dart
QueuedOperation(
  entityType: 'task',
  entityId: 'task-uuid',
  operation: OperationType.update,
  data: {'title': 'Updated Title'},
  timestamp: DateTime.now(),
)
```

### OperationType

Enum for operation types.

```dart
enum OperationType {
  insert,
  update,
  delete,
}
```

### QueueStats

Statistics about the queue.

```dart
QueueStats(
  totalOperations: 15,
  pendingOperations: 13,
  failedOperations: 2,
  oldestOperation: DateTime(...),
  newestOperation: DateTime(...),
)
```

## Usage

### Basic Queue Operations

```dart
import 'package:planpal/core/offline_queue/offline_queue_manager.dart';

// Get queue manager
final queueManager = ref.read(offlineQueueManagerProvider);

// Enqueue task creation
await queueManager.enqueueTaskOperation(
  taskId: 'task-123',
  operation: OperationType.insert,
  taskData: {
    'workspace_id': 'workspace-123',
    'title': 'New Task',
    'status': 'todo',
    'created_by': userId,
    'created_at': DateTime.now().toIso8601String(),
  },
);

// Enqueue task update
await queueManager.enqueueTaskOperation(
  taskId: 'task-123',
  operation: OperationType.update,
  taskData: {
    'title': 'Updated Task',
    'status': 'in_progress',
  },
);

// Enqueue task deletion
await queueManager.enqueueTaskOperation(
  taskId: 'task-123',
  operation: OperationType.delete,
);
```

### Using Helper Functions

```dart
import 'package:planpal/core/offline_queue/queue_helpers.dart';

// Create task
await QueueHelpers.createTask(
  ref,
  taskId: 'task-123',
  taskData: {...},
);

// Update task
await QueueHelpers.updateTask(
  ref,
  taskId: 'task-123',
  taskData: {'title': 'Updated'},
);

// Delete task
await QueueHelpers.deleteTask(
  ref,
  taskId: 'task-123',
);
```

### Using WidgetRef Extensions

```dart
// In a ConsumerWidget
await ref.enqueueCreateTask('task-123', taskData);
await ref.enqueueUpdateTask('task-123', updatedData);
await ref.enqueueDeleteTask('task-123');

// Get queue size
final size = await ref.getQueueSize();

// Clear queue
await ref.clearQueue();
```

### Watch Queue Statistics

```dart
// Watch queue stats in UI
final statsAsync = ref.watch(queueStatsStreamProvider);

statsAsync.when(
  data: (stats) {
    return Column(
      children: [
        Text('Pending: ${stats.pendingOperations}'),
        Text('Failed: ${stats.failedOperations}'),
        if (stats.oldestOperation != null)
          Text('Oldest: ${stats.oldestOperation}'),
      ],
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);
```

### Check Queue Status

```dart
// Check if queue is empty
final isEmptyAsync = ref.watch(isQueueEmptyProvider);

// Check for failed operations
final hasFailedAsync = ref.watch(hasFailedOperationsProvider);

// Get queue size
final sizeAsync = ref.watch(queueSizeProvider);
```

## Offline Workflow

### Create/Update Flow

```
1. User Action
   └─ User creates/updates a task

2. Check Connectivity
   ├─ Online: Direct API call
   └─ Offline: Queue operation

3. Queue Operation (if offline)
   ├─ Add to pending_operations table
   ├─ Update local database
   ├─ Mark as unsynced
   └─ Show success UI

4. When Online Again
   ├─ Sync service pulls queue
   ├─ Pushes to server
   ├─ Handles conflicts
   ├─ Updates local state
   └─ Clears queue
```

### Example: Create Task While Offline

```dart
Future<void> createTask(WidgetRef ref, TaskData task) async {
  final isOnline = ref.read(connectivityProvider);
  
  if (isOnline) {
    // Direct API call
    await taskRepository.createTask(task);
  } else {
    // Queue operation
    await ref.enqueueCreateTask(
      task.id,
      {
        'workspace_id': task.workspaceId,
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task queued for sync')),
    );
  }
}
```

## Queue Configuration

### Limits

```dart
// Maximum queue size
static const int maxQueueSize = 1000;

// Maximum retry attempts
static const int maxRetries = 3;
```

### Behavior

- **Queue full**: Oldest operations dropped (FIFO)
- **Max retries exceeded**: Operation marked as failed
- **App restart**: Queue persists
- **Duplicate operations**: Latest operation used

## Statistics & Monitoring

### Get Statistics

```dart
final queueManager = ref.read(offlineQueueManagerProvider);
final stats = await queueManager.getStats();

print('Total: ${stats.totalOperations}');
print('Pending: ${stats.pendingOperations}');
print('Failed: ${stats.failedOperations}');
print('Oldest: ${stats.oldestOperation}');
print('Newest: ${stats.newestOperation}');
```

### Monitor Queue Health

```dart
// Stream of queue stats
final statsStream = queueManager.queueStatsStream;

statsStream.listen((stats) {
  if (stats.failedOperations > 5) {
    // Alert: Too many failed operations
  }
  
  if (stats.totalOperations > 500) {
    // Warning: Queue getting large
  }
});
```

## Error Handling

### Failed Operations

```dart
// Check for failed operations
final hasFailed = await queueManager.hasFailedOperations();

if (hasFailed) {
  // Option 1: Retry
  await queueManager.retryFailedOperations();
  
  // Option 2: Clear failed
  final operations = await queueManager.getAllOperations();
  for (final op in operations) {
    if (op.retryCount >= OfflineQueueManager.maxRetries) {
      await queueManager.dequeue(op.id);
    }
  }
  
  // Option 3: Show UI for manual resolution
  showFailedOperationsDialog(operations);
}
```

### Queue Full

```dart
// Handled automatically - oldest dropped
// Monitor queue size to prevent this:

final size = await queueManager.getQueueSize();
if (size > 800) {
  // Warning: Queue approaching limit
  showQueueWarningDialog();
}
```

## Integration with Sync

The queue integrates seamlessly with the sync service:

```dart
// Sync service automatically processes queue
final syncManager = ref.read(syncManagerProvider);

// Manual sync with queue processing
final result = await syncManager.sync();

print('Queued operations synced: ${result.successful}');

// Check if queue is empty after sync
final isEmpty = await queueManager.isEmpty();
if (isEmpty) {
  print('All operations synced successfully');
}
```

## Best Practices

1. **Always queue when offline**: Don't fail user actions
2. **Immediate feedback**: Update local DB and show success
3. **Monitor queue size**: Alert when approaching limits
4. **Handle failures**: Provide UI for manual resolution
5. **Clear on logout**: Consider clearing queue on user logout
6. **Test queue overflow**: Simulate queue full scenarios
7. **Validate before queue**: Ensure data is valid before queuing

## Testing

```dart
import 'package:planpal/core/offline_queue/offline_queue_manager.dart';

test('should enqueue operation', () async {
  final mockDatabase = MockAppDatabase();
  final queueManager = OfflineQueueManager(database: mockDatabase);
  
  final operation = QueuedOperation(
    entityType: 'task',
    entityId: 'task-123',
    operation: OperationType.insert,
    data: {'title': 'Test Task'},
  );
  
  final result = await queueManager.enqueue(operation);
  
  expect(result, true);
  verify(mockDatabase.addPendingOperation(any, any, any, any)).called(1);
});

test('should process queued operation locally', () async {
  final mockDatabase = MockAppDatabase();
  final queueManager = OfflineQueueManager(database: mockDatabase);
  
  final operation = QueuedOperation(
    entityType: 'task',
    entityId: 'task-123',
    operation: OperationType.insert,
    data: {
      'id': 'task-123',
      'workspace_id': 'workspace-123',
      'title': 'Test Task',
      'created_by': 'user-123',
      'created_at': DateTime.now().toIso8601String(),
    },
  );
  
  await queueManager.processOperation(operation);
  
  verify(mockDatabase.insertTask(any)).called(1);
});
```

## Performance

### Optimization Tips

1. **Batch operations**: Group related operations
2. **Prune old operations**: Clear completed operations regularly
3. **Index database**: Ensure indexes on entity_id and created_at
4. **Limit queue size**: Keep under 1000 operations
5. **Async processing**: Don't block UI thread

### Monitoring Performance

```dart
final stopwatch = Stopwatch()..start();

// Enqueue operation
await queueManager.enqueue(operation);

stopwatch.stop();
print('Enqueue took ${stopwatch.elapsedMilliseconds}ms');

// Should be < 50ms for good performance
if (stopwatch.elapsedMilliseconds > 50) {
  print('Warning: Slow enqueue operation');
}
```

## Troubleshooting

### Queue Not Working

1. Check database initialization
2. Verify table creation
3. Check write permissions
4. Review error logs

### Operations Not Syncing

1. Verify connectivity
2. Check sync service integration
3. Review operation format
4. Check for conflicts

### Queue Growing Large

1. Trigger manual sync
2. Check sync frequency
3. Review failed operations
4. Consider clearing old operations

## Related Files

- `offline_queue_manager.dart`: Core queue implementation
- `offline_queue_providers.dart`: Riverpod providers
- `queue_helpers.dart`: Helper functions
- `../sync/`: Sync service (processes queue)
- `../database/`: Local database (stores queue)
- `../connectivity/`: Network monitoring
