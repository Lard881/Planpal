// app/lib/core/sync/sync_engine.dart
// Pull (delta sync), Push (outbox replay), triggers, backoff.
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../db/app_database.dart';
import '../network/api_client.dart';

const _storage = FlutterSecureStorage();
const _kLastSyncPrefix = 'planpal_last_sync_';

enum SyncStatus { idle, syncing, failed }

class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final int failedCount;
  final DateTime? lastSyncAt;
  final String? lastError;

  const SyncState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
    this.failedCount = 0,
    this.lastSyncAt,
    this.lastError,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    int? failedCount,
    DateTime? lastSyncAt,
    String? lastError,
    bool clearError = false,
  }) => SyncState(
    status: status ?? this.status,
    pendingCount: pendingCount ?? this.pendingCount,
    failedCount: failedCount ?? this.failedCount,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    lastError: clearError ? null : (lastError ?? this.lastError),
  );
}

class SyncEngine extends StateNotifier<SyncState> {
  final Dio _dio;
  final AppDatabase _db;
  final Future<String?> Function(String key) _readCheckpoint;
  final Future<void> Function(String key, String value) _writeCheckpoint;
  Timer? _periodicTimer;
  bool _syncing = false;

  SyncEngine(
    this._dio,
    this._db, {
    Future<String?> Function(String key)? readCheckpoint,
    Future<void> Function(String key, String value)? writeCheckpoint,
  }) : _readCheckpoint = readCheckpoint ?? ((key) => _storage.read(key: key)),
       _writeCheckpoint =
           writeCheckpoint ??
           ((key, value) => _storage.write(key: key, value: value)),
       super(const SyncState()) {
    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 2), (_) => sync());
  }

  // ── Pull (S6.4) ────────────────────────────────────────────────────────────
  Future<void> pull(String workspaceId) async {
    final checkpointKey = '$_kLastSyncPrefix$workspaceId';
    final since = await _readCheckpoint(checkpointKey);
    String? cursor;
    String? nextCheckpoint;
    bool hasMore = true;
    var completed = false;

    while (hasMore) {
      try {
        final params = <String, dynamic>{};
        if (cursor != null) {
          params['cursor'] = cursor;
        } else if (since != null) {
          params['since'] = since;
        }

        final res = await _dio.get(
          '/workspaces/$workspaceId/sync',
          queryParameters: params,
        );

        final data = res.data as Map<String, dynamic>;
        hasMore = data['hasMore'] == true;
        final serverTime = data['serverTime'] as String?;
        nextCheckpoint = serverTime ?? nextCheckpoint;

        // Merge into Drift
        await _mergeSync(data, workspaceId);

        if (!hasMore) {
          completed = true;
          break;
        }

        final nextCursor = data['nextCursor'];
        if (nextCursor is! String || nextCursor.isEmpty) break;
        cursor = nextCursor;
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) rethrow;
        break; // temporary failure — stop pull, try later
      }
    }

    // Keep the starting checkpoint intact unless every page was merged.
    if (completed && nextCheckpoint != null) {
      await _writeCheckpoint(checkpointKey, nextCheckpoint);
    }
  }

  Future<void> _mergeSync(Map<String, dynamic> data, String workspaceId) async {
    await _db.transaction(() async {
      final membershipRows =
          data['workspaceMemberships'] ??
          data['workspace_memberships'] ??
          data['workspaceMembers'] ??
          data['workspace_members'] ??
          data['memberships'];
      if (membershipRows is List) {
        for (final row in membershipRows) {
          if (row is! Map<String, dynamic> || row['deleted_at'] == null) {
            continue;
          }
          final removedWorkspaceId =
              row['workspace_id'] as String? ?? row['workspaceId'] as String?;
          if (removedWorkspaceId != null) {
            await _removeWorkspaceData(removedWorkspaceId);
          }
        }
      }

      // Tasks
      final tasks = data['tasks'] as List? ?? [];
      for (final t in tasks) {
        final task = t as Map<String, dynamic>;
        final deletedAt = task['deleted_at'];
        if (deletedAt != null) {
          await (_db.delete(
            _db.tasks,
          )..where((tbl) => tbl.id.equals(task['id'] as String))).go();
        } else {
          await _db.into(_db.tasks).insertOnConflictUpdate(_taskFromJson(task));
        }
      }

      // Subtasks
      final subtasks = data['subtasks'] as List? ?? [];
      for (final s in subtasks) {
        final sub = s as Map<String, dynamic>;
        if (sub['deleted_at'] != null) {
          await (_db.delete(
            _db.subtasks,
          )..where((tbl) => tbl.id.equals(sub['id'] as String))).go();
        } else {
          await _db
              .into(_db.subtasks)
              .insertOnConflictUpdate(_subtaskFromJson(sub));
        }
      }

      // Labels
      final labels = data['labels'] as List? ?? [];
      for (final l in labels) {
        final label = l as Map<String, dynamic>;
        if (label['deleted_at'] != null) {
          await (_db.delete(
            _db.labels,
          )..where((tbl) => tbl.id.equals(label['id'] as String))).go();
        } else {
          await _db
              .into(_db.labels)
              .insertOnConflictUpdate(_labelFromJson(label));
        }
      }

      final events = data['events'] as List? ?? [];
      for (final row in events) {
        final event = row as Map<String, dynamic>;
        if (event['deleted_at'] != null) {
          await (_db.delete(
            _db.events,
          )..where((table) => table.id.equals(event['id'] as String))).go();
        } else {
          await _db
              .into(_db.events)
              .insertOnConflictUpdate(
                EventsCompanion(
                  id: Value(event['id'] as String),
                  workspaceId: Value(event['workspace_id'] as String),
                  title: Value(event['title'] as String),
                  description: Value(event['description'] as String? ?? ''),
                  startsAt: Value(
                    DateTime.parse(event['starts_at'] as String).toLocal(),
                  ),
                  endsAt: Value(
                    DateTime.parse(event['ends_at'] as String).toLocal(),
                  ),
                  allDay: Value(event['all_day'] as bool? ?? false),
                  color: Value(event['color'] as String? ?? '#4F46E5'),
                  taskId: Value(event['task_id'] as String?),
                  reminderMinutesBefore: Value(
                    event['reminder_minutes_before'] as int? ?? 15,
                  ),
                  createdBy: Value(event['created_by'] as String),
                  createdAt: Value(
                    DateTime.parse(event['created_at'] as String),
                  ),
                  updatedAt: Value(
                    DateTime.parse(event['updated_at'] as String),
                  ),
                  deletedAt: const Value(null),
                ),
              );
        }
      }

      final attendees = data['eventAttendees'] as List? ?? [];
      for (final row in attendees) {
        final attendee = row as Map<String, dynamic>;
        final eventId = attendee['event_id'] as String;
        final userId = attendee['user_id'] as String;
        if (attendee['deleted_at'] != null) {
          await (_db.delete(_db.eventAttendees)..where(
                (table) =>
                    table.eventId.equals(eventId) & table.userId.equals(userId),
              ))
              .go();
        } else {
          await _db
              .into(_db.eventAttendees)
              .insertOnConflictUpdate(
                EventAttendeesCompanion(
                  eventId: Value(eventId),
                  userId: Value(userId),
                  createdAt: Value(
                    DateTime.parse(attendee['created_at'] as String),
                  ),
                  updatedAt: Value(
                    DateTime.parse(attendee['updated_at'] as String),
                  ),
                  deletedAt: const Value(null),
                ),
              );
        }
      }

      final folders = data['folders'] as List? ?? [];
      for (final row in folders) {
        final folder = row as Map<String, dynamic>;
        if (folder['deleted_at'] != null) {
          await (_db.delete(
            _db.folders,
          )..where((table) => table.id.equals(folder['id'] as String))).go();
        } else {
          await _db
              .into(_db.folders)
              .insertOnConflictUpdate(
                FoldersCompanion(
                  id: Value(folder['id'] as String),
                  workspaceId: Value(folder['workspace_id'] as String),
                  parentId: Value(folder['parent_id'] as String?),
                  name: Value(folder['name'] as String),
                  fileCount: const Value(0),
                  createdBy: Value(folder['created_by'] as String),
                  createdAt: Value(
                    DateTime.parse(folder['created_at'] as String),
                  ),
                  updatedAt: Value(
                    DateTime.parse(folder['updated_at'] as String),
                  ),
                  deletedAt: const Value(null),
                ),
              );
        }
      }

      final documents = data['documents'] as List? ?? [];
      final syncedFiles = data['files'] as List? ?? [];
      final filesById = <String, Map<String, dynamic>>{};
      for (final row in syncedFiles) {
        final file = row as Map<String, dynamic>;
        filesById[file['id'] as String] = file;
      }
      for (final row in documents) {
        final document = row as Map<String, dynamic>;
        if (document['deleted_at'] != null) {
          await (_db.delete(
            _db.documents,
          )..where((table) => table.id.equals(document['id'] as String))).go();
        } else {
          final content = document['content'];
          final file = filesById[document['file_id'] as String?];
          await _db
              .into(_db.documents)
              .insertOnConflictUpdate(
                DocumentsCompanion(
                  id: Value(document['id'] as String),
                  workspaceId: Value(document['workspace_id'] as String),
                  folderId: Value(document['folder_id'] as String?),
                  kind: Value(document['kind'] as String),
                  title: Value(document['title'] as String),
                  fileId: Value(document['file_id'] as String?),
                  mimeType: Value(file?['mime_type'] as String?),
                  sizeBytes: Value(file?['size_bytes'] as int?),
                  storagePath: Value(file?['storage_path'] as String?),
                  content: Value(
                    content == null
                        ? null
                        : content is String
                        ? content
                        : jsonEncode(content),
                  ),
                  contentText: Value(document['content_text'] as String? ?? ''),
                  createdBy: Value(document['created_by'] as String),
                  createdAt: Value(
                    DateTime.parse(document['created_at'] as String),
                  ),
                  updatedAt: Value(
                    DateTime.parse(document['updated_at'] as String),
                  ),
                  deletedAt: const Value(null),
                ),
              );
        }
      }
    });
  }

  Future<void> _removeWorkspaceData(String workspaceId) async {
    final taskIds =
        await (_db.select(_db.tasks)
              ..where((table) => table.workspaceId.equals(workspaceId)))
            .map((row) => row.id)
            .get();
    final eventIds =
        await (_db.select(_db.events)
              ..where((table) => table.workspaceId.equals(workspaceId)))
            .map((row) => row.id)
            .get();

    if (taskIds.isNotEmpty) {
      await (_db.delete(
        _db.taskAttachments,
      )..where((table) => table.taskId.isIn(taskIds))).go();
      await (_db.delete(
        _db.taskComments,
      )..where((table) => table.taskId.isIn(taskIds))).go();
      await (_db.delete(
        _db.subtasks,
      )..where((table) => table.taskId.isIn(taskIds))).go();
    }
    if (eventIds.isNotEmpty) {
      await (_db.delete(
        _db.eventAttendees,
      )..where((table) => table.eventId.isIn(eventIds))).go();
    }

    await (_db.delete(
      _db.tasks,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.labels,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.events,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.folders,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.documents,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.notifications,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.chatMessages,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.chatChannels,
    )..where((table) => table.workspaceId.equals(workspaceId))).go();
    await (_db.delete(
      _db.workspaces,
    )..where((table) => table.id.equals(workspaceId))).go();
  }

  // ── Push / Outbox (S6.5, S6.6) ────────────────────────────────────────────
  Future<void> push() async {
    final entries =
        await (_db.select(_db.outboxEntries)
              ..orderBy([(t) => OrderingTerm.asc(t.id)])
              ..where((t) => t.retryCount.isSmallerThanValue(5)))
            .get();

    for (final entry in entries) {
      await _processOutboxEntry(entry);
    }
  }

  Future<void> _processOutboxEntry(OutboxEntry entry) async {
    final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
    final entityType = entry.entityType;
    final entityId = entry.entityId;

    try {
      switch (entry.operation) {
        case 'notification_mark_read':
          await _dio.post('/notifications/$entityId/read');
        case 'notification_mark_unread':
          await _dio.post('/notifications/$entityId/unread');
        case 'notification_mark_all_read':
          await _dio.post('/notifications/read-all');
        case 'notification_delete':
          await _dio.delete('/notifications/$entityId');
        case 'subtask_create':
          await _dio.post(
            '/tasks/${payload['taskId']}/subtasks',
            data: {'id': entityId, 'title': payload['title']},
          );
        case 'task_attachment_create':
          await _dio.post(
            '/tasks/${payload['taskId']}/attachments',
            data: {'fileId': payload['fileId']},
          );
        case 'create' when entityType == 'documents':
          await _dio.post(
            '/workspaces/${payload['workspaceId']}/documents',
            data: payload,
          );
        case 'create' when entityType == 'chat_messages':
          await _dio.post(
            '/channels/${payload['channelId']}/messages',
            data: {
              'id': entityId,
              'body': payload['body'],
              if (payload['fileId'] != null) 'fileId': payload['fileId'],
            },
          );
          await (_db.update(_db.chatMessages)
                ..where((row) => row.id.equals(entityId)))
              .write(const ChatMessagesCompanion(status: Value('sent')));
        case 'comment_create':
          await _dio.post(
            '/tasks/${payload['taskId']}/comments',
            data: {'id': entityId, 'body': payload['body']},
          );
        case 'create':
          await _dio.post('/$entityType', data: payload);
        case 'update':
          await _dio.patch('/$entityType/$entityId', data: payload);
        case 'delete':
          await _dio.delete('/$entityType/$entityId');
      }
      // Success — remove from outbox
      await (_db.delete(
        _db.outboxEntries,
      )..where((t) => t.id.equals(entry.id))).go();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Permanent failures (S6.6) — stop retrying
      if (status == 400 || status == 403 || status == 404 || status == 409) {
        await (_db.update(
          _db.outboxEntries,
        )..where((t) => t.id.equals(entry.id))).write(
          OutboxEntriesCompanion(
            retryCount: Value(5), // mark as permanently failed
          ),
        );
        if (entityType == 'chat_messages') {
          await (_db.update(_db.chatMessages)
                ..where((row) => row.id.equals(entityId)))
              .write(const ChatMessagesCompanion(status: Value('failed')));
        }
      } else {
        // Keep transient failures pending so long outages do not need manual retry.
        await (_db.update(
          _db.outboxEntries,
        )..where((t) => t.id.equals(entry.id))).write(
          OutboxEntriesCompanion(
            retryCount: Value(entry.retryCount < 4 ? entry.retryCount + 1 : 4),
          ),
        );
      }
    }
  }

  // ── Full sync ────────────────────────────────────────────────────────────--
  Future<void> sync({String? workspaceId}) async {
    if (_syncing) return;
    _syncing = true;
    state = state.copyWith(status: SyncStatus.syncing);

    try {
      // Get pending/failed counts
      final pending = await (_db.select(
        _db.outboxEntries,
      )..where((t) => t.retryCount.isSmallerThanValue(5))).get();
      final failed = await (_db.select(
        _db.outboxEntries,
      )..where((t) => t.retryCount.equals(5))).get();

      state = state.copyWith(
        pendingCount: pending.length,
        failedCount: failed.length,
      );

      await push();

      final remainingPending = await (_db.select(
        _db.outboxEntries,
      )..where((t) => t.retryCount.isSmallerThanValue(5))).get();
      final remainingFailed = await (_db.select(
        _db.outboxEntries,
      )..where((t) => t.retryCount.equals(5))).get();
      state = state.copyWith(
        pendingCount: remainingPending.length,
        failedCount: remainingFailed.length,
      );

      // Pull for all workspaces if no specific one given
      if (workspaceId != null) {
        await pull(workspaceId);
      }

      state = state.copyWith(
        status: SyncStatus.idle,
        lastSyncAt: DateTime.now(),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.failed,
        lastError: e.toString(),
      );
    } finally {
      _syncing = false;
    }
  }

  // ── Outbox helpers ─────────────────────────────────────────────────────────
  Future<void> queueCreate(
    String entityType,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    await _db
        .into(_db.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: 'create',
            entityType: entityType,
            entityId: entityId,
            payload: jsonEncode(payload),
            createdAt: DateTime.now(),
          ),
        );
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueUpdate(
    String entityType,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    await _db
        .into(_db.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: 'update',
            entityType: entityType,
            entityId: entityId,
            payload: jsonEncode(payload),
            createdAt: DateTime.now(),
          ),
        );
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueChildCreate(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    await _db
        .into(_db.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: operation,
            entityType: 'tasks',
            entityId: entityId,
            payload: jsonEncode(payload),
            createdAt: DateTime.now(),
          ),
        );
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueDelete(String entityType, String entityId) async {
    await _db
        .into(_db.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: 'delete',
            entityType: entityType,
            entityId: entityId,
            payload: '{}',
            createdAt: DateTime.now(),
          ),
        );
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueNotificationAction(
    String operation,
    String notificationId,
  ) async {
    await _db
        .into(_db.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: 'notification_$operation',
            entityType: 'notifications',
            entityId: notificationId,
            payload: '{}',
            createdAt: DateTime.now(),
          ),
        );
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> clearSyncCursors() async {
    final keys = await _storage.readAll();
    for (final key in keys.keys.where(
      (key) => key.startsWith(_kLastSyncPrefix),
    )) {
      await _storage.delete(key: key);
    }
  }

  Future<void> retryFailed() async {
    await (_db.update(_db.outboxEntries)..where((t) => t.retryCount.equals(5)))
        .write(const OutboxEntriesCompanion(retryCount: Value(0)));
    await sync();
  }

  Future<void> discardFailed(int entryId) async {
    await (_db.delete(
      _db.outboxEntries,
    )..where((t) => t.id.equals(entryId))).go();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }

  // ── JSON mappers ───────────────────────────────────────────────────────────
  TasksCompanion _taskFromJson(Map<String, dynamic> j) => TasksCompanion(
    id: Value(j['id'] as String),
    workspaceId: Value(j['workspace_id'] as String),
    title: Value(j['title'] as String),
    description: Value(j['description'] as String? ?? ''),
    status: Value(j['status'] as String? ?? 'todo'),
    priority: Value(j['priority'] as String? ?? 'medium'),
    dueAt: Value(
      j['due_at'] != null ? DateTime.parse(j['due_at'] as String) : null,
    ),
    reminderMinutesBefore: Value(j['reminder_minutes_before'] as int?),
    assigneeId: Value(j['assignee_id'] as String?),
    labelId: Value(j['label_id'] as String?),
    createdBy: Value(j['created_by'] as String),
    completedAt: Value(
      j['completed_at'] != null
          ? DateTime.parse(j['completed_at'] as String)
          : null,
    ),
    createdAt: Value(DateTime.parse(j['created_at'] as String)),
    updatedAt: Value(DateTime.parse(j['updated_at'] as String)),
  );

  SubtasksCompanion _subtaskFromJson(Map<String, dynamic> j) =>
      SubtasksCompanion(
        id: Value(j['id'] as String),
        taskId: Value(j['task_id'] as String),
        title: Value(j['title'] as String),
        isDone: Value(j['is_done'] as bool? ?? false),
        position: Value(j['position'] as int? ?? 0),
        createdAt: Value(DateTime.parse(j['created_at'] as String)),
        updatedAt: Value(DateTime.parse(j['updated_at'] as String)),
      );

  LabelsCompanion _labelFromJson(Map<String, dynamic> j) => LabelsCompanion(
    id: Value(j['id'] as String),
    workspaceId: Value(j['workspace_id'] as String),
    name: Value(j['name'] as String),
    color: Value(j['color'] as String? ?? '#3B82F6'),
    createdAt: Value(DateTime.parse(j['created_at'] as String)),
    updatedAt: Value(DateTime.parse(j['updated_at'] as String)),
  );
}

final syncEngineProvider = StateNotifierProvider<SyncEngine, SyncState>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  final db = ref.watch(appDatabaseProvider);
  return SyncEngine(dio, db);
});
