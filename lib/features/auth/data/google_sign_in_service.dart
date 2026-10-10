import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/logger.dart';
import '../../../core/errors/app_failure.dart';
import 'supabase_auth_error_mapper.dart';
import 'google_sign_in_windows.dart';

/// Google Sign-In service
/// Handles platform-specific Google authentication flows
/// - Android: Native token flow with google_sign_in package
/// - Windows: Browser OAuth flow (handled in google_sign_in_windows.dart)
class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  GoogleSignIn? _googleSignIn;
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignInWindows _windowsSignIn = GoogleSignInWindows();

  /// Initialize Google Sign-In for Android
  /// Must be called before using signInWithGoogle on Android
  void initializeForAndroid({
    String? serverClientId,
    List<String> scopes = const ['email', 'profile'],
  }) {
    if (!Platform.isAndroid) {
      logger.w('⚠️ initializeForAndroid called on non-Android platform');
      return;
    }

    _googleSignIn = GoogleSignIn(
      scopes: scopes,
      serverClientId: serverClientId, // Optional: for getting ID token
    );

    logger.i('✅ Google Sign-In initialized for Android');
  }

  /// Sign in with Google (Android native flow)
  /// Returns true if successful, throws AppFailure on error
  /// 
  /// Flow:
  /// 1. Sign in with Google using native picker
  /// 2. Get ID token and access token
  /// 3. Exchange tokens with Supabase
  Future<bool> signInWithGoogleNative() async {
    if (!Platform.isAndroid) {
      throw const AppFailure.forbidden();
    }

    if (_googleSignIn == null) {
      throw const AppFailure.internalError();
    }

    try {
      logger.i('🔵 Starting native Google Sign-In flow...');

      // Sign out any existing Google session first (clean state)
      await _googleSignIn!.signOut();

      // Step 1: Trigger Google Sign-In picker
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        logger.w('⚠️ Google Sign-In cancelled by user');
        return false;
      }

      logger.i('✅ Google Sign-In successful: ${googleUser.email}');

      // Step 2: Get authentication tokens
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        logger.e('❌ Failed to get ID token from Google');
        throw const AppFailure.internalError();
      }

      logger.i('✅ Got Google tokens, exchanging with Supabase...');

      // Step 3: Exchange Google tokens with Supabase
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null && response.session != null) {
        logger.i('✅ Supabase authentication successful: ${response.user!.email}');
        return true;
      } else {
        logger.e('❌ Supabase authentication failed: no user or session');
        throw const AppFailure.invalidCredentials();
      }
    } on AuthException catch (e) {
      logger.e('❌ Supabase auth error during Google Sign-In', error: e);
      throw SupabaseAuthErrorMapper.mapAuthException(e);
    } catch (e, stack) {
      if (e is AppFailure) rethrow;
      
      logger.e('❌ Unexpected error during Google Sign-In', 
               error: e, stackTrace: stack);
      throw AppFailure.serverError(
        message: 'Google Sign-In failed: ${e.toString()}',
      );
    }
  }

  /// Sign in with Google (Windows browser flow)
  /// Returns true if successful, throws AppFailure on error
  /// 
  /// Flow:
  /// 1. Opens browser with Google OAuth URL
  /// 2. User authenticates with Google
  /// 3. Google redirects to local loopback server
  /// 4. Supabase handles callback and creates session
  Future<bool> signInWithGoogleBrowser() async {
    if (!Platform.isWindows) {
      throw const AppFailure.forbidden();
    }

    return await _windowsSignIn.signInWithBrowser();
  }

  /// Sign out from Google
  /// Clears Google account session on Android
  Future<void> signOut() async {
    if (!Platform.isAndroid || _googleSignIn == null) {
      return;
    }

    try {
      await _googleSignIn!.signOut();
      logger.i('✅ Signed out from Google');
    } catch (e) {
      logger.w('⚠️ Failed to sign out from Google', error: e);
      // Non-critical error, don't throw
    }
  }

  /// Disconnect from Google
  /// Revokes access and clears Google account session on Android
  Future<void> disconnect() async {
    if (!Platform.isAndroid || _googleSignIn == null) {
      return;
    }

    try {
      await _googleSignIn!.disconnect();
      logger.i('✅ Disconnected from Google');
    } catch (e) {
      logger.w('⚠️ Failed to disconnect from Google', error: e);
      // Non-critical error, don't throw
    }
  }
}
