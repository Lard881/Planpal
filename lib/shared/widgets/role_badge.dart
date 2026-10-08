import 'package:flutter/material.dart';

/// Role badge component
/// Shows Admin/Member/Guest with appropriate colors
class RoleBadge extends StatelessWidget {
  final String role; // 'admin', 'member', 'guest'
  final bool compact;

  const RoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getColor() {
      switch (role.toLowerCase()) {
        case 'admin':
          return const Color(0xFF8B5CF6); // Purple
        case 'member':
          return const Color(0xFF3B82F6); // Blue
        case 'guest':
        default:
          return const Color(0xFF64748B); // Gray
      }
    }

    String getLabel() {
      switch (role.toLowerCase()) {
        case 'admin':
          return 'Admin';
        case 'member':
          return 'Member';
        case 'guest':
        default:
          return 'Guest';
      }
    }

    IconData? getIcon() {
      switch (role.toLowerCase()) {
        case 'admin':
          return Icons.shield;
        case 'member':
          return Icons.person;
        case 'guest':
        default:
          return Icons.visibility;
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
