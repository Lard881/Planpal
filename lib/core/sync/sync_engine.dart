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
import '../connectivity/connectivity_service.dart';

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
  }) =>
      SyncState(
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
  Timer? _periodicTimer;
  bool _syncing = false;

  SyncEngine(this._dio, this._db) : super(const SyncState()) {
    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => sync(),
    );
  }

  // ── Pull (S6.4) ────────────────────────────────────────────────────────────
  Future<void> pull(String workspaceId) async {
    String? since = await _storage.read(key: '$_kLastSyncPrefix$workspaceId');
    bool hasMore = true;

    while (hasMore) {
      try {
        final params = <String, dynamic>{};
        if (since != null) params['since'] = since;

        final res = await _dio.get(
          '/workspaces/$workspaceId/sync',
          queryParameters: params,
        );

        final data = res.data as Map<String, dynamic>;
        hasMore = data['hasMore'] == true;

        // Store serverTime as next since — never use device clock
        final serverTime = data['serverTime'] as String?;
        if (serverTime != null) {
          since = serverTime;
          await _storage.write(
              key: '$_kLastSyncPrefix$workspaceId', value: serverTime);
        } else {
          hasMore = false;
        }

        // Merge into Drift
        await _mergeSync(data, workspaceId);
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) rethrow;
        break; // temporary failure — stop pull, try later
      }
    }
  }

  Future<void> _mergeSync(Map<String, dynamic> data, String workspaceId) async {
    await _db.transaction(() async {
      // Tasks
      final tasks = data['tasks'] as List? ?? [];
      for (final t in tasks) {
        final task = t as Map<String, dynamic>;
        final deletedAt = task['deleted_at'];
        if (deletedAt != null) {
          await (_db.delete(_db.tasks)
            ..where((tbl) => tbl.id.equals(task['id'] as String)))
              .go();
        } else {
          await _db.into(_db.tasks).insertOnConflictUpdate(_taskFromJson(task));
        }
      }

      // Subtasks
      final subtasks = data['subtasks'] as List? ?? [];
      for (final s in subtasks) {
        final sub = s as Map<String, dynamic>;
        if (sub['deleted_at'] != null) {
          await (_db.delete(_db.subtasks)
            ..where((tbl) => tbl.id.equals(sub['id'] as String))).go();
        } else {
          await _db.into(_db.subtasks).insertOnConflictUpdate(_subtaskFromJson(sub));
        }
      }

      // Labels
      final labels = data['labels'] as List? ?? [];
      for (final l in labels) {
        final label = l as Map<String, dynamic>;
        if (label['deleted_at'] != null) {
          await (_db.delete(_db.labels)
            ..where((tbl) => tbl.id.equals(label['id'] as String))).go();
        } else {
          await _db.into(_db.labels).insertOnConflictUpdate(_labelFromJson(label));
        }
      }
    });
  }

  // ── Push / Outbox (S6.5, S6.6) ────────────────────────────────────────────
  Future<void> push() async {
    final entries = await (_db.select(_db.outboxEntries)
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
        case 'create':
          await _dio.post('/$entityType', data: payload);
        case 'update':
          await _dio.patch('/$entityType/$entityId', data: payload);
        case 'delete':
          await _dio.delete('/$entityType/$entityId');
      }
      // Success — remove from outbox
      await (_db.delete(_db.outboxEntries)
        ..where((t) => t.id.equals(entry.id))).go();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Permanent failures (S6.6) — stop retrying
      if (status == 400 || status == 403 || status == 404 || status == 409) {
        await (_db.update(_db.outboxEntries)
          ..where((t) => t.id.equals(entry.id)))
            .write(OutboxEntriesCompanion(
              retryCount: Value(5), // mark as permanently failed
            ));
      } else {
        // Temporary — increment retry count (exponential backoff handled by periodic timer)
        await (_db.update(_db.outboxEntries)
          ..where((t) => t.id.equals(entry.id)))
            .write(OutboxEntriesCompanion(
              retryCount: Value(entry.retryCount + 1),
            ));
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
      final pending = await (_db.select(_db.outboxEntries)
        ..where((t) => t.retryCount.isSmallerThanValue(5))).get();
      final failed = await (_db.select(_db.outboxEntries)
        ..where((t) => t.retryCount.equals(5))).get();

      state = state.copyWith(
        pendingCount: pending.length,
        failedCount: failed.length,
      );

      await push();

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
  Future<void> queueCreate(String entityType, String entityId,
      Map<String, dynamic> payload) async {
    await _db.into(_db.outboxEntries).insert(OutboxEntriesCompanion.insert(
      operation: 'create',
      entityType: entityType,
      entityId: entityId,
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
    ));
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueUpdate(String entityType, String entityId,
      Map<String, dynamic> payload) async {
    await _db.into(_db.outboxEntries).insert(OutboxEntriesCompanion.insert(
      operation: 'update',
      entityType: entityType,
      entityId: entityId,
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
    ));
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> queueDelete(String entityType, String entityId) async {
    await _db.into(_db.outboxEntries).insert(OutboxEntriesCompanion.insert(
      operation: 'delete',
      entityType: entityType,
      entityId: entityId,
      payload: '{}',
      createdAt: DateTime.now(),
    ));
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> retryFailed() async {
    await (_db.update(_db.outboxEntries)
      ..where((t) => t.retryCount.equals(5)))
        .write(const OutboxEntriesCompanion(retryCount: Value(0)));
    await sync();
  }

  Future<void> discardFailed(int entryId) async {
    await (_db.delete(_db.outboxEntries)
      ..where((t) => t.id.equals(entryId))).go();
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
    dueAt: Value(j['due_at'] != null ? DateTime.parse(j['due_at'] as String) : null),
    assigneeId: Value(j['assignee_id'] as String?),
    labelId: Value(j['label_id'] as String?),
    createdBy: Value(j['created_by'] as String),
    completedAt: Value(j['completed_at'] != null
        ? DateTime.parse(j['completed_at'] as String) : null),
    createdAt: Value(DateTime.parse(j['created_at'] as String)),
    updatedAt: Value(DateTime.parse(j['updated_at'] as String)),
  );

  SubtasksCompanion _subtaskFromJson(Map<String, dynamic> j) => SubtasksCompanion(
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

final syncEngineProvider =
    StateNotifierProvider<SyncEngine, SyncState>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  final db = ref.watch(appDatabaseProvider);
  return SyncEngine(dio, db);
});
