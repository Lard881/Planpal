import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'sync_log.dart';

/// Service for logging sync operations and errors
/// Maintains an in-memory circular buffer of recent logs
class SyncLogger {
  static const int _maxLogs = 500; // Keep last 500 logs
  static const int _maxErrorLogs = 100; // Keep last 100 error logs separately
  
  final _logs = Queue<SyncLog>();
  final _errorLogs = Queue<SyncLog>();
  final _uuid = const Uuid();
  
  final _logsController = StreamController<SyncLog>.broadcast();
  Stream<SyncLog> get logStream => _logsController.stream;
  
  final _errorLogsController = StreamController<SyncLog>.broadcast();
  Stream<SyncLog> get errorLogStream => _errorLogsController.stream;

  /// Log a sync operation
  void log({
    required SyncLogLevel level,
    required SyncLogType type,
    required String message,
    String? entityType,
    String? entityId,
    String? workspaceId,
    String? errorDetails,
    Map<String, dynamic>? metadata,
  }) {
    final logEntry = SyncLog(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      level: level,
      type: type,
      message: message,
      entityType: entityType,
      entityId: entityId,
      workspaceId: workspaceId,
      errorDetails: errorDetails,
      metadata: metadata,
    );

    // Add to main logs
    _logs.add(logEntry);
    if (_logs.length > _maxLogs) {
      _logs.removeFirst();
    }

    // Add to error logs if error or warning
    if (level == SyncLogLevel.error || level == SyncLogLevel.warning) {
      _errorLogs.add(logEntry);
      if (_errorLogs.length > _maxErrorLogs) {
        _errorLogs.removeFirst();
      }
      _errorLogsController.add(logEntry);
    }

    // Emit to stream
    _logsController.add(logEntry);

    // Print to console in debug mode
    if (kDebugMode) {
      final levelLabel = level.label.toUpperCase().padRight(7);
      final typeLabel = type.label.padRight(20);
      debugPrint('[$levelLabel] [$typeLabel] $message');
      if (errorDetails != null) {
        debugPrint('  Error: $errorDetails');
      }
      if (metadata != null && metadata.isNotEmpty) {
        debugPrint('  Metadata: $metadata');
      }
    }
  }

  /// Convenience methods for different log levels
  void debug(SyncLogType type, String message, {
    String? entityType,
    String? entityId,
    String? workspaceId,
    Map<String, dynamic>? metadata,
  }) {
    log(
      level: SyncLogLevel.debug,
      type: type,
      message: message,
      entityType: entityType,
      entityId: entityId,
      workspaceId: workspaceId,
      metadata: metadata,
    );
  }

  void info(SyncLogType type, String message, {
    String? entityType,
    String? entityId,
    String? workspaceId,
    Map<String, dynamic>? metadata,
  }) {
    log(
      level: SyncLogLevel.info,
      type: type,
      message: message,
      entityType: entityType,
      entityId: entityId,
      workspaceId: workspaceId,
      metadata: metadata,
    );
  }

  void warning(SyncLogType type, String message, {
    String? entityType,
    String? entityId,
    String? workspaceId,
    String? errorDetails,
    Map<String, dynamic>? metadata,
  }) {
    log(
      level: SyncLogLevel.warning,
      type: type,
      message: message,
      entityType: entityType,
      entityId: entityId,
      workspaceId: workspaceId,
      errorDetails: errorDetails,
      metadata: metadata,
    );
  }

  void error(SyncLogType type, String message, {
    String? entityType,
    String? entityId,
    String? workspaceId,
    String? errorDetails,
    Map<String, dynamic>? metadata,
  }) {
    log(
      level: SyncLogLevel.error,
      type: type,
      message: message,
      entityType: entityType,
      entityId: entityId,
      workspaceId: workspaceId,
      errorDetails: errorDetails,
      metadata: metadata,
    );
  }

  /// Get all logs
  List<SyncLog> getAllLogs() => _logs.toList();

  /// Get error and warning logs only
  List<SyncLog> getErrorLogs() => _errorLogs.toList();

  /// Get logs filtered by level
  List<SyncLog> getLogsByLevel(SyncLogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  /// Get logs filtered by type
  List<SyncLog> getLogsByType(SyncLogType type) {
    return _logs.where((log) => log.type == type).toList();
  }

  /// Get logs for a specific workspace
  List<SyncLog> getLogsByWorkspace(String workspaceId) {
    return _logs.where((log) => log.workspaceId == workspaceId).toList();
  }

  /// Get logs for a specific entity
  List<SyncLog> getLogsByEntity(String entityType, String entityId) {
    return _logs.where((log) => 
      log.entityType == entityType && log.entityId == entityId
    ).toList();
  }

  /// Get recent logs (last n entries)
  List<SyncLog> getRecentLogs({int count = 50}) {
    final logs = _logs.toList();
    final startIndex = logs.length > count ? logs.length - count : 0;
    return logs.sublist(startIndex);
  }

  /// Clear all logs
  void clearAllLogs() {
    _logs.clear();
    _errorLogs.clear();
    debugPrint('[SyncLogger] All logs cleared');
  }

  /// Clear error logs only
  void clearErrorLogs() {
    _errorLogs.clear();
    debugPrint('[SyncLogger] Error logs cleared');
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{};
    
    stats['totalLogs'] = _logs.length;
    stats['errorLogs'] = _errorLogs.length;
    
    // Count by level
    stats['debugCount'] = _logs.where((l) => l.level == SyncLogLevel.debug).length;
    stats['infoCount'] = _logs.where((l) => l.level == SyncLogLevel.info).length;
    stats['warningCount'] = _logs.where((l) => l.level == SyncLogLevel.warning).length;
    stats['errorCount'] = _logs.where((l) => l.level == SyncLogLevel.error).length;
    
    // Count by type
    for (final type in SyncLogType.values) {
      final count = _logs.where((l) => l.type == type).length;
      if (count > 0) {
        stats['${type.name}Count'] = count;
      }
    }
    
    return stats;
  }

  /// Dispose of the logger
  void dispose() {
    _logsController.close();
    _errorLogsController.close();
  }
}
