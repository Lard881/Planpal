import 'package:flutter/material.dart';
import '../models/reminder_type.dart';

/// A widget that displays the current reminder setting
class ReminderDisplay extends StatelessWidget {
  final ReminderData reminder;
  final DateTime? taskDueDate;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool isEditing;

  const ReminderDisplay({
    Key? key,
    required this.reminder,
    this.taskDueDate,
    this.onTap,
    this.onClear,
    this.isEditing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasReminder = reminder.type != ReminderType.none;
    final reminderTime = reminder.calculateReminderTime(taskDueDate);

    return InkWell(
      onTap: isEditing ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasReminder
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(8),
          color: hasReminder
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              hasReminder ? Icons.notifications_active : Icons.notifications_off_outlined,
              color: hasReminder
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasReminder ? 'Reminder Set' : 'No Reminder',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: hasReminder
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.getDisplayText(taskDueDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (hasReminder && reminderTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Will notify at ${_formatFullDateTime(reminderTime)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (isEditing) ...[
              if (hasReminder && onClear != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClear,
                  tooltip: 'Clear reminder',
                ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatFullDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return 'in ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else if (difference.inDays < 1) {
      return 'in ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    }
    
    final date = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    
    return '$date at $hour:$minute $period';
  }
}

/// A compact chip version of the reminder display
class ReminderChip extends StatelessWidget {
  final ReminderData reminder;
  final DateTime? taskDueDate;
  final VoidCallback? onTap;

  const ReminderChip({
    Key? key,
    required this.reminder,
    this.taskDueDate,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reminder.type == ReminderType.none) {
      return const SizedBox.shrink();
    }

    return ActionChip(
      avatar: Icon(
        Icons.notifications_active,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        reminder.getDisplayText(taskDueDate),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }
}
