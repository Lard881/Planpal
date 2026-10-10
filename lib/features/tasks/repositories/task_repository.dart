import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/sync/outbox_service.dart';
import '../models/task.dart' as models;
import '../models/task.dart' show TaskView;
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Task repository with Drift + Outbox + Sync (S7.13)
/// Follows offline-first pattern from Stage 6
class TaskRepository {
  final AppDatabase _db;
  final ApiClient _api;
  final OutboxService _outbox;

  TaskRepository({
    required AppDatabase database,
    required ApiClient apiClient,
    required OutboxService outboxService,
  })  : _db = database,
        _api = apiClient,
        _outbox = outboxService;

  // ========================================================================
  // READ operations (Drift streams for reactive UI)
  // ========================================================================

  /// Watch all tasks for a workspace
  Stream<List<Task>> watchTasks(String workspaceId) {
    return (_db.select(_db.tasks)
          ..where((t) => t.workspaceId.equals(workspaceId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watch tasks with filters (status, assignee, view)
  Stream<List<Task>> watchTasksFiltered({
    required String workspaceId,
    String? status,
    String? assigneeId,
    String? labelId,
    TaskView? view,
  }) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.workspaceId.equals(workspaceId))
      ..where((t) => t.deletedAt.isNull());

    if (status != null) {
      query.where((t) => t.status.equals(status));
    }

    if (assigneeId != null) {
      query.where((t) => t.assigneeId.equals(assigneeId));
    }

    if (labelId != null) {
      // Label filtering handled via TaskLabels junction
    }

    // View-based filters
    if (view != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final weekEnd = today.add(const Duration(days: 7));

      switch (view) {
        case TaskView.today:
          query
            ..where((t) => t.dueDate.isSmallerOrEqualValue(today))
            ..where((t) => t.status.equals('completed').not());
          break;
        case TaskView.week:
          query
            ..where((t) => t.dueDate.isSmallerOrEqualValue(weekEnd))
            ..where((t) => t.status.equals('completed').not());
          break;
        case TaskView.overdue:
          query
            ..where((t) => t.dueDate.isSmallerThanValue(now))
            ..where((t) => t.status.equals('completed').not());
          break;
        case TaskView.completed:
          query.where((t) => t.status.equals('completed'));
          break;
        case TaskView.all:
          // No additional filter
          break;
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch();
  }

  /// Watch a single task
  Stream<Task?> watchTask(String id) {
    return (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Get a single task (one-time read)
  Future<Task?> getTask(String id) {
    return (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // ========================================================================
  // WRITE operations (Offline-first: local DB + outbox)
  // ========================================================================

  /// Create a new task (offline-first)
  Future<Task> createTask({
    required String workspaceId,
    required String title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? assigneeId,
    String? labelId,
  }) async {
    final taskId = _uuid.v4();
    final now = DateTime.now();

    // 1. Save to local DB immediately
    final task = TasksCompanion.insert(
      id: taskId,
      workspaceId: workspaceId,
      title: title,
      status: status ?? 'todo',
      priority: priority ?? 'medium',
      createdBy: 'current-user', // Will be set by server
      createdAt: now,
      updatedAt: now,
      description: Value(description ?? ''),
      dueDate: Value(dueDate),
      assigneeId: Value(assigneeId),
      // labelId removed - not in schema
    );

    await _db.into(_db.tasks).insert(task);

    // 2. Queue for sync (outbox handles retry)
    await _outbox.enqueue(
      entityType: 'task',
      entityId: taskId,
      operation: 'create',
      payload: {
        'workspace_id': workspaceId,
        'id': taskId, // Client-supplied ID for idempotency
        'title': title,
        'description': description,
        'status': status ?? 'todo',
        'priority': priority ?? 'medium',
        'due_at': dueDate?.toIso8601String(),
        'assignee_id': assigneeId,
        'label_id': labelId,
      },
    );

    return (await getTask(taskId))!;
  }

  /// Update a task (offline-first)
  Future<void> updateTask(
    String taskId,
    TasksCompanion updates,
  ) async {
    // 1. Update local DB immediately
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(updates.copyWith(updatedAt: Value(DateTime.now())));

    // 2. Get workspace ID and prepare payload
    final task = await getTask(taskId);
    if (task == null) return;

    final payload = <String, dynamic>{};
    if (updates.title.present) payload['title'] = updates.title.value;
    if (updates.description.present) {
      payload['description'] = updates.description.value;
    }
    if (updates.status.present) payload['status'] = updates.status.value;
    if (updates.priority.present) payload['priority'] = updates.priority.value;
    if (updates.dueDate.present) {
      payload['due_at'] = updates.dueDate.value?.toIso8601String();
    }
    if (updates.assigneeId.present) {
      payload['assignee_id'] = updates.assigneeId.value;
    }
    // labelId removed - not in schema
    // if (updates.labelId.present) {
    //   payload['label_id'] = updates.labelId.value;
    // }

    // 3. Queue for sync
    payload['workspace_id'] = task.workspaceId;
    await _outbox.enqueue(
      entityType: 'task',
      entityId: taskId,
      operation: 'update',
      payload: payload,
    );
  }

  /// Delete a task (offline-first soft delete)
  Future<void> deleteTask(String taskId) async {
    final now = DateTime.now();

    // 1. Soft delete in local DB immediately
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // 2. Get workspace ID (read before it's filtered out)
    final task = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task == null) return;

    // 3. Queue for sync
    await _outbox.enqueue(
      entityType: 'task',
      entityId: taskId,
      operation: 'delete',
      payload: {'workspace_id': task.workspaceId},
    );
  }

  /// Toggle task completion (convenience method)
  Future<void> toggleComplete(String taskId, bool isCompleted) async {
    final now = DateTime.now();

    await updateTask(
      taskId,
      TasksCompanion(
        status: Value(isCompleted ? 'completed' : 'todo'),
        completedAt: Value(isCompleted ? now : null),
      ),
    );
  }

  // ========================================================================
  // SYNC operations (pull from server, merge into Drift)
  // ========================================================================

  /// Fetch tasks from server and merge into local DB
  /// Called by SyncService automatically
  Future<void> syncTasks(String workspaceId) async {
    try {
      final response = await _api.get(
        '/workspaces/$workspaceId/tasks',
        queryParameters: {'limit': 100},
      );

      final tasksJson = response.data['tasks'] as List;

      for (final taskJson in tasksJson) {
        await _mergeTaskFromServer(taskJson as Map<String, dynamic>);
      }
    } catch (e) {
      // Sync fails silently (SyncService handles retry)
      print('Task sync failed: $e');
    }
  }

  /// Merge a task from server into local DB (upsert)
  Future<void> _mergeTaskFromServer(Map<String, dynamic> json) async {
    final apiTask = models.Task.fromJson(json);

    final task = TasksCompanion.insert(
      id: apiTask.id,
      workspaceId: apiTask.workspaceId,
      title: apiTask.title,
      status: apiTask.status,
      priority: apiTask.priority ?? 'medium',
      createdBy: apiTask.createdBy,
      createdAt: apiTask.createdAt,
      updatedAt: apiTask.updatedAt,
      description: Value(apiTask.description ?? ''),
      dueDate: Value(apiTask.dueDate),
      assigneeId: Value(apiTask.assigneeId),
      // labelId removed - not in schema
      completedAt: Value(apiTask.completedAt),
      deletedAt: Value(apiTask.deletedAt),
    );

    await _db.into(_db.tasks).insertOnConflictUpdate(task);
  }

  // ========================================================================
  // BULK operations
  // ========================================================================

  /// Bulk complete tasks (queued via outbox)
  Future<void> bulkComplete(List<String> taskIds) async {
    for (final taskId in taskIds) {
      await updateTask(
        taskId,
        TasksCompanion(status: const Value('completed')),
      );
    }
  }

  /// Bulk delete tasks (queued via outbox)
  Future<void> bulkDelete(List<String> taskIds) async {
    for (final taskId in taskIds) {
      await deleteTask(taskId);
    }
  }
}
