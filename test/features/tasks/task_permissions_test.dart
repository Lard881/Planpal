import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/tasks/models/task_model.dart';
import 'package:planpal/features/tasks/models/task_permissions.dart';

void main() {
  final task = TaskModel(
    id: 'task-1',
    workspaceId: 'workspace-1',
    title: 'Task',
    assigneeId: 'assignee-1',
    createdBy: 'creator-1',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  group('TaskPermissions.forTask', () {
    test('admins can edit and delete any task', () {
      final permissions = TaskPermissions.forTask(
        role: 'admin',
        userId: 'other-user',
        task: task,
      );

      expect(permissions.canEditFields, isTrue);
      expect(permissions.canChangeStatus, isTrue);
      expect(permissions.canComment, isTrue);
      expect(permissions.canDelete, isTrue);
    });

    test('members can edit assigned tasks but delete only their own', () {
      final assigned = TaskPermissions.forTask(
        role: 'member',
        userId: 'assignee-1',
        task: task,
      );
      final unrelated = TaskPermissions.forTask(
        role: 'member',
        userId: 'other-user',
        task: task,
      );

      expect(assigned.canEditFields, isTrue);
      expect(assigned.canDelete, isFalse);
      expect(unrelated.canEditFields, isFalse);
      expect(unrelated.canComment, isTrue);
      expect(unrelated.canDelete, isFalse);
    });

    test('guests can change status and comment only on assigned tasks', () {
      final assigned = TaskPermissions.forTask(
        role: 'guest',
        userId: 'assignee-1',
        task: task,
      );
      final unassigned = TaskPermissions.forTask(
        role: 'guest',
        userId: 'other-user',
        task: task,
      );

      expect(assigned.canEditFields, isFalse);
      expect(assigned.canChangeStatus, isTrue);
      expect(assigned.canComment, isTrue);
      expect(assigned.canDelete, isFalse);
      expect(unassigned.canChangeStatus, isFalse);
      expect(unassigned.canComment, isFalse);
    });
  });
}
