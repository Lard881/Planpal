import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/desktop_sidebar.dart';
import '../../../shared/widgets/desktop_topbar.dart';
import '../../home/screens/home_screen.dart';
import '../../tasks/screens/tasks_screen.dart';
import '../../calendar/screens/calendar_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../workspaces/providers/workspace_providers.dart';

/// Main navigation screen with adaptive layout:
/// - width < 600: BottomNavigationBar (5 destinations)
/// - 600 to 899: NavigationRail on left (icons + labels)
/// - width >= 900: DesktopSidebar (dark) + DesktopTopBar
class MainNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  final Widget? child;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.child,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  int _calculateSelectedIndex(BuildContext context) {
    try {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/home') || location.startsWith('/today')) return 0;
      if (location.startsWith('/tasks')) return 1;
      if (location.startsWith('/calendar')) return 2;
      if (location.startsWith('/chat')) return 3;
      if (location.startsWith('/settings')) return 4;
    } catch (_) {}
    return _currentIndex;
  }

  String _calculateCurrentRoute(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (_) {
      return '/home';
    }
  }

  void _onTabTapped(int index, bool canUseChat) {
    if (index == 3 && !canUseChat) {
      AppSnackbar.showError(
        context,
        AppLocalizations.of(context)!.errorChatNotAvailableInPersonal,
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/tasks');
        break;
      case 2:
        context.go('/calendar');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(currentWorkspacePermissionsProvider);

    return permissionsAsync.when(
      data: (permissions) {
        final canUseChat = permissions?.canUseChat ?? false;
        final selectedIndex = _calculateSelectedIndex(context);
        final currentRoute = _calculateCurrentRoute(context);
        final l10n = AppLocalizations.of(context)!;

        // Default screen stack if not wrapped in ShellRoute child
        final List<Widget> defaultScreens = [
          const HomeScreen(),
          const TasksScreen(),
          const CalendarScreen(),
          if (canUseChat) const ChatScreen() else const _ChatDisabledScreen(),
          const SettingsScreen(),
        ];

        final Widget contentBody = widget.child ??
            IndexedStack(
              index: selectedIndex.clamp(0, defaultScreens.length - 1),
              children: defaultScreens,
            );

        return LayoutBuilder(
          builder: (context, constraints) {
            // 1. Mobile (width < 600): BottomNavigationBar
            if (constraints.maxWidth < 600) {
              return Scaffold(
                body: contentBody,
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: selectedIndex.clamp(0, 4),
                  onTap: (index) => _onTabTapped(index, canUseChat),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.grey600,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home_outlined),
                      activeIcon: const Icon(Icons.home),
                      label: l10n.home,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.task_alt_outlined),
                      activeIcon: const Icon(Icons.task_alt),
                      label: l10n.tasks,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.calendar_today_outlined),
                      activeIcon: const Icon(Icons.calendar_today),
                      label: l10n.calendar,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: canUseChat ? null : AppColors.grey400,
                      ),
                      activeIcon: Icon(
                        Icons.chat_bubble,
                        color: canUseChat ? null : AppColors.grey400,
                      ),
                      label: l10n.chat,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.settings_outlined),
                      activeIcon: const Icon(Icons.settings),
                      label: l10n.settings,
                    ),
                  ],
                ),
              );
            }

            // 2. Tablet / Narrow Window (600 to 899): NavigationRail on left
            if (constraints.maxWidth < 900) {
              return Scaffold(
                body: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: selectedIndex.clamp(0, 4),
                      onDestinationSelected: (index) => _onTabTapped(index, canUseChat),
                      labelType: NavigationRailLabelType.all,
                      selectedIconTheme: const IconThemeData(color: AppColors.primary),
                      selectedLabelTextStyle: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: AppColors.grey600,
                        fontSize: 12,
                      ),
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.home_outlined),
                          selectedIcon: const Icon(Icons.home),
                          label: Text(l10n.home),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.task_alt_outlined),
                          selectedIcon: const Icon(Icons.task_alt),
                          label: Text(l10n.tasks),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.calendar_today_outlined),
                          selectedIcon: const Icon(Icons.calendar_today),
                          label: Text(l10n.calendar),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: canUseChat ? null : AppColors.grey400,
                          ),
                          selectedIcon: Icon(
                            Icons.chat_bubble,
                            color: canUseChat ? null : AppColors.grey400,
                          ),
                          label: Text(l10n.chat),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.settings_outlined),
                          selectedIcon: const Icon(Icons.settings),
                          label: Text(l10n.settings),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: contentBody),
                  ],
                ),
              );
            }

            // 3. Desktop (width >= 900): Dark Sidebar + TopBar
            return Scaffold(
              body: Row(
                children: [
                  DesktopSidebar(
                    currentRoute: currentRoute,
                    onDestinationSelected: (route) {
                      if (route == '/chat' && !canUseChat) {
                        AppSnackbar.showError(
                          context,
                          AppLocalizations.of(context)!.errorChatNotAvailableInPersonal,
                        );
                        return;
                      }
                      context.go(route);
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const DesktopTopBar(),
                        Expanded(child: contentBody),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading workspace: $error')),
      ),
    );
  }
}

/// Screen shown when chat is disabled (personal workspace)
class _ChatDisabledScreen extends StatelessWidget {
  const _ChatDisabledScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chat),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.chatNotAvailable,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.errorChatNotAvailableInPersonal,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
