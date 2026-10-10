import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/logger.dart';
import '../../../core/errors/app_failure.dart';
import 'supabase_auth_error_mapper.dart';

/// Google Sign-In for Windows
/// Uses browser OAuth flow with loopback redirect
/// 
/// Flow:
/// 1. Opens browser with Google OAuth URL
/// 2. User authenticates with Google
/// 3. Google redirects to http://localhost:[port]/auth/callback
/// 4. Supabase handles the callback and creates session
class GoogleSignInWindows {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with Google on Windows using browser OAuth flow
  /// Returns true if successful, false if cancelled
  /// Throws AppFailure on error
  Future<bool> signInWithBrowser() async {
    if (!Platform.isWindows) {
      throw const AppFailure.forbidden();
    }

    try {
      logger.i('🪟 Starting Windows browser OAuth flow...');

      // Supabase Flutter handles the loopback server automatically on desktop
      // It will:
      // 1. Start a local HTTP server on an available port
      // 2. Open the browser with the OAuth URL
      // 3. Wait for the redirect callback
      // 4. Close the server and create the session
      
      final bool success = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: null, // Let Supabase use its default loopback redirect
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (success) {
        logger.i('✅ Browser opened for Google Sign-In');
        
        // Wait for auth state change (session created)
        // The signInWithOAuth on desktop returns true immediately after opening browser
        // We need to wait for the actual authentication to complete
        await _waitForAuthStateChange();
        
        return true;
      } else {
        logger.w('⚠️ Failed to open browser for Google Sign-In');
        return false;
      }
    } on AuthException catch (e) {
      logger.e('❌ Supabase auth error during Windows OAuth', error: e);
      throw SupabaseAuthErrorMapper.mapAuthException(e);
    } catch (e, stack) {
      if (e is AppFailure) rethrow;
      
      logger.e('❌ Unexpected error during Windows Google Sign-In',
               error: e, stackTrace: stack);
      throw AppFailure.serverError(
        message: 'Google Sign-In failed: ${e.toString()}',
      );
    }
  }

  /// Wait for auth state change (session created) with timeout
  /// Returns when user is authenticated or timeout occurs
  Future<void> _waitForAuthStateChange() async {
    logger.i('⏳ Waiting for authentication callback...');

    try {
      // Wait up to 2 minutes for the user to complete OAuth flow
      await _supabase.auth.onAuthStateChange.firstWhere(
        (data) {
          final event = data.event;
          logger.i('Auth event: $event');
          
          // Success cases
          if (event == AuthChangeEvent.signedIn || 
              event == AuthChangeEvent.tokenRefreshed ||
              event == AuthChangeEvent.initialSession) {
            return true;
          }
          
          return false;
        },
      ).timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          logger.w('⚠️ Authentication timeout - user may have cancelled');
          throw const AppFailure.authCancelled();
        },
      );

      logger.i('✅ Authentication callback received');
    } catch (e) {
      if (e is AppFailure) rethrow;
      
      logger.e('❌ Error waiting for auth callback', error: e);
      throw AppFailure.serverError(
        message: 'Failed to complete authentication',
      );
    }
  }
}
