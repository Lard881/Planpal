// app/lib/features/settings/presentation/settings_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;
import '../../../core/platform/platform_info.dart';
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
import '../../../core/services/fcm_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../workspaces/data/workspace_repository.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../auth/presentation/auth_failure_message.dart';
import '../../notifications/providers/notification_preferences.dart';
import '../../../core/providers/user_profile_provider.dart';
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
    return isDesktop ? _buildDesktop(context) : _buildMobile(context);
  }

  Widget _buildDesktop(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final workspace = ref.watch(currentWorkspaceProvider);
    final isPersonal = workspace?.isPersonal ?? true;

    final menuItems = [
      _MenuItem('profile', l10n.settingsProfile, LucideIcons.user),
      _MenuItem('account', l10n.settingsAccount, LucideIcons.settings),
      _MenuItem('notifications', l10n.settingsNotifications, LucideIcons.bell),
      _MenuItem('appearance', l10n.settingsAppearance, LucideIcons.palette),
      _MenuItem('security', l10n.settingsSecurity, LucideIcons.lock),
      if (!isPersonal)
        _MenuItem('workspace', l10n.settingsWorkspace, LucideIcons.building2),
      _MenuItem('sync', l10n.settingsSyncStatus, LucideIcons.refreshCw),
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
                          Icon(
                            item.icon,
                            size: 16,
                            color: selected ? c.primary : c.textMuted,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.label,
                            style: AppText.bodyMedium.copyWith(
                              color: selected ? c.primary : c.textPrimary,
                            ),
                          ),
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
    final l10n = AppLocalizations.of(context);
    final workspace = ref.watch(currentWorkspaceProvider);
    final isPersonal = workspace?.isPersonal ?? true;

    // Profile tab
    if (_section == 'profile_tab') {
      return _MobileProfileTab();
    }

    // Section pages — show as full screen with back button
    if (_section != 'list') {
      return Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.surface,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => setState(() => _section = 'list'),
            child: Icon(Icons.arrow_back, color: context.colors.textPrimary),
          ),
          title: Text(
            _section[0].toUpperCase() + _section.substring(1),
            style: AppText.bodyStrong.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildSection(context),
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.navSettings,
              style: AppText.pageTitleMobile.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  _SettingsRow(
                    icon: LucideIcons.user,
                    label: l10n.settingsProfile,
                    onTap: () => setState(() => _section = 'profile'),
                  ),
                  _SettingsRow(
                    icon: LucideIcons.settings,
                    label: l10n.settingsAccount,
                    onTap: () => setState(() => _section = 'account'),
                  ),
                  _SettingsRow(
                    icon: LucideIcons.bell,
                    label: l10n.settingsNotifications,
                    onTap: () => setState(() => _section = 'notifications'),
                  ),
                  _SettingsRow(
                    icon: LucideIcons.palette,
                    label: l10n.settingsAppearance,
                    onTap: () => setState(() => _section = 'appearance'),
                  ),
                  _SettingsRow(
                    icon: LucideIcons.lock,
                    label: l10n.settingsSecurity,
                    onTap: () => setState(() => _section = 'security'),
                  ),
                  if (!isPersonal)
                    _SettingsRow(
                      icon: LucideIcons.building2,
                      label: l10n.settingsWorkspace,
                      onTap: () => setState(() => _section = 'workspace'),
                    ),
                  _SettingsRow(
                    icon: LucideIcons.refreshCw,
                    label: l10n.settingsSyncStatus,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SyncStatusScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (_section) {
      case 'profile':
        return _ProfileSection();
      case 'appearance':
        return _AppearanceSection();
      case 'account':
        return _AccountSection();
      case 'notifications':
        return const _NotificationSettingsSection();
      case 'security':
        return const _SecuritySection();
      case 'workspace':
        return _WorkspaceSection();
      case 'sync':
        return const SyncStatusScreen();
      default:
        return Center(
          child: Text(
            l10n.settingsComingSoon(_section),
            style: AppText.body.copyWith(color: context.colors.textMuted),
          ),
        );
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
  late final List<String> _timezones;
  String? _selectedTimezone;
  String _deviceTimezone = 'UTC';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    timezone_data.initializeTimeZones();
    _timezones = timezone.timeZoneDatabase.locations.keys.toList()..sort();
    final user = Supabase.instance.client.auth.currentUser;
    _nameCtrl = TextEditingController(
      text: user?.userMetadata?['full_name'] as String? ?? '',
    );
    unawaited(_loadDeviceTimezone());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final profile = ref.read(meProvider).valueOrNull;
      final selectedTimezone =
          _selectedTimezone ?? profile?.timezone ?? _deviceTimezone;
      await ref
          .read(apiClientProvider)
          .dio
          .patch(
            '/me',
            data: {
              'fullName': _nameCtrl.text.trim(),
              'timezone': selectedTimezone,
              'theme': ref.read(themeModeProvider).name,
              'language':
                  ref.read(localeProvider)?.languageCode ??
                  profile?.language ??
                  'en',
            },
          );
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'full_name': _nameCtrl.text.trim()}),
      );
      ref.invalidate(meProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.syncSaved)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _loadDeviceTimezone() async {
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      if (mounted && _timezones.contains(local.identifier)) {
        setState(() => _deviceTimezone = local.identifier);
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'device time-zone lookup',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final user = Supabase.instance.client.auth.currentUser;
    final profile = ref.watch(meProvider).valueOrNull;
    final name = user?.userMetadata?['full_name'] as String? ?? '';
    final email = user?.email ?? '';
    final perms = ref.watch(currentRolePermissionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsProfile,
          style: AppText.authTitle.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 24),
        // Avatar row
        Row(
          children: [
            CurrentUserAvatar(name: name, size: 56),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name · ${perms.role ?? 'Member'}',
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: c.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                              SnackBar(content: Text(err.message)),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).settingsAvatarUpdated,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          l10n.btnUploadNew,
                          style: AppText.caption.copyWith(color: c.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final err = await ref
                              .read(avatarUploadServiceProvider)
                              .removeAvatar();
                          if (err != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err.message)),
                            );
                          }
                        },
                        child: Text(
                          l10n.btnRemove,
                          style: AppText.caption.copyWith(color: c.textMuted),
                        ),
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
            Expanded(child: _Field(l10n.fieldFullName, _nameCtrl)),
            const SizedBox(width: 16),
            Expanded(child: _ReadOnlyField(l10n.fieldEmail, email)),
          ],
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          // The profile loads asynchronously, so this field must stay controlled.
          // ignore: deprecated_member_use
          value:
              _timezones.contains(
                _selectedTimezone ?? profile?.timezone ?? _deviceTimezone,
              )
              ? _selectedTimezone ?? profile?.timezone ?? _deviceTimezone
              : _deviceTimezone,
          decoration: InputDecoration(labelText: l10n.settingsTimezone),
          items: _timezones
              .map(
                (zone) => DropdownMenuItem<String>(
                  value: zone,
                  child: Text(zone, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (zone) => setState(() => _selectedTimezone = zone),
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: l10n.btnSaveSettings,
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
            filled: true,
            fillColor: c.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.control),
              borderSide: BorderSide.none,
            ),
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
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppText.body.copyWith(color: c.textMuted),
            ),
          ),
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
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    final themes = [
      (ThemeMode.light, l10n.settingsThemeLight, LucideIcons.sun),
      (ThemeMode.dark, l10n.settingsThemeDark, LucideIcons.moon),
      (ThemeMode.system, l10n.settingsThemeSystem, LucideIcons.monitor),
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
        Text(
          l10n.settingsAppearance,
          style: AppText.authTitle.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.settingsTheme,
          style: AppText.label.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: themes.map((
            (ThemeMode mode, String label, IconData icon) t,
          ) {
            final selected = themeMode == t.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _saveAppearance(
                    context,
                    ref,
                    theme: t.$1,
                    locale: locale,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: selected ? c.primary : c.border,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c.surfaceAlt,
                            borderRadius: BorderRadius.circular(
                              AppRadius.control,
                            ),
                          ),
                          child: Icon(t.$3, size: 18, color: c.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.$2,
                          style: AppText.bodyMedium.copyWith(
                            color: selected ? c.primary : c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.settingsLanguage,
          style: AppText.label.copyWith(color: c.textPrimary),
        ),
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
                onTap: () => _saveAppearance(
                  context,
                  ref,
                  theme: themeMode,
                  locale: Locale(lang.$1),
                ),
                title: Text(
                  lang.$2,
                  style: AppText.bodyMedium.copyWith(color: c.textPrimary),
                ),
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

  Future<void> _saveAppearance(
    BuildContext context,
    WidgetRef ref, {
    required ThemeMode theme,
    required Locale? locale,
  }) async {
    final l10n = AppLocalizations.of(context);
    final profile = ref.read(meProvider).valueOrNull;
    final selectedLocale = locale?.languageCode ?? profile?.language ?? 'en';
    try {
      await ref
          .read(apiClientProvider)
          .dio
          .patch(
            '/me',
            data: {'theme': theme.name, 'language': selectedLocale},
          );
      await ref.read(themeModeProvider.notifier).setTheme(theme);
      if (locale != null) {
        await ref.read(localeProvider.notifier).setLocale(locale);
      }
      ref.invalidate(meProvider);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().isEmpty ? l10n.errorGeneric : error.toString(),
            ),
          ),
        );
      }
    }
  }
}

class _NotificationSettingsSection extends ConsumerWidget {
  const _NotificationSettingsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    Future<void> update(NotificationPreferences next) async {
      try {
        await notifier.update(next);
        if (next.push != preferences.push) {
          await FcmService.setPushEnabled(ref, next.push);
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    }

    Widget preferenceSwitch(
      String label,
      bool value,
      NotificationPreferences Function(bool) change,
    ) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: (enabled) => update(change(enabled)),
    );

    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          l10n.settingsNotifications,
          style: AppText.authTitle.copyWith(color: context.colors.textPrimary),
        ),
        if (PlatformInfo.isAndroid)
          preferenceSwitch(
            l10n.settingsPushNotifications,
            preferences.push,
            (value) => preferences.copyWith(push: value),
          ),
        preferenceSwitch(
          l10n.settingsInAppNotifications,
          preferences.inApp,
          (value) => preferences.copyWith(inApp: value),
        ),
        preferenceSwitch(
          l10n.settingsNotifyAssignments,
          preferences.assignments,
          (value) => preferences.copyWith(assignments: value),
        ),
        preferenceSwitch(
          l10n.settingsNotifyComments,
          preferences.comments,
          (value) => preferences.copyWith(comments: value),
        ),
        preferenceSwitch(
          l10n.settingsNotifyMentions,
          preferences.mentions,
          (value) => preferences.copyWith(mentions: value),
        ),
        preferenceSwitch(
          l10n.settingsNotifyDeadlines,
          preferences.deadlines,
          (value) => preferences.copyWith(deadlines: value),
        ),
        preferenceSwitch(
          l10n.settingsNotifyChat,
          preferences.chat,
          (value) => preferences.copyWith(chat: value),
        ),
      ],
    );
  }
}

class _SecuritySection extends ConsumerStatefulWidget {
  const _SecuritySection();

  @override
  ConsumerState<_SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends ConsumerState<_SecuritySection> {
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final client = Supabase.instance.client;
    final email = client.auth.currentUser?.email;
    final current = _currentPassword.text;
    final next = _newPassword.text;
    if (email == null || current.isEmpty || next.isEmpty) return;
    setState(() => _saving = true);
    try {
      await client.auth.signInWithPassword(email: email, password: current);
      await client.auth.updateUser(UserAttributes(password: next));
      _currentPassword.clear();
      _newPassword.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsPasswordChanged),
          ),
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _signOutEverywhere() async {
    try {
      await FcmService.unregister(ref);
      await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
      if (mounted) context.go('/login');
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          l10n.settingsSecurity,
          style: AppText.authTitle.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _currentPassword,
          obscureText: true,
          decoration: InputDecoration(labelText: l10n.settingsCurrentPassword),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _newPassword,
          obscureText: true,
          decoration: InputDecoration(labelText: l10n.fieldNewPassword),
        ),
        const SizedBox(height: 16),
        PlanPalButton(
          label: l10n.settingsChangePassword,
          loading: _saving,
          onPressed: _saving ? null : _changePassword,
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: l10n.settingsSignOutEverywhere,
          variant: PlanPalButtonVariant.outline,
          onPressed: _signOutEverywhere,
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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsAccount,
          style: AppText.authTitle.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: l10n.btnSignOut,
          variant: PlanPalButtonVariant.outline,
          width: double.infinity,
          onPressed: () async {
            final failure = await ref
                .read(authNotifierProvider.notifier)
                .signOut(ref);
            if (context.mounted && failure != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authFailureMessage(l10n, failure))),
              );
            }
            if (context.mounted) context.go('/login');
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.dangerSoft,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.danger.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsDeleteAccountTitle,
                style: AppText.bodyStrong.copyWith(color: c.danger),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.settingsDeleteAccountDesc,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: 12),
              PlanPalButton(
                label: l10n.btnDeleteAccount,
                variant: PlanPalButtonVariant.dangerOutline,
                onPressed: () => _confirmDeleteAccount(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.danger,
            ),
            child: Text(l10n.btnDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(apiClientProvider)
          .dio
          .delete('/me', data: {'confirmDelete': true});
      final signOutFailure = await ref
          .read(authNotifierProvider.notifier)
          .signOut(ref);
      if (signOutFailure != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authFailureMessage(l10n, signOutFailure))),
        );
      }
      if (context.mounted) context.go('/login');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }
    }
  }
}

// ── Mobile Profile Tab ────────────────────────────────────────────────────────
class _MobileProfileTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
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
                  Text(
                    name,
                    style: AppText.pageTitleMobile.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  Text(email, style: AppText.body.copyWith(color: c.textMuted)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: c.surfaceAlt,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          workspace?.name ?? l10n.navSettings,
                          style: AppText.caption.copyWith(color: c.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (perms.role != null) RoleBadge(role: perms.role!),
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
                    _ProfileRow(
                      icon: LucideIcons.users,
                      label: l10n.navTeam,
                      onTap: () => context.go('/team'),
                    ),
                  _ProfileRow(
                    icon: LucideIcons.fileText,
                    label: l10n.navDocuments,
                    onTap: () => context.go('/documents'),
                  ),
                  if (!perms.isGuest)
                    _ProfileRow(
                      icon: LucideIcons.barChart2,
                      label: l10n.navAnalytics,
                      onTap: () => context.go('/analytics'),
                    ),
                  _ProfileRow(
                    icon: LucideIcons.bell,
                    label: l10n.settingsNotifications,
                    onTap: () => context.push('/notifications'),
                  ),
                  _ProfileRow(
                    icon: LucideIcons.refreshCw,
                    label: l10n.settingsSyncStatus,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SyncStatusScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(LucideIcons.logOut, color: c.danger),
                    title: Text(
                      l10n.btnSignOut,
                      style: AppText.bodyMedium.copyWith(color: c.danger),
                    ),
                    trailing: Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: c.textMuted,
                    ),
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
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListTile(
      leading: Icon(icon, color: c.textMuted, size: 20),
      title: Text(
        label,
        style: AppText.bodyMedium.copyWith(color: c.textPrimary),
      ),
      trailing: Icon(LucideIcons.chevronRight, size: 16, color: c.textMuted),
      onTap: onTap,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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

// ── Workspace Section ─────────────────────────────────────────────────────────
class _WorkspaceSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_WorkspaceSection> createState() => _WorkspaceSectionState();
}

class _WorkspaceSectionState extends ConsumerState<_WorkspaceSection> {
  late TextEditingController _nameCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final workspace = ref.read(currentWorkspaceProvider);
    _nameCtrl = TextEditingController(text: workspace?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _rename() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final wsId = ref.read(currentWorkspaceIdProvider) ?? '';
    final (_, err) = await ref
        .read(workspaceRepositoryProvider)
        .renameWorkspace(wsId, name);
    if (err != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err.message)));
    } else if (mounted) {
      final l10n = AppLocalizations.of(context);
      ref.invalidate(workspacesProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workspaceSettings)));
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _leave() async {
    final l10n = AppLocalizations.of(context);
    final wsId = ref.read(currentWorkspaceIdProvider) ?? '';
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave workspace?'),
        content: const Text('You will lose access to this workspace.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.danger,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final err = await ref
        .read(workspaceRepositoryProvider)
        .leaveWorkspace(wsId, userId);
    if (err != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err.message)));
    } else if (mounted) {
      ref.read(currentWorkspaceIdProvider.notifier).clear();
      ref.invalidate(workspacesProvider);
      context.go('/home');
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final wsId = ref.read(currentWorkspaceIdProvider) ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.danger,
            ),
            child: Text(l10n.btnDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final err = await ref
        .read(workspaceRepositoryProvider)
        .deleteWorkspace(wsId);
    if (err != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err.message)));
    } else if (mounted) {
      ref.read(currentWorkspaceIdProvider.notifier).clear();
      ref.invalidate(workspacesProvider);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final perms = ref.watch(currentRolePermissionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsWorkspace,
          style: AppText.authTitle.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 24),
        if (perms.isAdmin) ...[
          Text(
            l10n.workspaceNameLabel,
            style: AppText.label.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              filled: true,
              fillColor: c.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.control),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          PlanPalButton(
            label: l10n.btnSave,
            onPressed: _rename,
            loading: _saving,
            width: double.infinity,
          ),
          const SizedBox(height: 24),
        ],
        // Leave workspace
        PlanPalButton(
          label: l10n.btnRemove,
          variant: PlanPalButtonVariant.outline,
          width: double.infinity,
          onPressed: _leave,
        ),
        if (perms.isAdmin) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.dangerSoft,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: c.danger.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsDeleteAccountTitle,
                  style: AppText.bodyStrong.copyWith(color: c.danger),
                ),
                const SizedBox(height: 8),
                Text(
                  'Permanently deletes the workspace and all its data.',
                  style: AppText.body.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: 12),
                PlanPalButton(
                  label: l10n.btnDelete,
                  variant: PlanPalButtonVariant.dangerOutline,
                  onPressed: _delete,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
