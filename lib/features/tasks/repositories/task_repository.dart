import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class TaskRepository {
  final AppDatabase _db;
  final ApiClient _api;

  TaskRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _db = database,
        _api = apiClient;

  // ========================================================================
  // Local database operations
  // ========================================================================

  /// Get all tasks for a workspace
  Stream<List<TaskData>> watchTasks(String workspaceId) {
    return (_db.select(_db.tasks)
          ..where((t) => t.workspaceId.equals(workspaceId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Get tasks with filters
  Stream<List<TaskData>> watchTasksFiltered({
    required String workspaceId,
    String? projectId,
    String? assigneeId,
    String? status,
    TaskView? view,
  }) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.workspaceId.equals(workspaceId))
      ..where((t) => t.deletedAt.isNull());

    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }

    if (assigneeId != null) {
      query.where((t) => t.assigneeId.equals(assigneeId));
    }

    if (status != null) {
      query.where((t) => t.status.equals(status));
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
          // No filter
          break;
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    return query.watch();
  }

  /// Get a single task by ID
  Future<TaskData?> getTask(String id) {
    return (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Watch a single task
  Stream<TaskData?> watchTask(String id) {
    return (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  // ========================================================================
  // Create, Update, Delete (with outbox)
  // ========================================================================

  /// Create a new task (writes to local DB and queues for sync)
  Future<TaskData> createTask({
    required String workspaceId,
    required String title,
    String? projectId,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? assigneeId,
    List<String>? labelIds,
  }) async {
    final taskId = _uuid.v4();
    final now = DateTime.now();

    final task = TasksCompanion.insert(
      id: Value(taskId),
      workspaceId: workspaceId,
      projectId: Value(projectId),
      title: title,
      description: Value(description),
      status: Value(status ?? 'todo'),
      priority: Value(priority),
      dueDate: Value(dueDate),
      assigneeId: Value(assigneeId),
      createdBy: 'current-user-id', // TODO: Get from auth
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.tasks).insert(task);

    // Queue for sync
    await _queueOutbox(
      entity: 'task',
      entityId: taskId,
      action: 'create',
      payload: {
        'id': taskId,
        'workspace_id': workspaceId,
        'project_id': projectId,
        'title': title,
        'description': description,
        'status': status ?? 'todo',
        'priority': priority,
        'due_date': dueDate?.toIso8601String(),
        'assignee_id': assigneeId,
        'labels': labelIds ?? [],
      },
    );

    return (await getTask(taskId))!;
  }

  /// Update a task
  Future<void> updateTask(
    String taskId,
    TasksCompanion updates,
  ) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(updates.copyWith(updatedAt: Value(DateTime.now())));

    // Queue for sync
    await _queueOutbox(
      entity: 'task',
      entityId: taskId,
      action: 'update',
      payload: updates.toJson(),
    );
  }

  /// Delete a task (soft delete)
  Future<void> deleteTask(String taskId) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Queue for sync
    await _queueOutbox(
      entity: 'task',
      entityId: taskId,
      action: 'delete',
      payload: {},
    );
  }

  /// Toggle task completion
  Future<void> toggleComplete(String taskId, bool isCompleted) async {
    final now = DateTime.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        status: Value(isCompleted ? 'completed' : 'todo'),
        completedAt: Value(isCompleted ? now : null),
        updatedAt: Value(now),
      ),
    );

    // Queue for sync
    await _queueOutbox(
      entity: 'task',
      entityId: taskId,
      action: 'update',
      payload: {
        'status': isCompleted ? 'completed' : 'todo',
        'completed_at': isCompleted ? now.toIso8601String() : null,
      },
    );
  }

  // ========================================================================
  // API operations (for when online)
  // ========================================================================

  /// Fetch tasks from API
  Future<List<Task>> fetchTasks({
    required String workspaceId,
    String? projectId,
    String? assigneeId,
    String? status,
    TaskView? view,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, String>{
      'workspace_id': workspaceId,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (projectId != null) queryParams['project_id'] = projectId;
    if (assigneeId != null) queryParams['assignee_id'] = assigneeId;
    if (status != null) queryParams['status'] = status;
    if (view != null) queryParams['view'] = view.value;

    final response = await _api.get('/tasks', queryParams: queryParams);
    final tasks = (response.data['tasks'] as List)
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();

    return tasks;
  }

  /// Create task via API
  Future<Task> createTaskOnline(Task task) async {
    final response = await _api.post('/tasks', body: task.toJson());
    return Task.fromJson(response.data['task'] as Map<String, dynamic>);
  }

  /// Update task via API
  Future<Task> updateTaskOnline(String taskId, Map<String, dynamic> updates) async {
    final response = await _api.patch('/tasks/$taskId', body: updates);
    return Task.fromJson(response.data['task'] as Map<String, dynamic>);
  }

  /// Delete task via API
  Future<void> deleteTaskOnline(String taskId) async {
    await _api.delete('/tasks/$taskId');
  }

  // ========================================================================
  // Helpers
  // ========================================================================

  /// Queue an operation in the outbox for sync
  Future<void> _queueOutbox({
    required String entity,
    required String entityId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    await _db.outboxDao.insert(OutboxCompanion.insert(
      entity: entity,
      entityId: entityId,
      action: action,
      payload: payload.toString(), // Convert to JSON string
      createdAt: Value(DateTime.now()),
    ));
  }
}
