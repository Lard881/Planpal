// app/lib/features/analytics/data/analytics_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/analytics_models.dart';

class AnalyticsRepository {
  final Dio _dio;
  AnalyticsRepository(this._dio);

  Future<(AnalyticsData?, AppFailure?)> getAnalytics(
      String workspaceId, String range) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/analytics',
        queryParameters: {'range': range},
      );
      return (AnalyticsData.fromJson(res.data as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(String?, AppFailure?)> getExportUrl(
      String workspaceId, String range) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/analytics/export.csv',
        queryParameters: {'range': range},
        options: Options(responseType: ResponseType.bytes),
      );
      // Return the URL for download
      return (res.realUri.toString(), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(apiClientProvider).dio);
});
