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

class BulkTaskActionResult {
  final List<String> succeededIds;
  final List<String> failedIds;
  final AppFailure? failure;
  final bool queuedOffline;

  const BulkTaskActionResult({
    this.succeededIds = const [],
    this.failedIds = const [],
    this.failure,
    this.queuedOffline = false,
  });

  factory BulkTaskActionResult.fromJson(Map<String, dynamic> json) {
    final succeededIds = (json['succeeded'] as List).cast<String>();
    final failedIds = (json['failed'] as List)
        .map((entry) => (entry as Map<String, dynamic>)['id'] as String)
        .toList();
    return BulkTaskActionResult(
      succeededIds: succeededIds,
      failedIds: failedIds,
    );
  }
}

class TaskRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;
  final String? Function() _currentUserId;

  TaskRepository(
    this._dio,
    this._db,
    this._sync, {
    String? Function()? currentUserId,
  }) : _currentUserId =
           currentUserId ??
           (() => Supabase.instance.client.auth.currentUser?.id);

  // ── List ──────────────────────────────────────────────────────────────────
  /// Stream from Drift for offline-first display — shows cached data instantly.
  Stream<List<TaskModel>> watchTasks(
    String workspaceId, {
    String? status,
    String? priority,
    String? assigneeId,
    String? view,
    String sort = 'due_at',
  }) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final weekEnd = now.add(const Duration(days: 7));

    return (_db.select(_db.tasks)
          ..where((t) {
            Expression<bool> expr =
                t.workspaceId.equals(workspaceId) & t.deletedAt.isNull();
            if (status != null) expr = expr & t.status.equals(status);
            if (priority != null) expr = expr & t.priority.equals(priority);
            if (assigneeId != null) {
              expr = expr & t.assigneeId.equals(assigneeId);
            }
            if (view == 'today') {
              expr =
                  expr &
                  t.dueAt.isBiggerOrEqualValue(todayStart) &
                  t.dueAt.isSmallerThanValue(todayEnd);
            } else if (view == 'week') {
              expr =
                  expr &
                  t.dueAt.isBiggerOrEqualValue(now) &
                  t.dueAt.isSmallerThanValue(weekEnd);
            } else if (view == 'overdue') {
              expr =
                  expr &
                  t.dueAt.isSmallerThanValue(now) &
                  t.status.equals('completed').not();
            }
            return expr;
          })
          ..orderBy([
            (t) => switch (sort) {
              'due_at' => OrderingTerm.asc(t.dueAt),
              'priority' => OrderingTerm.desc(t.priority),
              'created_at' => OrderingTerm.desc(t.createdAt),
              'title' => OrderingTerm.asc(t.title),
              _ => OrderingTerm.desc(t.updatedAt),
            },
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => TaskModel(
                  id: r.id,
                  workspaceId: r.workspaceId,
                  title: r.title,
                  description: r.description,
                  status: r.status,
                  priority: r.priority,
                  dueAt: r.dueAt,
                  reminderMinutesBefore: r.reminderMinutesBefore,
                  assigneeId: r.assigneeId,
                  labelId: r.labelId,
                  createdBy: r.createdBy,
                  completedAt: r.completedAt,
                  createdAt: r.createdAt,
                  updatedAt: r.updatedAt,
                ),
              )
              .toList(),
        );
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

      final res = await _dio.get(
        '/workspaces/$workspaceId/tasks',
        queryParameters: params,
      );
      final tasks = (res.data['tasks'] as List)
          .map((t) => TaskModel.fromJson(t as Map<String, dynamic>))
          .toList();
      final nextCursor = res.data['nextCursor'] as String?;
      // Merge into Drift so offline reads are up to date
      await _db.transaction(() async {
        for (final task in tasks) {
          await _db
              .into(_db.tasks)
              .insertOnConflictUpdate(
                TasksCompanion(
                  id: Value(task.id),
                  workspaceId: Value(task.workspaceId),
                  title: Value(task.title),
                  description: Value(task.description),
                  status: Value(task.status),
                  priority: Value(task.priority),
                  dueAt: Value(task.dueAt),
                  reminderMinutesBefore: Value(task.reminderMinutesBefore),
                  assigneeId: Value(task.assigneeId),
                  labelId: Value(task.labelId),
                  createdBy: Value(task.createdBy),
                  completedAt: Value(task.completedAt),
                  createdAt: Value(task.createdAt),
                  updatedAt: Value(task.updatedAt),
                ),
              );
        }
      });
      return (tasks, nextCursor, null);
    } on DioException catch (e) {
      return (<TaskModel>[], null, mapDioError(e));
    }
  }

  // ── Get single ────────────────────────────────────────────────────────────
  Future<(TaskModel?, AppFailure?)> getTask(
    String taskId, {
    bool offline = false,
  }) async {
    if (offline) {
      final cachedTask = await _getCachedTask(taskId);
      if (cachedTask != null) return (cachedTask, null);
    }

    try {
      final res = await _dio.get('/tasks/$taskId');
      final task = TaskModel.fromJson(res.data['task'] as Map<String, dynamic>);
      await _cacheTask(task);
      return (task, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      final pendingCreate =
          failure is NotFoundFailure &&
          await (_db.select(_db.outboxEntries)..where(
                    (entry) =>
                        entry.entityId.equals(taskId) &
                        entry.operation.equals('create'),
                  ))
                  .getSingleOrNull() !=
              null;
      if (failure is! NetworkFailure &&
          failure is! ServerUnreachableFailure &&
          failure is! TimeoutFailure &&
          !pendingCreate) {
        return (null, failure);
      }
      final cachedTask = await _getCachedTask(taskId);
      return cachedTask == null ? (null, failure) : (cachedTask, null);
    }
  }

  Future<void> _cacheTask(TaskModel task) async {
    await _db.transaction(() async {
      await _db
          .into(_db.tasks)
          .insertOnConflictUpdate(
            TasksCompanion(
              id: Value(task.id),
              workspaceId: Value(task.workspaceId),
              title: Value(task.title),
              description: Value(task.description),
              status: Value(task.status),
              priority: Value(task.priority),
              dueAt: Value(task.dueAt),
              reminderMinutesBefore: Value(task.reminderMinutesBefore),
              assigneeId: Value(task.assigneeId),
              labelId: Value(task.labelId),
              createdBy: Value(task.createdBy),
              completedAt: Value(task.completedAt),
              createdAt: Value(task.createdAt),
              updatedAt: Value(task.updatedAt),
            ),
          );

      for (final subtask in task.subtasks) {
        await _db
            .into(_db.subtasks)
            .insertOnConflictUpdate(
              SubtasksCompanion(
                id: Value(subtask.id),
                taskId: Value(subtask.taskId),
                title: Value(subtask.title),
                isDone: Value(subtask.isDone),
                position: Value(subtask.position),
                createdAt: Value(task.createdAt),
                updatedAt: Value(task.updatedAt),
              ),
            );
      }
      for (final comment in task.comments) {
        await _db
            .into(_db.taskComments)
            .insertOnConflictUpdate(
              TaskCommentsCompanion(
                id: Value(comment.id),
                taskId: Value(comment.taskId),
                authorId: Value(comment.authorId),
                authorName: Value(comment.authorName),
                authorAvatarUrl: Value(comment.authorAvatarUrl),
                body: Value(comment.body),
                createdAt: Value(comment.createdAt),
                updatedAt: Value(comment.createdAt),
              ),
            );
      }
      for (final attachment in task.attachments) {
        await _db
            .into(_db.taskAttachments)
            .insertOnConflictUpdate(
              TaskAttachmentsCompanion(
                taskId: Value(task.id),
                fileId: Value(attachment.fileId),
                name: Value(attachment.name),
                mimeType: Value(attachment.mimeType),
                sizeBytes: Value(attachment.sizeBytes),
                storagePath: Value(attachment.storagePath),
              ),
            );
      }
    });
  }

  Future<TaskModel?> _getCachedTask(String taskId) async {
    final taskRow =
        await (_db.select(_db.tasks)..where(
              (task) => task.id.equals(taskId) & task.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (taskRow == null) return null;

    final subtasks =
        await (_db.select(_db.subtasks)
              ..where(
                (subtask) =>
                    subtask.taskId.equals(taskId) & subtask.deletedAt.isNull(),
              )
              ..orderBy([(subtask) => OrderingTerm.asc(subtask.position)]))
            .get();
    final comments =
        await (_db.select(_db.taskComments)
              ..where(
                (comment) =>
                    comment.taskId.equals(taskId) & comment.deletedAt.isNull(),
              )
              ..orderBy([(comment) => OrderingTerm.asc(comment.createdAt)]))
            .get();
    final attachments = await (_db.select(
      _db.taskAttachments,
    )..where((attachment) => attachment.taskId.equals(taskId))).get();

    return TaskModel(
      id: taskRow.id,
      workspaceId: taskRow.workspaceId,
      title: taskRow.title,
      description: taskRow.description,
      status: taskRow.status,
      priority: taskRow.priority,
      dueAt: taskRow.dueAt,
      reminderMinutesBefore: taskRow.reminderMinutesBefore,
      assigneeId: taskRow.assigneeId,
      labelId: taskRow.labelId,
      createdBy: taskRow.createdBy,
      completedAt: taskRow.completedAt,
      createdAt: taskRow.createdAt,
      updatedAt: taskRow.updatedAt,
      subtasks: subtasks
          .map(
            (subtask) => SubtaskModel(
              id: subtask.id,
              taskId: subtask.taskId,
              title: subtask.title,
              isDone: subtask.isDone,
              position: subtask.position,
            ),
          )
          .toList(),
      comments: comments
          .map(
            (comment) => CommentModel(
              id: comment.id,
              taskId: comment.taskId,
              authorId: comment.authorId,
              authorName: comment.authorName,
              authorAvatarUrl: comment.authorAvatarUrl,
              body: comment.body,
              createdAt: comment.createdAt,
            ),
          )
          .toList(),
      attachments: attachments
          .map(
            (attachment) => AttachmentModel(
              fileId: attachment.fileId,
              name: attachment.name,
              mimeType: attachment.mimeType,
              sizeBytes: attachment.sizeBytes,
              storagePath: attachment.storagePath,
            ),
          )
          .toList(),
    );
  }

  // ── Create ────────────────────────────────────────────────────────────────
  Future<(TaskModel?, AppFailure?)> createTask(
    String workspaceId, {
    required String title,
    String description = '',
    String priority = 'medium',
    DateTime? dueAt,
    int? reminderMinutesBefore,
    String? assigneeId,
    String? labelId,
    List<String> subtaskTitles = const [],
    List<String> attachmentFileIds = const [],
  }) async {
    final clientId = _uuid.v4();
    final childSubtasks = subtaskTitles
        .asMap()
        .entries
        .map(
          (entry) => {
            'id': _uuid.v4(),
            'title': entry.value,
            'position': entry.key,
          },
        )
        .toList();
    // Write to Drift first (offline-first)
    final now = DateTime.now();
    final currentUserId = _currentUserId() ?? 'local';
    await _db.transaction(() async {
      await _db
          .into(_db.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: clientId,
              workspaceId: workspaceId,
              title: title,
              description: Value(description),
              status: const Value('todo'),
              priority: Value(priority),
              dueAt: Value(dueAt),
              reminderMinutesBefore: Value(reminderMinutesBefore),
              assigneeId: Value(assigneeId),
              labelId: Value(labelId),
              createdBy: currentUserId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      for (final subtask in childSubtasks) {
        await _db
            .into(_db.subtasks)
            .insert(
              SubtasksCompanion.insert(
                id: subtask['id']! as String,
                taskId: clientId,
                title: subtask['title']! as String,
                position: Value(subtask['position']! as int),
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    });

    final data = <String, dynamic>{
      'id': clientId,
      'title': title,
      'description': description,
      'priority': priority,
      if (dueAt != null) 'dueAt': dueAt.toUtc().toIso8601String(),
      'reminderMinutesBefore': reminderMinutesBefore,
      if (assigneeId != null) 'assigneeId': assigneeId,
      if (labelId != null) 'labelId': labelId,
      if (childSubtasks.isNotEmpty)
        'subtasks': childSubtasks
            .map((subtask) => {'id': subtask['id'], 'title': subtask['title']})
            .toList(),
      if (attachmentFileIds.isNotEmpty) 'attachmentFileIds': attachmentFileIds,
    };

    try {
      final res = await _dio.post('/workspaces/$workspaceId/tasks', data: data);
      return (
        TaskModel.fromJson(res.data['task'] as Map<String, dynamic>),
        null,
      );
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueCreate(
          'workspaces/$workspaceId/tasks',
          clientId,
          data,
        );
        return (
          TaskModel(
            id: clientId,
            workspaceId: workspaceId,
            title: title,
            description: description,
            status: 'todo',
            priority: priority,
            dueAt: dueAt,
            reminderMinutesBefore: reminderMinutesBefore,
            assigneeId: assigneeId,
            labelId: labelId,
            createdBy: currentUserId,
            createdAt: now,
            updatedAt: now,
            subtasks: childSubtasks
                .map(
                  (subtask) => SubtaskModel(
                    id: subtask['id']! as String,
                    taskId: clientId,
                    title: subtask['title']! as String,
                    position: subtask['position']! as int,
                  ),
                )
                .toList(),
          ),
          failure,
        );
      }

      await (_db.delete(
        _db.tasks,
      )..where((task) => task.id.equals(clientId))).go();
      await (_db.delete(
        _db.subtasks,
      )..where((subtask) => subtask.taskId.equals(clientId))).go();
      return (null, failure);
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────
  Future<AppFailure?> updateTask(
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    final current = await (_db.select(
      _db.tasks,
    )..where((task) => task.id.equals(taskId))).getSingleOrNull();
    if (current != null) {
      await _writeLocalTaskUpdates(taskId, updates);
    }

    try {
      await _dio.patch('/tasks/$taskId', data: updates);
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NetworkFailure ||
          failure is ServerUnreachableFailure ||
          failure is TimeoutFailure) {
        await _sync.queueUpdate('tasks', taskId, updates);
      } else if (current != null) {
        await (_db.update(
          _db.tasks,
        )..where((task) => task.id.equals(taskId))).write(
          TasksCompanion(
            title: Value(current.title),
            description: Value(current.description),
            status: Value(current.status),
            priority: Value(current.priority),
            dueAt: Value(current.dueAt),
            reminderMinutesBefore: Value(current.reminderMinutesBefore),
            assigneeId: Value(current.assigneeId),
            labelId: Value(current.labelId),
            completedAt: Value(current.completedAt),
            updatedAt: Value(current.updatedAt),
          ),
        );
      }
      return failure;
    }
  }

  Future<void> _writeLocalTaskUpdates(
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    final companion = TasksCompanion(
      title: updates.containsKey('title')
          ? Value(updates['title'] as String)
          : const Value.absent(),
      description: updates.containsKey('description')
          ? Value(updates['description'] as String)
          : const Value.absent(),
      status: updates.containsKey('status')
          ? Value(updates['status'] as String)
          : const Value.absent(),
      priority: updates.containsKey('priority')
          ? Value(updates['priority'] as String)
          : const Value.absent(),
      dueAt: updates.containsKey('dueAt')
          ? Value(
              updates['dueAt'] == null
                  ? null
                  : DateTime.parse(updates['dueAt'] as String),
            )
          : const Value.absent(),
      reminderMinutesBefore: updates.containsKey('reminderMinutesBefore')
          ? Value(updates['reminderMinutesBefore'] as int?)
          : const Value.absent(),
      assigneeId: updates.containsKey('assigneeId')
          ? Value(updates['assigneeId'] as String?)
          : const Value.absent(),
      labelId: updates.containsKey('labelId')
          ? Value(updates['labelId'] as String?)
          : const Value.absent(),
      completedAt: updates.containsKey('status')
          ? Value(updates['status'] == 'completed' ? DateTime.now() : null)
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await (_db.update(
      _db.tasks,
    )..where((task) => task.id.equals(taskId))).write(companion);
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<AppFailure?> deleteTask(String taskId) async {
    final current = await (_db.select(
      _db.tasks,
    )..where((task) => task.id.equals(taskId))).getSingleOrNull();
    final deletedAt = DateTime.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(deletedAt: Value(deletedAt)),
    );
    try {
      await _dio.delete('/tasks/$taskId');
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueDelete('tasks', taskId);
      } else if (current != null) {
        await (_db.update(
          _db.tasks,
        )..where((task) => task.id.equals(taskId))).write(
          TasksCompanion(
            deletedAt: Value(current.deletedAt),
            updatedAt: Value(current.updatedAt),
          ),
        );
      }
      return failure;
    }
  }

  Future<AppFailure?> moveTask(String taskId, String targetWorkspaceId) async {
    try {
      final response = await _dio.post(
        '/tasks/$taskId/move',
        data: {'targetWorkspaceId': targetWorkspaceId},
      );
      final task = TaskModel.fromJson(
        response.data['task'] as Map<String, dynamic>,
      );
      await (_db.update(
        _db.tasks,
      )..where((row) => row.id.equals(taskId))).write(
        TasksCompanion(
          workspaceId: Value(task.workspaceId),
          title: Value(task.title),
          description: Value(task.description),
          status: Value(task.status),
          priority: Value(task.priority),
          dueAt: Value(task.dueAt),
          reminderMinutesBefore: Value(task.reminderMinutesBefore),
          assigneeId: Value(task.assigneeId),
          labelId: Value(task.labelId),
          completedAt: Value(task.completedAt),
          updatedAt: Value(task.updatedAt),
        ),
      );
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  // ── Bulk ──────────────────────────────────────────────────────────────────
  Future<BulkTaskActionResult> bulkAction(
    List<String> taskIds,
    String action,
  ) async {
    if (action != 'complete' && action != 'delete') {
      throw ArgumentError.value(action, 'action');
    }
    try {
      final res = await _dio.post(
        '/tasks/bulk',
        data: {'ids': taskIds, 'action': action},
      );
      final result = BulkTaskActionResult.fromJson(
        res.data as Map<String, dynamic>,
      );
      await _applyBulkActionLocally(result.succeededIds, action);
      return result;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _queueBulkActionOffline(taskIds, action);
        return BulkTaskActionResult(succeededIds: taskIds, queuedOffline: true);
      }
      return BulkTaskActionResult(failedIds: taskIds, failure: failure);
    }
  }

  Future<void> _applyBulkActionLocally(
    List<String> taskIds,
    String action,
  ) async {
    if (taskIds.isEmpty) return;
    final now = DateTime.now();
    final update = action == 'complete'
        ? TasksCompanion(
            status: const Value('completed'),
            completedAt: Value(now),
            updatedAt: Value(now),
          )
        : TasksCompanion(deletedAt: Value(now), updatedAt: Value(now));
    await (_db.update(
      _db.tasks,
    )..where((task) => task.id.isIn(taskIds))).write(update);
  }

  Future<void> _queueBulkActionOffline(
    List<String> taskIds,
    String action,
  ) async {
    final now = DateTime.now();
    for (final taskId in taskIds) {
      if (action == 'complete') {
        await (_db.update(
          _db.tasks,
        )..where((task) => task.id.equals(taskId))).write(
          TasksCompanion(
            status: const Value('completed'),
            completedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
        await _sync.queueUpdate('tasks', taskId, {'status': 'completed'});
      } else {
        await (_db.update(
          _db.tasks,
        )..where((task) => task.id.equals(taskId))).write(
          TasksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
        await _sync.queueDelete('tasks', taskId);
      }
    }
  }

  // ── Subtasks ──────────────────────────────────────────────────────────────
  Future<AppFailure?> addSubtask(String taskId, String title) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final lastSubtask =
        await (_db.select(_db.subtasks)
              ..where(
                (subtask) =>
                    subtask.taskId.equals(taskId) & subtask.deletedAt.isNull(),
              )
              ..orderBy([(subtask) => OrderingTerm.desc(subtask.position)])
              ..limit(1))
            .getSingleOrNull();
    final position = (lastSubtask?.position ?? -1) + 1;
    await _db
        .into(_db.subtasks)
        .insert(
          SubtasksCompanion.insert(
            id: id,
            taskId: taskId,
            title: title,
            position: Value(position),
            createdAt: now,
            updatedAt: now,
          ),
        );

    try {
      await _dio.post(
        '/tasks/$taskId/subtasks',
        data: {'id': id, 'title': title},
      );
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueChildCreate('subtask_create', id, {
          'taskId': taskId,
          'title': title,
        });
      } else {
        await (_db.update(_db.subtasks)
              ..where((subtask) => subtask.id.equals(id)))
            .write(SubtasksCompanion(deletedAt: Value(DateTime.now())));
      }
      return failure;
    }
  }

  Future<AppFailure?> updateSubtask(
    String subtaskId, {
    String? title,
    bool? isDone,
    int? position,
  }) async {
    final current = await (_db.select(
      _db.subtasks,
    )..where((subtask) => subtask.id.equals(subtaskId))).getSingleOrNull();
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (isDone != null) data['done'] = isDone;
    if (position != null) data['position'] = position;
    if (current != null) {
      await (_db.update(
        _db.subtasks,
      )..where((subtask) => subtask.id.equals(subtaskId))).write(
        SubtasksCompanion(
          title: title == null ? const Value.absent() : Value(title),
          isDone: isDone == null ? const Value.absent() : Value(isDone),
          position: position == null ? const Value.absent() : Value(position),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    try {
      await _dio.patch('/subtasks/$subtaskId', data: data);
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueUpdate('subtasks', subtaskId, data);
      } else if (current != null) {
        await (_db.update(
          _db.subtasks,
        )..where((subtask) => subtask.id.equals(subtaskId))).write(
          SubtasksCompanion(
            title: Value(current.title),
            isDone: Value(current.isDone),
            position: Value(current.position),
            updatedAt: Value(current.updatedAt),
          ),
        );
      }
      return failure;
    }
  }

  Future<AppFailure?> reorderSubtasks(
    List<SubtaskModel> orderedSubtasks,
  ) async {
    AppFailure? queuedFailure;
    for (var position = 0; position < orderedSubtasks.length; position++) {
      final subtask = orderedSubtasks[position];
      final failure = await updateSubtask(subtask.id, position: position);
      if (failure == null) continue;
      if (_isTemporaryFailure(failure)) {
        queuedFailure ??= failure;
        continue;
      }
      return failure;
    }
    return queuedFailure;
  }

  Future<AppFailure?> deleteSubtask(String subtaskId) async {
    final current = await (_db.select(
      _db.subtasks,
    )..where((subtask) => subtask.id.equals(subtaskId))).getSingleOrNull();
    if (current == null) return null;

    await (_db.update(
      _db.subtasks,
    )..where((subtask) => subtask.id.equals(subtaskId))).write(
      SubtasksCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    try {
      await _dio.delete('/subtasks/$subtaskId');
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueDelete('subtasks', subtaskId);
      } else {
        await (_db.update(
          _db.subtasks,
        )..where((subtask) => subtask.id.equals(subtaskId))).write(
          SubtasksCompanion(
            deletedAt: Value(current.deletedAt),
            updatedAt: Value(current.updatedAt),
          ),
        );
      }
      return failure;
    }
  }

  Future<AppFailure?> attachFile(String taskId, String fileId) async {
    try {
      await _dio.post('/tasks/$taskId/attachments', data: {'fileId': fileId});
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueChildCreate('task_attachment_create', fileId, {
          'taskId': taskId,
          'fileId': fileId,
        });
      }
      return failure;
    }
  }

  // ── Comments ──────────────────────────────────────────────────────────────
  Future<AppFailure?> addComment(String taskId, String body) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return const AuthRequiredFailure();
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.taskComments)
        .insert(
          TaskCommentsCompanion.insert(
            id: id,
            taskId: taskId,
            authorId: user.id,
            body: body,
            createdAt: now,
            updatedAt: now,
          ),
        );

    try {
      await _dio.post(
        '/tasks/$taskId/comments',
        data: {'id': id, 'body': body},
      );
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueChildCreate('comment_create', id, {
          'taskId': taskId,
          'body': body,
        });
      } else {
        await (_db.update(_db.taskComments)
              ..where((comment) => comment.id.equals(id)))
            .write(TaskCommentsCompanion(deletedAt: Value(DateTime.now())));
      }
      return failure;
    }
  }

  bool _isTemporaryFailure(AppFailure failure) =>
      failure is NetworkFailure ||
      failure is ServerUnreachableFailure ||
      failure is TimeoutFailure;
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
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dt.month - 1]} ${dt.day}';
}

int _hour12(int h) => h == 0 ? 12 : (h > 12 ? h - 12 : h);
