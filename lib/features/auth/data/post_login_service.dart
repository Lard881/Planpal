import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';

/// Service to handle post-login flow
/// Fetches user data, applies theme/language, starts sync
class PostLoginService {
  final Dio _apiClient;
  final SharedPreferences _prefs;

  PostLoginService({
    required Dio apiClient,
    required SharedPreferences prefs,
  })  : _apiClient = apiClient,
        _prefs = prefs;

  /// Execute post-login flow
  /// 1. Call GET /me to fetch user profile and workspaces
  /// 2. Apply saved theme from backend
  /// 3. Apply saved language from backend
  /// 4. Set current workspace (last used or personal)
  /// 5. Check if first login (for onboarding)
  /// 6. Start first data sync (future enhancement)
  /// 
  /// Returns:
  /// - 'onboarding' if this is first login
  /// - workspace ID if not first login
  /// - null on error
  Future<String?> executePostLoginFlow() async {
    try {
      logger.i('📡 Starting post-login flow...');

      // Check if this is first login
      final hasLoggedInBefore = _prefs.getBool('has_logged_in_before') ?? false;
      final isFirstLogin = !hasLoggedInBefore;

      // Step 1: Fetch user data from backend
      logger.i('📡 Calling GET /me...');
      final response = await _apiClient.get('/me');

      if (response.statusCode != 200) {
        logger.e('❌ GET /me failed with status: ${response.statusCode}');
        return null;
      }

      final data = response.data as Map<String, dynamic>;
      logger.i('✅ User data received');

      // Step 2 & 3: Apply theme and language from backend profile
      await _applyUserPreferences(data);

      // Step 4: Handle workspaces and select current workspace
      final workspaceId = await _handleWorkspaces(data);

      // Step 5: Check if first login - show onboarding
      if (isFirstLogin) {
        // Mark as logged in before
        await _prefs.setBool('has_logged_in_before', true);
        logger.i('🎉 First login detected - navigate to onboarding');
        return 'onboarding'; // Special value to indicate onboarding needed
      }

      // Step 6: Start first sync (placeholder for future implementation)
      // TODO: Trigger sync engine to fetch initial data
      logger.i('ℹ️ First sync will be triggered by sync engine');

      logger.i('🎉 Post-login flow completed successfully');
      return workspaceId;
    } catch (e, stack) {
      logger.e('❌ Post-login flow failed', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Apply user preferences (theme and language) from backend
  Future<void> _applyUserPreferences(Map<String, dynamic> data) async {
    try {
      final profile = data['profile'] as Map<String, dynamic>?;
      
      if (profile == null) {
        logger.w('⚠️ No profile data found in /me response');
        return;
      }

      // Apply theme
      final theme = profile['theme'] as String?;
      if (theme != null && theme.isNotEmpty) {
        await _prefs.setString('theme_mode', theme);
        logger.i('✅ Applied theme: $theme');
      }

      // Apply language
      final language = profile['language'] as String?;
      if (language != null && language.isNotEmpty) {
        await _prefs.setString('language', language);
        logger.i('✅ Applied language: $language');
      }

      // Store timezone for future use
      final timezone = profile['timezone'] as String?;
      if (timezone != null && timezone.isNotEmpty) {
        await _prefs.setString('timezone', timezone);
        logger.i('✅ Stored timezone: $timezone');
      }
    } catch (e, stack) {
      logger.e('❌ Error applying user preferences', error: e, stackTrace: stack);
    }
  }

  /// Handle workspaces and select current workspace
  /// Returns the selected workspace ID
  Future<String?> _handleWorkspaces(Map<String, dynamic> data) async {
    try {
      final workspaces = data['workspaces'] as List?;
      
      if (workspaces == null || workspaces.isEmpty) {
        logger.w('⚠️ No workspaces found in /me response');
        return null;
      }

      logger.i('📂 Found ${workspaces.length} workspace(s)');

      // Get last used workspace from SharedPreferences
      final lastWorkspaceId = _prefs.getString('last_workspace_id');
      
      // Try to find last used workspace
      Map<String, dynamic>? selectedWorkspace;
      
      if (lastWorkspaceId != null) {
        try {
          selectedWorkspace = workspaces.firstWhere(
            (w) => w['id'] == lastWorkspaceId,
            orElse: () => throw Exception('Not found'),
          ) as Map<String, dynamic>;
          logger.i('✅ Restored last used workspace: $lastWorkspaceId');
        } catch (e) {
          // Last workspace not found (maybe deleted), fall back to personal
          logger.w('⚠️ Last used workspace not found, falling back to personal');
          selectedWorkspace = null;
        }
      }
      
      // If no last workspace or not found, select personal workspace
      if (selectedWorkspace == null) {
        try {
          selectedWorkspace = workspaces.firstWhere(
            (w) => w['type'] == 'personal' || w['is_personal'] == true,
            orElse: () => workspaces.first,
          ) as Map<String, dynamic>;
          logger.i('✅ Selected personal workspace');
        } catch (e) {
          // Fallback to first workspace
          selectedWorkspace = workspaces.first as Map<String, dynamic>;
          logger.i('✅ Selected first workspace as fallback');
        }
      }
      
      // Extract workspace ID
      final workspaceId = selectedWorkspace['id'] as String?;
      
      // Save for next login
      if (workspaceId != null) {
        await _prefs.setString('last_workspace_id', workspaceId);
        logger.i('✅ Saved workspace for next login: $workspaceId');
      }

      // Store personal workspace ID for quick access
      final personalWorkspaceId = data['personal_workspace_id'] as String?;
      if (personalWorkspaceId != null) {
        await _prefs.setString('personal_workspace_id', personalWorkspaceId);
        logger.i('✅ Stored personal workspace ID: $personalWorkspaceId');
      }

      return workspaceId;
    } catch (e, stack) {
      logger.e('❌ Error handling workspaces', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Get user profile data from /me response
  static Map<String, dynamic>? getProfileFromResponse(Map<String, dynamic> data) {
    return data['profile'] as Map<String, dynamic>?;
  }

  /// Get workspaces list from /me response
  static List<dynamic>? getWorkspacesFromResponse(Map<String, dynamic> data) {
    return data['workspaces'] as List?;
  }

  /// Get personal workspace ID from /me response
  static String? getPersonalWorkspaceId(Map<String, dynamic> data) {
    return data['personal_workspace_id'] as String?;
  }
}
