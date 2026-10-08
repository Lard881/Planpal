import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/db/app_database.dart';
import '../repositories/event_repository.dart';

/// S8.9-S8.10: Calendar providers with timezone handling
/// Event repository provider
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  final outbox = ref.watch(outboxServiceProvider);

  return EventRepository(
    database: db,
    apiClient: api,
    outboxService: outbox,
  );
});

/// Watch events in date range
final eventsInRangeProvider = StreamProvider.autoDispose.family<
    List<Event>,
    ({String workspaceId, DateTime from, DateTime to})>((ref, params) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.watchEvents(
    params.workspaceId,
    from: params.from,
    to: params.to,
  );
});

/// Current workspace ID (from workspace providers)
final currentWorkspaceIdProvider = Provider<String?>((ref) {
  return ref.watch(currentWorkspaceProvider)?.id;
});

/// Current workspace (placeholder)
final currentWorkspaceProvider = Provider<({String id, String name})?>((ref) {
  return null; // TODO: Get from workspace state
});
