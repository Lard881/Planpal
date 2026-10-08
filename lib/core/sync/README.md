# Sync Layer

This directory contains the synchronization service for offline-first functionality.

## Overview

The sync layer provides:
- **Bidirectional sync**: Pull from server and push local changes
- **Conflict resolution**: Three strategies (server_wins, client_wins, fail_on_conflict)
- **Offline queue**: Track changes while offline
- **Automatic sync**: Periodic background sync
- **Manual sync**: User-triggered sync operations

## Architecture

```
┌─────────────────────────────────────────┐
│         Application Layer                │
│   (UI triggers sync operations)          │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Sync Manager                     │
│  - Orchestrates sync operations          │
│  - Manages sync state                    │
│  - Schedules periodic sync               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Sync Service                     │
│  - Pull changes from server              │
│  - Push changes to server                │
│  - Conflict resolution                   │
│  - Batch operations                      │
└─────────┬───────────────┬───────────────┘
          │               │
    ┌─────▼─────┐   ┌────▼──────┐
    │ Local DB  │   │  Backend  │
    │ (Drift)   │   │  API      │
    └───────────┘   └───────────┘
```

## Components

### SyncService

Core service for sync operations.

**Methods:**
- `fullSync()`: Complete bidirectional sync (pull + push)
- `pullChanges()`: Fetch and apply server changes
- `pushChanges()`: Send local changes to server
- `getSyncStatus()`: Get sync metadata from server
- `resetSyncState()`: Clear sync state (debug/testing)

### SyncManager

Orchestrates sync operations and manages state.

**Methods:**
- `sync()`: Perform full sync
- `pullOnly()`: Pull changes only
- `pushOnly()`: Push changes only
- `startPeriodicSync()`: Enable automatic sync
- `stopPeriodicSync()`: Disable automatic sync
- `needsSync()`: Check if sync needed

**Properties:**
- `isSyncing`: Boolean flag for sync status
- `currentState`: Current sync state (idle, syncing, success, error, conflicts)
- `syncStateStream`: Stream of sync state changes

### SyncConfig

Configuration for sync behavior.

```dart
SyncConfig(
  deviceId: 'unique-device-id',
  entityTypes: ['task', 'project', 'label'],
  strategy: ConflictResolutionStrategy.serverWins,
  batchSize: 100,
  timeout: Duration(seconds: 30),
)
```

### SyncResult

Result of sync operation.

```dart
SyncResult(
  success: true,
  processed: 25,
  successful: 24,
  failed: 1,
  conflicts: 2,
  conflictDetails: [...],
  errorMessage: null,
)
```

## Usage

### Basic Sync

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/sync/sync_manager.dart';

// Trigger manual sync
final syncManager = ref.read(syncManagerProvider);
final result = await syncManager.sync();

if (result.success) {
  print('Sync successful: ${result.successful} changes');
} else {
  print('Sync failed: ${result.errorMessage}');
}
```

### Periodic Sync

```dart
// Start automatic sync every 5 minutes
final syncManager = ref.read(syncManagerProvider);
syncManager.startPeriodicSync(
  interval: Duration(minutes: 5),
);

// Stop automatic sync
syncManager.stopPeriodicSync();
```

### Watch Sync State

```dart
// Watch sync state in UI
final syncState = ref.watch(syncStateStreamProvider);

syncState.when(
  data: (state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    } else if (state.isSuccess) {
      return Icon(Icons.check, color: Colors.green);
    } else if (state.isError) {
      return Icon(Icons.error, color: Colors.red);
    }
    return Icon(Icons.sync);
  },
  loading: () => CircularProgressIndicator(),
  error: (_, __) => Icon(Icons.error),
);
```

### Check Sync Status

```dart
// Check if sync is needed
final needsSync = await syncManager.needsSync();

// Get pending operations count
final pendingCount = await syncManager.getPendingCount();

// Get unsynced items count
final unsyncedCount = await syncManager.getUnsyncedCount();
```

### Pull Only

```dart
// Pull changes from server only
final result = await syncManager.pullOnly(
  workspaceId: 'workspace-123',
);
```

### Push Only

```dart
// Push local changes to server only
final result = await syncManager.pushOnly(
  workspaceId: 'workspace-123',
  strategy: ConflictResolutionStrategy.clientWins,
);
```

## Conflict Resolution

### Strategies

**1. Server Wins (Default)**
- Server data takes precedence
- Client changes discarded
- Safest option for most apps

```dart
ConflictResolutionStrategy.serverWins
```

**2. Client Wins**
- Client data takes precedence
- Server data overwritten
- Use when user's local changes are most important

```dart
ConflictResolutionStrategy.clientWins
```

**3. Fail on Conflict**
- Sync fails if conflict detected
- Requires manual resolution
- Use when conflicts need explicit handling

```dart
ConflictResolutionStrategy.failOnConflict
```

### Example with Custom Strategy

```dart
final result = await syncManager.sync(
  strategy: ConflictResolutionStrategy.clientWins,
);

if (result.hasConflicts) {
  print('Conflicts detected: ${result.conflicts}');
  for (final conflict in result.conflictDetails) {
    print('${conflict.entityType} ${conflict.entityId}: ${conflict.resolution}');
  }
}
```

## Providers

### syncServiceProvider

Provides SyncService instance.

```dart
final serviceAsync = ref.watch(syncServiceProvider);

serviceAsync.when(
  data: (service) => service.fullSync(),
  loading: () => ...,
  error: (e, s) => ...,
);
```

### syncManagerProvider

Provides SyncManager instance.

```dart
final manager = ref.read(syncManagerProvider);
```

### syncStateStreamProvider

Stream of sync state changes.

```dart
final stateAsync = ref.watch(syncStateStreamProvider);
```

### isSyncingProvider

Boolean flag for syncing status.

```dart
final isSyncing = ref.watch(isSyncingProvider);
```

### deviceIdProvider

Unique device identifier (persisted).

```dart
final deviceId = await ref.watch(deviceIdProvider.future);
```

### pendingOperationsProvider

Stream of pending operations count.

```dart
final pendingCount = ref.watch(pendingOperationsProvider);
```

### syncStatusProvider

Stream indicating if sync is needed.

```dart
final needsSync = ref.watch(syncStatusProvider);
```

## Sync Flow

### Full Sync Flow

```
1. Check if sync needed
   ├─ Pending operations?
   └─ Unsynced items?

2. Pull Phase
   ├─ Get last sync timestamps
   ├─ Request changes from server
   ├─ Apply changes to local DB
   └─ Update sync metadata

3. Push Phase
   ├─ Get pending operations
   ├─ Split into batches
   ├─ Send each batch to server
   ├─ Handle conflicts
   └─ Remove successful operations

4. Update State
   ├─ Success: Clear pending queue
   ├─ Conflicts: Log details
   └─ Error: Retry later
```

### Pull Changes Flow

```
1. Request: GET /sync/pull
   └─ Query params: device_id, entity_types, workspace_id

2. Server Response:
   {
     "changes": {
       "task": [
         {"id": "...", "operation": "update", "data": {...}}
       ],
       "project": [...]
     },
     "sync_timestamps": {...},
     "server_timestamp": "..."
   }

3. Apply Changes:
   └─ For each entity type:
      ├─ Parse changes
      ├─ Apply to local DB
      └─ Update sync state

4. Result: SyncResult with counts
```

### Push Changes Flow

```
1. Get Pending Operations:
   └─ Query local pending_operations table

2. Build Request: POST /sync/push
   {
     "device_id": "...",
     "conflict_resolution": "server_wins",
     "changes": [
       {
         "entity_type": "task",
         "entity_id": "...",
         "operation": "update",
         "data": {...},
         "client_updated_at": "..."
       }
     ]
   }

3. Server Processing:
   └─ For each change:
      ├─ Check for conflicts
      ├─ Apply resolution strategy
      └─ Update database

4. Handle Response:
   └─ For each result:
      ├─ Success: Remove from pending queue
      ├─ Conflict: Log details
      └─ Error: Keep in queue, increment retry

5. Result: SyncResult with conflicts
```

## Error Handling

### Network Errors

```dart
try {
  final result = await syncManager.sync();
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    // Handle timeout
  } else if (e.type == DioExceptionType.connectionError) {
    // Handle no internet
  }
}
```

### Conflict Errors

```dart
final result = await syncManager.sync(
  strategy: ConflictResolutionStrategy.failOnConflict,
);

if (result.hasConflicts) {
  // Show conflict resolution UI
  showConflictDialog(result.conflictDetails);
}
```

### Retry Logic

```dart
// Automatic retry with exponential backoff
int retryCount = 0;
const maxRetries = 3;

while (retryCount < maxRetries) {
  final result = await syncManager.sync();
  
  if (result.success) break;
  
  retryCount++;
  await Future.delayed(Duration(seconds: 2 << retryCount));
}
```

## Best Practices

1. **Always check network**: Use connectivity monitoring before sync
2. **Handle conflicts gracefully**: Choose appropriate strategy
3. **Batch operations**: Sync in batches to avoid timeouts
4. **Update UI**: Show sync progress and status
5. **Error recovery**: Implement retry logic
6. **Periodic sync**: Balance frequency with battery life
7. **User control**: Provide manual sync option
8. **Test conflicts**: Simulate multi-device scenarios

## Testing

```dart
import 'package:planpal/core/sync/sync_service.dart';
import 'package:planpal/core/sync/sync_manager.dart';

test('should sync successfully', () async {
  final mockService = MockSyncService();
  final manager = SyncManager(syncService: mockService);
  
  when(mockService.fullSync(any, any)).thenAnswer((_) async => SyncResult(
    success: true,
    processed: 10,
    successful: 10,
    failed: 0,
    conflicts: 0,
  ));
  
  final result = await manager.sync();
  
  expect(result.success, true);
  expect(result.processed, 10);
});
```

## Performance

### Optimization Tips

1. **Incremental sync**: Only fetch changes since last sync
2. **Batch size**: Tune based on network speed (default: 100)
3. **Entity filtering**: Sync only needed entity types
4. **Compression**: Enable gzip compression on API
5. **Indexes**: Ensure database indexes on sync columns
6. **Parallel batches**: Process multiple batches concurrently

### Monitoring

```dart
// Track sync performance
final stopwatch = Stopwatch()..start();
final result = await syncManager.sync();
stopwatch.stop();

print('Sync took ${stopwatch.elapsedMilliseconds}ms');
print('Throughput: ${result.processed / stopwatch.elapsedMilliseconds * 1000} items/sec');
```

## Troubleshooting

### Sync Not Working

1. Check network connectivity
2. Verify device ID is persisted
3. Check auth token validity
4. Review server logs
5. Inspect pending operations queue

### Conflicts Not Resolving

1. Check conflict resolution strategy
2. Review server and client timestamps
3. Verify entity versioning
4. Check for data inconsistencies

### Performance Issues

1. Reduce batch size
2. Increase timeout duration
3. Sync fewer entity types
4. Optimize database queries
5. Enable API caching

## Related Files

- `sync_service.dart`: Core sync implementation
- `sync_manager.dart`: Sync orchestration
- `sync_providers.dart`: Riverpod providers
- `../database/`: Local database layer
- `../connectivity/`: Network monitoring (Task 5)
- `../offline_queue/`: Queue management (Task 4)
