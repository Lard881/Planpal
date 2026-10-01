// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncLogImpl _$$SyncLogImplFromJson(Map<String, dynamic> json) =>
    _$SyncLogImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: $enumDecode(_$SyncLogLevelEnumMap, json['level']),
      type: $enumDecode(_$SyncLogTypeEnumMap, json['type']),
      message: json['message'] as String,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      workspaceId: json['workspaceId'] as String?,
      errorDetails: json['errorDetails'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SyncLogImplToJson(_$SyncLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'level': _$SyncLogLevelEnumMap[instance.level]!,
      'type': _$SyncLogTypeEnumMap[instance.type]!,
      'message': instance.message,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'workspaceId': instance.workspaceId,
      'errorDetails': instance.errorDetails,
      'metadata': instance.metadata,
    };

const _$SyncLogLevelEnumMap = {
  SyncLogLevel.debug: 'debug',
  SyncLogLevel.info: 'info',
  SyncLogLevel.warning: 'warning',
  SyncLogLevel.error: 'error',
};

const _$SyncLogTypeEnumMap = {
  SyncLogType.syncStart: 'syncStart',
  SyncLogType.syncComplete: 'syncComplete',
  SyncLogType.syncFailed: 'syncFailed',
  SyncLogType.pushOperation: 'pushOperation',
  SyncLogType.pullOperation: 'pullOperation',
  SyncLogType.conflictDetected: 'conflictDetected',
  SyncLogType.conflictResolved: 'conflictResolved',
  SyncLogType.queueOperation: 'queueOperation',
  SyncLogType.realtimeEvent: 'realtimeEvent',
  SyncLogType.networkError: 'networkError',
  SyncLogType.databaseError: 'databaseError',
  SyncLogType.backgroundSync: 'backgroundSync',
};
