import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/planpal_chip.dart';
import '../../../core/db/app_database.dart';

/// Task list item widget
class TaskListTile extends StatelessWidget {
  final TaskData task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final bool showProject;

  const TaskListTile({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.showProject = true,
  });

  Color get _priorityColor {
    switch (task.priority?.toLowerCase()) {
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

  bool get _isCompleted => task.status == 'completed';
  
  bool get _isOverdue {
    if (task.dueDate == null || _isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isOverdue ? AppColors.error.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Checkbox
                  InkWell(
                    onTap: onToggleComplete,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isCompleted ? AppColors.success : AppColors.grey400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: _isCompleted ? AppColors.success : null,
                      ),
                      child: _isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: _isCompleted ? TextDecoration.lineThrough : null,
                        color: _isCompleted ? AppColors.grey500 : AppColors.grey900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Priority indicator
                  if (task.priority != null)
                    Container(
                      width: 4,
                      height: 24,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: _priorityColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),

              // Description
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    task.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                      decoration: _isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Footer: project, status, due date
              if (task.projectId != null || task.dueDate != null || task.status != 'todo') ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Project (if showing)
                      if (showProject && task.projectId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.folder, size: 14, color: AppColors.grey700),
                              const SizedBox(width: 4),
                              Text(
                                'Project', // TODO: Get project name from relation
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Status chip
                      if (task.status != 'todo')
                        StatusChip(status: task.status),

                      // Due date
                      if (task.dueDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isOverdue
                                ? AppColors.error.withOpacity(0.1)
                                : AppColors.grey100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: _isOverdue ? AppColors.error : AppColors.grey600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDueDate(task.dueDate!),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _isOverdue ? AppColors.error : AppColors.grey700,
                                  fontWeight: _isOverdue ? FontWeight.w600 : null,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
      final diff = today.difference(dateOnly).inDays;
      return _isOverdue ? '$diff days overdue' : '$diff days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
