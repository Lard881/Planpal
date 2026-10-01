import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Provider for the app database singleton
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  
  // Close database when provider is disposed
  ref.onDispose(() {
    database.close();
  });
  
  return database;
});

/// Provider for unsynced items count
final unsyncedCountProvider = StreamProvider<int>((ref) {
  final database = ref.watch(appDatabaseProvider);
  
  // Watch for changes and recompute count
  return Stream.periodic(const Duration(seconds: 5), (_) async {
    return await database.getUnsyncedCount();
  }).asyncMap((event) => event);
});

/// Provider for sync state
final syncStateProvider = StreamProvider.family<SyncState?, String>((ref, entityType) {
  final database = ref.watch(appDatabaseProvider);
  
  return Stream.periodic(const Duration(seconds: 2), (_) async {
    return await database.getSyncState(entityType);
  }).asyncMap((event) => event);
});

/// Provider for pending operations count
final pendingOperationsCountProvider = StreamProvider<int>((ref) {
  final database = ref.watch(appDatabaseProvider);
  
  return Stream.periodic(const Duration(seconds: 2), (_) async {
    final operations = await database.getAllPendingOperations();
    return operations.length;
  }).asyncMap((event) => event);
});
