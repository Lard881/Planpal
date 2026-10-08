import 'package:flutter/material.dart';
import 'avatar.dart';
import 'priority_chip.dart';
import 'status_chip.dart';

/// Task row component for desktop table view and mobile list
/// Shows complete task information in a row/tile format
class TaskRow extends StatelessWidget {
  final String id;
  final String title;
  final String? assigneeName;
  final String? assigneeAvatar;
  final DateTime? dueDate;
  final String priority;
  final String status;
  final bool isCompleted;
  final bool isDesktop;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final bool isSelected;

  const TaskRow({
    super.key,
    required this.id,
    required this.title,
    this.assigneeName,
    this.assigneeAvatar,
    this.dueDate,
    required this.priority,
    required this.status,
    this.isCompleted = false,
    this.isDesktop = false,
    this.onTap,
    this.onToggleComplete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopRow(context);
    }
    return _buildMobileTile(context);
  }

  Widget _buildDesktopRow(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : null,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: isCompleted,
              onChanged: (value) => onToggleComplete?.call(),
            ),

            // Task name
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Assignee
            Expanded(
              flex: 2,
              child: assigneeName != null
                  ? Row(
                      children: [
                        Avatar(
                          imageUrl: assigneeAvatar,
                          name: assigneeName!,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            assigneeName!,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : const Text('-', style: TextStyle(fontSize: 14)),
            ),

            // Due date
            Expanded(
              flex: 2,
              child: dueDate != null
                  ? Text(
                      '${dueDate!.month}/${dueDate!.day}/${dueDate!.year}',
                      style: const TextStyle(fontSize: 14),
                    )
                  : const Text('-', style: TextStyle(fontSize: 14)),
            ),

            // Priority
            Expanded(
              flex: 1,
              child: PriorityChip(priority: priority),
            ),

            const SizedBox(width: 12),

            // Status
            Expanded(
              flex: 1,
              child: StatusChip(status: status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTile(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                    if (dueDate != null) ...[
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
                            '${dueDate!.month}/${dueDate!.day} ${dueDate!.hour}:${dueDate!.minute.toString().padLeft(2, '0')}',
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

              const SizedBox(width: 8),

              // Priority
              PriorityChip(priority: priority, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
