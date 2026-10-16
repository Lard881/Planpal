// app/lib/features/auth/presentation/auth_notifier.dart
// Handles sign-in, sign-up, password reset, Google sign-in, sign-out.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/network/auth_error_mapper.dart';
import '../../../core/db/app_database.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/sync/sync_engine.dart';
import '../../workspaces/providers/workspace_providers.dart';

class AuthState {
  final bool loading;
  final AppFailure? error;
  const AuthState({this.loading = false, this.error});
  AuthState copyWith({
    bool? loading,
    AppFailure? error,
    bool clearError = false,
  }) => AuthState(
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
      state = state.copyWith(
        loading: false,
        error: _mapAuthError(e, otpOperation: true),
      );
      return false;
    } catch (_) {
      state = state.copyWith(loading: false, error: const NetworkFailure());
      return false;
    }
  }

  Future<bool> resendOtp(String email) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
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
      state = state.copyWith(
        loading: false,
        error: _mapAuthError(e, otpOperation: true),
      );
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

  Future<AppFailure?> signOut(WidgetRef ref) async {
    state = state.copyWith(loading: true, clearError: true);
    AppFailure? failure;
    try {
      try {
        await FcmService.unregister(ref);
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'sign-out device token cleanup',
          ),
        );
      }
      try {
        await ref.read(appDatabaseProvider).clearUserData();
        await ref.read(currentWorkspaceIdProvider.notifier).clear();
        await ref.read(syncEngineProvider.notifier).clearSyncCursors();
      } catch (error, stackTrace) {
        failure = const UnknownFailure();
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'sign-out local data cleanup',
          ),
        );
      }
      try {
        await _client.auth.signOut();
      } on AuthException catch (error) {
        failure ??= _mapAuthError(error);
      } catch (error, stackTrace) {
        failure ??= const UnknownFailure();
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'Supabase sign out',
          ),
        );
      }
    } finally {
      state = state.copyWith(loading: false, error: failure);
    }
    return failure;
  }

  AuthFailure _mapAuthError(AuthException e, {bool otpOperation = false}) =>
      mapAuthException(e, otpOperation: otpOperation);
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
