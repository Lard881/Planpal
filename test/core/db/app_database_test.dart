import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';

void main() {
  test(
    'clearUserData removes events, attendees, and workspace cache',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime(2026, 7, 14);

      await database
          .into(database.workspaces)
          .insert(
            WorkspacesCompanion.insert(
              id: 'workspace-1',
              name: 'Workspace',
              type: 'team',
              createdBy: 'user-1',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.events)
          .insert(
            EventsCompanion.insert(
              id: 'event-1',
              workspaceId: 'workspace-1',
              title: 'Planning',
              startsAt: now,
              endsAt: now.add(const Duration(hours: 1)),
              createdBy: 'user-1',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.eventAttendees)
          .insert(
            EventAttendeesCompanion.insert(
              eventId: 'event-1',
              userId: 'user-2',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.clearUserData();

      expect(await database.select(database.events).get(), isEmpty);
      expect(await database.select(database.eventAttendees).get(), isEmpty);
      expect(await database.select(database.workspaces).get(), isEmpty);
    },
  );
}
