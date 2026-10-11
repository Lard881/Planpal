import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:planpal/core/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Subtasks table insert and read', () async {
    final now = DateTime.now();
    await db.into(db.subtasks).insert(
      SubtasksCompanion.insert(
        id: 'subtask-1',
        taskId: 'task-1',
        title: 'Review implementation',
        isDone: const Value(false),
        position: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final subtask = await (db.select(db.subtasks)..where((t) => t.id.equals('subtask-1'))).getSingle();
    expect(subtask.id, 'subtask-1');
    expect(subtask.taskId, 'task-1');
    expect(subtask.title, 'Review implementation');
    expect(subtask.isDone, false);
    expect(subtask.position, 1);
  });

  test('TaskComments table insert and read', () async {
    final now = DateTime.now();
    await db.into(db.taskComments).insert(
      TaskCommentsCompanion.insert(
        id: 'comment-1',
        taskId: 'task-1',
        authorId: 'user-1',
        body: 'Looks good to me!',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final comment = await (db.select(db.taskComments)..where((t) => t.id.equals('comment-1'))).getSingle();
    expect(comment.id, 'comment-1');
    expect(comment.taskId, 'task-1');
    expect(comment.authorId, 'user-1');
    expect(comment.body, 'Looks good to me!');
  });
}
