import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Custom chip widget for labels, tags, and filters
class PlanPalChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool isSelected;

  const PlanPalChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.onDelete,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = isSelected
        ? (backgroundColor ?? AppColors.primary)
        : (backgroundColor ?? AppColors.grey100);
    final effectiveTextColor = isSelected
        ? Colors.white
        : (textColor ?? AppColors.grey700);

    return Material(
      color: effectiveBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: onDelete != null ? 8 : 12,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: effectiveTextColor),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: effectiveTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Priority chip with preset colors
class PriorityChip extends StatelessWidget {
  final String priority;
  final VoidCallback? onTap;

  const PriorityChip({
    super.key,
    required this.priority,
    this.onTap,
  });

  Color get _backgroundColor {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'medium':
        return AppColors.info;
      case 'low':
        return AppColors.grey400;
      default:
        return AppColors.grey300;
    }
  }

  IconData get _icon {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.priority_high;
      case 'high':
        return Icons.arrow_upward;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlanPalChip(
      label: priority,
      backgroundColor: _backgroundColor,
      textColor: Colors.white,
      icon: _icon,
      onTap: onTap,
    );
  }
}

/// Status chip with preset colors
class StatusChip extends StatelessWidget {
  final String status;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.status,
    this.onTap,
  });

  Color get _backgroundColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return AppColors.info;
      case 'blocked':
        return AppColors.error;
      case 'todo':
        return AppColors.grey400;
      default:
        return AppColors.grey300;
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.timelapse;
      case 'blocked':
        return Icons.block;
      case 'todo':
        return Icons.circle_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlanPalChip(
      label: status.replaceAll('_', ' ').toUpperCase(),
      backgroundColor: _backgroundColor,
      textColor: Colors.white,
      icon: _icon,
      onTap: onTap,
    );
  }
}
