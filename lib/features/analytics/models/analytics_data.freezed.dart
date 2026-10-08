// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  AnalyticsSummary get summary => throw _privateConstructorUsedError;
  List<WeeklyData> get weekly => throw _privateConstructorUsedError;
  List<CategoryData> get categories => throw _privateConstructorUsedError;
  List<DailyData> get daily => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
          AnalyticsData value, $Res Function(AnalyticsData) then) =
      _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call(
      {AnalyticsSummary summary,
      List<WeeklyData> weekly,
      List<CategoryData> categories,
      List<DailyData> daily,
      int streak});

  $AnalyticsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? weekly = null,
    Object? categories = null,
    Object? daily = null,
    Object? streak = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as AnalyticsSummary,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as List<WeeklyData>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      daily: null == daily
          ? _value.daily
          : daily // ignore: cast_nullable_to_non_nullable
              as List<DailyData>,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsSummaryCopyWith<$Res> get summary {
    return $AnalyticsSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
          _$AnalyticsDataImpl value, $Res Function(_$AnalyticsDataImpl) then) =
      __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AnalyticsSummary summary,
      List<WeeklyData> weekly,
      List<CategoryData> categories,
      List<DailyData> daily,
      int streak});

  @override
  $AnalyticsSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
      _$AnalyticsDataImpl _value, $Res Function(_$AnalyticsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? weekly = null,
    Object? categories = null,
    Object? daily = null,
    Object? streak = null,
  }) {
    return _then(_$AnalyticsDataImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as AnalyticsSummary,
      weekly: null == weekly
          ? _value._weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as List<WeeklyData>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      daily: null == daily
          ? _value._daily
          : daily // ignore: cast_nullable_to_non_nullable
              as List<DailyData>,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl(
      {required this.summary,
      required final List<WeeklyData> weekly,
      required final List<CategoryData> categories,
      required final List<DailyData> daily,
      required this.streak})
      : _weekly = weekly,
        _categories = categories,
        _daily = daily;

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  final AnalyticsSummary summary;
  final List<WeeklyData> _weekly;
  @override
  List<WeeklyData> get weekly {
    if (_weekly is EqualUnmodifiableListView) return _weekly;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekly);
  }

  final List<CategoryData> _categories;
  @override
  List<CategoryData> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<DailyData> _daily;
  @override
  List<DailyData> get daily {
    if (_daily is EqualUnmodifiableListView) return _daily;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daily);
  }

  @override
  final int streak;

  @override
  String toString() {
    return 'AnalyticsData(summary: $summary, weekly: $weekly, categories: $categories, daily: $daily, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._weekly, _weekly) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._daily, _daily) &&
            (identical(other.streak, streak) || other.streak == streak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_weekly),
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_daily),
      streak);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData(
      {required final AnalyticsSummary summary,
      required final List<WeeklyData> weekly,
      required final List<CategoryData> categories,
      required final List<DailyData> daily,
      required final int streak}) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  AnalyticsSummary get summary;
  @override
  List<WeeklyData> get weekly;
  @override
  List<CategoryData> get categories;
  @override
  List<DailyData> get daily;
  @override
  int get streak;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) {
  return _AnalyticsSummary.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsSummary {
  @JsonKey(name: 'total_completed')
  int get totalCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_created')
  int get totalCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double get completionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_time_rate')
  double get onTimeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_completion_time')
  double get avgCompletionTime => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsSummaryCopyWith<AnalyticsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsSummaryCopyWith<$Res> {
  factory $AnalyticsSummaryCopyWith(
          AnalyticsSummary value, $Res Function(AnalyticsSummary) then) =
      _$AnalyticsSummaryCopyWithImpl<$Res, AnalyticsSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_completed') int totalCompleted,
      @JsonKey(name: 'total_created') int totalCreated,
      @JsonKey(name: 'completion_rate') double completionRate,
      @JsonKey(name: 'on_time_rate') double onTimeRate,
      @JsonKey(name: 'avg_completion_time') double avgCompletionTime});
}

/// @nodoc
class _$AnalyticsSummaryCopyWithImpl<$Res, $Val extends AnalyticsSummary>
    implements $AnalyticsSummaryCopyWith<$Res> {
  _$AnalyticsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCompleted = null,
    Object? totalCreated = null,
    Object? completionRate = null,
    Object? onTimeRate = null,
    Object? avgCompletionTime = null,
  }) {
    return _then(_value.copyWith(
      totalCompleted: null == totalCompleted
          ? _value.totalCompleted
          : totalCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalCreated: null == totalCreated
          ? _value.totalCreated
          : totalCreated // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      onTimeRate: null == onTimeRate
          ? _value.onTimeRate
          : onTimeRate // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletionTime: null == avgCompletionTime
          ? _value.avgCompletionTime
          : avgCompletionTime // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsSummaryImplCopyWith<$Res>
    implements $AnalyticsSummaryCopyWith<$Res> {
  factory _$$AnalyticsSummaryImplCopyWith(_$AnalyticsSummaryImpl value,
          $Res Function(_$AnalyticsSummaryImpl) then) =
      __$$AnalyticsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_completed') int totalCompleted,
      @JsonKey(name: 'total_created') int totalCreated,
      @JsonKey(name: 'completion_rate') double completionRate,
      @JsonKey(name: 'on_time_rate') double onTimeRate,
      @JsonKey(name: 'avg_completion_time') double avgCompletionTime});
}

/// @nodoc
class __$$AnalyticsSummaryImplCopyWithImpl<$Res>
    extends _$AnalyticsSummaryCopyWithImpl<$Res, _$AnalyticsSummaryImpl>
    implements _$$AnalyticsSummaryImplCopyWith<$Res> {
  __$$AnalyticsSummaryImplCopyWithImpl(_$AnalyticsSummaryImpl _value,
      $Res Function(_$AnalyticsSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCompleted = null,
    Object? totalCreated = null,
    Object? completionRate = null,
    Object? onTimeRate = null,
    Object? avgCompletionTime = null,
  }) {
    return _then(_$AnalyticsSummaryImpl(
      totalCompleted: null == totalCompleted
          ? _value.totalCompleted
          : totalCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalCreated: null == totalCreated
          ? _value.totalCreated
          : totalCreated // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      onTimeRate: null == onTimeRate
          ? _value.onTimeRate
          : onTimeRate // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletionTime: null == avgCompletionTime
          ? _value.avgCompletionTime
          : avgCompletionTime // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsSummaryImpl implements _AnalyticsSummary {
  const _$AnalyticsSummaryImpl(
      {@JsonKey(name: 'total_completed') required this.totalCompleted,
      @JsonKey(name: 'total_created') required this.totalCreated,
      @JsonKey(name: 'completion_rate') required this.completionRate,
      @JsonKey(name: 'on_time_rate') required this.onTimeRate,
      @JsonKey(name: 'avg_completion_time') required this.avgCompletionTime});

  factory _$AnalyticsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_completed')
  final int totalCompleted;
  @override
  @JsonKey(name: 'total_created')
  final int totalCreated;
  @override
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  @override
  @JsonKey(name: 'on_time_rate')
  final double onTimeRate;
  @override
  @JsonKey(name: 'avg_completion_time')
  final double avgCompletionTime;

  @override
  String toString() {
    return 'AnalyticsSummary(totalCompleted: $totalCompleted, totalCreated: $totalCreated, completionRate: $completionRate, onTimeRate: $onTimeRate, avgCompletionTime: $avgCompletionTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsSummaryImpl &&
            (identical(other.totalCompleted, totalCompleted) ||
                other.totalCompleted == totalCompleted) &&
            (identical(other.totalCreated, totalCreated) ||
                other.totalCreated == totalCreated) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.onTimeRate, onTimeRate) ||
                other.onTimeRate == onTimeRate) &&
            (identical(other.avgCompletionTime, avgCompletionTime) ||
                other.avgCompletionTime == avgCompletionTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalCompleted, totalCreated,
      completionRate, onTimeRate, avgCompletionTime);

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      __$$AnalyticsSummaryImplCopyWithImpl<_$AnalyticsSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsSummaryImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsSummary implements AnalyticsSummary {
  const factory _AnalyticsSummary(
      {@JsonKey(name: 'total_completed') required final int totalCompleted,
      @JsonKey(name: 'total_created') required final int totalCreated,
      @JsonKey(name: 'completion_rate') required final double completionRate,
      @JsonKey(name: 'on_time_rate') required final double onTimeRate,
      @JsonKey(name: 'avg_completion_time')
      required final double avgCompletionTime}) = _$AnalyticsSummaryImpl;

  factory _AnalyticsSummary.fromJson(Map<String, dynamic> json) =
      _$AnalyticsSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_completed')
  int get totalCompleted;
  @override
  @JsonKey(name: 'total_created')
  int get totalCreated;
  @override
  @JsonKey(name: 'completion_rate')
  double get completionRate;
  @override
  @JsonKey(name: 'on_time_rate')
  double get onTimeRate;
  @override
  @JsonKey(name: 'avg_completion_time')
  double get avgCompletionTime;

  /// Create a copy of AnalyticsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsSummaryImplCopyWith<_$AnalyticsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyData _$WeeklyDataFromJson(Map<String, dynamic> json) {
  return _WeeklyData.fromJson(json);
}

/// @nodoc
mixin _$WeeklyData {
  @JsonKey(name: 'day_of_week')
  String get dayOfWeek => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get created => throw _privateConstructorUsedError;

  /// Serializes this WeeklyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyDataCopyWith<WeeklyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyDataCopyWith<$Res> {
  factory $WeeklyDataCopyWith(
          WeeklyData value, $Res Function(WeeklyData) then) =
      _$WeeklyDataCopyWithImpl<$Res, WeeklyData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'day_of_week') String dayOfWeek,
      int completed,
      int created});
}

/// @nodoc
class _$WeeklyDataCopyWithImpl<$Res, $Val extends WeeklyData>
    implements $WeeklyDataCopyWith<$Res> {
  _$WeeklyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? completed = null,
    Object? created = null,
  }) {
    return _then(_value.copyWith(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyDataImplCopyWith<$Res>
    implements $WeeklyDataCopyWith<$Res> {
  factory _$$WeeklyDataImplCopyWith(
          _$WeeklyDataImpl value, $Res Function(_$WeeklyDataImpl) then) =
      __$$WeeklyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'day_of_week') String dayOfWeek,
      int completed,
      int created});
}

/// @nodoc
class __$$WeeklyDataImplCopyWithImpl<$Res>
    extends _$WeeklyDataCopyWithImpl<$Res, _$WeeklyDataImpl>
    implements _$$WeeklyDataImplCopyWith<$Res> {
  __$$WeeklyDataImplCopyWithImpl(
      _$WeeklyDataImpl _value, $Res Function(_$WeeklyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? completed = null,
    Object? created = null,
  }) {
    return _then(_$WeeklyDataImpl(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyDataImpl implements _WeeklyData {
  const _$WeeklyDataImpl(
      {@JsonKey(name: 'day_of_week') required this.dayOfWeek,
      required this.completed,
      required this.created});

  factory _$WeeklyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyDataImplFromJson(json);

  @override
  @JsonKey(name: 'day_of_week')
  final String dayOfWeek;
  @override
  final int completed;
  @override
  final int created;

  @override
  String toString() {
    return 'WeeklyData(dayOfWeek: $dayOfWeek, completed: $completed, created: $created)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyDataImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.created, created) || other.created == created));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dayOfWeek, completed, created);

  /// Create a copy of WeeklyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyDataImplCopyWith<_$WeeklyDataImpl> get copyWith =>
      __$$WeeklyDataImplCopyWithImpl<_$WeeklyDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyDataImplToJson(
      this,
    );
  }
}

abstract class _WeeklyData implements WeeklyData {
  const factory _WeeklyData(
      {@JsonKey(name: 'day_of_week') required final String dayOfWeek,
      required final int completed,
      required final int created}) = _$WeeklyDataImpl;

  factory _WeeklyData.fromJson(Map<String, dynamic> json) =
      _$WeeklyDataImpl.fromJson;

  @override
  @JsonKey(name: 'day_of_week')
  String get dayOfWeek;
  @override
  int get completed;
  @override
  int get created;

  /// Create a copy of WeeklyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyDataImplCopyWith<_$WeeklyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) {
  return _CategoryData.fromJson(json);
}

/// @nodoc
mixin _$CategoryData {
  String get category => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this CategoryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDataCopyWith<CategoryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDataCopyWith<$Res> {
  factory $CategoryDataCopyWith(
          CategoryData value, $Res Function(CategoryData) then) =
      _$CategoryDataCopyWithImpl<$Res, CategoryData>;
  @useResult
  $Res call({String category, int completed, int total, double percentage});
}

/// @nodoc
class _$CategoryDataCopyWithImpl<$Res, $Val extends CategoryData>
    implements $CategoryDataCopyWith<$Res> {
  _$CategoryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? completed = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryDataImplCopyWith<$Res>
    implements $CategoryDataCopyWith<$Res> {
  factory _$$CategoryDataImplCopyWith(
          _$CategoryDataImpl value, $Res Function(_$CategoryDataImpl) then) =
      __$$CategoryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, int completed, int total, double percentage});
}

/// @nodoc
class __$$CategoryDataImplCopyWithImpl<$Res>
    extends _$CategoryDataCopyWithImpl<$Res, _$CategoryDataImpl>
    implements _$$CategoryDataImplCopyWith<$Res> {
  __$$CategoryDataImplCopyWithImpl(
      _$CategoryDataImpl _value, $Res Function(_$CategoryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? completed = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_$CategoryDataImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDataImpl implements _CategoryData {
  const _$CategoryDataImpl(
      {required this.category,
      required this.completed,
      required this.total,
      required this.percentage});

  factory _$CategoryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDataImplFromJson(json);

  @override
  final String category;
  @override
  final int completed;
  @override
  final int total;
  @override
  final double percentage;

  @override
  String toString() {
    return 'CategoryData(category: $category, completed: $completed, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDataImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, completed, total, percentage);

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDataImplCopyWith<_$CategoryDataImpl> get copyWith =>
      __$$CategoryDataImplCopyWithImpl<_$CategoryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDataImplToJson(
      this,
    );
  }
}

abstract class _CategoryData implements CategoryData {
  const factory _CategoryData(
      {required final String category,
      required final int completed,
      required final int total,
      required final double percentage}) = _$CategoryDataImpl;

  factory _CategoryData.fromJson(Map<String, dynamic> json) =
      _$CategoryDataImpl.fromJson;

  @override
  String get category;
  @override
  int get completed;
  @override
  int get total;
  @override
  double get percentage;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDataImplCopyWith<_$CategoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyData _$DailyDataFromJson(Map<String, dynamic> json) {
  return _DailyData.fromJson(json);
}

/// @nodoc
mixin _$DailyData {
  String get date => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double? get completionRate => throw _privateConstructorUsedError;

  /// Serializes this DailyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyDataCopyWith<DailyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyDataCopyWith<$Res> {
  factory $DailyDataCopyWith(DailyData value, $Res Function(DailyData) then) =
      _$DailyDataCopyWithImpl<$Res, DailyData>;
  @useResult
  $Res call(
      {String date,
      int completed,
      int created,
      @JsonKey(name: 'completion_rate') double? completionRate});
}

/// @nodoc
class _$DailyDataCopyWithImpl<$Res, $Val extends DailyData>
    implements $DailyDataCopyWith<$Res> {
  _$DailyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completed = null,
    Object? created = null,
    Object? completionRate = freezed,
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
      completionRate: freezed == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyDataImplCopyWith<$Res>
    implements $DailyDataCopyWith<$Res> {
  factory _$$DailyDataImplCopyWith(
          _$DailyDataImpl value, $Res Function(_$DailyDataImpl) then) =
      __$$DailyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      int completed,
      int created,
      @JsonKey(name: 'completion_rate') double? completionRate});
}

/// @nodoc
class __$$DailyDataImplCopyWithImpl<$Res>
    extends _$DailyDataCopyWithImpl<$Res, _$DailyDataImpl>
    implements _$$DailyDataImplCopyWith<$Res> {
  __$$DailyDataImplCopyWithImpl(
      _$DailyDataImpl _value, $Res Function(_$DailyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completed = null,
    Object? created = null,
    Object? completionRate = freezed,
  }) {
    return _then(_$DailyDataImpl(
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
      completionRate: freezed == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyDataImpl implements _DailyData {
  const _$DailyDataImpl(
      {required this.date,
      required this.completed,
      required this.created,
      @JsonKey(name: 'completion_rate') required this.completionRate});

  factory _$DailyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyDataImplFromJson(json);

  @override
  final String date;
  @override
  final int completed;
  @override
  final int created;
  @override
  @JsonKey(name: 'completion_rate')
  final double? completionRate;

  @override
  String toString() {
    return 'DailyData(date: $date, completed: $completed, created: $created, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyDataImpl &&
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

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyDataImplCopyWith<_$DailyDataImpl> get copyWith =>
      __$$DailyDataImplCopyWithImpl<_$DailyDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyDataImplToJson(
      this,
    );
  }
}

abstract class _DailyData implements DailyData {
  const factory _DailyData(
      {required final String date,
      required final int completed,
      required final int created,
      @JsonKey(name: 'completion_rate')
      required final double? completionRate}) = _$DailyDataImpl;

  factory _DailyData.fromJson(Map<String, dynamic> json) =
      _$DailyDataImpl.fromJson;

  @override
  String get date;
  @override
  int get completed;
  @override
  int get created;
  @override
  @JsonKey(name: 'completion_rate')
  double? get completionRate;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyDataImplCopyWith<_$DailyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverviewData _$OverviewDataFromJson(Map<String, dynamic> json) {
  return _OverviewData.fromJson(json);
}

/// @nodoc
mixin _$OverviewData {
  OverviewCounts get counts => throw _privateConstructorUsedError;
  @JsonKey(name: 'productivityPercent')
  double get productivityPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'dailySeries')
  List<DailyData> get dailySeries => throw _privateConstructorUsedError;

  /// Serializes this OverviewData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewDataCopyWith<OverviewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewDataCopyWith<$Res> {
  factory $OverviewDataCopyWith(
          OverviewData value, $Res Function(OverviewData) then) =
      _$OverviewDataCopyWithImpl<$Res, OverviewData>;
  @useResult
  $Res call(
      {OverviewCounts counts,
      @JsonKey(name: 'productivityPercent') double productivityPercent,
      @JsonKey(name: 'dailySeries') List<DailyData> dailySeries});

  $OverviewCountsCopyWith<$Res> get counts;
}

/// @nodoc
class _$OverviewDataCopyWithImpl<$Res, $Val extends OverviewData>
    implements $OverviewDataCopyWith<$Res> {
  _$OverviewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewData
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
              as OverviewCounts,
      productivityPercent: null == productivityPercent
          ? _value.productivityPercent
          : productivityPercent // ignore: cast_nullable_to_non_nullable
              as double,
      dailySeries: null == dailySeries
          ? _value.dailySeries
          : dailySeries // ignore: cast_nullable_to_non_nullable
              as List<DailyData>,
    ) as $Val);
  }

  /// Create a copy of OverviewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverviewCountsCopyWith<$Res> get counts {
    return $OverviewCountsCopyWith<$Res>(_value.counts, (value) {
      return _then(_value.copyWith(counts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OverviewDataImplCopyWith<$Res>
    implements $OverviewDataCopyWith<$Res> {
  factory _$$OverviewDataImplCopyWith(
          _$OverviewDataImpl value, $Res Function(_$OverviewDataImpl) then) =
      __$$OverviewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OverviewCounts counts,
      @JsonKey(name: 'productivityPercent') double productivityPercent,
      @JsonKey(name: 'dailySeries') List<DailyData> dailySeries});

  @override
  $OverviewCountsCopyWith<$Res> get counts;
}

/// @nodoc
class __$$OverviewDataImplCopyWithImpl<$Res>
    extends _$OverviewDataCopyWithImpl<$Res, _$OverviewDataImpl>
    implements _$$OverviewDataImplCopyWith<$Res> {
  __$$OverviewDataImplCopyWithImpl(
      _$OverviewDataImpl _value, $Res Function(_$OverviewDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? productivityPercent = null,
    Object? dailySeries = null,
  }) {
    return _then(_$OverviewDataImpl(
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as OverviewCounts,
      productivityPercent: null == productivityPercent
          ? _value.productivityPercent
          : productivityPercent // ignore: cast_nullable_to_non_nullable
              as double,
      dailySeries: null == dailySeries
          ? _value._dailySeries
          : dailySeries // ignore: cast_nullable_to_non_nullable
              as List<DailyData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewDataImpl implements _OverviewData {
  const _$OverviewDataImpl(
      {required this.counts,
      @JsonKey(name: 'productivityPercent') required this.productivityPercent,
      @JsonKey(name: 'dailySeries') required final List<DailyData> dailySeries})
      : _dailySeries = dailySeries;

  factory _$OverviewDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewDataImplFromJson(json);

  @override
  final OverviewCounts counts;
  @override
  @JsonKey(name: 'productivityPercent')
  final double productivityPercent;
  final List<DailyData> _dailySeries;
  @override
  @JsonKey(name: 'dailySeries')
  List<DailyData> get dailySeries {
    if (_dailySeries is EqualUnmodifiableListView) return _dailySeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailySeries);
  }

  @override
  String toString() {
    return 'OverviewData(counts: $counts, productivityPercent: $productivityPercent, dailySeries: $dailySeries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewDataImpl &&
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

  /// Create a copy of OverviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewDataImplCopyWith<_$OverviewDataImpl> get copyWith =>
      __$$OverviewDataImplCopyWithImpl<_$OverviewDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewDataImplToJson(
      this,
    );
  }
}

abstract class _OverviewData implements OverviewData {
  const factory _OverviewData(
      {required final OverviewCounts counts,
      @JsonKey(name: 'productivityPercent')
      required final double productivityPercent,
      @JsonKey(name: 'dailySeries')
      required final List<DailyData> dailySeries}) = _$OverviewDataImpl;

  factory _OverviewData.fromJson(Map<String, dynamic> json) =
      _$OverviewDataImpl.fromJson;

  @override
  OverviewCounts get counts;
  @override
  @JsonKey(name: 'productivityPercent')
  double get productivityPercent;
  @override
  @JsonKey(name: 'dailySeries')
  List<DailyData> get dailySeries;

  /// Create a copy of OverviewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewDataImplCopyWith<_$OverviewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverviewCounts _$OverviewCountsFromJson(Map<String, dynamic> json) {
  return _OverviewCounts.fromJson(json);
}

/// @nodoc
mixin _$OverviewCounts {
  int get completed => throw _privateConstructorUsedError;
  int get inProgress => throw _privateConstructorUsedError;
  int get overdue => throw _privateConstructorUsedError;

  /// Serializes this OverviewCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewCountsCopyWith<OverviewCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewCountsCopyWith<$Res> {
  factory $OverviewCountsCopyWith(
          OverviewCounts value, $Res Function(OverviewCounts) then) =
      _$OverviewCountsCopyWithImpl<$Res, OverviewCounts>;
  @useResult
  $Res call({int completed, int inProgress, int overdue});
}

/// @nodoc
class _$OverviewCountsCopyWithImpl<$Res, $Val extends OverviewCounts>
    implements $OverviewCountsCopyWith<$Res> {
  _$OverviewCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewCounts
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
abstract class _$$OverviewCountsImplCopyWith<$Res>
    implements $OverviewCountsCopyWith<$Res> {
  factory _$$OverviewCountsImplCopyWith(_$OverviewCountsImpl value,
          $Res Function(_$OverviewCountsImpl) then) =
      __$$OverviewCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int completed, int inProgress, int overdue});
}

/// @nodoc
class __$$OverviewCountsImplCopyWithImpl<$Res>
    extends _$OverviewCountsCopyWithImpl<$Res, _$OverviewCountsImpl>
    implements _$$OverviewCountsImplCopyWith<$Res> {
  __$$OverviewCountsImplCopyWithImpl(
      _$OverviewCountsImpl _value, $Res Function(_$OverviewCountsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? inProgress = null,
    Object? overdue = null,
  }) {
    return _then(_$OverviewCountsImpl(
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
class _$OverviewCountsImpl implements _OverviewCounts {
  const _$OverviewCountsImpl(
      {required this.completed,
      required this.inProgress,
      required this.overdue});

  factory _$OverviewCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewCountsImplFromJson(json);

  @override
  final int completed;
  @override
  final int inProgress;
  @override
  final int overdue;

  @override
  String toString() {
    return 'OverviewCounts(completed: $completed, inProgress: $inProgress, overdue: $overdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewCountsImpl &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.overdue, overdue) || other.overdue == overdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, completed, inProgress, overdue);

  /// Create a copy of OverviewCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewCountsImplCopyWith<_$OverviewCountsImpl> get copyWith =>
      __$$OverviewCountsImplCopyWithImpl<_$OverviewCountsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewCountsImplToJson(
      this,
    );
  }
}

abstract class _OverviewCounts implements OverviewCounts {
  const factory _OverviewCounts(
      {required final int completed,
      required final int inProgress,
      required final int overdue}) = _$OverviewCountsImpl;

  factory _OverviewCounts.fromJson(Map<String, dynamic> json) =
      _$OverviewCountsImpl.fromJson;

  @override
  int get completed;
  @override
  int get inProgress;
  @override
  int get overdue;

  /// Create a copy of OverviewCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewCountsImplCopyWith<_$OverviewCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
