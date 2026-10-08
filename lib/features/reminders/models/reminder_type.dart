/// Reminder type enum
enum ReminderType {
  none,
  absolute,
  relative,
}

/// Reminder data model
class ReminderData {
  final ReminderType type;
  final DateTime? absoluteTime;
  final int? minutesBefore;

  const ReminderData({
    required this.type,
    this.absoluteTime,
    this.minutesBefore,
  });

  const ReminderData.none()
      : type = ReminderType.none,
        absoluteTime = null,
        minutesBefore = null;

  const ReminderData.absolute(this.absoluteTime)
      : type = ReminderType.absolute,
        minutesBefore = null;

  const ReminderData.relative(this.minutesBefore)
      : type = ReminderType.relative,
        absoluteTime = null;

  @override
  String toString() {
    switch (type) {
      case ReminderType.none:
        return 'No reminder';
      case ReminderType.absolute:
        return 'Remind at ${absoluteTime?.toString() ?? "unknown"}';
      case ReminderType.relative:
        return 'Remind $minutesBefore minutes before';
    }
  }
}
