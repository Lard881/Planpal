import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/logger.dart';
import '../../../core/errors/app_failure.dart';

/// Session expiry handler
/// Handles session refresh and expiry logic
/// 
/// Flow:
/// 1. Check if session is expired or about to expire
/// 2. Attempt refresh once
/// 3. If refresh fails, throw authExpired error
class SessionExpiryHandler {
  final SupabaseClient _supabase;
  bool _isRefreshing = false;
  DateTime? _lastRefreshAttempt;

  SessionExpiryHandler({required SupabaseClient supabase})
      : _supabase = supabase;

  /// Check if session needs refresh
  /// Returns true if session is expired or will expire in the next 5 minutes
  bool needsRefresh() {
    final session = _supabase.auth.currentSession;
    if (session == null) return false;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      session.expiresAt! * 1000,
    );
    final now = DateTime.now();
    final bufferTime = const Duration(minutes: 5);

    return expiresAt.isBefore(now.add(bufferTime));
  }

  /// Refresh session if needed
  /// Returns true if session is valid (either still valid or successfully refreshed)
  /// Returns false if session is invalid and refresh failed
  Future<bool> ensureValidSession() async {
    // Check if we have a session
    if (_supabase.auth.currentSession == null) {
      logger.w('⚠️ No session available');
      return false;
    }

    // Check if session needs refresh
    if (!needsRefresh()) {
      logger.i('✅ Session still valid');
      return true;
    }

    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      logger.i('⏳ Refresh already in progress');
      // Wait a bit for the ongoing refresh
      await Future.delayed(const Duration(milliseconds: 500));
      return _supabase.auth.currentSession != null;
    }

    // Check if we recently attempted refresh (within last 10 seconds)
    if (_lastRefreshAttempt != null &&
        DateTime.now().difference(_lastRefreshAttempt!) <
            const Duration(seconds: 10)) {
      logger.w('⚠️ Recently attempted refresh, skipping');
      return _supabase.auth.currentSession != null;
    }

    try {
      _isRefreshing = true;
      _lastRefreshAttempt = DateTime.now();
      
      logger.i('🔄 Session expired or expiring soon, refreshing...');

      final response = await _supabase.auth.refreshSession();

      if (response.session != null) {
        logger.i('✅ Session refreshed successfully');
        return true;
      } else {
        logger.e('❌ Session refresh returned null');
        return false;
      }
    } on AuthException catch (e) {
      logger.e('❌ Session refresh failed', error: e);
      return false;
    } catch (e, stack) {
      logger.e('❌ Unexpected error during session refresh',
               error: e, stackTrace: stack);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Handle 401 response by attempting refresh and indicating if retry should happen
  /// Returns true if refresh succeeded (caller should retry)
  /// Returns false if refresh failed (caller should sign out)
  Future<bool> handle401Response() async {
    logger.i('🔐 Handling 401 response, attempting refresh...');

    final refreshed = await ensureValidSession();

    if (refreshed) {
      logger.i('✅ Session refreshed, request can be retried');
      return true;
    } else {
      logger.e('❌ Session refresh failed after 401');
      return false;
    }
  }

  /// Reset refresh tracking (for testing)
  void reset() {
    _isRefreshing = false;
    _lastRefreshAttempt = null;
  }
}
