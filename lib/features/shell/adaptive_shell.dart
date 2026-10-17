// app/lib/features/shell/adaptive_shell.dart
// Adaptive navigation shell: sidebar (desktop) / rail (tablet) / bottom bar (mobile)
// Layout matches DesktopHome.png and MobileHome.png exactly.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/connectivity/connectivity_service.dart';
import '../../core/widgets/empty_state.dart';
import '../workspaces/presentation/workspace_switcher.dart';
import '../workspaces/providers/workspace_providers.dart';
import '../notifications/providers/notifications_providers.dart';

// Routes that should HIDE the bottom bar on mobile
const _fullScreenRoutes = {
  '/login',
  '/signup',
  '/verify-email',
  '/forgot-password',
  '/verify-code',
  '/new-password',
  '/onboarding/workspace',
  '/tasks/new',
  '/workspace/create',
  '/workspace/join',
};

class AdaptiveShell extends ConsumerWidget {
  final Widget child;
  const AdaptiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final layout = Breakpoints.of(size.width);

    if (layout == LayoutSize.desktop) return _DesktopShell(child: child);
    if (layout == LayoutSize.tablet) return _TabletShell(child: child);
    return _MobileShell(child: child);
  }
}

// ─────────────────────────────────────────────
// DESKTOP SHELL
// ─────────────────────────────────────────────
class _DesktopShell extends ConsumerWidget {
  final Widget child;
  const _DesktopShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
          context.push('/search');
        },
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: Row(
          children: [
            _DesktopSidebar(),
            Expanded(
              child: Column(
                children: [
                  _DesktopTopBar(),
                  ConnectivityBanner(
                    state: ref.watch(connectivityServiceProvider),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopSidebar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final location = GoRouterState.of(context).uri.path;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: LayoutMetrics.sidebarWidth,
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                // Indigo square with "P"
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'PlanPal',
                  style: AppText.brand.copyWith(color: c.textPrimary),
                ),
              ],
            ),
          ),

          // Workspace switcher card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: GestureDetector(
              onTap: () => showWorkspaceSwitcherPopover(context, ref),
              child: _WorkspaceSwitcherCard(),
            ),
          ),

          const SizedBox(height: 4),

          // Nav items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _navItems(l10n)
                    .map(
                      (item) => _SidebarNavItem(
                        icon: item.icon,
                        label: item.label,
                        route: item.route,
                        isActive: location.startsWith(item.route),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceSwitcherCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final workspace = ref.watch(currentWorkspaceProvider);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          // Workspace initial avatar
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                workspace?.initial ?? l10n.homeWorkspaceFallback[0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspace?.name ?? l10n.homeWorkspaceFallback,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  workspace == null
                      ? ''
                      : workspace.isPersonal
                      ? l10n.workspacePersonal
                      : switch (workspace.role) {
                          'admin' => l10n.roleAdmin,
                          'member' => l10n.roleMember,
                          'guest' => l10n.roleGuest,
                          _ => l10n.workspaceTeam,
                        },
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronsUpDown, size: 16, color: c.textMuted),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;
  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(AppRadius.control),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? c.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isActive ? c.primary : c.textMuted),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppText.label.copyWith(
                    color: isActive ? c.primary : c.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopTopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final unreadCount = ref.watch(unreadCountProvider);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      color: c.background,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                height: 40,
                constraints: const BoxConstraints(maxWidth: 448),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(LucideIcons.search, size: 16, color: c.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Search tasks, docs, people...',
                        style: AppText.body.copyWith(color: c.textMuted),
                      ),
                    ),
                    // Ctrl K chip
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: c.border),
                      ),
                      child: Text(
                        'Ctrl K',
                        style: AppText.chip.copyWith(color: c.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // Bell button
          _TopBarIconButton(
            icon: LucideIcons.bell,
            hasUnread: unreadCount > 0,
            onTap: () => context.push('/notifications'),
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasUnread;
  final VoidCallback? onTap;
  const _TopBarIconButton({
    required this.icon,
    this.hasUnread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.surface,
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Icon(icon, size: 20, color: c.textMuted),
          ),
        ),
        if (hasUnread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: c.danger,
                shape: BoxShape.circle,
                border: Border.all(color: c.surface, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TABLET SHELL
// ─────────────────────────────────────────────
class _TabletShell extends ConsumerWidget {
  final Widget child;
  const _TabletShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final location = GoRouterState.of(context).uri.path;
    final l10n = AppLocalizations.of(context);
    final items = _navItems(l10n);

    int selectedIndex = 0;
    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        selectedIndex = i;
        break;
      }
    }

    return Scaffold(
      backgroundColor: c.background,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => context.go(items[i].route),
            backgroundColor: c.surface,
            selectedIconTheme: IconThemeData(color: c.primary),
            unselectedIconTheme: IconThemeData(color: c.textMuted),
            selectedLabelTextStyle: AppText.chip.copyWith(color: c.primary),
            unselectedLabelTextStyle: AppText.chip.copyWith(color: c.textMuted),
            labelType: NavigationRailLabelType.all,
            minWidth: LayoutMetrics.railWidth,
            destinations: items
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          Container(width: 1, color: c.border),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MOBILE SHELL
// ─────────────────────────────────────────────
class _MobileShell extends ConsumerWidget {
  final Widget child;
  const _MobileShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final location = GoRouterState.of(context).uri.path;
    final l10n = AppLocalizations.of(context);

    // Hide bottom bar for full-screen routes
    final hideBar = _fullScreenRoutes.any((r) => location.startsWith(r));

    final mobileItems = _mobileNavItems(l10n);
    int selectedIndex = 0;
    for (int i = 0; i < mobileItems.length; i++) {
      if (location.startsWith(mobileItems[i].route)) {
        selectedIndex = i;
        break;
      }
    }

    return Scaffold(
      backgroundColor: c.background,
      body: child,
      bottomNavigationBar: hideBar
          ? null
          : Container(
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: List.generate(mobileItems.length, (i) {
                      final item = mobileItems[i];
                      final isActive = i == selectedIndex;
                      return Expanded(
                        child: InkWell(
                          onTap: () => context.go(item.route),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isActive ? item.activeIcon : item.icon,
                                size: 24,
                                color: isActive ? c.primary : c.textMuted,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.label,
                                style: AppText.chip.copyWith(
                                  color: isActive ? c.primary : c.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
// NAV ITEM DEFINITIONS
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

List<_NavItem> _navItems(AppLocalizations l10n) => [
  _NavItem(icon: LucideIcons.home, label: l10n.navHome, route: '/home'),
  _NavItem(
    icon: LucideIcons.checkSquare,
    label: l10n.navTasks,
    route: '/tasks',
  ),
  _NavItem(
    icon: LucideIcons.calendar,
    label: l10n.navCalendar,
    route: '/calendar',
  ),
  _NavItem(
    icon: LucideIcons.messageCircle,
    label: l10n.navChat,
    route: '/chat',
  ),
  _NavItem(
    icon: LucideIcons.fileText,
    label: l10n.navDocuments,
    route: '/documents',
  ),
  _NavItem(
    icon: LucideIcons.barChart2,
    label: l10n.navAnalytics,
    route: '/analytics',
  ),
  _NavItem(icon: LucideIcons.users, label: l10n.navTeam, route: '/team'),
  _NavItem(
    icon: LucideIcons.settings,
    label: l10n.navSettings,
    route: '/settings',
  ),
];

// Mobile: Home, Tasks, Chat, Profile, Settings (5 tabs per the mock)
List<_NavItem> _mobileNavItems(AppLocalizations l10n) => [
  _NavItem(icon: LucideIcons.home, label: l10n.navHome, route: '/home'),
  _NavItem(
    icon: LucideIcons.checkSquare,
    label: l10n.navTasks,
    route: '/tasks',
  ),
  _NavItem(
    icon: LucideIcons.messageCircle,
    label: l10n.navChat,
    route: '/chat',
  ),
  _NavItem(icon: LucideIcons.user, label: l10n.navProfile, route: '/profile'),
  _NavItem(
    icon: LucideIcons.settings,
    label: l10n.navSettings,
    route: '/settings',
  ),
];
