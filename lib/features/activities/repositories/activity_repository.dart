import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/activity.dart';

/// Repository for managing activity logs
class ActivityRepository {
  final ApiClient _apiClient;

  ActivityRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Get activities with filters
  Future<ActivitiesResponse> getActivities({
    String? workspaceId,
    ActivityEntityType? entityType,
    String? entityId,
    String? userId,
    String? action,
    int page = 1,
    int limit = 50,
    DateTime? updatedSince,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (workspaceId != null) queryParams['workspace_id'] = workspaceId;
      if (entityType != null) queryParams['entity_type'] = entityType.name;
      if (entityId != null) queryParams['entity_id'] = entityId;
      if (userId != null) queryParams['user_id'] = userId;
      if (action != null) queryParams['action'] = action;
      if (updatedSince != null) {
        queryParams['updated_since'] = updatedSince.toIso8601String();
      }

      final response = await _apiClient.get(
        '/activities',
        queryParameters: queryParams,
      );

      return ActivitiesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single activity by ID
  Future<Activity> getActivity(String id) async {
    try {
      final response = await _apiClient.get('/activities/$id');
      return Activity.fromJson(response.data['activity']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new activity log
  Future<Activity> createActivity(CreateActivityRequest request) async {
    try {
      final response = await _apiClient.post(
        '/activities',
        data: request.toJson(),
      );
      return Activity.fromJson(response.data['activity']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get activity timeline for a task
  Future<List<Activity>> getTaskTimeline(
    String taskId, {
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/activities/task/$taskId',
        queryParameters: {'limit': limit},
      );

      final activities = (response.data['activities'] as List)
          .map((json) => Activity.fromJson(json))
          .toList();

      return activities;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get workspace activity feed
  Future<ActivitiesResponse> getWorkspaceFeed(
    String workspaceId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/activities/workspace/$workspaceId/feed',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return ActivitiesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete an activity (admin only)
  Future<void> deleteActivity(String id) async {
    try {
      await _apiClient.delete('/activities/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle API errors
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      String? message;
      if (data is Map && data['error'] is Map) {
        message = data['error']['message'] as String?;
      }
      return Exception(message ?? 'Failed to process activity request');
    }
    return Exception('Network error: ${error.message}');
  }
}
