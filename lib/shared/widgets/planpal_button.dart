import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ButtonType { primary, secondary, danger, text }

enum AppButtonVariant { filled, outlined, text }

class PlanPalButton extends StatelessWidget {
  final String? text;
  final String? label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final ButtonType type;
  final AppButtonVariant? variant;
  final Color? color;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool fullWidth;

  const PlanPalButton({
    super.key,
    this.text,
    this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.type = ButtonType.primary,
    this.variant,
    this.color,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.width,
    this.height,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = text ?? label ?? '';
    final isDark = theme.brightness == Brightness.dark;

    final bool effectivelyOutlined =
        isOutlined || variant == AppButtonVariant.outlined || type == ButtonType.secondary;
    final bool isTextBtn = variant == AppButtonVariant.text || type == ButtonType.text;
    final bool isDanger = type == ButtonType.danger;

    final Color primaryColor = color ??
        (isDanger
            ? (isDark ? AppColors.dangerDark : AppColors.danger)
            : (isDark ? AppColors.primaryDark : AppColors.primary));

    final effectiveBackgroundColor = backgroundColor ??
        (effectivelyOutlined || isTextBtn ? Colors.transparent : primaryColor);

    final effectiveForegroundColor = foregroundColor ??
        (effectivelyOutlined || isTextBtn ? primaryColor : Colors.white);

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20, color: effectiveForegroundColor),
            const SizedBox(width: 8),
          ],
          Text(
            displayText,
            style: theme.textTheme.labelLarge?.copyWith(
              color: effectiveForegroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (fullWidth) {
      child = Center(child: child);
    } else if (width != null || height != null) {
      child = SizedBox(
        width: width,
        height: height ?? 48,
        child: Center(child: child),
      );
    }

    Widget buttonWidget;
    if (isTextBtn) {
      buttonWidget = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: effectiveForegroundColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: child,
      );
    } else if (effectivelyOutlined) {
      buttonWidget = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: effectiveForegroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: child,
      );
    } else {
      buttonWidget = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: child,
      );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: buttonWidget);
    }

    return buttonWidget;
  }
}
