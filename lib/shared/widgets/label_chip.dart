import 'package:flutter/material.dart';

/// Label/Category chip component
/// Shows task labels with customizable colors
class LabelChip extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool compact;

  const LabelChip({
    super.key,
    required this.label,
    this.color,
    this.onTap,
    this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    final chip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: chipColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                size: compact ? 12 : 14,
                color: chipColor,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    return chip;
  }
}
