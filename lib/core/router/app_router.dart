import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/simple_register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/auth/screens/reset_password_new_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/main/screens/main_navigation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/tasks/screens/tasks_screen.dart';
import '../../features/tasks/screens/task_detail_screen.dart';
import '../../features/tasks/screens/new_task_screen.dart';
import '../../features/workspaces/screens/workspaces_screen.dart';
import '../../features/workspaces/screens/create_workspace_screen.dart';
import '../../features/workspaces/screens/join_workspace_screen.dart';
import '../../features/workspaces/screens/workspace_members_screen.dart';
import '../../features/workspaces/screens/invite_codes_screen.dart';
import '../../features/workspaces/screens/workspace_settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import 'router_guards.dart';

/// App routing configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check guards for auth and login routes
      final path = state.uri.path;
      
      // Apply login guard to auth routes
      if (path.startsWith('/login') || path.startsWith('/auth')) {
        return loginGuard(context, state);
      }
      
      // Apply auth guard to protected routes
      final protectedRoutes = [
        '/home',
        '/today',
        '/tasks',
        '/workspaces',
        '/notifications',
        '/calendar',
        '/chat',
        '/settings',
        '/profile',
        '/onboarding',
      ];
      
      if (protectedRoutes.any((route) => path.startsWith(route))) {
        return authGuard(context, state);
      }
      
      return null;
    },
    routes: [
      // Splash screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: '/auth',
        name: 'auth',
        routes: [
          GoRoute(
            path: 'login',
            name: 'auth-login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            name: 'auth-register',
            builder: (context, state) => const SimpleRegisterScreen(),
          ),
          GoRoute(
            path: 'verify-email',
            name: 'auth-verify-email',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return VerifyEmailScreen(email: email);
            },
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'auth-forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'reset-password',
            name: 'auth-reset-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'reset-password/new',
            name: 'auth-reset-password-new',
            builder: (context, state) => const ResetPasswordNewScreen(),
          ),
        ],
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Onboarding route (first-time setup)
      GoRoute(
        path: '/onboarding/workspace',
        name: 'onboarding-workspace',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main app routes - Use MainNavigationScreen with bottom nav
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainNavigationScreen(initialIndex: 0),
      ),
      
      GoRoute(
        path: '/today',
        name: 'today',
        builder: (context, state) => const HomeScreen(), // Today view is in HomeScreen
      ),
      
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TasksScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: 'task-new',
            builder: (context, state) => const NewTaskScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'task-detail',
            builder: (context, state) {
              final taskId = state.pathParameters['id']!;
              return TaskDetailScreen(taskId: taskId);
            },
          ),
        ],
      ),
      
      GoRoute(
        path: '/workspaces',
        name: 'workspaces',
        builder: (context, state) => const WorkspacesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'workspace-create',
            builder: (context, state) => const CreateWorkspaceScreen(),
          ),
          GoRoute(
            path: 'join',
            name: 'workspace-join',
            builder: (context, state) => const JoinWorkspaceScreen(),
          ),
          GoRoute(
            path: ':id/members',
            name: 'workspace-members',
            builder: (context, state) {
              final workspaceId = state.pathParameters['id']!;
              return WorkspaceMembersScreen(workspaceId: workspaceId);
            },
          ),
          GoRoute(
            path: ':id/invite-codes',
            name: 'workspace-invite-codes',
            builder: (context, state) {
              final workspaceId = state.pathParameters['id']!;
              return InviteCodesScreen(workspaceId: workspaceId);
            },
          ),
          GoRoute(
            path: ':id/settings',
            name: 'workspace-settings',
            builder: (context, state) {
              final workspaceId = state.pathParameters['id']!;
              return WorkspaceSettingsScreen(workspaceId: workspaceId);
            },
          ),
        ],
      ),
      
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
