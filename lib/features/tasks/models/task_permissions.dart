import 'task_model.dart';

class TaskPermissions {
  final bool canEditFields;
  final bool canChangeStatus;
  final bool canComment;
  final bool canDelete;

  const TaskPermissions({
    required this.canEditFields,
    required this.canChangeStatus,
    required this.canComment,
    required this.canDelete,
  });

  factory TaskPermissions.forTask({
    required String? role,
    required String? userId,
    required TaskModel task,
  }) {
    final isAssignedToUser = userId != null && task.assigneeId == userId;
    final isCreator = userId != null && task.createdBy == userId;
    final canEditFields =
        role == 'admin' ||
        (role == 'member' && (isCreator || isAssignedToUser));
    final canChangeStatus =
        canEditFields || (role == 'guest' && isAssignedToUser);

    return TaskPermissions(
      canEditFields: canEditFields,
      canChangeStatus: canChangeStatus,
      canComment:
          role == 'admin' ||
          role == 'member' ||
          (role == 'guest' && isAssignedToUser),
      canDelete: role == 'admin' || (role == 'member' && isCreator),
    );
  }
}
