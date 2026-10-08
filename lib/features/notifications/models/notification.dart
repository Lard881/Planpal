import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

/// Notification types enum (matches backend)
enum NotificationType {
  @JsonValue('task_assigned')
  taskAssigned,
  @JsonValue('task_updated')
  taskUpdated,
  @JsonValue('task_comment')
  taskComment,
  @JsonValue('mention')
  mention,
  @JsonValue('deadline_approaching')
  deadlineApproaching,
  @JsonValue('task_overdue')
  taskOverdue,
  @JsonValue('event_reminder')
  eventReminder,
  @JsonValue('chat_message')
  chatMessage,
  @JsonValue('member_joined')
  memberJoined,
  @JsonValue('system')
  system,
}

/// Extension to convert notification type to/from string
extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.taskAssigned:
        return 'task_assigned';
      case NotificationType.taskUpdated:
        return 'task_updated';
      case NotificationType.taskComment:
        return 'task_comment';
      case NotificationType.mention:
        return 'mention';
      case NotificationType.deadlineApproaching:
        return 'deadline_approaching';
      case NotificationType.taskOverdue:
        return 'task_overdue';
      case NotificationType.eventReminder:
        return 'event_reminder';
      case NotificationType.chatMessage:
        return 'chat_message';
      case NotificationType.memberJoined:
        return 'member_joined';
      case NotificationType.system:
        return 'system';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'task_assigned':
        return NotificationType.taskAssigned;
      case 'task_updated':
        return NotificationType.taskUpdated;
      case 'task_comment':
        return NotificationType.taskComment;
      case 'mention':
        return NotificationType.mention;
      case 'deadline_approaching':
        return NotificationType.deadlineApproaching;
      case 'task_overdue':
        return NotificationType.taskOverdue;
      case 'event_reminder':
        return NotificationType.eventReminder;
      case 'chat_message':
        return NotificationType.chatMessage;
      case 'member_joined':
        return NotificationType.memberJoined;
      case 'system':
      default:
        return NotificationType.system;
    }
  }
}

/// Notification model (matches backend API schema)
@JsonSerializable()
class AppNotification {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'workspace_id')
  final String workspaceId;
  final NotificationType type;
  final String title;
  final String body;
  @JsonKey(name: 'entity_type')
  final String? entityType;
  @JsonKey(name: 'entity_id')
  final String? entityId;
  @JsonKey(name: 'dedupe_key')
  final String? dedupeKey;
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @JsonKey(name: 'pushed_at')
  final DateTime? pushedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.workspaceId,
    required this.type,
    required this.title,
    required this.body,
    this.entityType,
    this.entityId,
    this.dedupeKey,
    this.readAt,
    this.pushedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether the notification has been read
  bool get isRead => readAt != null;

  /// Whether the notification has been pushed
  bool get isPushed => pushedAt != null;

  /// Copy with method for immutability
  AppNotification copyWith({
    String? id,
    String? userId,
    String? workspaceId,
    NotificationType? type,
    String? title,
    String? body,
    String? entityType,
    String? entityId,
    String? dedupeKey,
    DateTime? readAt,
    DateTime? pushedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workspaceId: workspaceId ?? this.workspaceId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      readAt: readAt ?? this.readAt,
      pushedAt: pushedAt ?? this.pushedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// JSON serialization
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Notification counts model (from API)
@JsonSerializable()
class NotificationCounts {
  final int total;
  final int unread;
  final int read;
  @JsonKey(name: 'by_type')
  final Map<String, int> byType;
  @JsonKey(name: 'unread_by_type')
  final Map<String, int> unreadByType;

  NotificationCounts({
    required this.total,
    required this.unread,
    required this.read,
    required this.byType,
    required this.unreadByType,
  });

  factory NotificationCounts.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationCountsToJson(this);
}

/// Notification filter options
class NotificationFilter {
  final bool? read;
  final NotificationType? type;
  final String? workspaceId;

  NotificationFilter({
    this.read,
    this.type,
    this.workspaceId,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (read != null) params['read'] = read.toString();
    if (type != null) params['type'] = type!.value;
    if (workspaceId != null) params['workspace_id'] = workspaceId;
    return params;
  }
}

/// Alias for backward compatibility with code that uses NotificationData
typedef NotificationData = AppNotification;
