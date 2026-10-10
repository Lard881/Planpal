import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../home/screens/home_screen.dart';
import '../../tasks/screens/tasks_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../workspaces/providers/workspace_providers.dart';

/// Main navigation screen with bottom navigation bar
/// Matches the mobile design mockups
/// Dynamically shows/hides Chat based on workspace type
class MainNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
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

  void _onTabTapped(int index, bool canUseChat) {
    // Check if trying to access chat in personal workspace
    if (index == 2 && !canUseChat) {
      AppSnackbar.showError(
        context,
        AppLocalizations.of(context)!.errorChatNotAvailableInPersonal,
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(currentWorkspacePermissionsProvider);

    return permissionsAsync.when(
      data: (permissions) {
        final canUseChat = permissions?.canUseChat ?? false;

        // Build navigation items based on permissions
        final List<Widget> screens = [
          const HomeScreen(),
          const TasksScreen(),
          if (canUseChat) const ChatScreen() else const _ChatDisabledScreen(),
          const ProfileScreen(),
          const SettingsScreen(),
        ];

        final l10n = AppLocalizations.of(context)!;

        final List<BottomNavigationBarItem> navItems = [
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
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => _onTabTapped(index, canUseChat),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey600,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: navItems,
          ),
        );
      },
      loading: () => Scaffold(
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (_) {},
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.task_alt_outlined), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
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
              Icon(
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
