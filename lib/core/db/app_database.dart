import 'dart:io' as io;
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
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()(); // 'admin' | 'member' | 'guest'
  DateTimeColumn get joinedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
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
  TextColumn get projectId => text().nullable()();  // ✅ ADDED - matches backend
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text()(); // 'todo' | 'in_progress' | 'completed'
  TextColumn get priority => text()(); // 'high' | 'medium' | 'low'
  DateTimeColumn get dueDate => dateTime().nullable()();  // ✅ RENAMED from dueAt
  TextColumn get assigneeId => text().nullable()();
  // NOTE: Removed single labelId - use TaskLabels junction table instead
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

/// Sync metadata table (tracks last sync time per workspace)
class SyncMetadata extends Table {
  TextColumn get workspaceId => text()();
  DateTimeColumn get lastSyncTime => dateTime()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {workspaceId};
}

/// Events table (calendar events)
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get location => text().nullable()();
  IntColumn get reminderMinutes => integer().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Event attendees table
class EventAttendees extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Files table (uploaded files)
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get name => text()();
  TextColumn get mimeType => text()();
  Int64Column get sizeBytes => int64()();
  TextColumn get path => text()();
  TextColumn get uploadedBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Folders table
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Documents table
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get kind => text()(); // 'file' | 'written'
  TextColumn get title => text()();
  TextColumn get folderId => text().nullable()();
  TextColumn get fileId => text().nullable()(); // For kind='file'
  TextColumn get content => text().nullable()(); // For kind='written' (Quill delta JSON)
  TextColumn get contentText => text().nullable()(); // For kind='written' (plain text)
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Channels table (team chat channels and DMs)
class Channels extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get kind => text()(); // 'channel' | 'dm'
  TextColumn get name => text().nullable()(); // null for DMs
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Channel members table
class ChannelMembers extends Table {
  TextColumn get channelId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get lastReadAt => dateTime()();
  BoolColumn get muted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {channelId, userId};
}

/// Messages table (chat messages)
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text()();
  TextColumn get senderId => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn get fileId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get editedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {id};
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
  SyncMetadata,
  Events,
  EventAttendees,
  Files,
  Folders,
  Documents,
  Channels,
  ChannelMembers,
  Messages,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

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
          if (from < 6) {
            // Replace SyncState with SyncMetadata in version 6
            await m.deleteTable('sync_state');
            await m.createTable(syncMetadata);
          }
          if (from < 7) {
            // Add Events, Files, Folders, Documents tables in version 7
            await m.createTable(events);
            await m.createTable(eventAttendees);
            await m.createTable(files);
            await m.createTable(folders);
            await m.createTable(documents);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = io.File(p.join(dbFolder.path, 'planpal.db'));
    return NativeDatabase(file);
  });
}
