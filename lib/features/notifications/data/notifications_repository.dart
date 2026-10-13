// app/lib/features/notifications/data/notifications_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final Dio _dio;
  NotificationsRepository(this._dio);

  Future<(List<NotificationModel>, int, AppFailure?)> getNotifications({
    String filter = 'all',
    String? cursor,
  }) async {
    try {
      final params = <String, dynamic>{'filter': filter};
      if (cursor != null) params['cursor'] = cursor;
      final res = await _dio.get('/notifications', queryParameters: params);
      final list = (res.data['notifications'] as List)
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();
      final unreadCount = res.data['unreadCount'] as int? ?? 0;
      return (list, unreadCount, null);
    } on DioException catch (e) {
      return (<NotificationModel>[], 0, mapDioError(e));
    }
  }

  Future<AppFailure?> markRead(String notificationId) async {
    try {
      await _dio.post('/notifications/$notificationId/read');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> markUnread(String notificationId) async {
    try {
      await _dio.post('/notifications/$notificationId/unread');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> markAllRead() async {
    try {
      await _dio.post('/notifications/read-all');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> deleteNotification(String notificationId) async {
    try {
      await _dio.delete('/notifications/$notificationId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> registerDevice(String token, String platform) async {
    try {
      await _dio.post('/devices', data: {'token': token, 'platform': platform});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> unregisterDevice(String token) async {
    try {
      await _dio.delete('/devices/$token');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(apiClientProvider).dio);
});
