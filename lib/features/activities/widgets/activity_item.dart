import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';

/// Widget displaying a single activity item in the timeline
class ActivityItem extends StatelessWidget {
  final Activity activity;
  final bool showUser;
  final bool compact;

  const ActivityItem({
    super.key,
    required this.activity,
    this.showUser = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 16,
        vertical: compact ? 4 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon/Avatar
          if (showUser)
            _buildAvatar(context)
          else
            _buildActionIcon(context),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity description
                _buildDescription(context),
                
                const SizedBox(height: 4),
                
                // Timestamp
                Text(
                  _formatTimestamp(activity.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
                
                // Changes details (if any)
                if (!compact && activity.changes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildChangesCard(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: compact ? 14 : 18,
      backgroundColor: _getActionColor(context).withValues(alpha: 0.2),
      backgroundImage: activity.user?.avatarUrl != null
          ? NetworkImage(activity.user!.avatarUrl!)
          : null,
      child: activity.user?.avatarUrl == null
          ? Text(
              activity.action.icon,
              style: TextStyle(fontSize: compact ? 10 : 12),
            )
          : null,
    );
  }

  Widget _buildActionIcon(BuildContext context) {
    return Container(
      width: compact ? 28 : 36,
      height: compact ? 28 : 36,
      decoration: BoxDecoration(
        color: _getActionColor(context).withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          activity.action.icon,
          style: TextStyle(fontSize: compact ? 14 : 16),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final userName = activity.user?.name ?? 'Someone';
    final actionText = activity.action.displayName;
    final entityName = _getEntityName();

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          if (showUser) ...[
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(text: actionText),
          if (entityName != null) ...[
            const TextSpan(text: ' '),
            TextSpan(
              text: entityName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChangesCard(BuildContext context) {
    final changes = <String>[];
    
    activity.changes.forEach((key, value) {
      if (value is Map && value.containsKey('from') && value.containsKey('to')) {
        changes.add('$key: ${value['from']} → ${value['to']}');
      } else {
        changes.add('$key: $value');
      }
    });

    if (changes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: changes.map((change) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  size: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    change,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String? _getEntityName() {
    switch (activity.entityType) {
      case ActivityEntityType.task:
        return activity.task?.title;
      case ActivityEntityType.project:
        return activity.project?.name;
      case ActivityEntityType.workspace:
        return activity.workspace?.name;
      case ActivityEntityType.comment:
        return 'a comment';
    }
  }

  Color _getActionColor(BuildContext context) {
    switch (activity.action) {
      case ActivityAction.created:
        return Colors.green;
      case ActivityAction.updated:
        return Colors.blue;
      case ActivityAction.deleted:
        return Colors.red;
      case ActivityAction.completed:
        return Colors.green;
      case ActivityAction.reopened:
        return Colors.orange;
      case ActivityAction.assigned:
      case ActivityAction.unassigned:
        return Colors.purple;
      case ActivityAction.statusChanged:
        return Colors.blue;
      case ActivityAction.priorityChanged:
        return Colors.orange;
      case ActivityAction.dueDateChanged:
        return Colors.teal;
      case ActivityAction.moved:
        return Colors.indigo;
      case ActivityAction.commented:
        return Colors.cyan;
      case ActivityAction.mentioned:
        return Colors.amber;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
