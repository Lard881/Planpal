// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsDashboard _$AnalyticsDashboardFromJson(Map<String, dynamic> json) {
  return _AnalyticsDashboard.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsDashboard {
  AnalyticsPeriod get period => throw _privateConstructorUsedError;
  TaskMetrics get taskMetrics => throw _privateConstructorUsedError;
  List<EventCount> get eventCounts => throw _privateConstructorUsedError;
  List<DailyActivity> get dailyActivity => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDashboardCopyWith<AnalyticsDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDashboardCopyWith<$Res> {
  factory $AnalyticsDashboardCopyWith(
          AnalyticsDashboard value, $Res Function(AnalyticsDashboard) then) =
      _$AnalyticsDashboardCopyWithImpl<$Res, AnalyticsDashboard>;
  @useResult
  $Res call(
      {AnalyticsPeriod period,
      TaskMetrics taskMetrics,
      List<EventCount> eventCounts,
      List<DailyActivity> dailyActivity,
      String? workspaceId});

  $AnalyticsPeriodCopyWith<$Res> get period;
  $TaskMetricsCopyWith<$Res> get taskMetrics;
}

/// @nodoc
class _$AnalyticsDashboardCopyWithImpl<$Res, $Val extends AnalyticsDashboard>
    implements $AnalyticsDashboardCopyWith<$Res> {
  _$AnalyticsDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? taskMetrics = null,
    Object? eventCounts = null,
    Object? dailyActivity = null,
    Object? workspaceId = freezed,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      taskMetrics: null == taskMetrics
          ? _value.taskMetrics
          : taskMetrics // ignore: cast_nullable_to_non_nullable
              as TaskMetrics,
      eventCounts: null == eventCounts
          ? _value.eventCounts
          : eventCounts // ignore: cast_nullable_to_non_nullable
              as List<EventCount>,
      dailyActivity: null == dailyActivity
          ? _value.dailyActivity
          : dailyActivity // ignore: cast_nullable_to_non_nullable
              as List<DailyActivity>,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsPeriodCopyWith<$Res> get period {
    return $AnalyticsPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskMetricsCopyWith<$Res> get taskMetrics {
    return $TaskMetricsCopyWith<$Res>(_value.taskMetrics, (value) {
      return _then(_value.copyWith(taskMetrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDashboardImplCopyWith<$Res>
    implements $AnalyticsDashboardCopyWith<$Res> {
  factory _$$AnalyticsDashboardImplCopyWith(_$AnalyticsDashboardImpl value,
          $Res Function(_$AnalyticsDashboardImpl) then) =
      __$$AnalyticsDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AnalyticsPeriod period,
      TaskMetrics taskMetrics,
      List<EventCount> eventCounts,
      List<DailyActivity> dailyActivity,
      String? workspaceId});

  @override
  $AnalyticsPeriodCopyWith<$Res> get period;
  @override
  $TaskMetricsCopyWith<$Res> get taskMetrics;
}

/// @nodoc
class __$$AnalyticsDashboardImplCopyWithImpl<$Res>
    extends _$AnalyticsDashboardCopyWithImpl<$Res, _$AnalyticsDashboardImpl>
    implements _$$AnalyticsDashboardImplCopyWith<$Res> {
  __$$AnalyticsDashboardImplCopyWithImpl(_$AnalyticsDashboardImpl _value,
      $Res Function(_$AnalyticsDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? taskMetrics = null,
    Object? eventCounts = null,
    Object? dailyActivity = null,
    Object? workspaceId = freezed,
  }) {
    return _then(_$AnalyticsDashboardImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      taskMetrics: null == taskMetrics
          ? _value.taskMetrics
          : taskMetrics // ignore: cast_nullable_to_non_nullable
              as TaskMetrics,
      eventCounts: null == eventCounts
          ? _value._eventCounts
          : eventCounts // ignore: cast_nullable_to_non_nullable
              as List<EventCount>,
      dailyActivity: null == dailyActivity
          ? _value._dailyActivity
          : dailyActivity // ignore: cast_nullable_to_non_nullable
              as List<DailyActivity>,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDashboardImpl implements _AnalyticsDashboard {
  const _$AnalyticsDashboardImpl(
      {required this.period,
      required this.taskMetrics,
      final List<EventCount> eventCounts = const [],
      final List<DailyActivity> dailyActivity = const [],
      this.workspaceId})
      : _eventCounts = eventCounts,
        _dailyActivity = dailyActivity;

  factory _$AnalyticsDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDashboardImplFromJson(json);

  @override
  final AnalyticsPeriod period;
  @override
  final TaskMetrics taskMetrics;
  final List<EventCount> _eventCounts;
  @override
  @JsonKey()
  List<EventCount> get eventCounts {
    if (_eventCounts is EqualUnmodifiableListView) return _eventCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventCounts);
  }

  final List<DailyActivity> _dailyActivity;
  @override
  @JsonKey()
  List<DailyActivity> get dailyActivity {
    if (_dailyActivity is EqualUnmodifiableListView) return _dailyActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyActivity);
  }

  @override
  final String? workspaceId;

  @override
  String toString() {
    return 'AnalyticsDashboard(period: $period, taskMetrics: $taskMetrics, eventCounts: $eventCounts, dailyActivity: $dailyActivity, workspaceId: $workspaceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDashboardImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.taskMetrics, taskMetrics) ||
                other.taskMetrics == taskMetrics) &&
            const DeepCollectionEquality()
                .equals(other._eventCounts, _eventCounts) &&
            const DeepCollectionEquality()
                .equals(other._dailyActivity, _dailyActivity) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      period,
      taskMetrics,
      const DeepCollectionEquality().hash(_eventCounts),
      const DeepCollectionEquality().hash(_dailyActivity),
      workspaceId);

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      __$$AnalyticsDashboardImplCopyWithImpl<_$AnalyticsDashboardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDashboardImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsDashboard implements AnalyticsDashboard {
  const factory _AnalyticsDashboard(
      {required final AnalyticsPeriod period,
      required final TaskMetrics taskMetrics,
      final List<EventCount> eventCounts,
      final List<DailyActivity> dailyActivity,
      final String? workspaceId}) = _$AnalyticsDashboardImpl;

  factory _AnalyticsDashboard.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDashboardImpl.fromJson;

  @override
  AnalyticsPeriod get period;
  @override
  TaskMetrics get taskMetrics;
  @override
  List<EventCount> get eventCounts;
  @override
  List<DailyActivity> get dailyActivity;
  @override
  String? get workspaceId;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsPeriod _$AnalyticsPeriodFromJson(Map<String, dynamic> json) {
  return _AnalyticsPeriod.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsPeriod {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsPeriodCopyWith<AnalyticsPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsPeriodCopyWith<$Res> {
  factory $AnalyticsPeriodCopyWith(
          AnalyticsPeriod value, $Res Function(AnalyticsPeriod) then) =
      _$AnalyticsPeriodCopyWithImpl<$Res, AnalyticsPeriod>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class _$AnalyticsPeriodCopyWithImpl<$Res, $Val extends AnalyticsPeriod>
    implements $AnalyticsPeriodCopyWith<$Res> {
  _$AnalyticsPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsPeriodImplCopyWith<$Res>
    implements $AnalyticsPeriodCopyWith<$Res> {
  factory _$$AnalyticsPeriodImplCopyWith(_$AnalyticsPeriodImpl value,
          $Res Function(_$AnalyticsPeriodImpl) then) =
      __$$AnalyticsPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$$AnalyticsPeriodImplCopyWithImpl<$Res>
    extends _$AnalyticsPeriodCopyWithImpl<$Res, _$AnalyticsPeriodImpl>
    implements _$$AnalyticsPeriodImplCopyWith<$Res> {
  __$$AnalyticsPeriodImplCopyWithImpl(
      _$AnalyticsPeriodImpl _value, $Res Function(_$AnalyticsPeriodImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$AnalyticsPeriodImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsPeriodImpl implements _AnalyticsPeriod {
  const _$AnalyticsPeriodImpl({required this.startDate, required this.endDate});

  factory _$AnalyticsPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsPeriodImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'AnalyticsPeriod(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsPeriodImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsPeriodImplCopyWith<_$AnalyticsPeriodImpl> get copyWith =>
      __$$AnalyticsPeriodImplCopyWithImpl<_$AnalyticsPeriodImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsPeriodImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsPeriod implements AnalyticsPeriod {
  const factory _AnalyticsPeriod(
      {required final DateTime startDate,
      required final DateTime endDate}) = _$AnalyticsPeriodImpl;

  factory _AnalyticsPeriod.fromJson(Map<String, dynamic> json) =
      _$AnalyticsPeriodImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsPeriodImplCopyWith<_$AnalyticsPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskMetrics _$TaskMetricsFromJson(Map<String, dynamic> json) {
  return _TaskMetrics.fromJson(json);
}

/// @nodoc
mixin _$TaskMetrics {
  int get totalCreated => throw _privateConstructorUsedError;
  int get totalCompleted => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  double get avgCompletionTimeHours => throw _privateConstructorUsedError;

  /// Serializes this TaskMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskMetricsCopyWith<TaskMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskMetricsCopyWith<$Res> {
  factory $TaskMetricsCopyWith(
          TaskMetrics value, $Res Function(TaskMetrics) then) =
      _$TaskMetricsCopyWithImpl<$Res, TaskMetrics>;
  @useResult
  $Res call(
      {int totalCreated,
      int totalCompleted,
      double completionRate,
      double avgCompletionTimeHours});
}

/// @nodoc
class _$TaskMetricsCopyWithImpl<$Res, $Val extends TaskMetrics>
    implements $TaskMetricsCopyWith<$Res> {
  _$TaskMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCreated = null,
    Object? totalCompleted = null,
    Object? completionRate = null,
    Object? avgCompletionTimeHours = null,
  }) {
    return _then(_value.copyWith(
      totalCreated: null == totalCreated
          ? _value.totalCreated
          : totalCreated // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompleted: null == totalCompleted
          ? _value.totalCompleted
          : totalCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletionTimeHours: null == avgCompletionTimeHours
          ? _value.avgCompletionTimeHours
          : avgCompletionTimeHours // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskMetricsImplCopyWith<$Res>
    implements $TaskMetricsCopyWith<$Res> {
  factory _$$TaskMetricsImplCopyWith(
          _$TaskMetricsImpl value, $Res Function(_$TaskMetricsImpl) then) =
      __$$TaskMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCreated,
      int totalCompleted,
      double completionRate,
      double avgCompletionTimeHours});
}

/// @nodoc
class __$$TaskMetricsImplCopyWithImpl<$Res>
    extends _$TaskMetricsCopyWithImpl<$Res, _$TaskMetricsImpl>
    implements _$$TaskMetricsImplCopyWith<$Res> {
  __$$TaskMetricsImplCopyWithImpl(
      _$TaskMetricsImpl _value, $Res Function(_$TaskMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCreated = null,
    Object? totalCompleted = null,
    Object? completionRate = null,
    Object? avgCompletionTimeHours = null,
  }) {
    return _then(_$TaskMetricsImpl(
      totalCreated: null == totalCreated
          ? _value.totalCreated
          : totalCreated // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompleted: null == totalCompleted
          ? _value.totalCompleted
          : totalCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletionTimeHours: null == avgCompletionTimeHours
          ? _value.avgCompletionTimeHours
          : avgCompletionTimeHours // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskMetricsImpl implements _TaskMetrics {
  const _$TaskMetricsImpl(
      {this.totalCreated = 0,
      this.totalCompleted = 0,
      this.completionRate = 0.0,
      this.avgCompletionTimeHours = 0.0});

  factory _$TaskMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskMetricsImplFromJson(json);

  @override
  @JsonKey()
  final int totalCreated;
  @override
  @JsonKey()
  final int totalCompleted;
  @override
  @JsonKey()
  final double completionRate;
  @override
  @JsonKey()
  final double avgCompletionTimeHours;

  @override
  String toString() {
    return 'TaskMetrics(totalCreated: $totalCreated, totalCompleted: $totalCompleted, completionRate: $completionRate, avgCompletionTimeHours: $avgCompletionTimeHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskMetricsImpl &&
            (identical(other.totalCreated, totalCreated) ||
                other.totalCreated == totalCreated) &&
            (identical(other.totalCompleted, totalCompleted) ||
                other.totalCompleted == totalCompleted) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.avgCompletionTimeHours, avgCompletionTimeHours) ||
                other.avgCompletionTimeHours == avgCompletionTimeHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalCreated, totalCompleted,
      completionRate, avgCompletionTimeHours);

  /// Create a copy of TaskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskMetricsImplCopyWith<_$TaskMetricsImpl> get copyWith =>
      __$$TaskMetricsImplCopyWithImpl<_$TaskMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskMetricsImplToJson(
      this,
    );
  }
}

abstract class _TaskMetrics implements TaskMetrics {
  const factory _TaskMetrics(
      {final int totalCreated,
      final int totalCompleted,
      final double completionRate,
      final double avgCompletionTimeHours}) = _$TaskMetricsImpl;

  factory _TaskMetrics.fromJson(Map<String, dynamic> json) =
      _$TaskMetricsImpl.fromJson;

  @override
  int get totalCreated;
  @override
  int get totalCompleted;
  @override
  double get completionRate;
  @override
  double get avgCompletionTimeHours;

  /// Create a copy of TaskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskMetricsImplCopyWith<_$TaskMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventCount _$EventCountFromJson(Map<String, dynamic> json) {
  return _EventCount.fromJson(json);
}

/// @nodoc
mixin _$EventCount {
  String get eventType => throw _privateConstructorUsedError;
  int get eventCount => throw _privateConstructorUsedError;

  /// Serializes this EventCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCountCopyWith<EventCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCountCopyWith<$Res> {
  factory $EventCountCopyWith(
          EventCount value, $Res Function(EventCount) then) =
      _$EventCountCopyWithImpl<$Res, EventCount>;
  @useResult
  $Res call({String eventType, int eventCount});
}

/// @nodoc
class _$EventCountCopyWithImpl<$Res, $Val extends EventCount>
    implements $EventCountCopyWith<$Res> {
  _$EventCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? eventCount = null,
  }) {
    return _then(_value.copyWith(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCountImplCopyWith<$Res>
    implements $EventCountCopyWith<$Res> {
  factory _$$EventCountImplCopyWith(
          _$EventCountImpl value, $Res Function(_$EventCountImpl) then) =
      __$$EventCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String eventType, int eventCount});
}

/// @nodoc
class __$$EventCountImplCopyWithImpl<$Res>
    extends _$EventCountCopyWithImpl<$Res, _$EventCountImpl>
    implements _$$EventCountImplCopyWith<$Res> {
  __$$EventCountImplCopyWithImpl(
      _$EventCountImpl _value, $Res Function(_$EventCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? eventCount = null,
  }) {
    return _then(_$EventCountImpl(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCountImpl implements _EventCount {
  const _$EventCountImpl({required this.eventType, required this.eventCount});

  factory _$EventCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCountImplFromJson(json);

  @override
  final String eventType;
  @override
  final int eventCount;

  @override
  String toString() {
    return 'EventCount(eventType: $eventType, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCountImpl &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventType, eventCount);

  /// Create a copy of EventCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCountImplCopyWith<_$EventCountImpl> get copyWith =>
      __$$EventCountImplCopyWithImpl<_$EventCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCountImplToJson(
      this,
    );
  }
}

abstract class _EventCount implements EventCount {
  const factory _EventCount(
      {required final String eventType,
      required final int eventCount}) = _$EventCountImpl;

  factory _EventCount.fromJson(Map<String, dynamic> json) =
      _$EventCountImpl.fromJson;

  @override
  String get eventType;
  @override
  int get eventCount;

  /// Create a copy of EventCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventCountImplCopyWith<_$EventCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyActivity _$DailyActivityFromJson(Map<String, dynamic> json) {
  return _DailyActivity.fromJson(json);
}

/// @nodoc
mixin _$DailyActivity {
  DateTime get activityDate => throw _privateConstructorUsedError;
  int get eventCount => throw _privateConstructorUsedError;

  /// Serializes this DailyActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyActivityCopyWith<DailyActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyActivityCopyWith<$Res> {
  factory $DailyActivityCopyWith(
          DailyActivity value, $Res Function(DailyActivity) then) =
      _$DailyActivityCopyWithImpl<$Res, DailyActivity>;
  @useResult
  $Res call({DateTime activityDate, int eventCount});
}

/// @nodoc
class _$DailyActivityCopyWithImpl<$Res, $Val extends DailyActivity>
    implements $DailyActivityCopyWith<$Res> {
  _$DailyActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityDate = null,
    Object? eventCount = null,
  }) {
    return _then(_value.copyWith(
      activityDate: null == activityDate
          ? _value.activityDate
          : activityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyActivityImplCopyWith<$Res>
    implements $DailyActivityCopyWith<$Res> {
  factory _$$DailyActivityImplCopyWith(
          _$DailyActivityImpl value, $Res Function(_$DailyActivityImpl) then) =
      __$$DailyActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime activityDate, int eventCount});
}

/// @nodoc
class __$$DailyActivityImplCopyWithImpl<$Res>
    extends _$DailyActivityCopyWithImpl<$Res, _$DailyActivityImpl>
    implements _$$DailyActivityImplCopyWith<$Res> {
  __$$DailyActivityImplCopyWithImpl(
      _$DailyActivityImpl _value, $Res Function(_$DailyActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityDate = null,
    Object? eventCount = null,
  }) {
    return _then(_$DailyActivityImpl(
      activityDate: null == activityDate
          ? _value.activityDate
          : activityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyActivityImpl implements _DailyActivity {
  const _$DailyActivityImpl(
      {required this.activityDate, required this.eventCount});

  factory _$DailyActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyActivityImplFromJson(json);

  @override
  final DateTime activityDate;
  @override
  final int eventCount;

  @override
  String toString() {
    return 'DailyActivity(activityDate: $activityDate, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyActivityImpl &&
            (identical(other.activityDate, activityDate) ||
                other.activityDate == activityDate) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, activityDate, eventCount);

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyActivityImplCopyWith<_$DailyActivityImpl> get copyWith =>
      __$$DailyActivityImplCopyWithImpl<_$DailyActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyActivityImplToJson(
      this,
    );
  }
}

abstract class _DailyActivity implements DailyActivity {
  const factory _DailyActivity(
      {required final DateTime activityDate,
      required final int eventCount}) = _$DailyActivityImpl;

  factory _DailyActivity.fromJson(Map<String, dynamic> json) =
      _$DailyActivityImpl.fromJson;

  @override
  DateTime get activityDate;
  @override
  int get eventCount;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyActivityImplCopyWith<_$DailyActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
