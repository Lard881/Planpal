import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Profiles table (local cache)
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get fullName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get timezone => text().withDefault(const Constant('UTC'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn get personalWorkspaceId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Workspaces table
class Workspaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'personal' | 'team'
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Workspace members table
class WorkspaceMembers extends Table {
  TextColumn get workspaceId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()(); // 'admin' | 'member' | 'guest'
  DateTimeColumn get joinedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {workspaceId, userId};
}

/// Labels table
class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Task-Label junction table (many-to-many relationship)
class TaskLabels extends Table {
  TextColumn get taskId => text()();
  TextColumn get labelId => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {taskId, labelId};
}

/// Task attachments table (files uploaded to cloud storage)
class TaskAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get workspaceId => text()();
  TextColumn get uploadedBy => text()();
  TextColumn get fileName => text()();
  Int64Column get fileSize => int64()(); // Size in bytes
  TextColumn get mimeType => text()();
  TextColumn get storagePath => text()(); // Path in cloud storage
  TextColumn get thumbnailPath => text().nullable()(); // Thumbnail for images
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Task links table (URL attachments)
class TaskLinks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get workspaceId => text()();
  TextColumn get addedBy => text()();
  TextColumn get url => text()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get faviconUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tasks table
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text()(); // 'todo' | 'in_progress' | 'completed'
  TextColumn get priority => text()(); // 'high' | 'medium' | 'low'
  DateTimeColumn get dueAt => dateTime().nullable()();
  TextColumn get assigneeId => text().nullable()();
  TextColumn get labelId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get reminderMinutesBefore => integer().nullable()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))(); // 'synced' | 'pending' | 'failed'

  @override
  Set<Column> get primaryKey => {id};
}

/// Outbox table (for offline changes)
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // 'task' | 'workspace' | etc.
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // 'create' | 'update' | 'delete'
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get status => text()(); // 'pending' | 'failed'
}

/// Notifications table (local cache)
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get workspaceId => text()();
  TextColumn get type => text()(); // notification_type enum
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get entityType => text().nullable()(); // 'task' | 'comment' | 'event' | etc.
  TextColumn get entityId => text().nullable()();
  TextColumn get dedupeKey => text().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get pushedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Key-value storage table
class KeyValue extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Sync state table
class SyncState extends Table {
  TextColumn get workspaceId => text()();
  TextColumn get lastServerTime => text()();

  @override
  Set<Column> get primaryKey => {workspaceId};
}

/// Main database class
@DriftDatabase(tables: [
  Profiles,
  Workspaces,
  WorkspaceMembers,
  Labels,
  TaskLabels,
  Tasks,
  TaskAttachments,
  TaskLinks,
  Notifications,
  Outbox,
  KeyValue,
  SyncState,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Add TaskLabels junction table in version 2
            await m.createTable(taskLabels);
          }
          if (from < 3) {
            // Add reminderAt column in version 3
            await m.addColumn(tasks, tasks.reminderAt);
          }
          if (from < 4) {
            // Add TaskAttachments and TaskLinks tables in version 4
            await m.createTable(taskAttachments);
            await m.createTable(taskLinks);
          }
          if (from < 5) {
            // Add Notifications table in version 5
            await m.createTable(notifications);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'planpal.db'));
    return NativeDatabase(file);
  });
}
