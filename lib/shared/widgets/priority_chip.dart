import 'package:flutter/material.dart';

/// Priority chip component
/// Shows High/Medium/Low with appropriate colors
class PriorityChip extends StatelessWidget {
  final String priority; // 'high', 'medium', 'low'
  final bool compact;

  const PriorityChip({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color getColor() {
      switch (priority.toLowerCase()) {
        case 'high':
        case 'urgent':
          return isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
        case 'medium':
          return isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
        case 'low':
        default:
          return isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
      }
    }

    String getLabel() {
      switch (priority.toLowerCase()) {
        case 'high':
        case 'urgent':
          return compact ? 'H' : 'High';
        case 'medium':
          return compact ? 'M' : 'Medium';
        case 'low':
        default:
          return compact ? 'L' : 'Low';
      }
    }

    final color = getColor();
    final label = getLabel();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
