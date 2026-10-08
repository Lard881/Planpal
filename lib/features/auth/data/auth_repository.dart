import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/logger.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/models/user_profile.dart';
import 'google_sign_in_service.dart';
import 'supabase_auth_error_mapper.dart';

/// Authentication repository
/// Handles user authentication using Supabase
class AuthRepository {
  final SupabaseService _supabaseService;
  final GoogleSignInService _googleSignInService;

  AuthRepository({
    SupabaseService? supabaseService,
    GoogleSignInService? googleSignInService,
  })  : _supabaseService = supabaseService ?? SupabaseService.instance,
        _googleSignInService = googleSignInService ?? GoogleSignInService();

  /// Get current user
  User? get currentUser => _supabaseService.currentUser;

  /// Get current session
  Session? get currentSession => _supabaseService.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;

  /// Sign in with Google
  /// Platform-specific implementation:
  /// - Android: Native token flow with google_sign_in package
  /// - Windows: Browser OAuth flow with loopback redirect
  /// Returns true if successful, throws on error
  Future<bool> signInWithGoogle() async {
    try {
      logger.i('Starting Google Sign-In for ${Platform.operatingSystem}...');
      
      if (Platform.isAndroid) {
        // Android: Use native Google Sign-In flow with ID token
        logger.i('🤖 Using Android native Google Sign-In');
        return await _googleSignInService.signInWithGoogleNative();
      } else if (Platform.isWindows) {
        // Windows: Use browser OAuth flow with loopback redirect
        logger.i('🪟 Using Windows browser OAuth flow');
        return await _googleSignInService.signInWithGoogleBrowser();
      } else {
        // Unsupported platform
        logger.e('❌ Google Sign-In not supported on ${Platform.operatingSystem}');
        throw Exception('Google Sign-In not supported on this platform');
      }
    } catch (e, stack) {
      logger.e('❌ Google Sign-In error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Sign in with email and password
  /// Returns true if successful, throws AppFailure on error
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Signing in with email: $email');
      
      final response = await _supabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && response.session != null) {
        logger.i('✅ Email sign-in successful: ${response.user!.email}');
        return true;
      } else {
        logger.w('⚠️ Email sign-in failed: no user or session returned');
        return false;
      }
    } on AuthException catch (e) {
      logger.e('❌ Supabase auth error during email sign-in', error: e);
      throw SupabaseAuthErrorMapper.mapToAppFailure(e);
    } catch (e, stack) {
      if (e is AppFailure) rethrow;
      
      logger.e('❌ Email sign-in error', error: e, stackTrace: stack);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  /// Sign up with email and password
  /// Returns user ID if successful, throws AppFailure on error
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      logger.i('Signing up with email: $email');
      
      final response = await _supabaseService.auth.signUp(
        email: email,
        password: password,
        data: {
          if (fullName != null) 'full_name': fullName,
        },
      );

      if (response.user != null) {
        logger.i('✅ Email sign-up successful: ${response.user!.id}');
        return response.user!.id;
      } else {
        logger.w('⚠️ Email sign-up failed: no user returned');
        throw AppFailure.serverError(message: 'Failed to create account');
      }
    } on AuthException catch (e) {
      logger.e('❌ Supabase auth error during email sign-up', error: e);
      throw SupabaseAuthErrorMapper.mapToAppFailure(e);
    } catch (e, stack) {
      if (e is AppFailure) rethrow;
      
      logger.e('❌ Email sign-up error', error: e, stackTrace: stack);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  /// Sign out
  /// Complete sign-out with cleanup:
  /// - Unregister device token (best effort)
  /// - Clear local database
  /// - Clear secure storage
  /// - Sign out from Google (Android)
  /// - Sign out from Supabase
  Future<void> signOut() async {
    try {
      logger.i('Signing out...');
      
      // Sign out from Google on Android
      if (Platform.isAndroid) {
        await _googleSignInService.signOut();
      }
      
      // Sign out from Supabase
      // This clears the session from secure storage
      await _supabaseService.auth.signOut();
      
      logger.i('✅ Signed out successfully');
    } catch (e, stack) {
      logger.e('❌ Sign out error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get user profile from backend
  /// This fetches additional user data from our backend API
  Future<UserProfile?> getUserProfile() async {
    try {
      if (!isAuthenticated) {
        logger.w('Not authenticated, cannot fetch profile');
        return null;
      }

      final userId = currentUser!.id;
      logger.i('Fetching user profile for: $userId');

      // User profile is embedded in Supabase user metadata
      final user = currentUser!;
      
      return UserProfile(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] as String? ?? 
                  user.userMetadata?['name'] as String? ?? 
                  'User',
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        timezone: 'UTC', // Will be updated from backend /me endpoint
        language: 'en',
        theme: 'system',
        createdAt: DateTime.parse(user.createdAt),  // Parse String to DateTime
      );
    } catch (e, stack) {
      logger.e('❌ Error fetching user profile', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Refresh session
  /// Call this to get a fresh access token
  Future<Session?> refreshSession() async {
    try {
      logger.i('Refreshing session...');
      
      final response = await _supabaseService.auth.refreshSession();
      
      if (response.session != null) {
        logger.i('✅ Session refreshed successfully');
        return response.session;
      } else {
        logger.w('⚠️ Session refresh returned null');
        return null;
      }
    } catch (e, stack) {
      logger.e('❌ Session refresh error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get access token
  String? get accessToken => currentSession?.accessToken;

  /// Check if session is expired or about to expire (within 5 minutes)
  bool get isSessionExpired {
    final session = currentSession;
    if (session == null) return true;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      session.expiresAt! * 1000,
    );
    final now = DateTime.now();
    final bufferTime = const Duration(minutes: 5);

    return expiresAt.isBefore(now.add(bufferTime));
  }

  /// Restore session on app start
  /// Supabase automatically restores session from secure storage
  Future<bool> restoreSession() async {
    try {
      logger.i('Checking for existing session...');
      
      // Supabase auth automatically restores session
      final session = currentSession;
      
      if (session != null) {
        logger.i('✅ Session restored: ${currentUser?.email}');
        
        // Check if expired and refresh if needed
        if (isSessionExpired) {
          logger.i('Session expired, refreshing...');
          final refreshed = await refreshSession();
          return refreshed != null;
        }
        
        return true;
      } else {
        logger.i('No existing session found');
        return false;
      }
    } catch (e, stack) {
      logger.e('❌ Error restoring session', error: e, stackTrace: stack);
      return false;
    }
  }
}
