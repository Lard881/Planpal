import 'package:flutter/material.dart';
import '../models/reminder_type.dart';
import '../../../core/theme/app_colors.dart';

/// Display reminder information
class ReminderDisplay extends StatelessWidget {
  final ReminderData reminder;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  const ReminderDisplay({
    super.key,
    required this.reminder,
    this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (reminder.type == ReminderType.none) {
      return ListTile(
        leading: const Icon(Icons.notifications_none, color: AppColors.grey400),
        title: const Text('No reminder set'),
        trailing: onTap != null ? const Icon(Icons.add) : null,
        onTap: onTap,
      );
    }

    return ListTile(
      leading: const Icon(Icons.notifications_active, color: AppColors.primary),
      title: Text(reminder.toString()),
      trailing: onClear != null
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClear,
            )
          : null,
      onTap: onTap,
    );
  }
}
