// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncLog _$SyncLogFromJson(Map<String, dynamic> json) {
  return _SyncLog.fromJson(json);
}

/// @nodoc
mixin _$SyncLog {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  SyncLogLevel get level => throw _privateConstructorUsedError;
  SyncLogType get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get entityType => throw _privateConstructorUsedError;
  String? get entityId => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  String? get errorDetails => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SyncLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncLogCopyWith<SyncLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncLogCopyWith<$Res> {
  factory $SyncLogCopyWith(SyncLog value, $Res Function(SyncLog) then) =
      _$SyncLogCopyWithImpl<$Res, SyncLog>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      SyncLogLevel level,
      SyncLogType type,
      String message,
      String? entityType,
      String? entityId,
      String? workspaceId,
      String? errorDetails,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SyncLogCopyWithImpl<$Res, $Val extends SyncLog>
    implements $SyncLogCopyWith<$Res> {
  _$SyncLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? level = null,
    Object? type = null,
    Object? message = null,
    Object? entityType = freezed,
    Object? entityId = freezed,
    Object? workspaceId = freezed,
    Object? errorDetails = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as SyncLogLevel,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SyncLogType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: freezed == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorDetails: freezed == errorDetails
          ? _value.errorDetails
          : errorDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncLogImplCopyWith<$Res> implements $SyncLogCopyWith<$Res> {
  factory _$$SyncLogImplCopyWith(
          _$SyncLogImpl value, $Res Function(_$SyncLogImpl) then) =
      __$$SyncLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      SyncLogLevel level,
      SyncLogType type,
      String message,
      String? entityType,
      String? entityId,
      String? workspaceId,
      String? errorDetails,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SyncLogImplCopyWithImpl<$Res>
    extends _$SyncLogCopyWithImpl<$Res, _$SyncLogImpl>
    implements _$$SyncLogImplCopyWith<$Res> {
  __$$SyncLogImplCopyWithImpl(
      _$SyncLogImpl _value, $Res Function(_$SyncLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? level = null,
    Object? type = null,
    Object? message = null,
    Object? entityType = freezed,
    Object? entityId = freezed,
    Object? workspaceId = freezed,
    Object? errorDetails = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SyncLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as SyncLogLevel,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SyncLogType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: freezed == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorDetails: freezed == errorDetails
          ? _value.errorDetails
          : errorDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncLogImpl implements _SyncLog {
  const _$SyncLogImpl(
      {required this.id,
      required this.timestamp,
      required this.level,
      required this.type,
      required this.message,
      this.entityType,
      this.entityId,
      this.workspaceId,
      this.errorDetails,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$SyncLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncLogImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final SyncLogLevel level;
  @override
  final SyncLogType type;
  @override
  final String message;
  @override
  final String? entityType;
  @override
  final String? entityId;
  @override
  final String? workspaceId;
  @override
  final String? errorDetails;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SyncLog(id: $id, timestamp: $timestamp, level: $level, type: $type, message: $message, entityType: $entityType, entityId: $entityId, workspaceId: $workspaceId, errorDetails: $errorDetails, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.errorDetails, errorDetails) ||
                other.errorDetails == errorDetails) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      timestamp,
      level,
      type,
      message,
      entityType,
      entityId,
      workspaceId,
      errorDetails,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SyncLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncLogImplCopyWith<_$SyncLogImpl> get copyWith =>
      __$$SyncLogImplCopyWithImpl<_$SyncLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncLogImplToJson(
      this,
    );
  }
}

abstract class _SyncLog implements SyncLog {
  const factory _SyncLog(
      {required final String id,
      required final DateTime timestamp,
      required final SyncLogLevel level,
      required final SyncLogType type,
      required final String message,
      final String? entityType,
      final String? entityId,
      final String? workspaceId,
      final String? errorDetails,
      final Map<String, dynamic>? metadata}) = _$SyncLogImpl;

  factory _SyncLog.fromJson(Map<String, dynamic> json) = _$SyncLogImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  SyncLogLevel get level;
  @override
  SyncLogType get type;
  @override
  String get message;
  @override
  String? get entityType;
  @override
  String? get entityId;
  @override
  String? get workspaceId;
  @override
  String? get errorDetails;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SyncLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncLogImplCopyWith<_$SyncLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
