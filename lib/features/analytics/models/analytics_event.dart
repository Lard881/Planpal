import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';
part 'analytics_event.g.dart';

/// Analytics event types
enum AnalyticsEventType {
  @JsonValue('task_created')
  taskCreated,
  @JsonValue('task_completed')
  taskCompleted,
  @JsonValue('task_updated')
  taskUpdated,
  @JsonValue('task_deleted')
  taskDeleted,
  @JsonValue('search_performed')
  searchPerformed,
  @JsonValue('attachment_uploaded')
  attachmentUploaded,
  @JsonValue('comment_added')
  commentAdded,
  @JsonValue('label_applied')
  labelApplied,
  @JsonValue('project_created')
  projectCreated,
  @JsonValue('workspace_joined')
  workspaceJoined,
  @JsonValue('reminder_set')
  reminderSet,
  @JsonValue('filter_applied')
  filterApplied,
  @JsonValue('export_performed')
  exportPerformed,
  @JsonValue('notification_clicked')
  notificationClicked,
  @JsonValue('page_viewed')
  pageViewed,
}

/// Extension to convert enum to string
extension AnalyticsEventTypeExtension on AnalyticsEventType {
  String get value {
    switch (this) {
      case AnalyticsEventType.taskCreated:
        return 'task_created';
      case AnalyticsEventType.taskCompleted:
        return 'task_completed';
      case AnalyticsEventType.taskUpdated:
        return 'task_updated';
      case AnalyticsEventType.taskDeleted:
        return 'task_deleted';
      case AnalyticsEventType.searchPerformed:
        return 'search_performed';
      case AnalyticsEventType.attachmentUploaded:
        return 'attachment_uploaded';
      case AnalyticsEventType.commentAdded:
        return 'comment_added';
      case AnalyticsEventType.labelApplied:
        return 'label_applied';
      case AnalyticsEventType.projectCreated:
        return 'project_created';
      case AnalyticsEventType.workspaceJoined:
        return 'workspace_joined';
      case AnalyticsEventType.reminderSet:
        return 'reminder_set';
      case AnalyticsEventType.filterApplied:
        return 'filter_applied';
      case AnalyticsEventType.exportPerformed:
        return 'export_performed';
      case AnalyticsEventType.notificationClicked:
        return 'notificationClicked';
      case AnalyticsEventType.pageViewed:
        return 'page_viewed';
    }
  }
}

/// Analytics event model
@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent({
    String? id,
    required String userId,
    String? workspaceId,
    required AnalyticsEventType eventType,
    @Default({}) Map<String, dynamic> eventData,
    DateTime? createdAt,
  }) = _AnalyticsEvent;

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventFromJson(json);
}

/// Analytics event for batch submission
@freezed
class AnalyticsEventBatch with _$AnalyticsEventBatch {
  const factory AnalyticsEventBatch({
    required AnalyticsEventType eventType,
    String? workspaceId,
    @Default({}) Map<String, dynamic> eventData,
    DateTime? createdAt,
  }) = _AnalyticsEventBatch;

  factory AnalyticsEventBatch.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventBatchFromJson(json);
}
