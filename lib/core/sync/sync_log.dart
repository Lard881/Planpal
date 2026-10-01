import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_log.freezed.dart';
part 'sync_log.g.dart';

/// Represents a single sync log entry
@freezed
class SyncLog with _$SyncLog {
  const factory SyncLog({
    required String id,
    required DateTime timestamp,
    required SyncLogLevel level,
    required SyncLogType type,
    required String message,
    String? entityType,
    String? entityId,
    String? workspaceId,
    String? errorDetails,
    Map<String, dynamic>? metadata,
  }) = _SyncLog;

  factory SyncLog.fromJson(Map<String, dynamic> json) => _$SyncLogFromJson(json);
}

/// Log level for sync operations
enum SyncLogLevel {
  debug,
  info,
  warning,
  error,
}

/// Type of sync operation being logged
enum SyncLogType {
  syncStart,
  syncComplete,
  syncFailed,
  pushOperation,
  pullOperation,
  conflictDetected,
  conflictResolved,
  queueOperation,
  realtimeEvent,
  networkError,
  databaseError,
  backgroundSync,
}

/// Extension for log level colors and icons
extension SyncLogLevelExtension on SyncLogLevel {
  String get label {
    switch (this) {
      case SyncLogLevel.debug:
        return 'Debug';
      case SyncLogLevel.info:
        return 'Info';
      case SyncLogLevel.warning:
        return 'Warning';
      case SyncLogLevel.error:
        return 'Error';
    }
  }

  /// Get color for the log level (Material color value)
  int get colorValue {
    switch (this) {
      case SyncLogLevel.debug:
        return 0xFF9E9E9E; // Grey
      case SyncLogLevel.info:
        return 0xFF2196F3; // Blue
      case SyncLogLevel.warning:
        return 0xFFFF9800; // Orange
      case SyncLogLevel.error:
        return 0xFFF44336; // Red
    }
  }
}

/// Extension for log type labels
extension SyncLogTypeExtension on SyncLogType {
  String get label {
    switch (this) {
      case SyncLogType.syncStart:
        return 'Sync Started';
      case SyncLogType.syncComplete:
        return 'Sync Complete';
      case SyncLogType.syncFailed:
        return 'Sync Failed';
      case SyncLogType.pushOperation:
        return 'Push Operation';
      case SyncLogType.pullOperation:
        return 'Pull Operation';
      case SyncLogType.conflictDetected:
        return 'Conflict Detected';
      case SyncLogType.conflictResolved:
        return 'Conflict Resolved';
      case SyncLogType.queueOperation:
        return 'Queue Operation';
      case SyncLogType.realtimeEvent:
        return 'Realtime Event';
      case SyncLogType.networkError:
        return 'Network Error';
      case SyncLogType.databaseError:
        return 'Database Error';
      case SyncLogType.backgroundSync:
        return 'Background Sync';
    }
  }
}
