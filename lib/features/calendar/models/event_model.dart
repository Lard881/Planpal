// app/lib/features/calendar/models/event_model.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EventModel {
  final String id;
  final String workspaceId;
  final String title;
  final String description;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool allDay;
  final String color;
  final String? taskId;
  final int reminderMinutesBefore;
  final String createdBy;
  final List<String> attendeeIds;
  final List<String> attendeeNames;

  const EventModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    this.description = '',
    required this.startsAt,
    required this.endsAt,
    this.allDay = false,
    this.color = '#4F46E5',
    this.taskId,
    this.reminderMinutesBefore = 15,
    required this.createdBy,
    this.attendeeIds = const [],
    this.attendeeNames = const [],
  });

  Color get pillFg {
    try {
      return Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return PlanPalColors.light.primary;
    }
  }

  Color get pillBg => pillFg.withValues(alpha: 0.15);

  factory EventModel.fromJson(Map<String, dynamic> j) {
    final attendees =
        (j['event_attendees'] as List?) ?? (j['attendees'] as List?) ?? [];
    return EventModel(
      id: j['id'] as String,
      workspaceId: j['workspace_id'] as String,
      title: j['title'] as String,
      description: j['description'] as String? ?? '',
      startsAt: DateTime.parse(j['starts_at'] as String).toLocal(),
      endsAt: DateTime.parse(j['ends_at'] as String).toLocal(),
      allDay: j['all_day'] as bool? ?? false,
      color: j['color'] as String? ?? '#4F46E5',
      taskId: j['task_id'] as String?,
      reminderMinutesBefore: j['reminder_minutes_before'] as int? ?? 15,
      createdBy: j['created_by'] as String,
      attendeeIds: attendees
          .map((a) => ((a as Map)['user_id'] ?? a['id']) as String)
          .toList(),
      attendeeNames: attendees
          .map((a) {
            final p =
                (a as Map)['profile'] as Map? ?? a['profiles'] as Map? ?? a;
            return (p['full_name'] ?? '') as String;
          })
          .where((n) => n.isNotEmpty)
          .toList(),
    );
  }

  String formatTime(BuildContext context) => MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(TimeOfDay.fromDateTime(startsAt));
}

class DueTaskModel {
  final String id;
  final String title;
  final DateTime dueAt;
  final String status;
  final String priority;

  const DueTaskModel({
    required this.id,
    required this.title,
    required this.dueAt,
    required this.status,
    required this.priority,
  });

  factory DueTaskModel.fromJson(Map<String, dynamic> json) => DueTaskModel(
    id: json['id'] as String,
    title: json['title'] as String,
    dueAt: DateTime.parse(json['due_at'] as String).toLocal(),
    status: json['status'] as String,
    priority: json['priority'] as String,
  );
}
