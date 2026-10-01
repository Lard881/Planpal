import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Represents an activity log entry for tracking changes
@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required ActivityEntityType entityType,
    required String entityId,
    required ActivityAction action,
    required String workspaceId,
    required String userId,
    required DateTime createdAt,
    @Default({}) Map<String, dynamic> changes,
    @Default({}) Map<String, dynamic> metadata,
    
    // Populated from joins
    ActivityUser? user,
    ActivityTask? task,
    ActivityProject? project,
    ActivityWorkspace? workspace,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

/// User information for an activity
@freezed
class ActivityUser with _$ActivityUser {
  const factory ActivityUser({
    required String id,
    required String name,
    String? avatarUrl,
    String? email,
  }) = _ActivityUser;

  factory ActivityUser.fromJson(Map<String, dynamic> json) => _$ActivityUserFromJson(json);
}

/// Task information for an activity
@freezed
class ActivityTask with _$ActivityTask {
  const factory ActivityTask({
    required String id,
    required String title,
    String? status,
  }) = _ActivityTask;

  factory ActivityTask.fromJson(Map<String, dynamic> json) => _$ActivityTaskFromJson(json);
}

/// Project information for an activity
@freezed
class ActivityProject with _$ActivityProject {
  const factory ActivityProject({
    required String id,
    required String name,
    String? color,
  }) = _ActivityProject;

  factory ActivityProject.fromJson(Map<String, dynamic> json) => _$ActivityProjectFromJson(json);
}

/// Workspace information for an activity
@freezed
class ActivityWorkspace with _$ActivityWorkspace {
  const factory ActivityWorkspace({
    required String id,
    required String name,
  }) = _ActivityWorkspace;

  factory ActivityWorkspace.fromJson(Map<String, dynamic> json) =>
      _$ActivityWorkspaceFromJson(json);
}

/// Type of entity the activity is related to
enum ActivityEntityType {
  @JsonValue('task')
  task,
  @JsonValue('project')
  project,
  @JsonValue('workspace')
  workspace,
  @JsonValue('comment')
  comment,
}

/// Type of action performed
enum ActivityAction {
  @JsonValue('created')
  created,
  @JsonValue('updated')
  updated,
  @JsonValue('deleted')
  deleted,
  @JsonValue('completed')
  completed,
  @JsonValue('reopened')
  reopened,
  @JsonValue('assigned')
  assigned,
  @JsonValue('unassigned')
  unassigned,
  @JsonValue('status_changed')
  statusChanged,
  @JsonValue('priority_changed')
  priorityChanged,
  @JsonValue('due_date_changed')
  dueDateChanged,
  @JsonValue('moved')
  moved,
  @JsonValue('commented')
  commented,
  @JsonValue('mentioned')
  mentioned,
}

/// Request to create a new activity log
@freezed
class CreateActivityRequest with _$CreateActivityRequest {
  const factory CreateActivityRequest({
    String? id,
    required ActivityEntityType entityType,
    required String entityId,
    required ActivityAction action,
    required String workspaceId,
    @Default({}) Map<String, dynamic> changes,
    @Default({}) Map<String, dynamic> metadata,
  }) = _CreateActivityRequest;

  factory CreateActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateActivityRequestFromJson(json);
}

/// Response containing list of activities
@freezed
class ActivitiesResponse with _$ActivitiesResponse {
  const factory ActivitiesResponse({
    required List<Activity> activities,
    int? total,
    ActivitiesPagination? pagination,
  }) = _ActivitiesResponse;

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesResponseFromJson(json);
}

/// Pagination info for activities
@freezed
class ActivitiesPagination with _$ActivitiesPagination {
  const factory ActivitiesPagination({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
  }) = _ActivitiesPagination;

  factory ActivitiesPagination.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesPaginationFromJson(json);
}

/// Extension for user-friendly activity descriptions
extension ActivityActionExtension on ActivityAction {
  String get displayName {
    switch (this) {
      case ActivityAction.created:
        return 'created';
      case ActivityAction.updated:
        return 'updated';
      case ActivityAction.deleted:
        return 'deleted';
      case ActivityAction.completed:
        return 'completed';
      case ActivityAction.reopened:
        return 'reopened';
      case ActivityAction.assigned:
        return 'assigned';
      case ActivityAction.unassigned:
        return 'unassigned';
      case ActivityAction.statusChanged:
        return 'changed status';
      case ActivityAction.priorityChanged:
        return 'changed priority';
      case ActivityAction.dueDateChanged:
        return 'changed due date';
      case ActivityAction.moved:
        return 'moved';
      case ActivityAction.commented:
        return 'commented on';
      case ActivityAction.mentioned:
        return 'mentioned you in';
    }
  }

  String get icon {
    switch (this) {
      case ActivityAction.created:
        return '➕';
      case ActivityAction.updated:
        return '✏️';
      case ActivityAction.deleted:
        return '🗑️';
      case ActivityAction.completed:
        return '✅';
      case ActivityAction.reopened:
        return '🔄';
      case ActivityAction.assigned:
        return '👤';
      case ActivityAction.unassigned:
        return '👥';
      case ActivityAction.statusChanged:
        return '📊';
      case ActivityAction.priorityChanged:
        return '🔥';
      case ActivityAction.dueDateChanged:
        return '📅';
      case ActivityAction.moved:
        return '📦';
      case ActivityAction.commented:
        return '💬';
      case ActivityAction.mentioned:
        return '@';
    }
  }
}
