import '../models/workspace.dart';
import '../models/workspace_member.dart';

/// Workspace permission utilities
/// 
/// Implements UI rules for workspace features based on:
/// - Workspace type (personal vs team)
/// - User role (admin, member, guest)
/// - Feature availability
class WorkspacePermissions {
  final Workspace workspace;
  final WorkspaceMember? currentMember;

  WorkspacePermissions({
    required this.workspace,
    this.currentMember,
  });

  // ============ Workspace Type Checks ============

  /// Check if this is a personal workspace
  bool get isPersonal => workspace.type == 'personal';

  /// Check if this is a team workspace
  bool get isTeam => workspace.type == 'team';

  // ============ Role Checks ============

  /// Check if current user is an admin
  bool get isAdmin => currentMember?.role == 'admin';

  /// Check if current user is a member (not guest)
  bool get isMember => currentMember?.role == 'member' || isAdmin;

  /// Check if current user is a guest
  bool get isGuest => currentMember?.role == 'guest';

  // ============ Feature Permissions ============

  /// Can use chat feature
  /// Chat is only available in team workspaces
  bool get canUseChat => isTeam;

  /// Can view workspace members
  /// Members list is visible in team workspaces only
  bool get canViewMembers => isTeam;

  /// Can manage workspace members (add, remove, change roles)
  /// Only admins in team workspaces can manage members
  bool get canManageMembers => isTeam && isAdmin;

  /// Can change member roles
  /// Only admins can change roles
  bool get canChangeMemberRoles => isTeam && isAdmin;

  /// Can remove members
  /// Only admins can remove members
  bool get canRemoveMembers => isTeam && isAdmin;

  /// Can leave workspace
  /// Users cannot leave personal workspaces
  /// Users can leave team workspaces
  bool get canLeaveWorkspace => isTeam;

  /// Can view invite codes
  /// Invite codes are only for team workspaces
  /// All members can view codes
  bool get canViewInviteCodes => isTeam;

  /// Can create invite codes
  /// Only admins can create invite codes
  bool get canCreateInviteCodes => isTeam && isAdmin;

  /// Can revoke invite codes
  /// Only admins can revoke invite codes
  bool get canRevokeInviteCodes => isTeam && isAdmin;

  /// Can edit workspace settings
  /// Only admins can edit workspace settings
  bool get canEditWorkspaceSettings => isAdmin;

  /// Can delete workspace
  /// Only admins can delete workspaces
  /// Cannot delete personal workspaces
  bool get canDeleteWorkspace => isTeam && isAdmin;

  /// Can create tasks
  /// All members can create tasks (guests cannot)
  bool get canCreateTasks => isMember;

  /// Can edit task
  /// Task creator, assignees, and admins can edit
  bool canEditTask({
    required String taskCreatorId,
    required String currentUserId,
    List<String>? assigneeIds,
  }) {
    if (isAdmin) return true;
    if (taskCreatorId == currentUserId) return true;
    if (assigneeIds?.contains(currentUserId) ?? false) return true;
    return false;
  }

  /// Can delete task
  /// Task creator and admins can delete
  bool canDeleteTask({
    required String taskCreatorId,
    required String currentUserId,
  }) {
    if (isAdmin) return true;
    if (taskCreatorId == currentUserId) return true;
    return false;
  }

  /// Can assign tasks to others
  /// Admins and members can assign tasks
  bool get canAssignTasks => isMember;

  /// Can change task priority
  /// All members can change priority
  bool get canChangeTaskPriority => isMember;

  /// Can create projects
  /// Only admins can create projects in team workspaces
  /// In personal workspaces, the user can create projects
  bool get canCreateProjects => isAdmin || isPersonal;

  /// Can edit project
  /// Project creator and admins can edit
  bool canEditProject({
    required String projectCreatorId,
    required String currentUserId,
  }) {
    if (isAdmin) return true;
    if (projectCreatorId == currentUserId) return true;
    return false;
  }

  /// Can delete project
  /// Project creator and admins can delete
  bool canDeleteProject({
    required String projectCreatorId,
    required String currentUserId,
  }) {
    if (isAdmin) return true;
    if (projectCreatorId == currentUserId) return true;
    return false;
  }

  /// Can send messages in chat
  /// All members can send messages (guests can only read)
  bool get canSendChatMessages => isTeam && isMember;

  /// Can create channels
  /// Only admins can create channels
  bool get canCreateChannels => isTeam && isAdmin;

  /// Can edit channel
  /// Channel creator and admins can edit
  bool canEditChannel({
    required String channelCreatorId,
    required String currentUserId,
  }) {
    if (isAdmin) return true;
    if (channelCreatorId == currentUserId) return true;
    return false;
  }

  /// Can delete channel
  /// Only admins can delete channels
  bool get canDeleteChannel => isTeam && isAdmin;

  /// Can upload files
  /// All members can upload files
  bool get canUploadFiles => isMember;

  /// Can delete file
  /// File uploader and admins can delete
  bool canDeleteFile({
    required String fileUploaderId,
    required String currentUserId,
  }) {
    if (isAdmin) return true;
    if (fileUploaderId == currentUserId) return true;
    return false;
  }

  // ============ UI Visibility Helpers ============

  /// Should show chat in navigation
  bool get showChatInNavigation => canUseChat;

  /// Should show members option in workspace menu
  bool get showMembersOption => canViewMembers;

  /// Should show invite codes option in workspace menu
  bool get showInviteCodesOption => canViewInviteCodes;

  /// Should show workspace settings in menu
  bool get showWorkspaceSettings => canEditWorkspaceSettings;

  /// Should show "Leave Workspace" option
  bool get showLeaveWorkspaceOption => canLeaveWorkspace;

  /// Should show "Delete Workspace" option
  bool get showDeleteWorkspaceOption => canDeleteWorkspace;

  /// Should show admin badge on member
  bool get showAdminBadge => isAdmin;

  /// Should show create invite code button
  bool get showCreateInviteCodeButton => canCreateInviteCodes;

  /// Should show revoke invite code button
  bool get showRevokeInviteCodeButton => canRevokeInviteCodes;

  // ============ Error Messages ============

  /// Get error message for chat not available
  String get chatNotAvailableMessage =>
      'Chat is not available in Personal workspaces. Create or join a team workspace to use chat.';

  /// Get error message for feature not available
  String featureNotAvailableMessage(String feature) =>
      '$feature is not available in Personal workspaces.';

  /// Get error message for insufficient permissions
  String get insufficientPermissionsMessage =>
      'You don\'t have permission to perform this action.';

  /// Get error message for admin only feature
  String get adminOnlyMessage =>
      'Only workspace admins can perform this action.';
}

/// Extension on Workspace for quick permission checks
extension WorkspacePermissionsExtension on Workspace {
  /// Get permissions helper for this workspace
  WorkspacePermissions permissions(WorkspaceMember? currentMember) {
    return WorkspacePermissions(
      workspace: this,
      currentMember: currentMember,
    );
  }

  /// Quick check if workspace is personal
  bool get isPersonal => type == 'personal';

  /// Quick check if workspace is team
  bool get isTeam => type == 'team';
}
