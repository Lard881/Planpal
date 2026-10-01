import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';
import '../utils/logger.dart';

/// Supabase service singleton
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  /// Initialize Supabase
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
          persistSession: true,
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 3,
        ),
      );

      logger.info('✅ Supabase initialized successfully');
    } catch (e, stack) {
      logger.error('Failed to initialize Supabase', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  /// Get auth client
  GoTrueClient get auth => client.auth;

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Get current session
  Session? get currentSession => auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get user ID
  String? get userId => currentUser?.id;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;
}
