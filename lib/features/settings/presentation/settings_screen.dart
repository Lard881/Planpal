// app/lib/features/settings/presentation/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/services/avatar_upload_service.dart';
import '../../../core/widgets/avatar_crop_dialog.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../workspaces/providers/workspace_providers.dart';
import 'sync_status_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final String? section;
  const SettingsScreen({super.key, this.section});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late String _section;

  @override
  void initState() {
    super.initState();
    _section = widget.section ?? 'profile';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktopLayout;
    return isDesktop
        ? _buildDesktop(context)
        : _buildMobile(context);
  }

  Widget _buildDesktop(BuildContext context) {
    final c = context.colors;
    final workspace = ref.watch(currentWorkspaceProvider);
    final isPersonal = workspace?.isPersonal ?? true;

    final menuItems = [
      _MenuItem('profile', 'Profile', LucideIcons.user),
      _MenuItem('account', 'Account', LucideIcons.settings),
      _MenuItem('notifications', 'Notifications', LucideIcons.bell),
      _MenuItem('appearance', 'Appearance', LucideIcons.palette),
      _MenuItem('security', 'Security', LucideIcons.lock),
      if (!isPersonal) _MenuItem('workspace', 'Workspace', LucideIcons.building2),
      _MenuItem('sync', 'Sync status', LucideIcons.refreshCw),
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left menu
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: menuItems.map((item) {
                  final selected = _section == item.key;
                  return GestureDetector(
                    onTap: () => setState(() => _section = item.key),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: selected ? c.primarySoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, size: 16,
                            color: selected ? c.primary : c.textMuted),
                          const SizedBox(width: 10),
                          Text(item.label,
                            style: AppText.bodyMedium.copyWith(
                              color: selected ? c.primary : c.textPrimary)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 24),
            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.panel),
                  border: Border.all(color: c.border),
                ),
                padding: const EdgeInsets.all(32),
                child: _buildSection(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    final c = context.colors;
    final user = Supabase.instance.client.auth.currentUser;
    final workspace = ref.watch(currentWorkspaceProvider);
    final isPersonal = workspace?.isPersonal ?? true;
    final perms = ref.watch(currentRolePermissionsProvider);

    // Profile tab
    if (_section == 'profile_tab') {
      return _MobileProfileTab();
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Settings',
              style: AppText.pageTitleMobile.copyWith(color: c.textPrimary)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  _SettingsRow(icon: LucideIcons.user, label: 'Profile',
                    onTap: () => setState(() => _section = 'profile')),
                  _SettingsRow(icon: LucideIcons.settings, label: 'Account',
                    onTap: () => setState(() => _section = 'account')),
                  _SettingsRow(icon: LucideIcons.bell, label: 'Notifications',
                    onTap: () => setState(() => _section = 'notifications')),
                  _SettingsRow(icon: LucideIcons.palette, label: 'Appearance',
                    onTap: () => setState(() => _section = 'appearance')),
                  _SettingsRow(icon: LucideIcons.lock, label: 'Security',
                    onTap: () => setState(() => _section = 'security')),
                  if (!isPersonal)
                    _SettingsRow(icon: LucideIcons.building2, label: 'Workspace',
                      onTap: () => setState(() => _section = 'workspace')),
                  _SettingsRow(icon: LucideIcons.refreshCw, label: 'Sync status',
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => const SyncStatusScreen()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context) {
    switch (_section) {
      case 'profile': return _ProfileSection();
      case 'appearance': return _AppearanceSection();
      case 'account': return _AccountSection();
      case 'sync': return const SyncStatusScreen();
      default: return Center(
        child: Text('$_section settings coming soon.',
          style: AppText.body.copyWith(color: context.colors.textMuted)));
    }
  }
}

// ── Profile Section ───────────────────────────────────────────────────────────
class _ProfileSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<_ProfileSection> {
  late TextEditingController _nameCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _nameCtrl = TextEditingController(
      text: user?.userMetadata?['full_name'] as String? ?? '');
  }

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'full_name': _nameCtrl.text.trim()}));
    } catch (_) {}
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String? ?? '';
    final email = user?.email ?? '';
    final perms = ref.watch(currentRolePermissionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile',
          style: AppText.authTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 24),
        // Avatar row
        Row(
          children: [
            CurrentUserAvatar(name: name, size: 56),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name · ${perms.role ?? 'Member'}',
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: c.primarySoft,
                        borderRadius: BorderRadius.circular(20)),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await pickAndCropAvatar(context);
                          if (result == null) return;
                          final (file, mime) = result;
                          final (_, err) = await ref
                              .read(avatarUploadServiceProvider)
                              .upload(file, mime);
                          if (err != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err.message)));
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Avatar updated!')));
                          }
                        },
                        child: Text('Upload New',
                          style: AppText.caption.copyWith(color: c.primary)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(20)),
                      child: GestureDetector(
                        onTap: () async {
                          final err = await ref
                              .read(avatarUploadServiceProvider)
                              .removeAvatar();
                          if (err != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err.message)));
                          }
                        },
                        child: Text('Remove',
                          style: AppText.caption.copyWith(color: c.textMuted)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Fields
        Row(
          children: [
            Expanded(child: _Field('Full name', _nameCtrl)),
            const SizedBox(width: 16),
            Expanded(child: _ReadOnlyField('Email', email)),
          ],
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: 'Save Settings',
          onPressed: _save,
          loading: _saving,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  const _Field(this.label, this.ctrl);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            filled: true, fillColor: c.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.control),
              borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  const _ReadOnlyField(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.control)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value,
              style: AppText.body.copyWith(color: c.textMuted))),
        ),
      ],
    );
  }
}

// ── Appearance Section ────────────────────────────────────────────────────────
class _AppearanceSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    const themes = [
      (ThemeMode.light, 'Light', LucideIcons.sun),
      (ThemeMode.dark, 'Dark', LucideIcons.moon),
      (ThemeMode.system, 'System', LucideIcons.monitor),
    ];

    // fix F9 — all 5 languages with their own names
    const languages = [
      ('en', 'English'),
      ('es', 'Español'),
      ('fr', 'Français'),
      ('zh', '简体中文'),
      ('ko', '한국어'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appearance',
          style: AppText.authTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 24),
        Text('Theme', style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 12),
        Row(
          children: themes.map(((ThemeMode mode, String label, IconData icon) t) {
            final selected = themeMode == t.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => ref.read(themeModeProvider.notifier)
                      .setTheme(t.$1),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: selected ? c.primary : c.border,
                        width: selected ? 2 : 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: c.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadius.control)),
                          child: Icon(t.$3, size: 18, color: c.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(t.$2,
                          style: AppText.bodyMedium.copyWith(
                            color: selected ? c.primary : c.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('Language', style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: languages.map(((String code, String name) lang) {
              final selected = (locale?.languageCode ?? 'en') == lang.$1;
              return ListTile(
                dense: true,
                onTap: () => ref.read(localeProvider.notifier)
                    .setLocale(Locale(lang.$1)),
                title: Text(lang.$2,
                  style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
                trailing: selected
                    ? Icon(Icons.check, color: c.primary, size: 18)
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Account Section ───────────────────────────────────────────────────────────
class _AccountSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account',
          style: AppText.authTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 24),
        PlanPalButton(
          label: 'Sign out',
          variant: PlanPalButtonVariant.outline,
          width: double.infinity,
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) context.go('/login');
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.dangerSoft,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.danger.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delete account',
                style: AppText.bodyStrong.copyWith(color: c.danger)),
              const SizedBox(height: 8),
              Text('This permanently deletes your account and all data.',
                style: AppText.body.copyWith(color: c.textMuted)),
              const SizedBox(height: 12),
              PlanPalButton(
                label: 'Delete account',
                variant: PlanPalButtonVariant.dangerOutline,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Mobile Profile Tab ────────────────────────────────────────────────────────
class _MobileProfileTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String? ?? '';
    final email = user?.email ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final perms = ref.watch(currentRolePermissionsProvider);
    final isPersonal = workspace?.isPersonal ?? true;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar + name + email
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CurrentUserAvatar(name: name, size: 96),
                  const SizedBox(height: 12),
                  Text(name,
                    style: AppText.pageTitleMobile.copyWith(
                        color: c.textPrimary)),
                  Text(email,
                    style: AppText.body.copyWith(color: c.textMuted)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: c.surfaceAlt,
                          borderRadius: BorderRadius.circular(20)),
                        child: Text(workspace?.name ?? 'Workspace',
                          style: AppText.caption.copyWith(
                              color: c.textPrimary)),
                      ),
                      const SizedBox(width: 8),
                      if (perms.role != null)
                        RoleBadge(role: perms.role!),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // List card (fix F25)
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  if (!isPersonal)
                    _ProfileRow(icon: LucideIcons.users, label: 'Team',
                      onTap: () => context.go('/team')),
                  _ProfileRow(icon: LucideIcons.fileText, label: 'Documents',
                    onTap: () => context.go('/documents')),
                  if (!perms.isGuest)
                    _ProfileRow(icon: LucideIcons.barChart2, label: 'Analytics',
                      onTap: () => context.go('/analytics')),
                  _ProfileRow(icon: LucideIcons.bell, label: 'Notifications',
                    onTap: () => context.push('/notifications')),
                  _ProfileRow(icon: LucideIcons.refreshCw, label: 'Sync status',
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const SyncStatusScreen()))),
                  ListTile(
                    leading: Icon(LucideIcons.logOut, color: c.danger),
                    title: Text('Sign out',
                      style: AppText.bodyMedium.copyWith(color: c.danger)),
                    trailing: Icon(LucideIcons.chevronRight,
                      size: 16, color: c.textMuted),
                    onTap: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListTile(
      leading: Icon(icon, color: c.textMuted, size: 20),
      title: Text(label,
        style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
      trailing: Icon(LucideIcons.chevronRight, size: 16, color: c.textMuted),
      onTap: onTap,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _ProfileRow(icon: icon, label: label, onTap: onTap);
  }
}

class _MenuItem {
  final String key;
  final String label;
  final IconData icon;
  const _MenuItem(this.key, this.label, this.icon);
}
