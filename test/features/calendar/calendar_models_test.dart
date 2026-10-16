import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/calendar/models/event_model.dart';

void main() {
  group('calendar models', () {
    test('parses event attendees returned with profile joins', () {
      final event = EventModel.fromJson({
        'id': 'event-1',
        'workspace_id': 'workspace-1',
        'title': 'Planning',
        'starts_at': '2026-07-14T09:00:00.000Z',
        'ends_at': '2026-07-14T10:00:00.000Z',
        'created_by': 'user-1',
        'reminder_minutes_before': 30,
        'event_attendees': [
          {
            'user_id': 'user-2',
            'profiles': {'full_name': 'Alex Example'},
          },
        ],
      });

      expect(event.attendeeIds, ['user-2']);
      expect(event.attendeeNames, ['Alex Example']);
      expect(event.reminderMinutesBefore, 30);
      expect(event.startsAt.isUtc, isFalse);
    });

    test('parses due-task range rows', () {
      final task = DueTaskModel.fromJson({
        'id': 'task-1',
        'title': 'Prepare agenda',
        'due_at': '2026-07-14T09:00:00.000Z',
        'status': 'todo',
        'priority': 'high',
      });

      expect(task.id, 'task-1');
      expect(task.title, 'Prepare agenda');
      expect(task.status, 'todo');
      expect(task.priority, 'high');
      expect(task.dueAt.isUtc, isFalse);
    });
  });
}
