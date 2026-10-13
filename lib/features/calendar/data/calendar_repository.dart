// app/lib/features/calendar/data/calendar_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/event_model.dart';

class CalendarRepository {
  final Dio _dio;
  CalendarRepository(this._dio);

  Future<(List<EventModel>, AppFailure?)> getEvents(
    String workspaceId,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/events',
        queryParameters: {
          'from': from.toUtc().toIso8601String(),
          'to': to.toUtc().toIso8601String(),
        },
      );
      final events = (res.data['events'] as List? ?? [])
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (events, null);
    } on DioException catch (e) {
      return (<EventModel>[], mapDioError(e));
    }
  }

  Future<(EventModel?, AppFailure?)> createEvent(
    String workspaceId, {
    required String title,
    String description = '',
    required DateTime startsAt,
    required DateTime endsAt,
    bool allDay = false,
    String color = '#4F46E5',
    List<String> attendeeIds = const [],
    int reminderMinutesBefore = 15,
  }) async {
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/events',
        data: {
          'title': title,
          'description': description,
          'starts_at': startsAt.toUtc().toIso8601String(),
          'ends_at': endsAt.toUtc().toIso8601String(),
          'all_day': allDay,
          'color': color,
          'reminder_minutes_before': reminderMinutesBefore,
          if (attendeeIds.isNotEmpty) 'attendeeIds': attendeeIds,
        },
      );
      return (EventModel.fromJson(res.data['event'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> updateEvent(
      String eventId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/events/$eventId', data: updates);
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> deleteEvent(String workspaceId, String eventId) async {
    try {
      await _dio.delete('/events/$eventId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(ref.watch(apiClientProvider).dio);
});
