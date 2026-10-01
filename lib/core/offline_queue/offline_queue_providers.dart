import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../database/database_providers.dart';
import 'offline_queue_manager.dart';

/// Offline queue manager provider
final offlineQueueManagerProvider = Provider<OfflineQueueManager>((ref) {
  final database = ref.watch(appDatabaseProvider);
  
  final manager = OfflineQueueManager(
    database: database,
    logger: Logger(),
  );
  
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});

/// Queue statistics stream provider
final queueStatsStreamProvider = StreamProvider<QueueStats>((ref) {
  final manager = ref.watch(offlineQueueManagerProvider);
  return manager.queueStatsStream;
});

/// Queue size provider
final queueSizeProvider = FutureProvider<int>((ref) async {
  final manager = ref.watch(offlineQueueManagerProvider);
  return await manager.getQueueSize();
});

/// Queue empty check provider
final isQueueEmptyProvider = FutureProvider<bool>((ref) async {
  final manager = ref.watch(offlineQueueManagerProvider);
  return await manager.isEmpty();
});

/// Has failed operations provider
final hasFailedOperationsProvider = FutureProvider<bool>((ref) async {
  final manager = ref.watch(offlineQueueManagerProvider);
  return await manager.hasFailedOperations();
});

/// All pending operations provider
final allPendingOperationsProvider = FutureProvider<List<PendingOperation>>((ref) async {
  final manager = ref.watch(offlineQueueManagerProvider);
  return await manager.getAllOperations();
});

/// Operations by entity type provider
final operationsByTypeProvider = FutureProvider.family<List<PendingOperation>, String>(
  (ref, entityType) async {
    final manager = ref.watch(offlineQueueManagerProvider);
    return await manager.getOperationsByType(entityType);
  },
);

/// Operations by entity ID provider
final operationsByEntityIdProvider = FutureProvider.family<List<PendingOperation>, String>(
  (ref, entityId) async {
    final manager = ref.watch(offlineQueueManagerProvider);
    return await manager.getOperationsByEntityId(entityId);
  },
);
