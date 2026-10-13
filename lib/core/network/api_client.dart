// app/lib/core/network/api_client.dart
// Dio client: base path /api/v1, bearer token, retry once on AUTH_EXPIRED.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // Long timeout on first call — backend may be waking up on Render
      sendTimeout: const Duration(seconds: 60),
    ));

    _dio.interceptors.add(_AuthInterceptor(_dio));
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
    ));
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  _AuthInterceptor(this.dio);

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
        try {
          await Supabase.instance.client.auth.refreshSession();
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${session.accessToken}';
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          }
        } catch (_) {}
      }
    }
    handler.next(err);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
