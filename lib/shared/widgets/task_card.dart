import 'package:flutter/material.dart';
import 'priority_chip.dart';
import 'status_chip.dart';

/// Task card component for Home screen
/// Compact card showing task overview
class TaskCard extends StatelessWidget {
  final String title;
  final String? dueTime;
  final String priority;
  final String status;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    super.key,
    required this.title,
    this.dueTime,
    required this.priority,
    required this.status,
    this.isCompleted = false,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: 2,
                    ),
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),

              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dueTime != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dueTime!,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Priority chip
              PriorityChip(priority: priority, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
