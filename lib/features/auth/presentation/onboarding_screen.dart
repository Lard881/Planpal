// app/lib/features/auth/presentation/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import 'widgets/auth_logo.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: isDesktop
            ? _buildDesktop(context, c)
            : _buildMobile(context, c),
      ),
    );
  }

  Widget _buildMobile(BuildContext context, PlanPalColors c) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const Center(child: AuthLogo()),
                const SizedBox(height: 32),
                Text('Where do you want\nto start?',
                  style: AppText.pageTitleMobile.copyWith(color: c.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('You can always switch or create more later.',
                  style: AppText.body.copyWith(color: c.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _OnboardingCard(
                  icon: LucideIcons.user,
                  iconBg: c.primarySoft,
                  iconColor: c.primary,
                  title: 'My Personal workspace',
                  subtitle: 'Private tasks and notes.',
                  onTap: () => context.go('/home'),
                ),
                const SizedBox(height: 12),
                _OnboardingCard(
                  icon: LucideIcons.users,
                  iconBg: c.violetSoft,
                  iconColor: c.violet,
                  title: 'Create or join a team',
                  subtitle: 'Share work with others.',
                  onTap: () => context.go('/workspace/create'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: TextButton(
            onPressed: () => context.go('/home'),
            child: Text('Skip for now',
              style: AppText.body.copyWith(color: c.textMuted)),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context, PlanPalColors c) {
    return Center(
      child: SizedBox(
        width: 640,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthLogo(),
            const SizedBox(height: 48),
            Text('Where do you want to start?',
              style: AppText.authTitle.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('You can always switch or create more later.',
              style: AppText.body.copyWith(color: c.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _OnboardingCard(
                    icon: LucideIcons.user,
                    iconBg: c.primarySoft,
                    iconColor: c.primary,
                    title: 'Continue with my Personal workspace',
                    subtitle: 'A calm private space for your own tasks and notes.',
                    actionLabel: 'Continue ->',
                    onTap: () => context.go('/home'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _OnboardingCard(
                    icon: LucideIcons.users,
                    iconBg: c.violetSoft,
                    iconColor: c.violet,
                    title: 'Create or join a team',
                    subtitle: 'Invite teammates, share tasks and chat together.',
                    actionLabel: 'Get started ->',
                    onTap: () => context.go('/workspace/create'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text('Skip for now',
                style: AppText.body.copyWith(color: c.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback onTap;

  const _OnboardingCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
          boxShadow: AppShadows.card(Brightness.light),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                    style: AppText.body.copyWith(color: c.textMuted)),
                  if (actionLabel != null) ...[
                    const SizedBox(height: 8),
                    Text(actionLabel!,
                      style: AppText.bodyMedium.copyWith(color: c.primary)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
