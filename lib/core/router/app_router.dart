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
import '../../features/workspaces/presentation/workspace_settings_screen.dart';
import '../providers/auth_provider.dart';
import '../../features/settings/presentation/sync_status_screen.dart';
import '../../features/tasks/presentation/new_task_screen.dart';
import '../../features/tasks/presentation/task_detail_screen.dart';
import '../../features/tasks/models/task_model.dart';
import 'splash_screen.dart';

// ── A1.2: One stable router — rebuilt once, never on auth events ──────────────
// The GlobalKey instances must be module-level (not inside a Provider) so they
// are never re-created by Riverpod.
final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

// A1.2: Single GoRouter; auth redirects are driven by refreshListenable.
// Create this once; expose via routerProvider.
final routerProvider = Provider<GoRouter>((ref) {
  // A listenable that fires whenever auth state changes, so GoRouter can
  // re-evaluate the redirect without rebuilding the router instance.
  final authListenable = _AuthStateListenable(ref);

  return GoRouter(
    navigatorKey: _rootKey,
    // A1.5: Start at splash so session can be restored before navigating.
    initialLocation: '/splash',
    refreshListenable: authListenable,
    redirect: (context, state) {
      // A1.2: read — not watch — so we never rebuild the router.
      final authState = ref.read(authStateProvider);

      // While session is loading show nothing (splash handles this).
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final loc = state.matchedLocation;

      // A1.3/A1.4: Auth routes — but NOT if a reset is in progress or
      // onboarding is pending (those flags are handled inside the screens).
      final isAuthRoute =
          loc.startsWith('/login') ||
          loc.startsWith('/signup') ||
          loc.startsWith('/forgot-password') ||
          loc.startsWith('/verify-email') ||
          // A1.3 fix: verify-code and new-password must NOT be treated as
          // "go to /home if logged-in" — they are part of the reset flow
          // where Supabase signs the user in on verifyOTP(recovery).
          // Handled by keeping reset-in-progress in the notifier (see
          // auth_notifier.dart). The redirect here simply excludes them.
          loc.startsWith('/verify-code') ||
          loc.startsWith('/new-password') ||
          loc.startsWith('/onboarding') ||
          loc == '/not-configured' ||
          loc == '/splash';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      // A1.3: logged-in guard intentionally omits /verify-code and /new-password
      // so those steps survive the Supabase auto-sign-in during recovery.
      final isRedirectedAuthRoute =
          isLoggedIn &&
          (loc.startsWith('/login') ||
              loc.startsWith('/signup') ||
              loc.startsWith('/forgot-password') ||
              loc.startsWith('/verify-email'));
      if (isRedirectedAuthRoute) return '/home';
      return null;
    },
    routes: [
      // ── A1.5: Splash ─────────────────────────────────────────────────────
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),

      // ── Auth routes (no shell) ────────────────────────────────────────────
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      // A1.3: These stay outside redirect guard so the reset flow works
      GoRoute(
        path: '/verify-code',
        builder: (_, __) => const ForgotPasswordScreen(initialStep: 2),
      ),
      GoRoute(
        path: '/new-password',
        builder: (_, __) => const ForgotPasswordScreen(initialStep: 3),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      // Legacy alias kept for any existing deep links
      GoRoute(
        path: '/onboarding/workspace',
        builder: (_, __) => const OnboardingScreen(),
      ),

      // ── App not configured ────────────────────────────────────────────────
      // A1.9: shown instead of placeholder Supabase URL
      GoRoute(
        path: '/not-configured',
        builder: (_, __) => const _AppNotConfiguredScreen(),
      ),

      // ── Shell routes (sidebar + top bar on desktop) ───────────────────────
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AdaptiveShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(
            path: '/tasks',
            builder: (_, state) {
              final extra = state.extra;
              return TasksScreen(
                initialView: state.uri.queryParameters['view'] ?? 'all',
                createdTask: extra is TaskModel ? extra : null,
              );
            },
          ),
          GoRoute(
            path: '/calendar',
            builder: (_, __) => const CalendarScreen(),
          ),
          GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
          GoRoute(
            path: '/chat/:channelId',
            builder: (context, state) =>
                ChatScreen(channelId: state.pathParameters['channelId']),
          ),
          GoRoute(
            path: '/documents',
            builder: (_, __) => const DocumentsScreen(),
          ),
          GoRoute(
            path: '/documents/:id',
            builder: (context, state) =>
                DocumentsScreen(documentId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/analytics',
            builder: (_, __) => const AnalyticsScreen(),
          ),
          GoRoute(path: '/team', builder: (_, __) => const TeamScreen()),

          // A1.7: Notifications, search, task routes inside shell so they
          // get the sidebar on desktop.
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
            builder: (_, __) => const NewTaskScreen(),
          ),
          GoRoute(
            path: '/tasks/:id',
            builder: (context, state) =>
                TaskDetailScreen(taskId: state.pathParameters['id']!),
          ),

          GoRoute(
            path: '/workspace/:id/members',
            builder: (context, state) => WorkspaceSettingsScreen(
              workspaceId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/workspace/:id/invites',
            builder: (context, state) => WorkspaceSettingsScreen(
              workspaceId: state.pathParameters['id']!,
              showInvites: true,
            ),
          ),
          GoRoute(
            path: '/workspace/create',
            builder: (_, __) => const CreateWorkspaceScreen(),
          ),
          GoRoute(
            path: '/workspace/join',
            builder: (_, __) => const JoinWorkspaceScreen(),
          ),

          // A1.1: /settings top-level route (was missing).
          // On mobile: shows the settings list.
          // On desktop: handled inside SettingsScreen — defaults to profile.
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/settings/profile',
            builder: (_, __) => const SettingsScreen(section: 'profile'),
          ),
          GoRoute(
            path: '/settings/account',
            builder: (_, __) => const SettingsScreen(section: 'account'),
          ),
          GoRoute(
            path: '/settings/notifications',
            builder: (_, __) => const SettingsScreen(section: 'notifications'),
          ),
          GoRoute(
            path: '/settings/appearance',
            builder: (_, __) => const SettingsScreen(section: 'appearance'),
          ),
          GoRoute(
            path: '/settings/security',
            builder: (_, __) => const SettingsScreen(section: 'security'),
          ),
          GoRoute(
            path: '/settings/workspace',
            builder: (_, __) => const SettingsScreen(section: 'workspace'),
          ),
          GoRoute(
            path: '/settings/sync',
            builder: (_, __) => const SyncStatusScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const SettingsScreen(section: 'profile'),
          ),
        ],
      ),
    ],
  );
});

// ── A1.2: Listenable that converts Riverpod auth stream → ChangeNotifier ─────
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}

// ── A1.9: "App not configured" screen ────────────────────────────────────────
class _AppNotConfiguredScreen extends StatelessWidget {
  const _AppNotConfiguredScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(height: 24),
              const Text(
                'App is not configured',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'SUPABASE_URL and SUPABASE_ANON_KEY must be set via '
                '--dart-define before running the app.',
                style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
