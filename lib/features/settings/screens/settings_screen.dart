import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart' hide currentWorkspaceIdProvider;
import '../../../core/providers/theme_provider.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../workspaces/providers/workspace_providers.dart';

/// Settings Screen - Mobile Design
/// Account settings, notifications, preferences, workspace management
/// Matches mobile-settings.png design
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeModeAsync = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Account Settings Section
              _buildSectionHeader('ACCOUNT SETTINGS'),
              _buildSettingsTile(
                context,
                icon: Icons.person_outline,
                title: 'Personal Info',
                onTap: () {
                  Navigator.pushNamed(context, '/settings/personal-info');
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.lock_outline,
                title: 'Security & Password',
                onTap: () {
                  Navigator.pushNamed(context, '/settings/security');
                },
              ),

              const SizedBox(height: 16),

              // Workspace Section
              _buildSectionHeader('WORKSPACE'),
              _buildWorkspaceSection(context, ref),

              const SizedBox(height: 16),

              // Notifications Section
              _buildSectionHeader('NOTIFICATIONS'),
              _buildToggleTile(
                context,
                ref,
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                value: true,
                onChanged: (value) {
                  // TODO: Toggle push notifications
                },
              ),
              _buildToggleTile(
                context,
                ref,
                icon: Icons.email_outlined,
                title: 'Email digests',
                value: false,
                onChanged: (value) {
                  // TODO: Toggle email digests
                },
              ),

              const SizedBox(height: 16),

              // Preferences Section
              _buildSectionHeader('PREFERENCES'),
              _buildAppearanceSection(context, ref, themeModeAsync),
              _buildSettingsTile(
                context,
                icon: Icons.shield_outlined,
                title: 'Privacy & Data',
                onTap: () {
                  Navigator.pushNamed(context, '/settings/privacy');
                },
              ),

              const SizedBox(height: 32),

              // Log Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Log Out'),
                          content: const Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        await ref.read(authStateNotifierProvider.notifier).signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Log Out of PlanPal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.grey[700]),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildWorkspaceSection(BuildContext context, WidgetRef ref) {
    final workspacesAsync = ref.watch(workspacesProvider);
    final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);

    return workspacesAsync.when(
      data: (workspaces) {
        final currentWorkspace = workspaces.firstWhere(
          (w) => w.id == currentWorkspaceId,
          orElse: () => workspaces.first,
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  currentWorkspace.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              currentWorkspace.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              currentWorkspace.type == 'personal' ? 'Personal Workspace' : 'Team Workspace',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: workspaces.length > 1
                ? TextButton(
                    onPressed: () {
                      _showWorkspaceSwitcher(context, ref, workspaces, currentWorkspaceId);
                    },
                    child: const Text('Switch'),
                  )
                : null,
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: 72,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: const Text('Error loading workspace'),
      ),
    );
  }

  void _showWorkspaceSwitcher(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> workspaces,
    String? currentWorkspaceId,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Switch Workspace',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...workspaces.map((workspace) {
              final isSelected = workspace.id == currentWorkspaceId;
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      workspace.name[0].toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  workspace.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  if (!isSelected) {
                    ref.read(currentWorkspaceIdProvider.notifier).state = workspace.id;
                    // Save last used workspace (like Asana/ClickUp/Notion)
                    final prefs = ref.read(sharedPreferencesProvider);
                    prefs.setString('last_workspace_id', workspace.id);
                  }
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    WidgetRef ref,
    ThemeMode themeMode,
  ) {
    String themeModeLabel;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeLabel = 'Light';
        break;
      case ThemeMode.dark:
        themeModeLabel = 'Dark';
        break;
      case ThemeMode.system:
        themeModeLabel = 'System';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.brightness_6_outlined, color: Colors.grey[700]),
        title: const Text(
          'Appearance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              themeModeLabel,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        onTap: () {
          _showAppearanceDialog(context, ref, themeMode);
        },
      ),
    );
  }

  void _showAppearanceDialog(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appearance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
