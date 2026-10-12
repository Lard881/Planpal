// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardOverview _$DashboardOverviewFromJson(Map<String, dynamic> json) {
  return _DashboardOverview.fromJson(json);
}

/// @nodoc
mixin _$DashboardOverview {
  DashboardCounts get counts => throw _privateConstructorUsedError;
  int get productivityPercent => throw _privateConstructorUsedError;
  List<DailyDataPoint> get dailySeries => throw _privateConstructorUsedError;

  /// Serializes this DashboardOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardOverviewCopyWith<DashboardOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOverviewCopyWith<$Res> {
  factory $DashboardOverviewCopyWith(
          DashboardOverview value, $Res Function(DashboardOverview) then) =
      _$DashboardOverviewCopyWithImpl<$Res, DashboardOverview>;
  @useResult
  $Res call(
      {DashboardCounts counts,
      int productivityPercent,
      List<DailyDataPoint> dailySeries});

  $DashboardCountsCopyWith<$Res> get counts;
}

/// @nodoc
class _$DashboardOverviewCopyWithImpl<$Res, $Val extends DashboardOverview>
    implements $DashboardOverviewCopyWith<$Res> {
  _$DashboardOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? productivityPercent = null,
    Object? dailySeries = null,
  }) {
    return _then(_value.copyWith(
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as DashboardCounts,
      productivityPercent: null == productivityPercent
          ? _value.productivityPercent
          : productivityPercent // ignore: cast_nullable_to_non_nullable
              as int,
      dailySeries: null == dailySeries
          ? _value.dailySeries
          : dailySeries // ignore: cast_nullable_to_non_nullable
              as List<DailyDataPoint>,
    ) as $Val);
  }

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardCountsCopyWith<$Res> get counts {
    return $DashboardCountsCopyWith<$Res>(_value.counts, (value) {
      return _then(_value.copyWith(counts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardOverviewImplCopyWith<$Res>
    implements $DashboardOverviewCopyWith<$Res> {
  factory _$$DashboardOverviewImplCopyWith(_$DashboardOverviewImpl value,
          $Res Function(_$DashboardOverviewImpl) then) =
      __$$DashboardOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DashboardCounts counts,
      int productivityPercent,
      List<DailyDataPoint> dailySeries});

  @override
  $DashboardCountsCopyWith<$Res> get counts;
}

/// @nodoc
class __$$DashboardOverviewImplCopyWithImpl<$Res>
    extends _$DashboardOverviewCopyWithImpl<$Res, _$DashboardOverviewImpl>
    implements _$$DashboardOverviewImplCopyWith<$Res> {
  __$$DashboardOverviewImplCopyWithImpl(_$DashboardOverviewImpl _value,
      $Res Function(_$DashboardOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? productivityPercent = null,
    Object? dailySeries = null,
  }) {
    return _then(_$DashboardOverviewImpl(
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as DashboardCounts,
      productivityPercent: null == productivityPercent
          ? _value.productivityPercent
          : productivityPercent // ignore: cast_nullable_to_non_nullable
              as int,
      dailySeries: null == dailySeries
          ? _value._dailySeries
          : dailySeries // ignore: cast_nullable_to_non_nullable
              as List<DailyDataPoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardOverviewImpl implements _DashboardOverview {
  const _$DashboardOverviewImpl(
      {required this.counts,
      required this.productivityPercent,
      required final List<DailyDataPoint> dailySeries})
      : _dailySeries = dailySeries;

  factory _$DashboardOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardOverviewImplFromJson(json);

  @override
  final DashboardCounts counts;
  @override
  final int productivityPercent;
  final List<DailyDataPoint> _dailySeries;
  @override
  List<DailyDataPoint> get dailySeries {
    if (_dailySeries is EqualUnmodifiableListView) return _dailySeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailySeries);
  }

  @override
  String toString() {
    return 'DashboardOverview(counts: $counts, productivityPercent: $productivityPercent, dailySeries: $dailySeries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOverviewImpl &&
            (identical(other.counts, counts) || other.counts == counts) &&
            (identical(other.productivityPercent, productivityPercent) ||
                other.productivityPercent == productivityPercent) &&
            const DeepCollectionEquality()
                .equals(other._dailySeries, _dailySeries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, counts, productivityPercent,
      const DeepCollectionEquality().hash(_dailySeries));

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOverviewImplCopyWith<_$DashboardOverviewImpl> get copyWith =>
      __$$DashboardOverviewImplCopyWithImpl<_$DashboardOverviewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardOverviewImplToJson(
      this,
    );
  }
}

abstract class _DashboardOverview implements DashboardOverview {
  const factory _DashboardOverview(
          {required final DashboardCounts counts,
          required final int productivityPercent,
          required final List<DailyDataPoint> dailySeries}) =
      _$DashboardOverviewImpl;

  factory _DashboardOverview.fromJson(Map<String, dynamic> json) =
      _$DashboardOverviewImpl.fromJson;

  @override
  DashboardCounts get counts;
  @override
  int get productivityPercent;
  @override
  List<DailyDataPoint> get dailySeries;

  /// Create a copy of DashboardOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOverviewImplCopyWith<_$DashboardOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardCounts _$DashboardCountsFromJson(Map<String, dynamic> json) {
  return _DashboardCounts.fromJson(json);
}

/// @nodoc
mixin _$DashboardCounts {
  int get completed => throw _privateConstructorUsedError;
  int get inProgress => throw _privateConstructorUsedError;
  int get overdue => throw _privateConstructorUsedError;

  /// Serializes this DashboardCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardCountsCopyWith<DashboardCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardCountsCopyWith<$Res> {
  factory $DashboardCountsCopyWith(
          DashboardCounts value, $Res Function(DashboardCounts) then) =
      _$DashboardCountsCopyWithImpl<$Res, DashboardCounts>;
  @useResult
  $Res call({int completed, int inProgress, int overdue});
}

/// @nodoc
class _$DashboardCountsCopyWithImpl<$Res, $Val extends DashboardCounts>
    implements $DashboardCountsCopyWith<$Res> {
  _$DashboardCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? inProgress = null,
    Object? overdue = null,
  }) {
    return _then(_value.copyWith(
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as int,
      overdue: null == overdue
          ? _value.overdue
          : overdue // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardCountsImplCopyWith<$Res>
    implements $DashboardCountsCopyWith<$Res> {
  factory _$$DashboardCountsImplCopyWith(_$DashboardCountsImpl value,
          $Res Function(_$DashboardCountsImpl) then) =
      __$$DashboardCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int completed, int inProgress, int overdue});
}

/// @nodoc
class __$$DashboardCountsImplCopyWithImpl<$Res>
    extends _$DashboardCountsCopyWithImpl<$Res, _$DashboardCountsImpl>
    implements _$$DashboardCountsImplCopyWith<$Res> {
  __$$DashboardCountsImplCopyWithImpl(
      _$DashboardCountsImpl _value, $Res Function(_$DashboardCountsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? inProgress = null,
    Object? overdue = null,
  }) {
    return _then(_$DashboardCountsImpl(
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as int,
      overdue: null == overdue
          ? _value.overdue
          : overdue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardCountsImpl implements _DashboardCounts {
  const _$DashboardCountsImpl(
      {required this.completed,
      required this.inProgress,
      required this.overdue});

  factory _$DashboardCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardCountsImplFromJson(json);

  @override
  final int completed;
  @override
  final int inProgress;
  @override
  final int overdue;

  @override
  String toString() {
    return 'DashboardCounts(completed: $completed, inProgress: $inProgress, overdue: $overdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardCountsImpl &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.overdue, overdue) || other.overdue == overdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, completed, inProgress, overdue);

  /// Create a copy of DashboardCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardCountsImplCopyWith<_$DashboardCountsImpl> get copyWith =>
      __$$DashboardCountsImplCopyWithImpl<_$DashboardCountsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardCountsImplToJson(
      this,
    );
  }
}

abstract class _DashboardCounts implements DashboardCounts {
  const factory _DashboardCounts(
      {required final int completed,
      required final int inProgress,
      required final int overdue}) = _$DashboardCountsImpl;

  factory _DashboardCounts.fromJson(Map<String, dynamic> json) =
      _$DashboardCountsImpl.fromJson;

  @override
  int get completed;
  @override
  int get inProgress;
  @override
  int get overdue;

  /// Create a copy of DashboardCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardCountsImplCopyWith<_$DashboardCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyDataPoint _$DailyDataPointFromJson(Map<String, dynamic> json) {
  return _DailyDataPoint.fromJson(json);
}

/// @nodoc
mixin _$DailyDataPoint {
  String get date => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double get completionRate => throw _privateConstructorUsedError;

  /// Serializes this DailyDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyDataPointCopyWith<DailyDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyDataPointCopyWith<$Res> {
  factory $DailyDataPointCopyWith(
          DailyDataPoint value, $Res Function(DailyDataPoint) then) =
      _$DailyDataPointCopyWithImpl<$Res, DailyDataPoint>;
  @useResult
  $Res call(
      {String date,
      int completed,
      int created,
      @JsonKey(name: 'completion_rate') double completionRate});
}

/// @nodoc
class _$DailyDataPointCopyWithImpl<$Res, $Val extends DailyDataPoint>
    implements $DailyDataPointCopyWith<$Res> {
  _$DailyDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completed = null,
    Object? created = null,
    Object? completionRate = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyDataPointImplCopyWith<$Res>
    implements $DailyDataPointCopyWith<$Res> {
  factory _$$DailyDataPointImplCopyWith(_$DailyDataPointImpl value,
          $Res Function(_$DailyDataPointImpl) then) =
      __$$DailyDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      int completed,
      int created,
      @JsonKey(name: 'completion_rate') double completionRate});
}

/// @nodoc
class __$$DailyDataPointImplCopyWithImpl<$Res>
    extends _$DailyDataPointCopyWithImpl<$Res, _$DailyDataPointImpl>
    implements _$$DailyDataPointImplCopyWith<$Res> {
  __$$DailyDataPointImplCopyWithImpl(
      _$DailyDataPointImpl _value, $Res Function(_$DailyDataPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completed = null,
    Object? created = null,
    Object? completionRate = null,
  }) {
    return _then(_$DailyDataPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyDataPointImpl implements _DailyDataPoint {
  const _$DailyDataPointImpl(
      {required this.date,
      required this.completed,
      required this.created,
      @JsonKey(name: 'completion_rate') required this.completionRate});

  factory _$DailyDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyDataPointImplFromJson(json);

  @override
  final String date;
  @override
  final int completed;
  @override
  final int created;
  @override
  @JsonKey(name: 'completion_rate')
  final double completionRate;

  @override
  String toString() {
    return 'DailyDataPoint(date: $date, completed: $completed, created: $created, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, completed, created, completionRate);

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyDataPointImplCopyWith<_$DailyDataPointImpl> get copyWith =>
      __$$DailyDataPointImplCopyWithImpl<_$DailyDataPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyDataPointImplToJson(
      this,
    );
  }
}

abstract class _DailyDataPoint implements DailyDataPoint {
  const factory _DailyDataPoint(
      {required final String date,
      required final int completed,
      required final int created,
      @JsonKey(name: 'completion_rate')
      required final double completionRate}) = _$DailyDataPointImpl;

  factory _DailyDataPoint.fromJson(Map<String, dynamic> json) =
      _$DailyDataPointImpl.fromJson;

  @override
  String get date;
  @override
  int get completed;
  @override
  int get created;
  @override
  @JsonKey(name: 'completion_rate')
  double get completionRate;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyDataPointImplCopyWith<_$DailyDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
