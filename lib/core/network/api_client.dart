// app/lib/core/network/api_client.dart
// Dio client: base path /api/v1, bearer token, retry once on AUTH_EXPIRED.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({required VoidCallback onSessionExpired}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // Long timeout on first call — backend may be waking up on Render
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    _dio.interceptors.add(_AuthInterceptor(_dio, onSessionExpired));
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false, error: true),
    );
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  final VoidCallback onSessionExpired;
  _AuthInterceptor(this.dio, this.onSessionExpired);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Retry once on 401 AUTH_EXPIRED — refresh the session first
    if (err.response?.statusCode == 401) {
      final data = err.response?.data;
      final Map? errorMap = (data is Map) ? data['error'] as Map? : null;
      final code = errorMap?['code'];
      if (code == 'AUTH_EXPIRED') {
        final requestOptions = err.requestOptions;
        if (requestOptions.extra['authRetry'] == true) {
          await _signOutAfterRefreshFailure();
          return handler.next(err);
        }
        try {
          await Supabase.instance.client.auth.refreshSession();
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            requestOptions.extra['authRetry'] = true;
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${session.accessToken}';
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          }
        } catch (error, stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'session refresh',
            ),
          );
        }
        await _signOutAfterRefreshFailure();
      }
    }
    handler.next(err);
  }

  Future<void> _signOutAfterRefreshFailure() async {
    onSessionExpired();
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'session-expired sign out',
        ),
      );
    }
  }
}

final sessionExpiredProvider = StateProvider<bool>((ref) => false);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    onSessionExpired: () =>
        ref.read(sessionExpiredProvider.notifier).state = true,
  ),
);
