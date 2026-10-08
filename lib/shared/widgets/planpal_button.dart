import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PlanPalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const PlanPalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveBackgroundColor = backgroundColor ?? 
        (isOutlined ? Colors.transparent : AppColors.primary);
    
    final effectiveForegroundColor = foregroundColor ??
        (isOutlined ? AppColors.primary : Colors.white);

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
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: effectiveForegroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (width != null || height != null) {
      child = SizedBox(
        width: width,
        height: height ?? 48,
        child: Center(child: child),
      );
    }

    return isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide(color: effectiveForegroundColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: child,
          )
        : ElevatedButton(
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
}
