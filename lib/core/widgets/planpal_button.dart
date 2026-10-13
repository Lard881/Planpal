// app/lib/core/widgets/planpal_button.dart
// Primary, outline, soft, danger-outline variants. 44px forms, 40px toolbars.
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';

enum PlanPalButtonVariant { primary, outline, soft, dangerOutline }

class PlanPalButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PlanPalButtonVariant variant;
  final bool loading;
  final bool toolbar; // true = 40px height, false = 44px
  final IconData? icon;
  final double? width;

  const PlanPalButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = PlanPalButtonVariant.primary,
    this.loading = false,
    this.toolbar = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final h = toolbar ? 40.0 : 44.0;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.control),
    );

    Widget child = loading
        ? SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _fgColor(c),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: _fgColor(c)),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppText.bodyStrong.copyWith(color: _fgColor(c))),
            ],
          );

    final btn = SizedBox(
      height: h,
      width: width,
      child: _buildButton(context, c, shape, child),
    );

    return btn;
  }

  Widget _buildButton(BuildContext context, PlanPalColors c,
      RoundedRectangleBorder shape, Widget child) {
    switch (variant) {
      case PlanPalButtonVariant.primary:
        return FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: Colors.white,
            shape: shape,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
      case PlanPalButtonVariant.outline:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: c.textPrimary,
            side: BorderSide(color: c.border),
            shape: shape,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
      case PlanPalButtonVariant.soft:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: c.primarySoft,
            foregroundColor: c.primary,
            shape: shape,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
      case PlanPalButtonVariant.dangerOutline:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: c.danger,
            side: BorderSide(color: c.danger),
            shape: shape,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
    }
  }

  Color _fgColor(PlanPalColors c) {
    switch (variant) {
      case PlanPalButtonVariant.primary:
        return Colors.white;
      case PlanPalButtonVariant.outline:
        return c.textPrimary;
      case PlanPalButtonVariant.soft:
        return c.primary;
      case PlanPalButtonVariant.dangerOutline:
        return c.danger;
    }
  }
}
