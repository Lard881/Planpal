import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/config/env.dart';
import '../../../core/errors/app_failure.dart';
import '../models/analytics_data.dart';

class AnalyticsRepository {
  final Dio _dio;
  final String? _accessToken;
  final SharedPreferences? _prefs;

  AnalyticsRepository({
    required Dio dio,
    String? accessToken,
    SharedPreferences? prefs,
  })  : _dio = dio,
        _accessToken = accessToken,
        _prefs = prefs;

  /// Get full analytics for workspace
  Future<AnalyticsData> getAnalytics({
    required String workspaceId,
    String range = '7d',
  }) async {
    if (_accessToken == null) {
      // Try to load from cache when offline
      return _getAnalyticsFromCache(workspaceId, range) ??
          (throw const AppFailure.authRequired());
    }

    try {
      final response = await _dio.get(
        '${Env.apiBaseUrl}/workspaces/$workspaceId/analytics',
        queryParameters: {'range': range},
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
        ),
      );

      final analytics = AnalyticsData.fromJson(response.data);

      // Cache the result
      await _cacheAnalytics(workspaceId, range, analytics);

      return analytics;
    } on DioException catch (e) {
      // Try cache on network error
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        final cached = _getAnalyticsFromCache(workspaceId, range);
        if (cached != null) return cached;
      }

      if (e.response?.statusCode == 401) {
        throw const AppFailure.authExpired();
      }
      if (e.response?.statusCode == 403) {
        throw const AppFailure.forbidden();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AppFailure.timeout();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const AppFailure.noNetwork();
      }
      throw AppFailure.serverError(
        message: e.response?.data?['message'] ?? 'Failed to load analytics',
      );
    } catch (e) {
      throw AppFailure.unknown(message: e.toString());
    }
  }

  /// Cache analytics data
  Future<void> _cacheAnalytics(
    String workspaceId,
    String range,
    AnalyticsData analytics,
  ) async {
    if (_prefs == null) return;

    try {
      final key = 'analytics_${workspaceId}_$range';
      final json = jsonEncode(analytics.toJson());
      await _prefs.setString(key, json);

      // Save timestamp
      final timestampKey = '${key}_timestamp';
      await _prefs.setString(
        timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Get analytics from cache
  AnalyticsData? _getAnalyticsFromCache(String workspaceId, String range) {
    if (_prefs == null) return null;

    try {
      final key = 'analytics_${workspaceId}_$range';
      final json = _prefs.getString(key);
      if (json == null) return null;

      return AnalyticsData.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  /// Get last updated timestamp for cached analytics
  DateTime? getLastUpdated(String workspaceId, String range) {
    if (_prefs == null) return null;

    try {
      final key = 'analytics_${workspaceId}_${range}_timestamp';
      final timestamp = _prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Get overview data for home dashboard
  Future<OverviewData> getOverview({
    required String workspaceId,
    String range = 'week',
  }) async {
    if (_accessToken == null) {
      throw const AppFailure.authRequired();
    }

    try {
      final response = await _dio.get(
        '${Env.apiBaseUrl}/workspaces/$workspaceId/overview',
        queryParameters: {'range': range},
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
        ),
      );

      return OverviewData.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AppFailure.authExpired();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AppFailure.timeout();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const AppFailure.noNetwork();
      }
      throw AppFailure.serverError(
        message: e.response?.data?['message'] ?? 'Failed to load overview',
      );
    } catch (e) {
      throw AppFailure.unknown(message: e.toString());
    }
  }

  /// Export analytics as CSV
  Future<String> exportCsv({
    required String workspaceId,
    String range = '7d',
  }) async {
    if (_accessToken == null) {
      throw const AppFailure.authRequired();
    }

    try {
      final response = await _dio.get(
        '${Env.apiBaseUrl}/workspaces/$workspaceId/analytics/export.csv',
        queryParameters: {'range': range},
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
          responseType: ResponseType.plain,
        ),
      );

      return response.data as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AppFailure.authExpired();
      }
      if (e.response?.statusCode == 403) {
        throw const AppFailure.forbidden();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AppFailure.timeout();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const AppFailure.noNetwork();
      }
      throw AppFailure.serverError(
        message: e.response?.data?['message'] ?? 'Failed to export CSV',
      );
    } catch (e) {
      throw AppFailure.unknown(message: e.toString());
    }
  }
}
