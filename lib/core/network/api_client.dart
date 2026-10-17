// Dio client: base path /api/v1, bearer token, retry once on AUTH_EXPIRED.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
    required VoidCallback onSessionExpired,
    Future<String?> Function()? accessTokenProvider,
    Future<String?> Function()? refreshAccessToken,
    Future<void> Function()? signOut,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // Long timeout on first call — backend may be waking up on Render
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    _dio.interceptors.add(
      _AuthInterceptor(
        _dio,
        onSessionExpired,
        accessTokenProvider ??
            (() async =>
                Supabase.instance.client.auth.currentSession?.accessToken),
        refreshAccessToken ??
            (() async {
              final auth = Supabase.instance.client.auth;
              final response = await auth.refreshSession();
              return response.session?.accessToken ??
                  auth.currentSession?.accessToken;
            }),
        signOut ?? (() => Supabase.instance.client.auth.signOut()),
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false, error: true),
    );
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  final VoidCallback onSessionExpired;
  final Future<String?> Function() accessTokenProvider;
  final Future<String?> Function() refreshAccessToken;
  final Future<void> Function() signOut;

  _AuthInterceptor(
    this.dio,
    this.onSessionExpired,
    this.accessTokenProvider,
    this.refreshAccessToken,
    this.signOut,
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.extra['authRetry'] == true &&
          options.headers['Authorization'] != null) {
        handler.next(options);
        return;
      }
      final token = await accessTokenProvider();
      if (token == null || token.isEmpty) {
        options.headers.remove('Authorization');
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'session access token',
        ),
      );
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final data = err.response?.data;
      final rawError = data is Map ? data['error'] : null;
      final Map? errorMap = rawError is Map ? rawError : null;
      if (errorMap?['code'] == 'AUTH_EXPIRED') {
        final requestOptions = err.requestOptions;
        if (requestOptions.extra['authRetry'] == true) {
          await _signOutAfterRefreshFailure();
          return handler.next(err);
        }

        String? refreshedToken;
        try {
          refreshedToken = await refreshAccessToken();
        } catch (error, stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'session refresh',
            ),
          );
        }
        if (refreshedToken == null || refreshedToken.isEmpty) {
          await _signOutAfterRefreshFailure();
          return handler.next(err);
        }

        requestOptions.extra['authRetry'] = true;
        requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
        try {
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      }
    }
    handler.next(err);
  }

  Future<void> _signOutAfterRefreshFailure() async {
    onSessionExpired();
    try {
      await signOut();
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
