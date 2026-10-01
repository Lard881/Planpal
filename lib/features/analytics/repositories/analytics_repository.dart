import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/analytics_event.dart';
import '../models/analytics_dashboard.dart';
import '../models/analytics_insights.dart';

/// Repository for analytics operations
class AnalyticsRepository {
  final ApiClient _apiClient;

  AnalyticsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Log a single analytics event
  Future<AnalyticsEvent> logEvent({
    required AnalyticsEventType eventType,
    String? workspaceId,
    Map<String, dynamic>? eventData,
  }) async {
    try {
      final response = await _apiClient.post(
        '/analytics/events',
        data: {
          'event_type': eventType.value,
          if (workspaceId != null) 'workspace_id': workspaceId,
          if (eventData != null) 'event_data': eventData,
        },
      );

      return AnalyticsEvent.fromJson(response.data['event']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AnalyticsException(
          e.response?.data['error'] ?? 'Invalid event data',
        );
      }
      throw AnalyticsException('Failed to log event: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to log event: $e');
    }
  }

  /// Log multiple events in batch (max 100)
  Future<List<AnalyticsEvent>> logEventsBatch({
    required List<AnalyticsEventBatch> events,
  }) async {
    if (events.isEmpty) {
      throw AnalyticsException('Events list cannot be empty');
    }

    if (events.length > 100) {
      throw AnalyticsException('Maximum 100 events per batch');
    }

    try {
      final response = await _apiClient.post(
        '/analytics/events/batch',
        data: {
          'events': events.map((e) => {
            'event_type': e.eventType.value,
            if (e.workspaceId != null) 'workspace_id': e.workspaceId,
            'event_data': e.eventData,
            if (e.createdAt != null) 'created_at': e.createdAt!.toIso8601String(),
          }).toList(),
        },
      );

      final eventsList = response.data['events'] as List;
      return eventsList.map((e) => AnalyticsEvent.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AnalyticsException(
          e.response?.data['error'] ?? 'Invalid events data',
        );
      }
      throw AnalyticsException('Failed to log events batch: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to log events batch: $e');
    }
  }

  /// Get analytics dashboard
  Future<AnalyticsDashboard> getDashboard({
    String? workspaceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (workspaceId != null) {
        queryParams['workspace_id'] = workspaceId;
      }
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        '/analytics/dashboard',
        queryParameters: queryParams,
      );

      return AnalyticsDashboard.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AnalyticsException(
          e.response?.data['error'] ?? 'Invalid dashboard parameters',
        );
      }
      throw AnalyticsException('Failed to fetch dashboard: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to fetch dashboard: $e');
    }
  }

  /// Get analytics insights
  Future<AnalyticsInsights> getInsights({
    String? workspaceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (workspaceId != null) {
        queryParams['workspace_id'] = workspaceId;
      }
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        '/analytics/insights',
        queryParameters: queryParams,
      );

      return AnalyticsInsights.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AnalyticsException(
          e.response?.data['error'] ?? 'Invalid insights parameters',
        );
      }
      throw AnalyticsException('Failed to fetch insights: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to fetch insights: $e');
    }
  }

  /// Get workspace analytics (admin only)
  Future<WorkspaceAnalytics> getWorkspaceAnalytics({
    required String workspaceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        '/analytics/workspace/$workspaceId',
        queryParameters: queryParams,
      );

      return WorkspaceAnalytics.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw AnalyticsException('Access denied. Workspace admin required.');
      }
      if (e.response?.statusCode == 400) {
        throw AnalyticsException(
          e.response?.data['error'] ?? 'Invalid workspace analytics parameters',
        );
      }
      throw AnalyticsException('Failed to fetch workspace analytics: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to fetch workspace analytics: $e');
    }
  }

  /// Get workspace team activity (admin only)
  Future<List<TeamActivity>> getWorkspaceTeamActivity({
    required String workspaceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        '/analytics/workspace/$workspaceId/team',
        queryParameters: queryParams,
      );

      final teamActivity = response.data['team_activity'] as List;
      return teamActivity.map((t) => TeamActivity.fromJson(t)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw AnalyticsException('Access denied. Workspace admin required.');
      }
      throw AnalyticsException('Failed to fetch team activity: ${e.message}');
    } catch (e) {
      throw AnalyticsException('Failed to fetch team activity: $e');
    }
  }
}

/// Analytics exception
class AnalyticsException implements Exception {
  final String message;

  AnalyticsException(this.message);

  @override
  String toString() => message;
}
