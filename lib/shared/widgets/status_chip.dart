import 'package:flutter/material.dart';

/// Status chip component
/// Shows Todo/In Progress/Completed/Overdue with appropriate colors
class StatusChip extends StatelessWidget {
  final String status; // 'todo', 'in_progress', 'completed', 'overdue'
  final bool compact;

  const StatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color getColor() {
      switch (status.toLowerCase()) {
        case 'completed':
        case 'done':
          return isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
        case 'in_progress':
        case 'in progress':
        case 'inprogress':
          return isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
        case 'overdue':
          return isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
        case 'todo':
        case 'pending':
        default:
          return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
      }
    }

    String getLabel() {
      switch (status.toLowerCase()) {
        case 'completed':
        case 'done':
          return 'Completed';
        case 'in_progress':
        case 'in progress':
        case 'inprogress':
          return compact ? 'In Prog' : 'In Progress';
        case 'overdue':
          return 'Overdue';
        case 'todo':
        case 'pending':
        default:
          return 'Todo';
      }
    }

    IconData? getIcon() {
      switch (status.toLowerCase()) {
        case 'completed':
        case 'done':
          return Icons.check_circle;
        case 'in_progress':
        case 'in progress':
        case 'inprogress':
          return Icons.sync;
        case 'overdue':
          return Icons.warning;
        case 'todo':
        case 'pending':
        default:
          return Icons.circle_outlined;
      }
    }

    final color = getColor();
    final label = getLabel();
    final icon = getIcon();

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
          if (icon != null && !compact) ...[
            Icon(icon, size: 12, color: color),
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
