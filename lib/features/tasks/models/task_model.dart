// app/lib/features/tasks/models/task_model.dart
class TaskModel {
  final String id;
  final String workspaceId;
  final String title;
  final String description;
  final String status; // todo | in_progress | completed
  final String priority; // high | medium | low
  final DateTime? dueAt;
  final int? reminderMinutesBefore;
  final String? assigneeId;
  final String? assigneeName;
  final String? assigneeAvatarUrl;
  final String? labelId;
  final String? labelName;
  final String? labelColor;
  final String createdBy;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubtaskModel> subtasks;
  final List<CommentModel> comments;
  final List<AttachmentModel> attachments;

  const TaskModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    this.description = '',
    this.status = 'todo',
    this.priority = 'medium',
    this.dueAt,
    this.reminderMinutesBefore,
    this.assigneeId,
    this.assigneeName,
    this.assigneeAvatarUrl,
    this.labelId,
    this.labelName,
    this.labelColor,
    required this.createdBy,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.subtasks = const [],
    this.comments = const [],
    this.attachments = const [],
  });

  bool get isCompleted => status == 'completed';
  bool get isOverdue =>
      !isCompleted && dueAt != null && dueAt!.isBefore(DateTime.now());
  bool get isToday {
    if (dueAt == null) return false;
    final now = DateTime.now();
    return dueAt!.year == now.year &&
        dueAt!.month == now.month &&
        dueAt!.day == now.day;
  }

  factory TaskModel.fromJson(Map<String, dynamic> j) {
    final assignee = j['assignee'] as Map<String, dynamic>?;
    final label = j['label'] as Map<String, dynamic>?;
    return TaskModel(
      id: j['id'] as String,
      workspaceId: j['workspace_id'] as String,
      title: j['title'] as String,
      description: j['description'] as String? ?? '',
      status: j['status'] as String? ?? 'todo',
      priority: j['priority'] as String? ?? 'medium',
      dueAt: j['due_at'] != null ? DateTime.parse(j['due_at'] as String) : null,
      reminderMinutesBefore: j['reminder_minutes_before'] as int?,
      assigneeId: j['assignee_id'] as String?,
      assigneeName: assignee?['full_name'] as String?,
      assigneeAvatarUrl: assignee?['avatar_url'] as String?,
      labelId: j['label_id'] as String?,
      labelName: label?['name'] as String?,
      labelColor: label?['color'] as String?,
      createdBy: j['created_by'] as String,
      completedAt: j['completed_at'] != null
          ? DateTime.parse(j['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(j['created_at'] as String),
      updatedAt: DateTime.parse(j['updated_at'] as String),
      subtasks: (j['subtasks'] as List? ?? [])
          .map((s) => SubtaskModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      comments: (j['comments'] as List? ?? [])
          .map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      attachments:
          (j['attachments'] as List? ?? j['task_attachments'] as List? ?? [])
              .map((a) => AttachmentModel.fromJson(a as Map<String, dynamic>))
              .toList(),
    );
  }
}

class TaskLabelModel {
  final String id;
  final String name;
  final String color;

  const TaskLabelModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory TaskLabelModel.fromJson(Map<String, dynamic> json) => TaskLabelModel(
    id: json['id'] as String,
    name: json['name'] as String,
    color: json['color'] as String? ?? '#3B82F6',
  );
}

class SubtaskModel {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;
  final int position;

  const SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.isDone = false,
    this.position = 0,
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> j) => SubtaskModel(
    id: j['id'] as String,
    taskId: j['task_id'] as String,
    title: j['title'] as String,
    isDone: j['is_done'] as bool? ?? j['done'] as bool? ?? false,
    position: j['position'] as int? ?? 0,
  );
}

List<SubtaskModel> reorderSubtaskList(
  List<SubtaskModel> subtasks,
  int oldIndex,
  int newIndex,
) {
  final reordered = List<SubtaskModel>.from(subtasks);
  final moved = reordered.removeAt(oldIndex);
  reordered.insert(newIndex, moved);
  return [
    for (var index = 0; index < reordered.length; index++)
      SubtaskModel(
        id: reordered[index].id,
        taskId: reordered[index].taskId,
        title: reordered[index].title,
        isDone: reordered[index].isDone,
        position: index,
      ),
  ];
}

class CommentModel {
  final String id;
  final String taskId;
  final String authorId;
  final String? authorName;
  final String? authorAvatarUrl;
  final String body;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.taskId,
    required this.authorId,
    this.authorName,
    this.authorAvatarUrl,
    required this.body,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> j) {
    final author = j['author'] as Map<String, dynamic>?;
    return CommentModel(
      id: j['id'] as String,
      taskId: j['task_id'] as String,
      authorId: j['author_id'] as String,
      authorName: author?['full_name'] as String?,
      authorAvatarUrl: author?['avatar_url'] as String?,
      body: j['body'] as String,
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}

class AttachmentModel {
  final String fileId;
  final String name;
  final String mimeType;
  final int sizeBytes;
  final String storagePath;

  const AttachmentModel({
    required this.fileId,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
    required this.storagePath,
  });

  String get extension => name.split('.').last.toLowerCase();
  String get sizeLabel {
    if (sizeBytes < 1024) return '${sizeBytes}B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  factory AttachmentModel.fromJson(Map<String, dynamic> j) {
    final file =
        j['file'] as Map<String, dynamic>? ??
        j['files'] as Map<String, dynamic>? ??
        j;
    return AttachmentModel(
      fileId: file['id'] as String? ?? j['file_id'] as String,
      name: file['name'] as String? ?? '',
      mimeType: file['mime_type'] as String? ?? '',
      sizeBytes: file['size_bytes'] as int? ?? 0,
      storagePath: file['storage_path'] as String? ?? '',
    );
  }
}
