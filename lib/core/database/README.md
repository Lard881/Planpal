# Local Database Layer

This directory contains the local database implementation using Drift (formerly Moor) for offline-first functionality.

## Overview

The local database mirrors the backend Supabase schema and enables:
- **Offline data access**: Full CRUD operations while offline
- **Sync queue**: Pending operations tracked until online
- **Conflict resolution**: Track sync state and handle conflicts
- **Performance**: Fast local queries without network latency

## Architecture

```
┌─────────────────────────────────────────────┐
│           Application Layer                  │
│  (Features: Tasks, Projects, Labels, etc.)  │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│         Sync Service Layer                   │
│  - Bidirectional sync (pull/push)           │
│  - Conflict resolution                       │
│  - Offline queue management                  │
└─────────────┬─────────────┬─────────────────┘
              │             │
    ┌─────────▼────┐  ┌────▼────────┐
    │ Local DB     │  │  Supabase   │
    │ (Drift)      │  │  (Remote)   │
    └──────────────┘  └─────────────┘
```

## Database Schema

### Entity Tables

All entity tables include:
- Standard fields matching backend schema
- `is_synced`: Boolean flag indicating sync status
- `deleted_at`: For soft deletes (matches backend)
- `updated_at`: Automatic timestamp for change tracking

**Tables:**
- `local_tasks`: Task entities
- `local_projects`: Project entities
- `local_labels`: Label entities
- `local_task_labels`: Task-Label relationships
- `local_comments`: Task comments
- `local_attachments`: File attachments
- `local_links`: External links

### Support Tables

**pending_operations**
- Tracks CRUD operations performed while offline
- Auto-replayed when connection restored
- Includes retry count and error tracking

**sync_states**
- Tracks last sync timestamp per entity type
- Stores sync status (idle, syncing, error)
- Enables incremental sync

## Usage

### Initialize Database

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/database/database_providers.dart';

// Access database via provider
final database = ref.read(appDatabaseProvider);
```

### Basic CRUD Operations

#### Tasks

```dart
// Get all tasks
final tasks = await database.getAllTasks(workspaceId: 'workspace-id');

// Get single task
final task = await database.getTaskById('task-id');

// Insert task
await database.insertTask(localTask);

// Update task
await database.updateTask(
  'task-id',
  LocalTasksCompanion(
    title: Value('Updated Title'),
    status: Value('completed'),
  ),
);

// Delete task (soft delete)
await database.deleteTask('task-id');

// Batch upsert (for sync)
await database.batchUpsertTasks([task1, task2, task3]);
```

#### Projects

```dart
// Get all projects
final projects = await database.getAllProjects(workspaceId: 'workspace-id');

// Insert project
await database.insertProject(localProject);

// Batch upsert
await database.batchUpsertProjects([proj1, proj2]);
```

#### Labels

```dart
// Get all labels
final labels = await database.getAllLabels(workspaceId: 'workspace-id');

// Insert label
await database.insertLabel(localLabel);
```

### Offline Queue Management

```dart
// Add operation to queue
await database.addPendingOperation(
  entityType: 'task',
  entityId: 'task-id',
  operation: 'update',
  data: jsonEncode(taskData),
);

// Get all pending operations
final pending = await database.getAllPendingOperations();

// Remove operation after successful sync
await database.removePendingOperation(operationId);

// Clear all operations
await database.clearPendingOperations();
```

### Sync State Management

```dart
// Get sync state for entity type
final syncState = await database.getSyncState('task');

// Update sync state
await database.updateSyncState(
  entityType: 'task',
  lastSyncAt: DateTime.now(),
  syncStatus: 'success',
);

// Get all sync states
final allStates = await database.getAllSyncStates();
```

### Utility Operations

```dart
// Get count of unsynced items
final unsyncedCount = await database.getUnsyncedCount();

// Clear all data (logout/reset)
await database.clearAllData();
```

## Entity Mappers

Use `EntityMappers` to convert between Supabase models and local entities:

```dart
import 'package:planpal/core/database/entity_mappers.dart';

// Convert Supabase model to local entity
final localTask = EntityMappers.taskModelToLocal(taskModel);

// Convert local entity to Supabase model
final taskModel = EntityMappers.localTaskToModel(localTask);

// Convert JSON to local entity (for sync)
final localTask = EntityMappers.jsonToLocalTask(jsonData);

// Convert local entity to JSON (for sync)
final jsonData = EntityMappers.localTaskToJson(localTask);

// Batch conversions
final localTasks = EntityMappers.taskModelsToLocal(taskModels);
final taskModels = EntityMappers.localTasksToModels(localTasks);
```

## Providers

**appDatabaseProvider**
- Provides singleton database instance
- Auto-closes on dispose

**unsyncedCountProvider**
- Stream of unsynced items count
- Updates every 5 seconds

**syncStateProvider**
- Stream of sync state per entity type
- Updates every 2 seconds

**pendingOperationsCountProvider**
- Stream of pending operations count
- Updates every 2 seconds

```dart
// Watch unsynced count
final unsyncedCount = ref.watch(unsyncedCountProvider);

// Watch sync state for tasks
final taskSyncState = ref.watch(syncStateProvider('task'));

// Watch pending operations
final pendingCount = ref.watch(pendingOperationsCountProvider);
```

## Code Generation

After modifying `app_database.dart`, regenerate code:

```bash
# Run build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

This generates `app_database.g.dart` with table definitions and type-safe queries.

## Database Location

- **Android**: `/data/data/com.planpal.app/app_flutter/planpal.db`
- **iOS**: `~/Library/Application Support/planpal.db`
- **Windows**: `%APPDATA%\PlanPal\planpal.db`
- **macOS**: `~/Library/Application Support/com.planpal.app/planpal.db`
- **Linux**: `~/.local/share/planpal/planpal.db`

## Migration Strategy

When schema changes are needed:

1. Increment `schemaVersion` in `AppDatabase`
2. Add migration logic in `onUpgrade`
3. Test migration path from previous versions

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1 && to == 2) {
      // Add new column
      await m.addColumn(localTasks, localTasks.newColumn);
    }
  },
);
```

## Performance Tips

1. **Batch Operations**: Use `batch()` for multiple inserts/updates
2. **Indexes**: Add indexes on frequently queried columns
3. **Pagination**: Use `limit()` and `offset()` for large datasets
4. **Soft Deletes**: Filter `deletedAt.isNull()` in queries
5. **Streams**: Use `watch()` for reactive queries

## Testing

```dart
import 'package:drift/native.dart';

// Create in-memory database for testing
final database = AppDatabase(
  NativeDatabase.memory(),
);

// Run tests
test('should insert task', () async {
  final task = LocalTask(...);
  await database.insertTask(task);
  
  final result = await database.getTaskById(task.id);
  expect(result, equals(task));
});
```

## Debugging

Enable SQL logging:

```dart
import 'package:drift/drift.dart';

// In debug mode
if (kDebugMode) {
  database.stream(select(localTasks)).listen((tasks) {
    print('Tasks changed: ${tasks.length}');
  });
}
```

## Best Practices

1. **Always use providers**: Don't instantiate `AppDatabase` directly
2. **Handle null safety**: Use `?.` and `??` operators
3. **Soft delete**: Never hard delete entities that sync
4. **Batch upserts**: Use for sync operations
5. **Track sync status**: Set `is_synced` appropriately
6. **Error handling**: Wrap database operations in try-catch
7. **Close properly**: Let providers handle disposal

## Related Files

- `app_database.dart`: Main database definition and operations
- `database_providers.dart`: Riverpod providers for DI
- `entity_mappers.dart`: Conversion utilities
- `../sync/`: Sync service implementation
