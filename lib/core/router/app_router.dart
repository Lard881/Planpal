// app/lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/shell/adaptive_shell.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/documents/presentation/documents_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/team/presentation/team_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/workspaces/presentation/create_workspace_screen.dart';
import '../../features/workspaces/presentation/join_workspace_screen.dart';
import '../providers/auth_provider.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/signup') ||
          state.matchedLocation.startsWith('/forgot-password') ||
          state.matchedLocation.startsWith('/verify-email') ||
          state.matchedLocation.startsWith('/onboarding');

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/verify-email', builder: (context, state) {
        final email = state.extra as String?;
        return VerifyEmailScreen(email: email);
      }),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/verify-code', builder: (_, __) => const ForgotPasswordScreen(initialStep: 2)),
      GoRoute(path: '/new-password', builder: (_, __) => const ForgotPasswordScreen(initialStep: 3)),
      GoRoute(path: '/onboarding/workspace', builder: (_, __) => const OnboardingScreen()),

      // Standalone routes (no shell, with back button)
      GoRoute(path: '/workspace/create', builder: (_, __) => const CreateWorkspaceScreen()),
      GoRoute(path: '/workspace/join', builder: (_, __) => const JoinWorkspaceScreen()),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final q = state.uri.queryParameters['q'] ?? '';
          return SearchScreen(initialQuery: q);
        },
      ),
      GoRoute(
        path: '/tasks/new',
        builder: (_, __) => const TasksScreen(showNewTask: true),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) => TasksScreen(taskId: state.pathParameters['id']),
      ),

      // Shell routes
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AdaptiveShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
          GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
          GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
          GoRoute(
            path: '/chat/:channelId',
            builder: (context, state) =>
                ChatScreen(channelId: state.pathParameters['channelId']),
          ),
          GoRoute(path: '/documents', builder: (_, __) => const DocumentsScreen()),
          GoRoute(
            path: '/documents/:id',
            builder: (context, state) =>
                DocumentsScreen(documentId: state.pathParameters['id']),
          ),
          GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
          GoRoute(path: '/team', builder: (_, __) => const TeamScreen()),
          GoRoute(
            path: '/workspace/:id/members',
            builder: (context, state) =>
                TeamScreen(workspaceId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/workspace/:id/invites',
            builder: (context, state) =>
                TeamScreen(workspaceId: state.pathParameters['id'], showInvites: true),
          ),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/settings/profile', builder: (_, __) => const SettingsScreen()),
          GoRoute(
            path: '/settings/appearance',
            builder: (_, __) => const SettingsScreen(section: 'appearance'),
          ),
          GoRoute(path: '/profile', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
