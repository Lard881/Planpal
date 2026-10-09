import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/sync/outbox_service.dart';
import '../../../core/sync/sync_coordinator.dart';

/// Sync service provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return SyncService(
    database: database,
    apiClient: apiClient,
  );
});

/// Outbox service provider
final outboxServiceProvider = Provider<OutboxService>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return OutboxService(
    database: database,
    apiClient: apiClient,
  );
});

/// Sync coordinator provider
final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  
  return SyncCoordinator(
    syncService: syncService,
    outboxService: outboxService,
  );
});

/// Sync state data class
class SyncState {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final int pendingCount;
  final int failedCount;

  const SyncState({
    required this.isSyncing,
    this.lastSyncTime,
    required this.pendingCount,
    required this.failedCount,
  });

  SyncState copyWith({
    bool? isSyncing,
    DateTime? lastSyncTime,
    int? pendingCount,
    int? failedCount,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
    );
  }
}

/// Sync state provider
final syncStateProvider = FutureProvider<SyncState>((ref) async {
  final coordinator = ref.watch(syncCoordinatorProvider);
  
  final pendingCount = await coordinator.getPendingCount();
  final failedCount = await coordinator.getFailedCount();
  
  return SyncState(
    isSyncing: coordinator.isSyncing,
    lastSyncTime: coordinator.lastSyncTime,
    pendingCount: pendingCount,
    failedCount: failedCount,
  );
});

/// Failed sync items provider
final failedSyncItemsProvider = FutureProvider<List<OutboxData>>((ref) async {
  final outboxService = ref.watch(outboxServiceProvider);
  return await outboxService.getFailedItems();
});

/// Pending count provider (for quick access)
final pendingCountProvider = FutureProvider<int>((ref) async {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return await coordinator.getPendingCount();
});

/// Failed count provider (for quick access)
final failedCountProvider = FutureProvider<int>((ref) async {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return await coordinator.getFailedCount();
});

/// Outbox items provider (all pending/failed items)
final outboxItemsProvider = FutureProvider<List<OutboxData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.select(database.outbox).get();
});
