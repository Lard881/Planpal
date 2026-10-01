/// Types of reminders
enum ReminderType {
  /// No reminder set
  none,
  
  /// Relative reminder (X minutes before due date)
  relative,
  
  /// Absolute reminder (specific date/time)
  absolute,
}

/// Preset relative reminder options
enum RelativeReminderPreset {
  fifteenMinutes(15, '15 minutes before'),
  thirtyMinutes(30, '30 minutes before'),
  oneHour(60, '1 hour before'),
  twoHours(120, '2 hours before'),
  oneDay(1440, '1 day before'),
  twoDays(2880, '2 days before'),
  oneWeek(10080, '1 week before'),
  custom(-1, 'Custom');

  const RelativeReminderPreset(this.minutes, this.label);
  
  final int minutes;
  final String label;
  
  static RelativeReminderPreset? fromMinutes(int minutes) {
    try {
      return RelativeReminderPreset.values.firstWhere(
        (preset) => preset.minutes == minutes,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Helper class for reminder data
class ReminderData {
  final ReminderType type;
  final int? minutesBefore;
  final DateTime? reminderAt;
  
  const ReminderData({
    required this.type,
    this.minutesBefore,
    this.reminderAt,
  });
  
  const ReminderData.none()
      : type = ReminderType.none,
        minutesBefore = null,
        reminderAt = null;
  
  const ReminderData.relative(this.minutesBefore)
      : type = ReminderType.relative,
        reminderAt = null;
  
  const ReminderData.absolute(this.reminderAt)
      : type = ReminderType.absolute,
        minutesBefore = null;
  
  /// Calculate the actual reminder time
  DateTime? calculateReminderTime(DateTime? dueDate) {
    switch (type) {
      case ReminderType.none:
        return null;
      case ReminderType.relative:
        if (dueDate == null || minutesBefore == null) return null;
        return dueDate.subtract(Duration(minutes: minutesBefore!));
      case ReminderType.absolute:
        return reminderAt;
    }
  }
  
  /// Get display text for the reminder
  String getDisplayText(DateTime? dueDate) {
    switch (type) {
      case ReminderType.none:
        return 'No reminder';
      case ReminderType.relative:
        if (minutesBefore == null) return 'No reminder';
        final preset = RelativeReminderPreset.fromMinutes(minutesBefore!);
        if (preset != null && preset != RelativeReminderPreset.custom) {
          return preset.label;
        }
        return _formatMinutes(minutesBefore!);
      case ReminderType.absolute:
        if (reminderAt == null) return 'No reminder';
        return _formatDateTime(reminderAt!);
    }
  }
  
  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes minute${minutes == 1 ? '' : 's'} before';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return '$hours hour${hours == 1 ? '' : 's'} before';
    } else {
      final days = minutes ~/ 1440;
      return '$days day${days == 1 ? '' : 's'} before';
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow at ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${_getWeekday(dateTime)} at ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} at ${_formatTime(dateTime)}';
    }
  }
  
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
  
  String _getWeekday(DateTime dateTime) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[dateTime.weekday - 1];
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderData &&
          type == other.type &&
          minutesBefore == other.minutesBefore &&
          reminderAt == other.reminderAt;
  
  @override
  int get hashCode => Object.hash(type, minutesBefore, reminderAt);
}
