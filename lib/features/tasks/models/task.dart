import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String workspaceId,
    String? projectId,
    required String title,
    String? description,
    @Default('todo') String status,
    String? priority,
    DateTime? dueDate,
    String? assigneeId,
    String? parentTaskId,
    int? position,
    @Default([]) List<String> labelIds,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    DateTime? deletedAt,
    // Related data (from joins)
    @JsonKey(includeFromJson: true, includeToJson: false) TaskProject? project,
    @JsonKey(includeFromJson: true, includeToJson: false) TaskAssignee? assignee,
    @JsonKey(includeFromJson: true, includeToJson: false) @Default([]) List<TaskLabel>? labels,
    @JsonKey(includeFromJson: true, includeToJson: false) @Default([]) List<Task>? subtasks,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class TaskProject with _$TaskProject {
  const factory TaskProject({
    required String id,
    required String name,
    String? color,
    String? icon,
  }) = _TaskProject;

  factory TaskProject.fromJson(Map<String, dynamic> json) => _$TaskProjectFromJson(json);
}

@freezed
class TaskAssignee with _$TaskAssignee {
  const factory TaskAssignee({
    required String id,
    required String name,
    String? avatarUrl,
  }) = _TaskAssignee;

  factory TaskAssignee.fromJson(Map<String, dynamic> json) => _$TaskAssigneeFromJson(json);
}

@freezed
class TaskLabel with _$TaskLabel {
  const factory TaskLabel({
    required String id,
    required String name,
    required String color,
  }) = _TaskLabel;

  factory TaskLabel.fromJson(Map<String, dynamic> json) => _$TaskLabelFromJson(json);
}

/// Task status enum
enum TaskStatus {
  todo('todo'),
  inProgress('in_progress'),
  blocked('blocked'),
  completed('completed');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TaskStatus.todo,
    );
  }
}

/// Task priority enum
enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority? fromString(String? value) {
    if (value == null) return null;
    return TaskPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

/// Task view filter enum
enum TaskView {
  all('all'),
  today('today'),
  week('week'),
  overdue('overdue'),
  completed('completed');

  const TaskView(this.value);
  final String value;
}

/// Extension for task helpers
extension TaskExtension on Task {
  bool get isCompleted => status == 'completed';
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return dueDate!.isAfter(today) && dueDate!.isBefore(tomorrow);
  }

  TaskPriority? get priorityEnum => TaskPriority.fromString(priority);
  TaskStatus get statusEnum => TaskStatus.fromString(status);
}
