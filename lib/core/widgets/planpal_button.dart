import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum ButtonType { primary, secondary, danger, text }

/// Reusable PlanPal button
class PlanPalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const PlanPalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
            foregroundColor:
                isDark ? AppColors.onPrimaryDark : AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusButton),
            ),
          ),
          child: _buildContent(context),
        );
        break;

      case ButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
            side: BorderSide(
              color: isDark ? AppColors.primaryDark : AppColors.primary,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusButton),
            ),
          ),
          child: _buildContent(context),
        );
        break;

      case ButtonType.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.dangerDark : AppColors.danger,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusButton),
            ),
          ),
          child: _buildContent(context),
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
          ),
          child: _buildContent(context),
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppTheme.spacing8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
