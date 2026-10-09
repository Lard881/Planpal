import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/logger.dart';
import '../presentation/auth_providers.dart';
import '../../../core/providers/app_providers.dart';

/// Splash screen with session restore logic
/// Checks for existing session and restores it (works offline)
/// Fetches user data from backend if online
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _updateStatus('sessionCheckingAuth');
      
      // Wait a moment for visual feedback
      await Future.delayed(const Duration(milliseconds: 800));

      // Try to restore existing session from secure storage
      logger.i('🔄 Checking for existing session...');
      final authNotifier = ref.read(authStateNotifierProvider.notifier);
      final hasSession = await authNotifier.restoreSession();

      if (!mounted) return;

      if (hasSession) {
        logger.i('✅ Session found, attempting to fetch user data...');
        _updateStatus('sessionRestoring');

        // Session exists, try to fetch user data from backend
        await _fetchUserDataAndNavigate();
      } else {
        // No session found, go to login
        logger.i('ℹ️ No session found, navigating to login');
        if (mounted) {
          context.go('/auth/login');
        }
      }
    } catch (e, stack) {
      // Error during initialization
      logger.e('❌ Error during app initialization', error: e, stackTrace: stack);
      
      if (mounted) {
        // If we have a session but initialization failed, try to continue anyway
        final authNotifier = ref.read(authStateNotifierProvider.notifier);
        if (authNotifier.isAuthenticated) {
          logger.i('⚠️ Continuing with offline session despite error');
          context.go('/today');
        } else {
          // No session, go to login
          context.go('/auth/login');
        }
      }
    }
  }

  Future<void> _fetchUserDataAndNavigate() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final prefs = ref.read(sharedPreferencesProvider);
      
      logger.i('📡 Calling GET /me endpoint...');
      final response = await apiClient.get('/me');
      
      if (!mounted) return;

      logger.i('✅ User data received');
      
      // Store user profile data
      final profile = response.data['profile'];
      if (profile != null) {
        // Apply saved theme from backend
        final theme = profile['theme'] as String?;
        if (theme != null) {
          await prefs.setString('theme_mode', theme);
        }

        // Apply saved language from backend
        final language = profile['language'] as String?;
        if (language != null) {
          await prefs.setString('language', language);
        }
      }

      // Handle workspaces (like Asana/ClickUp/Notion)
      final workspaces = response.data['workspaces'] as List?;
      if (workspaces != null && workspaces.isNotEmpty) {
        logger.i('📂 Found ${workspaces.length} workspace(s)');
        
        // Get last used workspace from SharedPreferences
        final lastWorkspaceId = prefs.getString('last_workspace_id');
        
        // Try to find last used workspace
        dynamic selectedWorkspace;
        if (lastWorkspaceId != null) {
          try {
            selectedWorkspace = workspaces.firstWhere(
              (w) => w['id'] == lastWorkspaceId,
            );
            logger.i('✅ Restored last workspace: $lastWorkspaceId');
          } catch (e) {
            // Last workspace not found (maybe deleted), fall back to personal
            logger.w('⚠️ Last workspace not found, falling back to personal');
            selectedWorkspace = null;
          }
        }
        
        // If no last workspace or not found, select personal workspace
        if (selectedWorkspace == null) {
          selectedWorkspace = workspaces.firstWhere(
            (w) => w['type'] == 'personal' || w['is_personal'] == true,
            orElse: () => workspaces.first,
          );
          logger.i('✅ Selected personal workspace');
        }
        
        // Set as current workspace
        final workspaceId = selectedWorkspace['id'] as String?;
        ref.read(currentWorkspaceIdProvider.notifier).state = workspaceId;
        
        // Save for next login
        if (workspaceId != null) {
          await prefs.setString('last_workspace_id', workspaceId);
        }
      }

      // Store personal workspace ID for quick access
      final personalWorkspaceId = response.data['personal_workspace_id'] as String?;
      if (personalWorkspaceId != null) {
        await prefs.setString('personal_workspace_id', personalWorkspaceId);
      }

      // Navigate to main app
      if (mounted) {
        logger.i('🎉 Initialization complete, navigating to app');
        context.go('/today');
      }
    } catch (e, stack) {
      // If /me fails but session exists, still let user in (offline mode)
      logger.w('⚠️ Failed to fetch user data, continuing in offline mode', error: e);
      
      if (mounted) {
        // Check if we have a valid session
        final authNotifier = ref.read(authStateNotifierProvider.notifier);
        if (authNotifier.isAuthenticated) {
          logger.i('✅ Offline session valid, proceeding to app');
          context.go('/today');
        } else {
          // Session invalid, go to login
          logger.i('❌ Session invalid, navigating to login');
          context.go('/auth/login');
        }
      }
    }
  }

  void _updateStatus(String messageKey) {
    if (mounted) {
      setState(() {
        _statusMessage = messageKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Get status message
    String statusText = l10n?.sessionCheckingAuth ?? 'Checking authentication...';
    if (_statusMessage == 'sessionRestoring') {
      statusText = l10n?.sessionRestoring ?? 'Restoring your session...';
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.task_alt,
                size: 72,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),

            // App name
            Text(
              l10n?.appName ?? 'PlanPal',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Task & Team Productivity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),

            // Status message
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
