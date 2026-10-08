import 'package:flutter/material.dart';

/// Workspace switcher component (shared version)
/// Can be used in both sidebar and mobile header
class WorkspaceSwitcher extends StatelessWidget {
  final String currentWorkspaceName;
  final VoidCallback onTap;
  final bool compact;

  const WorkspaceSwitcher({
    super.key,
    required this.currentWorkspaceName,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Workspace avatar
            Container(
              width: compact ? 20 : 24,
              height: compact ? 20 : 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  currentWorkspaceName.isNotEmpty
                      ? currentWorkspaceName[0].toUpperCase()
                      : 'W',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              // Workspace name
              Flexible(
                child: Text(
                  currentWorkspaceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: compact ? 18 : 20,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
