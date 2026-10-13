// app/lib/core/db/app_database.dart
// Drift local database — tables mirror backend schema for offline-first sync.
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

class Workspaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'personal' | 'team'
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('todo'))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  DateTimeColumn? get dueAt => dateTime().nullable()();
  TextColumn? get assigneeId => text().nullable()();
  TextColumn? get labelId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn? get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TaskComments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get authorId => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(const Constant('#3B82F6'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Events extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();
  BoolColumn get allDay => boolean().withDefault(const Constant(false))();
  TextColumn get color => text().withDefault(const Constant('#4F46E5'))();
  TextColumn? get taskId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get email => text()();
  TextColumn? get avatarUrl => text().nullable()();
  TextColumn get timezone => text().withDefault(const Constant('UTC'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn? get personalWorkspaceId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn? get workspaceId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn? get entityType => text().nullable()();
  TextColumn? get entityId => text().nullable()();
  DateTimeColumn? get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Outbox: stores writes that haven't been synced yet
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()(); // 'create' | 'update' | 'delete'
  TextColumn get entityType => text()(); // 'task' | 'subtask' | etc
  TextColumn get entityId => text()();
  TextColumn get payload => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  Workspaces,
  Tasks,
  Subtasks,
  TaskComments,
  Labels,
  Events,
  Profiles,
  Notifications,
  OutboxEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Future migrations go here
    },
  );
}

// Opens the database file on disk
AppDatabase _openDatabase() {
  return AppDatabase(_openConnection());
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'planpal.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = _openDatabase();
  ref.onDispose(db.close);
  return db;
});
