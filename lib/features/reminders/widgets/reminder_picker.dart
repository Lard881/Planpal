import 'package:flutter/material.dart';
import '../models/reminder_type.dart';
import '../../../core/theme/app_colors.dart';

/// Reminder picker widget
class ReminderPicker extends StatefulWidget {
  final ReminderData initialReminder;
  final Function(ReminderData) onReminderSelected;

  const ReminderPicker({
    super.key,
    required this.initialReminder,
    required this.onReminderSelected,
  });

  @override
  State<ReminderPicker> createState() => _ReminderPickerState();
}

class _ReminderPickerState extends State<ReminderPicker> {
  late ReminderType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialReminder.type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Reminder',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.notifications_off),
            title: const Text('No reminder'),
            onTap: () {
              widget.onReminderSelected(const ReminderData.none());
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('15 minutes before'),
            onTap: () {
              widget.onReminderSelected(const ReminderData.relative(15));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('1 hour before'),
            onTap: () {
              widget.onReminderSelected(const ReminderData.relative(60));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('1 day before'),
            onTap: () {
              widget.onReminderSelected(const ReminderData.relative(1440));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Custom time...'),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null && mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null && mounted) {
                  final dateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                  widget.onReminderSelected(ReminderData.absolute(dateTime));
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
