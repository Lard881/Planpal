import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ============================================================================
// Table Definitions
// ============================================================================

@DataClassName('LocalTask')
class LocalTasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().named('workspace_id')();
  TextColumn get projectId => text().nullable().named('project_id')();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('todo'))();
  TextColumn get priority => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable().named('due_date')();
  TextColumn get assigneeId => text().nullable().named('assignee_id')();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get labelIds => text().nullable().named('label_ids')(); // JSON array as string
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProject')
class LocalProjects extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().named('workspace_id')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false)).named('is_favorite')();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalLabel')
class LocalLabels extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().named('workspace_id')();
  TextColumn get name => text()();
  TextColumn get color => text()();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalTaskLabel')
class LocalTaskLabels extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  TextColumn get labelId => text().named('label_id')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalComment')
class LocalComments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  TextColumn get userId => text().named('user_id')();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalAttachment')
class LocalAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  TextColumn get fileName => text().named('file_name')();
  TextColumn get fileSize => text().named('file_size')();
  TextColumn get fileType => text().named('file_type')();
  TextColumn get storagePath => text().nullable().named('storage_path')();
  TextColumn get localPath => text().nullable().named('local_path')(); // For offline files
  TextColumn get uploadedBy => text().named('uploaded_by')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalLink')
class LocalLinks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  TextColumn get url => text()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get addedBy => text().named('added_by')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true)).named('is_synced')();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================================
// Pending Operations Table (Offline Queue)
// ============================================================================

@DataClassName('PendingOperation')
class PendingOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().named('entity_type')(); // 'task', 'project', etc.
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get operation => text()(); // 'insert', 'update', 'delete'
  TextColumn get data => text().nullable()(); // JSON string of entity data
  DateTimeColumn get clientUpdatedAt => dateTime().named('client_updated_at')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  IntColumn get retryCount => integer().withDefault(const Constant(0)).named('retry_count')();
  TextColumn get errorMessage => text().nullable().named('error_message')();
}

// ============================================================================
// Sync State Table
// ============================================================================

@DataClassName('SyncState')
class SyncStates extends Table {
  TextColumn get entityType => text().named('entity_type')();
  DateTimeColumn get lastSyncAt => dateTime().nullable().named('last_sync_at')();
  TextColumn get syncStatus => text().withDefault(const Constant('idle')).named('sync_status')(); // 'idle', 'syncing', 'error'
  TextColumn get errorMessage => text().nullable().named('error_message')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();
  
  @override
  Set<Column> get primaryKey => {entityType};
}

// ============================================================================
// Database Class
// ============================================================================

@DriftDatabase(tables: [
  LocalTasks,
  LocalProjects,
  LocalLabels,
  LocalTaskLabels,
  LocalComments,
  LocalAttachments,
  LocalLinks,
  PendingOperations,
  SyncStates,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database upgrades here
    },
  );

  // ============================================================================
  // Tasks Operations
  // ============================================================================

  Future<List<LocalTask>> getAllTasks({String? workspaceId, bool includeDeleted = false}) async {
    final query = select(localTasks)
      ..where((t) => includeDeleted ? t.deletedAt.isNull() | t.deletedAt.isNotNull() : t.deletedAt.isNull());
    
    if (workspaceId != null) {
      query.where((t) => t.workspaceId.equals(workspaceId));
    }
    
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.get();
  }

  Future<LocalTask?> getTaskById(String id) async {
    return (select(localTasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertTask(LocalTask task) async {
    return into(localTasks).insert(task, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateTask(String id, LocalTasksCompanion task) async {
    return (update(localTasks)..where((t) => t.id.equals(id))).write(task);
  }

  Future<int> deleteTask(String id) async {
    return (update(localTasks)..where((t) => t.id.equals(id)))
        .write(LocalTasksCompanion(deletedAt: Value(DateTime.now())));
  }

  Future<int> batchUpsertTasks(List<LocalTask> tasks) async {
    return batch((batch) {
      batch.insertAll(localTasks, tasks, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Projects Operations
  // ============================================================================

  Future<List<LocalProject>> getAllProjects({String? workspaceId, bool includeDeleted = false}) async {
    final query = select(localProjects)
      ..where((p) => includeDeleted ? p.deletedAt.isNull() | p.deletedAt.isNotNull() : p.deletedAt.isNull());
    
    if (workspaceId != null) {
      query.where((p) => p.workspaceId.equals(workspaceId));
    }
    
    query.orderBy([(p) => OrderingTerm.asc(p.name)]);
    return query.get();
  }

  Future<LocalProject?> getProjectById(String id) async {
    return (select(localProjects)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertProject(LocalProject project) async {
    return into(localProjects).insert(project, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateProject(String id, LocalProjectsCompanion project) async {
    return (update(localProjects)..where((p) => p.id.equals(id))).write(project);
  }

  Future<int> deleteProject(String id) async {
    return (update(localProjects)..where((p) => p.id.equals(id)))
        .write(LocalProjectsCompanion(deletedAt: Value(DateTime.now())));
  }

  Future<int> batchUpsertProjects(List<LocalProject> projects) async {
    return batch((batch) {
      batch.insertAll(localProjects, projects, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Labels Operations
  // ============================================================================

  Future<List<LocalLabel>> getAllLabels({String? workspaceId, bool includeDeleted = false}) async {
    final query = select(localLabels)
      ..where((l) => includeDeleted ? l.deletedAt.isNull() | l.deletedAt.isNotNull() : l.deletedAt.isNull());
    
    if (workspaceId != null) {
      query.where((l) => l.workspaceId.equals(workspaceId));
    }
    
    query.orderBy([(l) => OrderingTerm.asc(l.name)]);
    return query.get();
  }

  Future<LocalLabel?> getLabelById(String id) async {
    return (select(localLabels)..where((l) => l.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertLabel(LocalLabel label) async {
    return into(localLabels).insert(label, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateLabel(String id, LocalLabelsCompanion label) async {
    return (update(localLabels)..where((l) => l.id.equals(id))).write(label);
  }

  Future<int> batchUpsertLabels(List<LocalLabel> labels) async {
    return batch((batch) {
      batch.insertAll(localLabels, labels, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Comments Operations
  // ============================================================================

  Future<List<LocalComment>> getCommentsByTask(String taskId) async {
    return (select(localComments)
      ..where((c) => c.taskId.equals(taskId))
      ..orderBy([(c) => OrderingTerm.asc(c.createdAt)])).get();
  }

  Future<int> insertComment(LocalComment comment) async {
    return into(localComments).insert(comment, mode: InsertMode.insertOrReplace);
  }

  Future<int> batchUpsertComments(List<LocalComment> comments) async {
    return batch((batch) {
      batch.insertAll(localComments, comments, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Attachments Operations
  // ============================================================================

  Future<List<LocalAttachment>> getAttachmentsByTask(String taskId) async {
    return (select(localAttachments)
      ..where((a) => a.taskId.equals(taskId))
      ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])).get();
  }

  Future<int> insertAttachment(LocalAttachment attachment) async {
    return into(localAttachments).insert(attachment, mode: InsertMode.insertOrReplace);
  }

  Future<int> batchUpsertAttachments(List<LocalAttachment> attachments) async {
    return batch((batch) {
      batch.insertAll(localAttachments, attachments, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Links Operations
  // ============================================================================

  Future<List<LocalLink>> getLinksByTask(String taskId) async {
    return (select(localLinks)
      ..where((l) => l.taskId.equals(taskId))
      ..orderBy([(l) => OrderingTerm.desc(l.createdAt)])).get();
  }

  Future<int> insertLink(LocalLink link) async {
    return into(localLinks).insert(link, mode: InsertMode.insertOrReplace);
  }

  Future<int> batchUpsertLinks(List<LocalLink> links) async {
    return batch((batch) {
      batch.insertAll(localLinks, links, mode: InsertMode.insertOrReplace);
    });
  }

  // ============================================================================
  // Pending Operations (Offline Queue)
  // ============================================================================

  Future<List<PendingOperation>> getAllPendingOperations() async {
    return (select(pendingOperations)..orderBy([(o) => OrderingTerm.asc(o.createdAt)])).get();
  }

  Future<int> addPendingOperation({
    required String entityType,
    required String entityId,
    required String operation,
    String? data,
  }) async {
    return into(pendingOperations).insert(
      PendingOperationsCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        data: Value(data),
        clientUpdatedAt: DateTime.now(),
      ),
    );
  }

  Future<int> removePendingOperation(int id) async {
    return (delete(pendingOperations)..where((o) => o.id.equals(id))).go();
  }

  Future<int> clearPendingOperations() async {
    return delete(pendingOperations).go();
  }

  Future<int> updatePendingOperationRetry(int id, String errorMessage) async {
    return (update(pendingOperations)..where((o) => o.id.equals(id))).write(
      PendingOperationsCompanion(
        retryCount: Value((select(pendingOperations)..where((o) => o.id.equals(id)))
            .getSingleOrNull()
            .then((op) => (op?.retryCount ?? 0) + 1)),
        errorMessage: Value(errorMessage),
      ),
    );
  }

  // ============================================================================
  // Sync State Operations
  // ============================================================================

  Future<SyncState?> getSyncState(String entityType) async {
    return (select(syncStates)..where((s) => s.entityType.equals(entityType))).getSingleOrNull();
  }

  Future<int> updateSyncState({
    required String entityType,
    DateTime? lastSyncAt,
    String? syncStatus,
    String? errorMessage,
  }) async {
    return into(syncStates).insert(
      SyncStatesCompanion.insert(
        entityType: entityType,
        lastSyncAt: Value(lastSyncAt),
        syncStatus: Value(syncStatus ?? 'idle'),
        errorMessage: Value(errorMessage),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<Map<String, DateTime?>> getAllSyncStates() async {
    final states = await select(syncStates).get();
    return {for (var state in states) state.entityType: state.lastSyncAt};
  }

  // ============================================================================
  // Utility Operations
  // ============================================================================

  Future<int> getUnsyncedCount() async {
    final tasks = await (select(localTasks)..where((t) => t.isSynced.equals(false))).get();
    final projects = await (select(localProjects)..where((p) => p.isSynced.equals(false))).get();
    final labels = await (select(localLabels)..where((l) => l.isSynced.equals(false))).get();
    
    return tasks.length + projects.length + labels.length;
  }

  Future<void> clearAllData() async {
    await batch((batch) {
      batch.deleteWhere(localTasks, (_) => const Constant(true));
      batch.deleteWhere(localProjects, (_) => const Constant(true));
      batch.deleteWhere(localLabels, (_) => const Constant(true));
      batch.deleteWhere(localTaskLabels, (_) => const Constant(true));
      batch.deleteWhere(localComments, (_) => const Constant(true));
      batch.deleteWhere(localAttachments, (_) => const Constant(true));
      batch.deleteWhere(localLinks, (_) => const Constant(true));
      batch.deleteWhere(pendingOperations, (_) => const Constant(true));
      batch.deleteWhere(syncStates, (_) => const Constant(true));
    });
  }
}

// ============================================================================
// Database Connection
// ============================================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'planpal.db'));
    return NativeDatabase(file);
  });
}
