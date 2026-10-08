import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/sync/sync_logger.dart';
import 'package:planpal/core/sync/sync_log.dart';

void main() {
  group('SyncLogger', () {
    late SyncLogger logger;

    setUp(() {
      logger = SyncLogger();
    });

    tearDown(() {
      logger.dispose();
    });

    test('should log messages with different levels', () {
      logger.d(SyncLogType.syncStart, 'Debug message');
      logger.i(SyncLogType.syncComplete, 'Info message');
      logger.w(SyncLogType.networkError, 'Warning message');
      logger.e(SyncLogType.syncFailed, 'Error message');

      final logs = logger.getAllLogs();
      expect(logs.length, 4);
      expect(logs[0].level, SyncLogLevel.debug);
      expect(logs[1].level, SyncLogLevel.info);
      expect(logs[2].level, SyncLogLevel.warning);
      expect(logs[3].level, SyncLogLevel.error);
    });

    test('should maintain separate error logs', () {
      logger.i(SyncLogType.syncStart, 'Info message');
      logger.e(SyncLogType.syncFailed, 'Error message');
      logger.w(SyncLogType.conflictDetected, 'Warning message');

      final errorLogs = logger.getErrorLogs();
      expect(errorLogs.length, 2); // Error + Warning
      expect(errorLogs.every((log) => 
        log.level == SyncLogLevel.error || log.level == SyncLogLevel.warning
      ), true);
    });

    test('should filter logs by level', () {
      logger.d(SyncLogType.syncStart, 'Debug 1');
      logger.i(SyncLogType.syncComplete, 'Info 1');
      logger.e(SyncLogType.syncFailed, 'Error 1');
      logger.i(SyncLogType.pullOperation, 'Info 2');

      final infoLogs = logger.getLogsByLevel(SyncLogLevel.info);
      expect(infoLogs.length, 2);
      expect(infoLogs.every((log) => log.level == SyncLogLevel.info), true);
    });

    test('should filter logs by type', () {
      logger.i(SyncLogType.syncStart, 'Sync start 1');
      logger.i(SyncLogType.syncComplete, 'Sync complete');
      logger.i(SyncLogType.syncStart, 'Sync start 2');

      final syncStartLogs = logger.getLogsByType(SyncLogType.syncStart);
      expect(syncStartLogs.length, 2);
      expect(syncStartLogs.every((log) => log.type == SyncLogType.syncStart), true);
    });

    test('should filter logs by workspace', () {
      logger.i(
        SyncLogType.syncStart,
        'Workspace 1 sync',
        workspaceId: 'workspace-1',
      );
      logger.i(
        SyncLogType.syncComplete,
        'Workspace 2 sync',
        workspaceId: 'workspace-2',
      );
      logger.i(
        SyncLogType.pushOperation,
        'Workspace 1 push',
        workspaceId: 'workspace-1',
      );

      final workspace1Logs = logger.getLogsByWorkspace('workspace-1');
      expect(workspace1Logs.length, 2);
      expect(workspace1Logs.every((log) => log.workspaceId == 'workspace-1'), true);
    });

    test('should filter logs by entity', () {
      logger.i(
        SyncLogType.pushOperation,
        'Task 1 sync',
        entityType: 'tasks',
        entityId: 'task-1',
      );
      logger.i(
        SyncLogType.pullOperation,
        'Project sync',
        entityType: 'projects',
        entityId: 'project-1',
      );
      logger.i(
        SyncLogType.conflictDetected,
        'Task 1 conflict',
        entityType: 'tasks',
        entityId: 'task-1',
      );

      final task1Logs = logger.getLogsByEntity('tasks', 'task-1');
      expect(task1Logs.length, 2);
      expect(task1Logs.every((log) => 
        log.entityType == 'tasks' && log.entityId == 'task-1'
      ), true);
    });

    test('should limit log buffer size', () {
      // Add more than max logs (500)
      for (int i = 0; i < 600; i++) {
        logger.i(SyncLogType.syncStart, 'Message $i');
      }

      final logs = logger.getAllLogs();
      expect(logs.length, 500); // Should be capped at 500
      
      // Should keep the most recent logs
      expect(logs.last.message, 'Message 599');
    });

    test('should limit error log buffer size', () {
      // Add more than max error logs (100)
      for (int i = 0; i < 150; i++) {
        logger.e(SyncLogType.syncFailed, 'Error $i');
      }

      final errorLogs = logger.getErrorLogs();
      expect(errorLogs.length, 100); // Should be capped at 100
      
      // Should keep the most recent errors
      expect(errorLogs.last.message, 'Error 149');
    });

    test('should get recent logs', () {
      for (int i = 0; i < 100; i++) {
        logger.i(SyncLogType.syncStart, 'Message $i');
      }

      final recent = logger.getRecentLogs(count: 10);
      expect(recent.length, 10);
      expect(recent.last.message, 'Message 99');
      expect(recent.first.message, 'Message 90');
    });

    test('should clear all logs', () {
      logger.i(SyncLogType.syncStart, 'Info');
      logger.e(SyncLogType.syncFailed, 'Error');
      
      expect(logger.getAllLogs().length, 2);
      expect(logger.getErrorLogs().length, 1);

      logger.clearAllLogs();
      
      expect(logger.getAllLogs().length, 0);
      expect(logger.getErrorLogs().length, 0);
    });

    test('should clear error logs only', () {
      logger.i(SyncLogType.syncStart, 'Info');
      logger.e(SyncLogType.syncFailed, 'Error');
      
      logger.clearErrorLogs();
      
      expect(logger.getAllLogs().length, 2); // All logs still there
      expect(logger.getErrorLogs().length, 0); // Error logs cleared
    });

    test('should provide accurate statistics', () {
      logger.d(SyncLogType.syncStart, 'Debug');
      logger.i(SyncLogType.syncComplete, 'Info 1');
      logger.i(SyncLogType.pullOperation, 'Info 2');
      logger.w(SyncLogType.networkError, 'Warning');
      logger.e(SyncLogType.syncFailed, 'Error');

      final stats = logger.getStatistics();
      expect(stats['totalLogs'], 5);
      expect(stats['debugCount'], 1);
      expect(stats['infoCount'], 2);
      expect(stats['warningCount'], 1);
      expect(stats['errorCount'], 1);
      expect(stats['errorLogs'], 2); // Warning + Error
    });

    test('should emit logs to stream', () async {
      final logs = <SyncLog>[];
      logger.logStream.listen((log) => logs.add(log));

      logger.i(SyncLogType.syncStart, 'Test message');
      
      // Give time for stream to emit
      await Future.delayed(const Duration(milliseconds: 10));
      
      expect(logs.length, 1);
      expect(logs.first.message, 'Test message');
    });

    test('should emit error logs to error stream', () async {
      final errorLogs = <SyncLog>[];
      logger.errorLogStream.listen((log) => errorLogs.add(log));

      logger.i(SyncLogType.syncStart, 'Info');
      logger.e(SyncLogType.syncFailed, 'Error');
      logger.w(SyncLogType.networkError, 'Warning');
      
      // Give time for stream to emit
      await Future.delayed(const Duration(milliseconds: 10));
      
      expect(errorLogs.length, 2); // Error + Warning
    });

    test('should store metadata', () {
      logger.i(
        SyncLogType.syncComplete,
        'Sync done',
        metadata: {
          'duration': 1500,
          'itemCount': 42,
          'type': 'incremental',
        },
      );

      final logs = logger.getAllLogs();
      expect(logs.first.metadata, isNotNull);
      expect(logs.first.metadata!['duration'], 1500);
      expect(logs.first.metadata!['itemCount'], 42);
    });

    test('should store error details', () {
      logger.e(
        SyncLogType.databaseError,
        'Database operation failed',
        errorDetails: 'SQLException: Connection timeout after 30 seconds',
      );

      final logs = logger.getAllLogs();
      expect(logs.first.errorDetails, isNotNull);
      expect(logs.first.errorDetails, contains('SQLException'));
    });
  });
}
