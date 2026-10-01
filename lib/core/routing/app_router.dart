import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_verify_screen.dart';
import '../../features/auth/screens/reset_password_new_screen.dart';
import '../../features/tasks/screens/tasks_screen.dart';
import '../../features/tasks/screens/task_detail_screen.dart';
import '../../features/tasks/models/task.dart';
import '../../features/projects/screens/projects_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../widgets/main_shell.dart';

/// Main router configuration for PlanPal
/// Handles navigation, deep links, and route guards
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GoRouter createRouter({
    required bool isAuthenticated,
    String? initialLocation,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation ?? '/splash',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isOnAuthRoute = state.matchedLocation.startsWith('/auth');
        final isOnSplash = state.matchedLocation == '/splash';

        // Allow splash and auth routes
        if (isOnSplash || isOnAuthRoute) {
          return null;
        }

        // Redirect to login if not authenticated
        if (!isAuthenticated) {
          return '/auth/login';
        }

        return null;
      },
      routes: [
        // Splash screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Authentication routes
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/auth/verify-email',
          name: 'verifyEmail',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return VerifyEmailScreen(email: email);
          },
        ),
        GoRoute(
          path: '/auth/forgot-password',
          name: 'forgotPassword',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/auth/reset-password/verify',
          name: 'resetPasswordVerify',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return ResetPasswordVerifyScreen(email: email);
          },
        ),
        GoRoute(
          path: '/auth/reset-password/new',
          name: 'resetPasswordNew',
          builder: (context, state) => const ResetPasswordNewScreen(),
        ),

        // Main app shell with bottom navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            // Today view
            GoRoute(
              path: '/today',
              name: 'today',
              builder: (context, state) => const TasksScreen(initialView: TaskView.today),
            ),

            // Inbox
            GoRoute(
              path: '/inbox',
              name: 'inbox',
              builder: (context, state) => const TasksScreen(initialView: TaskView.all),
            ),

            // Projects
            GoRoute(
              path: '/projects',
              name: 'projects',
              builder: (context, state) => const ProjectsScreen(),
              routes: [
                GoRoute(
                  path: ':projectId',
                  name: 'projectDetail',
                  builder: (context, state) {
                    final projectId = state.pathParameters['projectId']!;
                    return TasksScreen(projectId: projectId);
                  },
                ),
              ],
            ),

            // Search
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) {
                final query = state.uri.queryParameters['q'];
                return SearchScreen(initialQuery: query);
              },
            ),

            // Profile
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),

        // Task detail (full screen)
        GoRoute(
          path: '/tasks/:taskId',
          name: 'taskDetail',
          builder: (context, state) {
            final taskId = state.pathParameters['taskId']!;
            return TaskDetailScreen(taskId: taskId);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${state.error?.toString() ?? "Unknown error"}'),
            ],
          ),
        ),
      ),
    );
  }
}
