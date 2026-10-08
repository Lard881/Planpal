import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/db/app_database.dart';
import '../../../core/utils/logger.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/app_failure.dart';

/// Sign-out service
/// Handles complete sign-out with cleanup:
/// - Unregister device push token (if online)
/// - Clear local database
/// - Clear secure storage
/// - Clear SharedPreferences
class SignOutService {
  final AppDatabase _database;
  final SharedPreferences _prefs;
  final ApiClient? _apiClient;

  SignOutService({
    required AppDatabase database,
    required SharedPreferences prefs,
    ApiClient? apiClient,
  })  : _database = database,
        _prefs = prefs,
        _apiClient = apiClient;

  /// Execute complete sign-out flow
  /// Works offline - server cleanup is best-effort
  Future<void> executeSignOut() async {
    logger.i('🚪 Starting sign-out flow...');

    // Step 1: Unregister device token (best effort, don't block on failure)
    await _unregisterDeviceToken();

    // Step 2: Clear local database
    await _clearDatabase();

    // Step 3: Clear SharedPreferences (except essential app settings)
    await _clearPreferences();

    logger.i('✅ Sign-out complete');
  }

  /// Unregister device push token from backend
  /// This is best-effort - if offline or fails, token will expire eventually
  Future<void> _unregisterDeviceToken() async {
    try {
      // Only unregister on mobile platforms where we have push notifications
      if (!Platform.isAndroid && !Platform.isIOS) {
        logger.i('⏭️ Skipping device token unregister (not mobile)');
        return;
      }

      // Get stored device token
      final deviceToken = _prefs.getString('device_token');
      if (deviceToken == null || deviceToken.isEmpty) {
        logger.i('⏭️ No device token to unregister');
        return;
      }

      if (_apiClient == null) {
        logger.w('⚠️ ApiClient not available, skipping token unregister');
        return;
      }

      logger.i('🔔 Unregistering device token...');

      // Call backend to remove device token
      // DELETE /devices/:token
      await _apiClient.delete('/devices/$deviceToken');

      // Clear stored token
      await _prefs.remove('device_token');

      logger.i('✅ Device token unregistered');
    } catch (e) {
      // Don't fail sign-out if this fails
      // Token will expire on server or be overwritten on next login
      logger.w('⚠️ Failed to unregister device token (non-critical)', error: e);
    }
  }

  /// Clear all local database tables
  /// This wipes all user data from the device
  Future<void> _clearDatabase() async {
    try {
      logger.i('🗑️ Clearing local database...');

      // Delete all rows from all tables
      // Order matters due to foreign key constraints
      await _database.transaction(() async {
        // Clear junction tables first
        await _database.delete(_database.taskLabels).go();
        
        // Clear dependent tables
        await _database.delete(_database.taskAttachments).go();
        await _database.delete(_database.taskLinks).go();
        await _database.delete(_database.notifications).go();
        await _database.delete(_database.outbox).go();
        
        // Clear main tables
        await _database.delete(_database.tasks).go();
        await _database.delete(_database.labels).go();
        await _database.delete(_database.workspaceMembers).go();
        await _database.delete(_database.workspaces).go();
        await _database.delete(_database.profiles).go();
        
        // Clear metadata tables
        await _database.delete(_database.syncState).go();
        await _database.delete(_database.keyValue).go();
      });

      logger.i('✅ Local database cleared');
    } catch (e, stack) {
      logger.e('❌ Failed to clear database', error: e, stackTrace: stack);
      // Re-throw as this is critical for sign-out
      throw AppFailure.localDatabaseError(
        message: 'Failed to clear local data: ${e.toString()}',
      );
    }
  }

  /// Clear SharedPreferences except essential app settings
  /// Keeps: theme, language (user preferences that work without account)
  Future<void> _clearPreferences() async {
    try {
      logger.i('🧹 Clearing shared preferences...');

      // Save values we want to keep
      final theme = _prefs.getString('theme_mode');
      final language = _prefs.getString('language_code');

      // Clear all preferences
      await _prefs.clear();

      // Restore preserved values
      if (theme != null) {
        await _prefs.setString('theme_mode', theme);
      }
      if (language != null) {
        await _prefs.setString('language_code', language);
      }

      logger.i('✅ Shared preferences cleared (preserved: theme, language)');
    } catch (e, stack) {
      logger.e('❌ Failed to clear preferences', error: e, stackTrace: stack);
      // Non-critical, don't block sign-out
    }
  }

  /// Clear specific cached values (called from outside if needed)
  Future<void> clearCurrentWorkspace() async {
    try {
      await _prefs.remove('current_workspace_id');
      logger.i('✅ Cleared current workspace');
    } catch (e) {
      logger.w('⚠️ Failed to clear current workspace', error: e);
    }
  }

  /// Check if local data exists (for debugging/testing)
  Future<bool> hasLocalData() async {
    try {
      final profileCount = await _database.select(_database.profiles).get();
      return profileCount.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
