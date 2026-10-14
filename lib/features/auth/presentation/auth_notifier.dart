// app/lib/features/auth/presentation/auth_notifier.dart
// Handles sign-in, sign-up, password reset, Google sign-in, sign-out.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/db/app_database.dart';
import '../../../core/services/fcm_service.dart';

class AuthState {
  final bool loading;
  final AppFailure? error;
  const AuthState({this.loading = false, this.error});
  AuthState copyWith({bool? loading, AppFailure? error, bool clearError = false}) =>
      AuthState(
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  final _client = Supabase.instance.client;

  void clearError() => state = state.copyWith(clearError: true);

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String token) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> resendOtp(String email) async {
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.resetPasswordForEmail(email);
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> verifyPasswordResetOtp(String email, String token) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> setNewPassword(String newPassword) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      state = state.copyWith(loading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: _mapAuthError(e));
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<void> signOut(WidgetRef ref) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      // A1.6: unregister FCM token first (non-fatal)
      try { await FcmService.unregister(ref); } catch (_) {}
      // A1.6: clear Drift database
      try { await ref.read(appDatabaseProvider).close(); } catch (_) {}
      // A1.6: clear all secure storage
      try {
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
      } catch (_) {}
      // Sign out from Supabase last
      await _client.auth.signOut();
    } catch (_) {} finally {
      state = state.copyWith(loading: false);
    }
  }

  AppFailure _mapAuthError(AuthException e) {
    // A1.8: map by code first (stable), fall back to message substring
    final code = e.code ?? '';
    final msg = e.message.toLowerCase();
    if (code == 'invalid_credentials' ||
        msg.contains('invalid login') ||
        msg.contains('invalid credentials')) {
      return const ServerFailure('Incorrect email or password. Please try again.');
    }
    if (code == 'email_not_confirmed' || msg.contains('email not confirmed')) {
      return const ServerFailure('Please verify your email before logging in.');
    }
    if (code == 'user_already_exists' || msg.contains('user already registered')) {
      return const ConflictFailure('An account with this email already exists.');
    }
    if (code == 'weak_password' || msg.contains('password should be at least')) {
      return const ValidationFailure('Password must be at least 8 characters.');
    }
    if (code == 'over_request_rate_limit' || msg.contains('rate limit')) {
      return const ServerFailure(
          'Too many attempts. Please wait a moment and try again.',
          code: 'RATE_LIMITED');
    }
    if (code == 'network_failure' ||
        msg.contains('network') ||
        msg.contains('connection')) {
      return const NetworkFailure();
    }
    if (code == 'otp_expired' ||
        code == 'token_expired' ||
        msg.contains('token') ||
        msg.contains('otp')) {
      return const ServerFailure('Invalid or expired code. Please try again.');
    }
    return ServerFailure(e.message);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
