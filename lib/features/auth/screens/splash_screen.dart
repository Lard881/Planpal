import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/network/api_client.dart';

/// Splash screen with session restore logic
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait a moment for visual feedback
      await Future.delayed(const Duration(seconds: 1));

      // Check for existing session
      final authService = ref.read(authServiceProvider);
      final session = await authService.refreshSession();

      if (!mounted) return;

      if (session != null) {
        // Session exists, fetch user data from backend
        try {
          final apiClient = ref.read(apiClientProvider);
          final response = await apiClient.get('/me');
          
          // Store user data (workspaces, current workspace, etc.)
          // This will be expanded in Stage 5
          final workspaces = response.data['workspaces'] as List?;
          if (workspaces != null && workspaces.isNotEmpty) {
            final personalWorkspace = workspaces.firstWhere(
              (w) => w['is_personal'] == true,
              orElse: () => workspaces.first,
            );
            ref.read(currentWorkspaceIdProvider.notifier).state = personalWorkspace['id'];
          }

          // Navigate to main app
          if (mounted) {
            context.go('/today');
          }
        } catch (e) {
          // If /me fails but session exists, still let user in
          // They can work offline
          if (mounted) {
            context.go('/today');
          }
        }
      } else {
        // No session, go to login
        if (mounted) {
          context.go('/auth/login');
        }
      }
    } catch (e) {
      // Error during initialization, go to login
      if (mounted) {
        context.go('/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'PlanPal',
              style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
