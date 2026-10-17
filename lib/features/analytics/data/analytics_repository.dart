// app/lib/features/analytics/data/analytics_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/analytics_models.dart';

class AnalyticsRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  AnalyticsRepository(this._dio, this._storage);

  Future<(AnalyticsData?, DateTime?, AppFailure?)> getAnalytics(
      String workspaceId, String range) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/analytics',
        queryParameters: {'range': range},
      );
      final data = AnalyticsData.fromJson(res.data as Map<String, dynamic>);
      final updatedAt = DateTime.now();
      await _storage.write(
        key: _cacheKey(workspaceId, range),
        value: jsonEncode({
          'data': data.toJson(),
          'updatedAt': updatedAt.toIso8601String(),
        }),
      );
      return (data, updatedAt, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NetworkFailure ||
          failure is TimeoutFailure ||
          failure is ServerUnreachableFailure) {
        final saved = await _storage.read(key: _cacheKey(workspaceId, range));
        if (saved != null) {
          final cached = jsonDecode(saved) as Map<String, dynamic>;
          return (
            AnalyticsData.fromJson(cached['data'] as Map<String, dynamic>),
            DateTime.parse(cached['updatedAt'] as String),
            null,
          );
        }
      }
      return (null, null, failure);
    }
  }

  Future<(List<int>?, AppFailure?)> getCsv(
      String workspaceId, String range) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/analytics/export.csv',
        queryParameters: {'range': range},
        options: Options(responseType: ResponseType.bytes),
      );
      return ((res.data as List<int>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  String _cacheKey(String workspaceId, String range) =>
      'analytics:$workspaceId:$range';
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(
    ref.watch(apiClientProvider).dio,
    const FlutterSecureStorage(),
  );
});
