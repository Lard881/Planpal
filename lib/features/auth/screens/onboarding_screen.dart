import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../shared/widgets/planpal_button.dart';

/// Onboarding screen
/// Shown after first login to help user choose between:
/// - Continue with Personal workspace (default)
/// - Create a team workspace
/// - Join a team workspace
/// 
/// This screen is skippable
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Icon(
                    Icons.workspace_premium_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Welcome to PlanPal!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  Text(
                    'Choose how you want to get started',
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Option 1: Continue with Personal
                  _OptionCard(
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    title: 'Continue with Personal',
                    description: 'Start using your personal workspace right away. Perfect for individual task management.',
                    onTap: () => _continueWithPersonal(context),
                  ),
                  const SizedBox(height: 16),

                  // Option 2: Create Team
                  _OptionCard(
                    icon: Icons.group_add_outlined,
                    iconColor: AppColors.success,
                    title: 'Create a Team',
                    description: 'Create a new team workspace to collaborate with others.',
                    onTap: () => _createTeam(context),
                  ),
                  const SizedBox(height: 16),

                  // Option 3: Join Team
                  _OptionCard(
                    icon: Icons.group_outlined,
                    iconColor: AppColors.warning,
                    title: 'Join a Team',
                    description: 'Use an invite code to join an existing team workspace.',
                    onTap: () => _joinTeam(context),
                  ),
                  const SizedBox(height: 32),

                  // Skip button
                  TextButton(
                    onPressed: () => _skip(context),
                    child: Text(
                      'Skip for now',
                      style: TextStyle(color: AppColors.grey600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _continueWithPersonal(BuildContext context) {
    // User chose to continue with their Personal workspace
    // Navigate to home - they're already set up with a Personal workspace
    context.go('/home');
  }

  void _createTeam(BuildContext context) {
    // Navigate to create workspace screen
    // After creation, will navigate to home
    context.push('/workspace/create').then((_) {
      // After creating workspace, go to home
      if (context.mounted) {
        context.go('/home');
      }
    });
  }

  void _joinTeam(BuildContext context) {
    // Navigate to join workspace screen
    // After joining, will navigate to home
    context.push('/workspace/join').then((_) {
      // After joining workspace, go to home
      if (context.mounted) {
        context.go('/home');
      }
    });
  }

  void _skip(BuildContext context) {
    // Skip onboarding, go directly to home with Personal workspace
    context.go('/home');
  }
}

/// Option card widget
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}
