import 'package:dio/dio.dart';
import '../models/dashboard_overview.dart';
import '../../../core/config/env.dart';

/// Repository for home dashboard data
class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  /// Get dashboard overview from analytics/overview endpoint
  /// Uses lighter version suitable for home screen
  Future<DashboardOverview> getOverview(
    String workspaceId, {
    String range = 'week', // 'week', '7d', or '30d'
  }) async {
    try {
      final response = await _dio.get(
        '${Env.apiBaseUrl}/workspaces/$workspaceId/overview',
        queryParameters: {'range': range},
      );

      if (response.statusCode == 200) {
        return DashboardOverview.fromJson(response.data);
      } else {
        throw Exception('Failed to load dashboard overview');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Guest users - return empty data
        return const DashboardOverview(
          counts: DashboardCounts(
            completed: 0,
            inProgress: 0,
            overdue: 0,
          ),
          productivityPercent: 0,
          dailySeries: [],
        );
      }
      rethrow;
    }
  }
}
