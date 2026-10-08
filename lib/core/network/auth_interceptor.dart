import 'dart:async';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';
import '../errors/app_failure.dart';

/// Auth interceptor for Dio
/// Handles:
/// 1. Adding access token to requests
/// 2. Token refresh on 401 AUTH_EXPIRED
/// 3. Retry once after refresh
/// 4. Sign out if refresh fails
class AuthInterceptor extends Interceptor {
  final SupabaseClient _supabase;
  final Function() onSessionExpired;
  
  // Track if we're currently refreshing to avoid multiple refresh calls
  bool _isRefreshing = false;
  
  // Queue for pending requests while refreshing
  final List<_RetryRequest> _pendingRequests = [];

  AuthInterceptor({
    required SupabaseClient supabase,
    required this.onSessionExpired,
  }) : _supabase = supabase;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add current access token to request
    final session = _supabase.auth.currentSession;
    if (session != null && session.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if it's a 401 Unauthorized error
    if (err.response?.statusCode == 401) {
      final errorCode = err.response?.data?['error']?['code'];
      
      // Check if it's specifically AUTH_EXPIRED or AUTH_REQUIRED
      final isAuthExpired = errorCode == 'AUTH_EXPIRED' || 
                           errorCode == 'AUTH_REQUIRED' ||
                           err.response?.statusCode == 401;
      
      if (isAuthExpired) {
        logger.i('🔄 Received 401, attempting token refresh...');
        
        // Try to refresh and retry
        final retryResponse = await _refreshAndRetry(err.requestOptions);
        
        if (retryResponse != null) {
          // Success! Return the retry response
          return handler.resolve(retryResponse);
        } else {
          // Refresh failed, session expired
          logger.e('❌ Session refresh failed, signing out');
          
          // Call session expired callback (will navigate to login)
          onSessionExpired();
          
          // Return auth expired error
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              type: DioExceptionType.badResponse,
              error: AppFailure.authExpired(),
            ),
          );
        }
      }
    }
    
    // Not a 401 or refresh not applicable, pass through
    return handler.next(err);
  }

  /// Refresh token and retry the request
  /// Returns the retry response if successful, null if refresh failed
  Future<Response?> _refreshAndRetry(RequestOptions requestOptions) async {
    // If already refreshing, queue this request
    if (_isRefreshing) {
      logger.i('⏳ Refresh in progress, queueing request');
      final completer = _RetryRequest(requestOptions);
      _pendingRequests.add(completer);
      return await completer.completer.future;
    }
    
    try {
      _isRefreshing = true;
      logger.i('🔐 Refreshing session...');
      
      // Attempt to refresh the session
      final response = await _supabase.auth.refreshSession();
      
      if (response.session == null) {
        logger.e('❌ Session refresh returned null');
        _rejectAllPending();
        return null;
      }
      
      logger.i('✅ Session refreshed successfully');
      
      // Retry the original request with new token
      final newToken = response.session!.accessToken;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      
      final dio = Dio();
      final retryResponse = await dio.fetch(requestOptions);
      
      // Resolve all pending requests with success
      _resolveAllPending();
      
      return retryResponse;
    } on AuthException catch (e) {
      logger.e('❌ Session refresh failed: ${e.message}');
      _rejectAllPending();
      return null;
    } catch (e, stack) {
      logger.e('❌ Unexpected error during refresh', error: e, stackTrace: stack);
      _rejectAllPending();
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Resolve all pending requests (refresh succeeded)
  void _resolveAllPending() {
    logger.i('✅ Resolving ${_pendingRequests.length} pending requests');
    
    for (final request in _pendingRequests) {
      // Each pending request should retry with the new token
      final newToken = _supabase.auth.currentSession?.accessToken;
      if (newToken != null) {
        request.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        
        // Retry the request
        final dio = Dio();
        dio.fetch(request.requestOptions).then((response) {
          request.completer.complete(response);
        }).catchError((error) {
          request.completer.completeError(error);
        });
      } else {
        request.completer.completeError(
          DioException(
            requestOptions: request.requestOptions,
            error: AppFailure.authExpired(),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }
    
    _pendingRequests.clear();
  }

  /// Reject all pending requests (refresh failed)
  void _rejectAllPending() {
    logger.w('⚠️ Rejecting ${_pendingRequests.length} pending requests');
    
    for (final request in _pendingRequests) {
      request.completer.completeError(
        DioException(
          requestOptions: request.requestOptions,
          error: AppFailure.authExpired(),
          type: DioExceptionType.badResponse,
        ),
      );
    }
    
    _pendingRequests.clear();
  }
}

/// Helper class to track pending requests during refresh
class _RetryRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer = Completer<Response>();

  _RetryRequest(this.requestOptions);
}
