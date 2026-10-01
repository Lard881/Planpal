import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planpal/core/sync/sync_timestamps.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncTimestamps', () {
    late SyncTimestamps timestamps;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      timestamps = await SyncTimestamps.create();
    });

    test('should return null for entity with no sync history', () {
      final lastSync = timestamps.getLastSyncTime('tasks', 'workspace-1');
      expect(lastSync, isNull);
    });

    test('should store and retrieve sync timestamp', () async {
      final now = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      
      final retrieved = timestamps.getLastSyncTime('tasks', 'workspace-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.difference(now).abs().inSeconds, lessThan(1));
    });

    test('should handle multiple entity types', () async {
      final now = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      await timestamps.setLastSyncTime('projects', 'workspace-1', now);
      await timestamps.setLastSyncTime('comments', 'workspace-1', now);
      
      expect(timestamps.getLastSyncTime('tasks', 'workspace-1'), isNotNull);
      expect(timestamps.getLastSyncTime('projects', 'workspace-1'), isNotNull);
      expect(timestamps.getLastSyncTime('comments', 'workspace-1'), isNotNull);
    });

    test('should handle multiple workspaces', () async {
      final now = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      await timestamps.setLastSyncTime('tasks', 'workspace-2', now.add(const Duration(hours: 1)));
      
      final ws1Time = timestamps.getLastSyncTime('tasks', 'workspace-1');
      final ws2Time = timestamps.getLastSyncTime('tasks', 'workspace-2');
      
      expect(ws1Time, isNotNull);
      expect(ws2Time, isNotNull);
      expect(ws2Time!.isAfter(ws1Time!), true);
    });

    test('should determine if incremental sync is possible', () async {
      final now = DateTime.now();
      
      // No timestamp - can't use incremental
      expect(timestamps.canUseIncrementalSync('tasks', 'workspace-1'), false);
      
      // Recent timestamp - can use incremental
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      expect(timestamps.canUseIncrementalSync('tasks', 'workspace-1'), true);
      
      // Old timestamp (>7 days) - can't use incremental
      final oldTime = now.subtract(const Duration(days: 8));
      await timestamps.setLastSyncTime('projects', 'workspace-1', oldTime);
      expect(timestamps.canUseIncrementalSync('projects', 'workspace-1'), false);
    });

    test('should calculate time since last sync', () async {
      final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2));
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', twoHoursAgo);
      
      final timeSince = timestamps.getTimeSinceLastSync('tasks', 'workspace-1');
      expect(timeSince, isNotNull);
      expect(timeSince!.inHours, 2);
    });

    test('should return null time since for entity with no history', () {
      final timeSince = timestamps.getTimeSinceLastSync('tasks', 'workspace-1');
      expect(timeSince, isNull);
    });

    test('should clear workspace sync times', () async {
      final now = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      await timestamps.setLastSyncTime('projects', 'workspace-1', now);
      await timestamps.setLastSyncTime('tasks', 'workspace-2', now);
      
      await timestamps.clearWorkspaceSyncTimes('workspace-1');
      
      // workspace-1 times should be cleared
      expect(timestamps.getLastSyncTime('tasks', 'workspace-1'), isNull);
      expect(timestamps.getLastSyncTime('projects', 'workspace-1'), isNull);
      
      // workspace-2 times should remain
      expect(timestamps.getLastSyncTime('tasks', 'workspace-2'), isNotNull);
    });

    test('should persist timestamps across instances', () async {
      final now = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', now);
      
      // Create new instance
      final newInstance = await SyncTimestamps.create();
      
      final retrieved = newInstance.getLastSyncTime('tasks', 'workspace-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.difference(now).abs().inSeconds, lessThan(1));
    });

    test('should update existing timestamps', () async {
      final firstSync = DateTime.now().subtract(const Duration(hours: 1));
      final secondSync = DateTime.now();
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', firstSync);
      await timestamps.setLastSyncTime('tasks', 'workspace-1', secondSync);
      
      final retrieved = timestamps.getLastSyncTime('tasks', 'workspace-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.isAfter(firstSync), true);
      expect(retrieved.difference(secondSync).abs().inSeconds, lessThan(1));
    });

    test('should handle edge case of exactly 7 days', () async {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', sevenDaysAgo);
      
      // At exactly 7 days, should still allow incremental sync
      expect(timestamps.canUseIncrementalSync('tasks', 'workspace-1'), true);
    });

    test('should handle future timestamps gracefully', () async {
      final future = DateTime.now().add(const Duration(hours: 1));
      
      await timestamps.setLastSyncTime('tasks', 'workspace-1', future);
      
      final retrieved = timestamps.getLastSyncTime('tasks', 'workspace-1');
      expect(retrieved, isNotNull);
      
      // Can still use incremental sync
      expect(timestamps.canUseIncrementalSync('tasks', 'workspace-1'), true);
    });
  });
}
