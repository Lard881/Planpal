import '../../../core/db/app_database.dart';

/// S7.24: Guest and role restrictions in the UI
/// Defines what each role can do with tasks
class TaskPermissions {
  /// Can the user create tasks?
  static bool canCreateTasks(String role) {
    // Guests cannot create tasks
    return role != 'guest';
  }

  /// Can the user edit this task?
  static bool canEditTask(String role, Task task, String currentUserId) {
    // Admins and members can edit any task
    // Guests cannot edit tasks at all
    if (role == 'guest') return false;
    return true;
  }

  /// Can the user delete this task?
  static bool canDeleteTask(String role, Task task, String currentUserId) {
    // Admins can delete any task
    if (role == 'admin') return true;
    
    // Members can delete their own tasks
    if (role == 'member' && task.createdBy == currentUserId) return true;
    
    // Guests cannot delete
    return false;
  }

  /// Can the user change task status?
  static bool canChangeStatus(String role, Task task) {
    // Guests can only view, not change
    if (role == 'guest') return false;
    
    // Admins and members can change status
    return true;
  }

  /// Can the user add comments?
  static bool canAddComments(String role) {
    // Guests cannot comment
    return role != 'guest';
  }

  /// Can the user add attachments?
  static bool canAddAttachments(String role) {
    // Guests cannot add attachments
    return role != 'guest';
  }

  /// Can the user assign tasks?
  static bool canAssignTasks(String role) {
    // Only admins and members can assign
    return role != 'guest';
  }

  /// Can the user move tasks between workspaces?
  static bool canMoveTasks(String role) {
    // Only admins can move tasks
    return role == 'admin';
  }

  /// Can the user bulk delete?
  static bool canBulkDelete(String role) {
    // Only admins can bulk delete
    return role == 'admin';
  }

  /// Get a friendly message for why action is disabled
  static String getPermissionMessage(String role, String action) {
    if (role == 'guest') {
      return 'Guests can only view $action. Contact an admin to upgrade your role.';
    }
    return 'You don\'t have permission to $action.';
  }
}
