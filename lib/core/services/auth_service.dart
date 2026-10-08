import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';
import 'supabase_service.dart';
import '../errors/app_failure.dart';

/// Authentication service handling all auth operations
class AuthService {
  final SupabaseService _supabase;

  AuthService({SupabaseService? supabase})
      : _supabase = supabase ?? SupabaseService.instance;

  // ========================================================================
  // Email & Password Authentication
  // ========================================================================

  /// Sign up with email and password
  /// Returns user ID if successful
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      logger.i('Signing up user: $email');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'name': name,
        },
        emailRedirectTo: null, // We'll handle verification manually
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw const AppFailure.timeout(),
      );

      if (response.user == null) {
        throw const AppFailure.serverError(message: 'Failed to create account');
      }

      logger.i('User signed up successfully: ${response.user!.id}');
      return response.user!.id;
    } on AuthException catch (e) {
      logger.e('Sign up failed', error: e);
      throw _mapAuthException(e);
    } catch (e) {
      logger.e('Unexpected sign up error', error: e);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  /// Sign in with email and password
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Signing in user: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw const AppFailure.timeout(),
      );

      if (response.user == null) {
        throw const AppFailure.invalidCredentials();
      }

      // Check if email is confirmed
      if (response.user!.emailConfirmedAt == null) {
        throw const AppFailure.emailNotConfirmed();
      }

      logger.i('User signed in successfully: ${response.user!.id}');
      return response.user!;
    } on AuthException catch (e) {
      logger.e('Sign in failed', error: e);
      throw _mapAuthException(e);
    } catch (e) {
      if (e is AppFailure) rethrow;
      logger.e('Unexpected sign in error', error: e);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      logger.i('Signing out user');
      await _supabase.auth.signOut();
      logger.i('User signed out successfully');
    } on AuthException catch (e) {
      logger.e('Sign out failed', error: e);
      throw _mapAuthException(e);
    }
  }

  // ========================================================================
  // Email Verification
  // ========================================================================

  /// Verify email with OTP code
  Future<User> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    try {
      logger.i('Verifying email OTP for: $email');

      final response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: token,
      );

      if (response.user == null) {
        throw const AppFailure.invalidCode();
      }

      logger.i('Email verified successfully: ${response.user!.id}');
      return response.user!;
    } on AuthException catch (e) {
      logger.e('Email verification failed', error: e);
      throw _mapAuthException(e);
    } catch (e) {
      if (e is AppFailure) rethrow;
      logger.e('Unexpected verification error', error: e);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  /// Resend email verification code
  Future<void> resendEmailVerification(String email) async {
    try {
      logger.i('Resending verification code to: $email');

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      logger.i('Verification code resent successfully');
    } on AuthException catch (e) {
      logger.e('Resend verification failed', error: e);
      throw _mapAuthException(e);
    }
  }

  // ========================================================================
  // Password Reset
  // ========================================================================

  /// Request password reset code
  Future<void> requestPasswordReset(String email) async {
    try {
      logger.i('Requesting password reset for: $email');

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // We'll handle with OTP
      );

      logger.i('Password reset code sent');
    } on AuthException catch (e) {
      logger.e('Password reset request failed', error: e);
      throw _mapAuthException(e);
    }
  }

  /// Verify password reset OTP
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String token,
  }) async {
    try {
      logger.i('Verifying password reset OTP');

      final response = await _supabase.auth.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: token,
      );

      if (response.session == null) {
        throw const AppFailure.invalidCode();
      }

      logger.i('Password reset OTP verified');
    } on AuthException catch (e) {
      logger.e('Password reset verification failed', error: e);
      throw _mapAuthException(e);
    }
  }

  /// Update password (after OTP verification)
  Future<void> updatePassword(String newPassword) async {
    try {
      logger.i('Updating password');

      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      logger.i('Password updated successfully');
    } on AuthException catch (e) {
      logger.e('Password update failed', error: e);
      throw _mapAuthException(e);
    }
  }

  // ========================================================================
  // OAuth (Google)
  // ========================================================================

  /// Sign in with Google (Native on Android, Web flow on others)
  Future<User> signInWithGoogle() async {
    try {
      logger.i('Signing in with Google');

      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.planpal.app://callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!response) {
        throw const AppFailure.authCancelled();
      }

      // Wait for auth state change
      final user = await _supabase.authStateChanges
          .firstWhere((state) => state.session != null)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const AppFailure.timeout(),
          )
          .then((state) => state.session!.user);

      logger.i('Google sign in successful: ${user.id}');
      return user;
    } on AuthException catch (e) {
      logger.e('Google sign in failed', error: e);
      throw _mapAuthException(e);
    } catch (e) {
      if (e is AppFailure) rethrow;
      logger.e('Unexpected Google sign in error', error: e);
      throw AppFailure.serverError(message: e.toString());
    }
  }

  // ========================================================================
  // Session Management
  // ========================================================================

  /// Check and refresh current session
  Future<Session?> refreshSession() async {
    try {
      final session = _supabase.currentSession;
      if (session == null) return null;

      // Check if token is expired or about to expire
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        session.expiresAt! * 1000,
      );
      final now = DateTime.now();

      if (expiresAt.isBefore(now.add(const Duration(minutes: 5)))) {
        logger.i('Refreshing session token');
        final response = await _supabase.auth.refreshSession();
        return response.session;
      }

      return session;
    } on AuthException catch (e) {
      logger.e('Session refresh failed', error: e);
      throw _mapAuthException(e);
    }
  }

  /// Get current user
  User? getCurrentUser() => _supabase.currentUser;

  /// Get current session
  Session? getCurrentSession() => _supabase.currentSession;

  /// Check if user is authenticated
  bool isAuthenticated() => _supabase.isAuthenticated;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.authStateChanges;

  // ========================================================================
  // Error Mapping
  // ========================================================================

  AppFailure _mapAuthException(AuthException e) {
    logger.d('Mapping auth exception: ${e.message} (${e.statusCode})');

    // Check message patterns
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return const AppFailure.invalidCredentials();
    }

    if (message.contains('email not confirmed')) {
      return const AppFailure.emailNotConfirmed();
    }

    if (message.contains('user already registered') ||
        message.contains('already been registered')) {
      return const AppFailure.emailAlreadyInUse();
    }

    if (message.contains('invalid token') ||
        message.contains('token has expired') ||
        message.contains('invalid otp')) {
      return const AppFailure.invalidCode();
    }

    if (message.contains('expired')) {
      return const AppFailure.codeExpired();
    }

    if (message.contains('weak password') ||
        message.contains('password is too weak')) {
      return const AppFailure.weakPassword();
    }

    if (message.contains('rate limit')) {
      return const AppFailure.rateLimited();
    }

    if (message.contains('network') || message.contains('connection')) {
      return const AppFailure.networkError();
    }

    // Check status codes
    switch (e.statusCode) {
      case '400':
        return AppFailure.validationError(message: e.message);
      case '401':
        return const AppFailure.authRequired();
      case '403':
        return const AppFailure.forbidden();
      case '404':
        return const AppFailure.notFound();
      case '422':
        return AppFailure.validationError(message: e.message);
      case '429':
        return const AppFailure.rateLimited();
      case '500':
      case '502':
      case '503':
        return const AppFailure.serverError();
      default:
        return AppFailure.serverError(message: e.message);
    }
  }
}
