import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import 'package:intl/intl.dart';

/// Task Tile widget for mobile list view (S7.14)
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = task.status == 'completed';
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !isCompleted;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Checkbox(
                value: isCompleted,
                onChanged: (_) => onToggleComplete(),
                shape: const CircleBorder(),
              ),

              const SizedBox(width: 8),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Metadata row
                    Row(
                      children: [
                        // Priority badge
                        _buildPriorityBadge(theme),

                        const SizedBox(width: 8),

                        // Due date
                        if (task.dueDate != null)
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isOverdue ? Colors.red : Colors.grey[600],
                          ),
                        if (task.dueDate != null) const SizedBox(width: 4),
                        if (task.dueDate != null)
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue ? Colors.red : Colors.grey[600],
                              fontWeight: isOverdue ? FontWeight.w600 : null,
                            ),
                          ),

                        const Spacer(),

                        // Status badge
                        _buildStatusBadge(theme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(ThemeData theme) {
    final color = _getPriorityColor(task.priority);
    final label = task.priority.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final color = _getStatusColor(task.status);
    final label = task.status.toUpperCase().replaceAll('_', ' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'todo':
        return Colors.orange;
      case 'backlog':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else if (dateOnly.isBefore(today)) {
      return 'Overdue';
    } else if (dateOnly.difference(today).inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
