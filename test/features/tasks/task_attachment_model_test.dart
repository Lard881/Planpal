import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/tasks/models/task_model.dart';

void main() {
  test('parses task list fields and detail subtask/comment contracts', () {
    final task = TaskModel.fromJson({
      'id': 'task-1',
      'workspace_id': 'workspace-1',
      'title': 'Task',
      'created_by': 'user-1',
      'created_at': '2025-01-01T00:00:00.000Z',
      'updated_at': '2025-01-01T00:00:00.000Z',
      'subtasks': [
        {
          'id': 'subtask-1',
          'task_id': 'task-1',
          'title': 'Subtask',
          'is_done': true,
          'position': 0,
        },
      ],
      'comments': [
        {
          'id': 'comment-1',
          'task_id': 'task-1',
          'author_id': 'user-2',
          'body': 'Comment',
          'created_at': '2025-01-01T00:00:00.000Z',
          'author': {
            'full_name': 'Member',
            'avatar_url': 'https://example.invalid/avatar',
          },
        },
      ],
    });

    expect(task.workspaceId, 'workspace-1');
    expect(task.createdBy, 'user-1');
    expect(task.subtasks.single.isDone, isTrue);
    expect(task.comments.single.taskId, 'task-1');
    expect(task.comments.single.authorId, 'user-2');
    expect(task.comments.single.authorName, 'Member');
    expect(task.comments.single.authorAvatarUrl, contains('/avatar'));
  });

  test('parses attachments returned by the task detail endpoint', () {
    final task = TaskModel.fromJson({
      'id': 'task-1',
      'workspace_id': 'workspace-1',
      'title': 'Task',
      'created_by': 'user-1',
      'created_at': '2025-01-01T00:00:00.000Z',
      'updated_at': '2025-01-01T00:00:00.000Z',
      'task_attachments': [
        {
          'file_id': 'file-1',
          'files': {
            'id': 'file-1',
            'name': 'requirements.pdf',
            'mime_type': 'application/pdf',
            'size_bytes': 2048,
            'storage_path': 'workspace-1/requirements.pdf',
          },
        },
      ],
    });

    expect(task.attachments, hasLength(1));
    expect(task.attachments.single.fileId, 'file-1');
    expect(task.attachments.single.name, 'requirements.pdf');
    expect(task.attachments.single.mimeType, 'application/pdf');
    expect(task.attachments.single.sizeBytes, 2048);
    expect(task.attachments.single.storagePath, 'workspace-1/requirements.pdf');
  });
}
