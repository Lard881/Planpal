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
  TextColumn? get role => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkspaceMembers extends Table {
  TextColumn get workspaceId => text()();
  TextColumn get userId => text()();
  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn? get avatarUrl => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn? get joinedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {workspaceId, userId};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('todo'))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  DateTimeColumn? get dueAt => dateTime().nullable()();
  IntColumn? get reminderMinutesBefore => integer().nullable()();
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
  TextColumn? get authorName => text().nullable()();
  TextColumn? get authorAvatarUrl => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TaskAttachments extends Table {
  TextColumn get taskId => text()();
  TextColumn get fileId => text()();
  TextColumn get name => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get storagePath => text()();

  @override
  Set<Column> get primaryKey => {taskId, fileId};
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
  IntColumn get reminderMinutesBefore =>
      integer().withDefault(const Constant(15))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EventAttendees extends Table {
  TextColumn get eventId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {eventId, userId};
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

class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn? get parentId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get fileCount => integer().withDefault(const Constant(0))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn? get folderId => text().nullable()();
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn? get fileId => text().nullable()();
  TextColumn? get mimeType => text().nullable()();
  IntColumn? get sizeBytes => integer().nullable()();
  TextColumn? get storagePath => text().nullable()();
  TextColumn? get content => text().nullable()();
  TextColumn get contentText => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn? get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatChannels extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get kind => text()();
  TextColumn? get name => text().nullable()();
  TextColumn? get description => text().nullable()();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  TextColumn? get lastMessageBody => text().nullable()();
  TextColumn? get lastMessageSenderName => text().nullable()();
  DateTimeColumn? get lastMessageAt => dateTime().nullable()();
  TextColumn get memberIds => text().withDefault(const Constant('[]'))();
  TextColumn get memberNames => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get channelId => text()();
  TextColumn get senderId => text()();
  TextColumn? get senderName => text().nullable()();
  TextColumn? get senderAvatarUrl => text().nullable()();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn? get fileId => text().nullable()();
  TextColumn? get fileName => text().nullable()();
  TextColumn? get fileMimeType => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn? get editedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('sent'))();

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

@DriftDatabase(
  tables: [
    Workspaces,
    WorkspaceMembers,
    Tasks,
    Subtasks,
    TaskComments,
    TaskAttachments,
    Labels,
    Events,
    EventAttendees,
    Profiles,
    Notifications,
    Folders,
    Documents,
    ChatChannels,
    ChatMessages,
    OutboxEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  Future<void> clearUserData() async {
    await transaction(() async {
      await delete(taskAttachments).go();
      await delete(taskComments).go();
      await delete(subtasks).go();
      await delete(eventAttendees).go();
      await delete(events).go();
      await delete(tasks).go();
      await delete(labels).go();
      await delete(notifications).go();
      await delete(documents).go();
      await delete(folders).go();
      await delete(chatMessages).go();
      await delete(chatChannels).go();
      await delete(profiles).go();
      await delete(workspaceMembers).go();
      await delete(workspaces).go();
      await delete(outboxEntries).go();
    });
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(tasks, tasks.reminderMinutesBefore);
      }
      if (from < 3) {
        await m.addColumn(taskComments, taskComments.authorName);
        await m.addColumn(taskComments, taskComments.authorAvatarUrl);
        await m.createTable(taskAttachments);
      }
      if (from < 4) {
        await m.addColumn(events, events.reminderMinutesBefore);
        await m.createTable(eventAttendees);
      }
      if (from < 5) {
        await m.addColumn(workspaces, workspaces.role);
      }
      if (from < 6) {
        await m.createTable(folders);
        await m.createTable(documents);
      }
      if (from < 7) {
        await m.createTable(chatChannels);
        await m.createTable(chatMessages);
      }
      if (from < 8) {
        await m.createTable(workspaceMembers);
      }
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
