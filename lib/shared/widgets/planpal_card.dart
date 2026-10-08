import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable card widget with consistent styling
class PlanPalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;

  const PlanPalCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? 0.5,
      color: color,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}

/// Task card for displaying task items
class TaskCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? priority;
  final String? status;
  final DateTime? dueDate;
  final List<String>? labels;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    super.key,
    required this.title,
    this.description,
    this.priority,
    this.status,
    this.dueDate,
    this.labels,
    this.isCompleted = false,
    this.onTap,
    this.onToggleComplete,
  });

  Color get _priorityColor {
    switch (priority?.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = dueDate != null && 
        dueDate!.isBefore(DateTime.now()) && 
        !isCompleted;

    return PlanPalCard(
      onTap: onTap,
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
                      color: isCompleted ? AppColors.success : AppColors.grey400,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isCompleted ? AppColors.success : null,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              
              // Title
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? AppColors.grey500 : AppColors.grey900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Priority indicator
              if (priority != null)
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _priorityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
          
          // Description
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          
          // Footer: labels, due date
          if ((labels != null && labels!.isNotEmpty) || dueDate != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Row(
                children: [
                  // Labels
                  if (labels != null && labels!.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: labels!.take(3).map((label) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              label,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.grey700,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  
                  // Due date
                  if (dueDate != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isOverdue ? AppColors.error : AppColors.grey500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDueDate(dueDate!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOverdue ? AppColors.error : AppColors.grey600,
                            fontWeight: isOverdue ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
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
      return '$diff days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
