import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
import '../data/sign_out_service.dart';
import '../domain/models/user_profile.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/app_providers.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Sign-out service provider
final signOutServiceProvider = Provider<SignOutService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return SignOutService(
    database: database,
    prefs: prefs,
    apiClient: apiClient,
  );
});

/// Current user provider (Supabase User)
final currentUserProvider = StateProvider<User?>((ref) {
  // This will be updated by auth state listener
  return null;
});

/// Current user profile provider
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  
  if (!authRepo.isAuthenticated) {
    return null;
  }
  
  return await authRepo.getUserProfile();
});

/// Auth state stream provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.isAuthenticated;
});

/// Access token provider
final accessTokenProvider = Provider<String?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.accessToken;
});

/// Auth state notifier for managing auth state
class AuthStateNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final AuthRepository _authRepository;
  final SignOutService _signOutService;

  AuthStateNotifier(
    this._authRepository,
    this._signOutService,
  ) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen(
      (authState) {
        state = AsyncValue.data(authState);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      final success = await _authRepository.signInWithGoogle();
      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final success = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow; // Re-throw so UI can show specific error message
    }
  }

  /// Sign out with complete cleanup
  /// - Unregister device token
  /// - Clear local database
  /// - Clear SharedPreferences (preserving theme/language)
  /// - Sign out from Supabase
  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      
      // Execute complete cleanup
      await _signOutService.executeSignOut();
      
      // Sign out from Supabase (clears session)
      await _authRepository.signOut();
      
      state = const AsyncValue.data(AuthState(
        event: AuthChangeEvent.signedOut,
        session: null,
      ));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Restore session
  Future<bool> restoreSession() async {
    try {
      state = const AsyncValue.loading();
      return await _authRepository.restoreSession();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
  
  /// Get current authentication status
  bool get isAuthenticated => _authRepository.isAuthenticated;
}

/// Auth state notifier provider
final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<AuthState>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final signOutService = ref.watch(signOutServiceProvider);
  return AuthStateNotifier(authRepo, signOutService);
});
