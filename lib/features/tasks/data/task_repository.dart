// app/lib/features/tasks/data/task_repository.dart
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/db/app_database.dart';
import '../../../core/sync/sync_engine.dart';
import '../models/task_model.dart';

const _uuid = Uuid();

class TaskRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;

  TaskRepository(this._dio, this._db, this._sync);

  // ── List ──────────────────────────────────────────────────────────────────
  /// Stream from Drift for offline-first display — shows cached data instantly.
  Stream<List<TaskModel>> watchTasks(
    String workspaceId, {
    String? status,
    String? priority,
    String? view,
  }) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final weekEnd = now.add(const Duration(days: 7));

    return (_db.select(_db.tasks)
          ..where((t) {
            Expression<bool> expr = t.workspaceId.equals(workspaceId) &
                t.deletedAt.isNull();
            if (status != null) expr = expr & t.status.equals(status);
            if (priority != null) expr = expr & t.priority.equals(priority);
            if (view == 'today') {
              expr = expr &
                  t.dueAt.isBiggerOrEqualValue(todayStart) &
                  t.dueAt.isSmallerThanValue(todayEnd);
            } else if (view == 'week') {
              expr = expr &
                  t.dueAt.isBiggerOrEqualValue(now) &
                  t.dueAt.isSmallerThanValue(weekEnd);
            } else if (view == 'overdue') {
              expr = expr &
                  t.dueAt.isSmallerThanValue(now) &
                  t.status.equals('completed').not();
            }
            return expr;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map((r) => TaskModel(
              id: r.id,
              workspaceId: r.workspaceId,
              title: r.title,
              description: r.description,
              status: r.status,
              priority: r.priority,
              dueAt: r.dueAt,
              assigneeId: r.assigneeId,
              labelId: r.labelId,
              createdBy: r.createdBy,
              completedAt: r.completedAt,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            )).toList());
  }

  // ── Fetch from API and merge into Drift ───────────────────────────────────
  Future<(List<TaskModel>, String? cursor, AppFailure?)> getTasks(
    String workspaceId, {
    String? status,
    String? priority,
    String? assigneeId,
    String? view, // all|today|week|overdue
    String? sort,
    String? cursor,
    String? q,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (status != null) params['status'] = status;
      if (priority != null) params['priority'] = priority;
      if (assigneeId != null) params['assigneeId'] = assigneeId;
      if (view != null && view != 'all') params['view'] = view;
      if (sort != null) params['sort'] = sort;
      if (cursor != null) params['cursor'] = cursor;
      if (q != null && q.isNotEmpty) params['q'] = q;

      final res = await _dio.get('/workspaces/$workspaceId/tasks',
          queryParameters: params);
      final tasks = (res.data['tasks'] as List)
          .map((t) => TaskModel.fromJson(t as Map<String, dynamic>))
          .toList();
      final nextCursor = res.data['nextCursor'] as String?;
      // Merge into Drift so offline reads are up to date
      await _db.transaction(() async {
        for (final task in tasks) {
          await _db.into(_db.tasks).insertOnConflictUpdate(TasksCompanion(
            id: Value(task.id),
            workspaceId: Value(task.workspaceId),
            title: Value(task.title),
            description: Value(task.description),
            status: Value(task.status),
            priority: Value(task.priority),
            dueAt: Value(task.dueAt),
            assigneeId: Value(task.assigneeId),
            labelId: Value(task.labelId),
            createdBy: Value(task.createdBy),
            completedAt: Value(task.completedAt),
            createdAt: Value(task.createdAt),
            updatedAt: Value(task.updatedAt),
          ));
        }
      });
      return (tasks, nextCursor, null);
    } on DioException catch (e) {
      return (<TaskModel>[], null, mapDioError(e));
    }
  }

  // ── Get single ────────────────────────────────────────────────────────────
  Future<(TaskModel?, AppFailure?)> getTask(String taskId) async {
    try {
      final res = await _dio.get('/tasks/$taskId');
      return (TaskModel.fromJson(res.data['task'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────
  Future<(TaskModel?, AppFailure?)> createTask(
    String workspaceId, {
    required String title,
    String description = '',
    String priority = 'medium',
    DateTime? dueAt,
    String? assigneeId,
    String? labelId,
    List<String> subtaskTitles = const [],
  }) async {
    final clientId = _uuid.v4();
    // Write to Drift first (offline-first)
    final now = DateTime.now();
    final currentUserId =
        Supabase.instance.client.auth.currentUser?.id ?? 'local';
    await _db.into(_db.tasks).insertOnConflictUpdate(TasksCompanion.insert(
      id: clientId,
      workspaceId: workspaceId,
      title: title,
      description: Value(description),
      status: const Value('todo'),
      priority: Value(priority),
      dueAt: Value(dueAt),
      assigneeId: Value(assigneeId),
      labelId: Value(labelId),
      createdBy: currentUserId,
      createdAt: now,
      updatedAt: now,
    ));

    try {
      final data = <String, dynamic>{
        'id': clientId,
        'title': title,
        'description': description,
        'priority': priority,
        if (dueAt != null) 'dueAt': dueAt.toIso8601String(),
        if (assigneeId != null) 'assigneeId': assigneeId,
        if (labelId != null) 'labelId': labelId,
        if (subtaskTitles.isNotEmpty)
          'subtasks': subtaskTitles.map((t) => {'title': t}).toList(),
      };
      final res = await _dio.post('/workspaces/$workspaceId/tasks', data: data);
      return (TaskModel.fromJson(res.data['task'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      // Queue for later sync
      await _sync.queueCreate('workspaces/$workspaceId/tasks', clientId, {
        'id': clientId, 'title': title, 'description': description,
        'priority': priority,
        if (dueAt != null) 'dueAt': dueAt.toIso8601String(),
      });
      return (null, mapDioError(e));
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────
  Future<AppFailure?> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/tasks/$taskId', data: updates);
      return null;
    } on DioException catch (e) {
      await _sync.queueUpdate('tasks', taskId, updates);
      return mapDioError(e);
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<AppFailure?> deleteTask(String taskId) async {
    // Soft-delete locally
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(TasksCompanion(deletedAt: Value(DateTime.now())));
    try {
      await _dio.delete('/tasks/$taskId');
      return null;
    } on DioException catch (e) {
      await _sync.queueDelete('tasks', taskId);
      return mapDioError(e);
    }
  }

  // ── Bulk ──────────────────────────────────────────────────────────────────
  Future<(int succeeded, List<String> failed, AppFailure?)> bulkAction(
    List<String> taskIds, String action) async {
    try {
      final res = await _dio.post('/tasks/bulk',
          data: {'ids': taskIds, 'action': action});
      final succeeded = res.data['succeeded'] as int? ?? taskIds.length;
      final failed = (res.data['failed'] as List? ?? [])
          .map((e) => e.toString()).toList();
      return (succeeded, failed, null);
    } on DioException catch (e) {
      return (0, taskIds, mapDioError(e));
    }
  }

  // ── Subtasks ──────────────────────────────────────────────────────────────
  Future<AppFailure?> addSubtask(String taskId, String title) async {
    try {
      await _dio.post('/tasks/$taskId/subtasks', data: {'title': title});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> updateSubtask(
      String subtaskId, {String? title, bool? isDone}) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (isDone != null) data['done'] = isDone; // backend field name is 'done'
      await _dio.patch('/subtasks/$subtaskId', data: data);
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  // ── Comments ──────────────────────────────────────────────────────────────
  Future<AppFailure?> addComment(String taskId, String body) async {
    try {
      await _dio.post('/tasks/$taskId/comments', data: {'body': body});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider.notifier),
  );
});

// Helper: compute display date string for a task
String taskDateLabel(TaskModel task) {
  if (task.isCompleted && task.completedAt != null) {
    return 'Done ${_monthDay(task.completedAt!)}';
  }
  if (task.dueAt == null) return '';
  final now = DateTime.now();
  final due = task.dueAt!;
  final today = DateTime(now.year, now.month, now.day);
  final dueDay = DateTime(due.year, due.month, due.day);
  final diff = dueDay.difference(today).inDays;

  final timeStr = due.minute == 0
      ? '${_hour12(due.hour)} ${due.hour < 12 ? 'AM' : 'PM'}'
      : '${_hour12(due.hour)}:${due.minute.toString().padLeft(2, '0')} ${due.hour < 12 ? 'AM' : 'PM'}';

  if (diff == 0) return 'Today · $timeStr';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  if (diff < 0) return _monthDay(due);
  return _monthDay(due);
}

String _monthDay(DateTime dt) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun',
                  'Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${months[dt.month - 1]} ${dt.day}';
}

int _hour12(int h) => h == 0 ? 12 : (h > 12 ? h - 12 : h);
