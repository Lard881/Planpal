// app/lib/core/providers/user_profile_provider.dart
// Calls GET /me after login to load backend profile, set theme/language,
// and identify the personal workspace ID.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../../features/workspaces/providers/workspace_providers.dart';

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String timezone;
  final String language;
  final String theme;
  final String? personalWorkspaceId;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.timezone = 'UTC',
    this.language = 'en',
    this.theme = 'system',
    this.personalWorkspaceId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) {
    final profile = j['profile'] as Map<String, dynamic>? ?? j;
    return UserProfile(
      id: profile['id'] as String? ?? '',
      fullName: profile['full_name'] as String? ?? '',
      email: profile['email'] as String? ?? '',
      avatarUrl: profile['avatar_url'] as String?,
      timezone: profile['timezone'] as String? ?? 'UTC',
      language: profile['language'] as String? ?? 'en',
      theme: profile['theme'] as String? ?? 'system',
      personalWorkspaceId: profile['personal_workspace_id'] as String?,
    );
  }
}

final meProvider = FutureProvider.autoDispose<UserProfile?>((ref) async {
  try {
    final res = await ref.watch(apiClientProvider).dio.get('/me');
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
});

/// Call this after every successful login/signup/Google sign-in.
/// Loads the profile, applies theme + language, sets personal workspace.
Future<void> loadMeAndApply(WidgetRef ref) async {
  try {
    final res = await ref.read(apiClientProvider).dio.get('/me');
    final profile =
        UserProfile.fromJson(res.data as Map<String, dynamic>);

    // Apply theme from profile
    final themeStr = profile.theme;
    ThemeMode mode;
    if (themeStr == 'light') {
      mode = ThemeMode.light;
    } else if (themeStr == 'dark') {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.system;
    }
    await ref.read(themeModeProvider.notifier).setTheme(mode);

    // Apply language from profile
    if (profile.language.isNotEmpty) {
      await ref.read(localeProvider.notifier).setLocale(
          Locale(profile.language));
    }

    // Set personal workspace if not already set
    final currentWs = ref.read(currentWorkspaceIdProvider);
    if (currentWs == null && profile.personalWorkspaceId != null) {
      await ref.read(currentWorkspaceIdProvider.notifier)
          .set(profile.personalWorkspaceId!);
    }
  } catch (_) {
    // Profile load failure is non-fatal — app still works
  }
}
