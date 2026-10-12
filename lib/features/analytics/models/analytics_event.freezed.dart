// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsEvent _$AnalyticsEventFromJson(Map<String, dynamic> json) {
  return _AnalyticsEvent.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsEvent {
  String? get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  AnalyticsEventType get eventType => throw _privateConstructorUsedError;
  Map<String, dynamic> get eventData => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsEventCopyWith<AnalyticsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsEventCopyWith<$Res> {
  factory $AnalyticsEventCopyWith(
          AnalyticsEvent value, $Res Function(AnalyticsEvent) then) =
      _$AnalyticsEventCopyWithImpl<$Res, AnalyticsEvent>;
  @useResult
  $Res call(
      {String? id,
      String userId,
      String? workspaceId,
      AnalyticsEventType eventType,
      Map<String, dynamic> eventData,
      DateTime? createdAt});
}

/// @nodoc
class _$AnalyticsEventCopyWithImpl<$Res, $Val extends AnalyticsEvent>
    implements $AnalyticsEventCopyWith<$Res> {
  _$AnalyticsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? workspaceId = freezed,
    Object? eventType = null,
    Object? eventData = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AnalyticsEventType,
      eventData: null == eventData
          ? _value.eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsEventImplCopyWith<$Res>
    implements $AnalyticsEventCopyWith<$Res> {
  factory _$$AnalyticsEventImplCopyWith(_$AnalyticsEventImpl value,
          $Res Function(_$AnalyticsEventImpl) then) =
      __$$AnalyticsEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String userId,
      String? workspaceId,
      AnalyticsEventType eventType,
      Map<String, dynamic> eventData,
      DateTime? createdAt});
}

/// @nodoc
class __$$AnalyticsEventImplCopyWithImpl<$Res>
    extends _$AnalyticsEventCopyWithImpl<$Res, _$AnalyticsEventImpl>
    implements _$$AnalyticsEventImplCopyWith<$Res> {
  __$$AnalyticsEventImplCopyWithImpl(
      _$AnalyticsEventImpl _value, $Res Function(_$AnalyticsEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? workspaceId = freezed,
    Object? eventType = null,
    Object? eventData = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$AnalyticsEventImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AnalyticsEventType,
      eventData: null == eventData
          ? _value._eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsEventImpl implements _AnalyticsEvent {
  const _$AnalyticsEventImpl(
      {this.id,
      required this.userId,
      this.workspaceId,
      required this.eventType,
      final Map<String, dynamic> eventData = const {},
      this.createdAt})
      : _eventData = eventData;

  factory _$AnalyticsEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsEventImplFromJson(json);

  @override
  final String? id;
  @override
  final String userId;
  @override
  final String? workspaceId;
  @override
  final AnalyticsEventType eventType;
  final Map<String, dynamic> _eventData;
  @override
  @JsonKey()
  Map<String, dynamic> get eventData {
    if (_eventData is EqualUnmodifiableMapView) return _eventData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eventData);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AnalyticsEvent(id: $id, userId: $userId, workspaceId: $workspaceId, eventType: $eventType, eventData: $eventData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other._eventData, _eventData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, workspaceId,
      eventType, const DeepCollectionEquality().hash(_eventData), createdAt);

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsEventImplCopyWith<_$AnalyticsEventImpl> get copyWith =>
      __$$AnalyticsEventImplCopyWithImpl<_$AnalyticsEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsEventImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsEvent implements AnalyticsEvent {
  const factory _AnalyticsEvent(
      {final String? id,
      required final String userId,
      final String? workspaceId,
      required final AnalyticsEventType eventType,
      final Map<String, dynamic> eventData,
      final DateTime? createdAt}) = _$AnalyticsEventImpl;

  factory _AnalyticsEvent.fromJson(Map<String, dynamic> json) =
      _$AnalyticsEventImpl.fromJson;

  @override
  String? get id;
  @override
  String get userId;
  @override
  String? get workspaceId;
  @override
  AnalyticsEventType get eventType;
  @override
  Map<String, dynamic> get eventData;
  @override
  DateTime? get createdAt;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsEventImplCopyWith<_$AnalyticsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsEventBatch _$AnalyticsEventBatchFromJson(Map<String, dynamic> json) {
  return _AnalyticsEventBatch.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsEventBatch {
  AnalyticsEventType get eventType => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  Map<String, dynamic> get eventData => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsEventBatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsEventBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsEventBatchCopyWith<AnalyticsEventBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsEventBatchCopyWith<$Res> {
  factory $AnalyticsEventBatchCopyWith(
          AnalyticsEventBatch value, $Res Function(AnalyticsEventBatch) then) =
      _$AnalyticsEventBatchCopyWithImpl<$Res, AnalyticsEventBatch>;
  @useResult
  $Res call(
      {AnalyticsEventType eventType,
      String? workspaceId,
      Map<String, dynamic> eventData,
      DateTime? createdAt});
}

/// @nodoc
class _$AnalyticsEventBatchCopyWithImpl<$Res, $Val extends AnalyticsEventBatch>
    implements $AnalyticsEventBatchCopyWith<$Res> {
  _$AnalyticsEventBatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsEventBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? workspaceId = freezed,
    Object? eventData = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AnalyticsEventType,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventData: null == eventData
          ? _value.eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsEventBatchImplCopyWith<$Res>
    implements $AnalyticsEventBatchCopyWith<$Res> {
  factory _$$AnalyticsEventBatchImplCopyWith(_$AnalyticsEventBatchImpl value,
          $Res Function(_$AnalyticsEventBatchImpl) then) =
      __$$AnalyticsEventBatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AnalyticsEventType eventType,
      String? workspaceId,
      Map<String, dynamic> eventData,
      DateTime? createdAt});
}

/// @nodoc
class __$$AnalyticsEventBatchImplCopyWithImpl<$Res>
    extends _$AnalyticsEventBatchCopyWithImpl<$Res, _$AnalyticsEventBatchImpl>
    implements _$$AnalyticsEventBatchImplCopyWith<$Res> {
  __$$AnalyticsEventBatchImplCopyWithImpl(_$AnalyticsEventBatchImpl _value,
      $Res Function(_$AnalyticsEventBatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsEventBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? workspaceId = freezed,
    Object? eventData = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$AnalyticsEventBatchImpl(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AnalyticsEventType,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventData: null == eventData
          ? _value._eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsEventBatchImpl implements _AnalyticsEventBatch {
  const _$AnalyticsEventBatchImpl(
      {required this.eventType,
      this.workspaceId,
      final Map<String, dynamic> eventData = const {},
      this.createdAt})
      : _eventData = eventData;

  factory _$AnalyticsEventBatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsEventBatchImplFromJson(json);

  @override
  final AnalyticsEventType eventType;
  @override
  final String? workspaceId;
  final Map<String, dynamic> _eventData;
  @override
  @JsonKey()
  Map<String, dynamic> get eventData {
    if (_eventData is EqualUnmodifiableMapView) return _eventData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eventData);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AnalyticsEventBatch(eventType: $eventType, workspaceId: $workspaceId, eventData: $eventData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsEventBatchImpl &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            const DeepCollectionEquality()
                .equals(other._eventData, _eventData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventType, workspaceId,
      const DeepCollectionEquality().hash(_eventData), createdAt);

  /// Create a copy of AnalyticsEventBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsEventBatchImplCopyWith<_$AnalyticsEventBatchImpl> get copyWith =>
      __$$AnalyticsEventBatchImplCopyWithImpl<_$AnalyticsEventBatchImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsEventBatchImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsEventBatch implements AnalyticsEventBatch {
  const factory _AnalyticsEventBatch(
      {required final AnalyticsEventType eventType,
      final String? workspaceId,
      final Map<String, dynamic> eventData,
      final DateTime? createdAt}) = _$AnalyticsEventBatchImpl;

  factory _AnalyticsEventBatch.fromJson(Map<String, dynamic> json) =
      _$AnalyticsEventBatchImpl.fromJson;

  @override
  AnalyticsEventType get eventType;
  @override
  String? get workspaceId;
  @override
  Map<String, dynamic> get eventData;
  @override
  DateTime? get createdAt;

  /// Create a copy of AnalyticsEventBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsEventBatchImplCopyWith<_$AnalyticsEventBatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
