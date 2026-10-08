// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsInsights _$AnalyticsInsightsFromJson(Map<String, dynamic> json) {
  return _AnalyticsInsights.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsInsights {
  AnalyticsPeriod get period => throw _privateConstructorUsedError;
  List<ProductivityTrend> get productivityTrends =>
      throw _privateConstructorUsedError;
  List<StatusDistribution> get statusDistribution =>
      throw _privateConstructorUsedError;
  List<PriorityDistribution> get priorityDistribution =>
      throw _privateConstructorUsedError;
  List<ActiveHour> get activeHours => throw _privateConstructorUsedError;
  List<ActiveDay> get activeDays => throw _privateConstructorUsedError;
  OverdueTasks? get overdueTasks => throw _privateConstructorUsedError;
  AvgTasksPerDay? get avgTasksPerDay => throw _privateConstructorUsedError;
  CompletionStreak? get completionStreak => throw _privateConstructorUsedError;
  List<Insight> get insights => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsInsightsCopyWith<AnalyticsInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsInsightsCopyWith<$Res> {
  factory $AnalyticsInsightsCopyWith(
          AnalyticsInsights value, $Res Function(AnalyticsInsights) then) =
      _$AnalyticsInsightsCopyWithImpl<$Res, AnalyticsInsights>;
  @useResult
  $Res call(
      {AnalyticsPeriod period,
      List<ProductivityTrend> productivityTrends,
      List<StatusDistribution> statusDistribution,
      List<PriorityDistribution> priorityDistribution,
      List<ActiveHour> activeHours,
      List<ActiveDay> activeDays,
      OverdueTasks? overdueTasks,
      AvgTasksPerDay? avgTasksPerDay,
      CompletionStreak? completionStreak,
      List<Insight> insights,
      String? workspaceId});

  $AnalyticsPeriodCopyWith<$Res> get period;
  $OverdueTasksCopyWith<$Res>? get overdueTasks;
  $AvgTasksPerDayCopyWith<$Res>? get avgTasksPerDay;
  $CompletionStreakCopyWith<$Res>? get completionStreak;
}

/// @nodoc
class _$AnalyticsInsightsCopyWithImpl<$Res, $Val extends AnalyticsInsights>
    implements $AnalyticsInsightsCopyWith<$Res> {
  _$AnalyticsInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? productivityTrends = null,
    Object? statusDistribution = null,
    Object? priorityDistribution = null,
    Object? activeHours = null,
    Object? activeDays = null,
    Object? overdueTasks = freezed,
    Object? avgTasksPerDay = freezed,
    Object? completionStreak = freezed,
    Object? insights = null,
    Object? workspaceId = freezed,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      productivityTrends: null == productivityTrends
          ? _value.productivityTrends
          : productivityTrends // ignore: cast_nullable_to_non_nullable
              as List<ProductivityTrend>,
      statusDistribution: null == statusDistribution
          ? _value.statusDistribution
          : statusDistribution // ignore: cast_nullable_to_non_nullable
              as List<StatusDistribution>,
      priorityDistribution: null == priorityDistribution
          ? _value.priorityDistribution
          : priorityDistribution // ignore: cast_nullable_to_non_nullable
              as List<PriorityDistribution>,
      activeHours: null == activeHours
          ? _value.activeHours
          : activeHours // ignore: cast_nullable_to_non_nullable
              as List<ActiveHour>,
      activeDays: null == activeDays
          ? _value.activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as List<ActiveDay>,
      overdueTasks: freezed == overdueTasks
          ? _value.overdueTasks
          : overdueTasks // ignore: cast_nullable_to_non_nullable
              as OverdueTasks?,
      avgTasksPerDay: freezed == avgTasksPerDay
          ? _value.avgTasksPerDay
          : avgTasksPerDay // ignore: cast_nullable_to_non_nullable
              as AvgTasksPerDay?,
      completionStreak: freezed == completionStreak
          ? _value.completionStreak
          : completionStreak // ignore: cast_nullable_to_non_nullable
              as CompletionStreak?,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<Insight>,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsPeriodCopyWith<$Res> get period {
    return $AnalyticsPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverdueTasksCopyWith<$Res>? get overdueTasks {
    if (_value.overdueTasks == null) {
      return null;
    }

    return $OverdueTasksCopyWith<$Res>(_value.overdueTasks!, (value) {
      return _then(_value.copyWith(overdueTasks: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvgTasksPerDayCopyWith<$Res>? get avgTasksPerDay {
    if (_value.avgTasksPerDay == null) {
      return null;
    }

    return $AvgTasksPerDayCopyWith<$Res>(_value.avgTasksPerDay!, (value) {
      return _then(_value.copyWith(avgTasksPerDay: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletionStreakCopyWith<$Res>? get completionStreak {
    if (_value.completionStreak == null) {
      return null;
    }

    return $CompletionStreakCopyWith<$Res>(_value.completionStreak!, (value) {
      return _then(_value.copyWith(completionStreak: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsInsightsImplCopyWith<$Res>
    implements $AnalyticsInsightsCopyWith<$Res> {
  factory _$$AnalyticsInsightsImplCopyWith(_$AnalyticsInsightsImpl value,
          $Res Function(_$AnalyticsInsightsImpl) then) =
      __$$AnalyticsInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AnalyticsPeriod period,
      List<ProductivityTrend> productivityTrends,
      List<StatusDistribution> statusDistribution,
      List<PriorityDistribution> priorityDistribution,
      List<ActiveHour> activeHours,
      List<ActiveDay> activeDays,
      OverdueTasks? overdueTasks,
      AvgTasksPerDay? avgTasksPerDay,
      CompletionStreak? completionStreak,
      List<Insight> insights,
      String? workspaceId});

  @override
  $AnalyticsPeriodCopyWith<$Res> get period;
  @override
  $OverdueTasksCopyWith<$Res>? get overdueTasks;
  @override
  $AvgTasksPerDayCopyWith<$Res>? get avgTasksPerDay;
  @override
  $CompletionStreakCopyWith<$Res>? get completionStreak;
}

/// @nodoc
class __$$AnalyticsInsightsImplCopyWithImpl<$Res>
    extends _$AnalyticsInsightsCopyWithImpl<$Res, _$AnalyticsInsightsImpl>
    implements _$$AnalyticsInsightsImplCopyWith<$Res> {
  __$$AnalyticsInsightsImplCopyWithImpl(_$AnalyticsInsightsImpl _value,
      $Res Function(_$AnalyticsInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? productivityTrends = null,
    Object? statusDistribution = null,
    Object? priorityDistribution = null,
    Object? activeHours = null,
    Object? activeDays = null,
    Object? overdueTasks = freezed,
    Object? avgTasksPerDay = freezed,
    Object? completionStreak = freezed,
    Object? insights = null,
    Object? workspaceId = freezed,
  }) {
    return _then(_$AnalyticsInsightsImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      productivityTrends: null == productivityTrends
          ? _value._productivityTrends
          : productivityTrends // ignore: cast_nullable_to_non_nullable
              as List<ProductivityTrend>,
      statusDistribution: null == statusDistribution
          ? _value._statusDistribution
          : statusDistribution // ignore: cast_nullable_to_non_nullable
              as List<StatusDistribution>,
      priorityDistribution: null == priorityDistribution
          ? _value._priorityDistribution
          : priorityDistribution // ignore: cast_nullable_to_non_nullable
              as List<PriorityDistribution>,
      activeHours: null == activeHours
          ? _value._activeHours
          : activeHours // ignore: cast_nullable_to_non_nullable
              as List<ActiveHour>,
      activeDays: null == activeDays
          ? _value._activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as List<ActiveDay>,
      overdueTasks: freezed == overdueTasks
          ? _value.overdueTasks
          : overdueTasks // ignore: cast_nullable_to_non_nullable
              as OverdueTasks?,
      avgTasksPerDay: freezed == avgTasksPerDay
          ? _value.avgTasksPerDay
          : avgTasksPerDay // ignore: cast_nullable_to_non_nullable
              as AvgTasksPerDay?,
      completionStreak: freezed == completionStreak
          ? _value.completionStreak
          : completionStreak // ignore: cast_nullable_to_non_nullable
              as CompletionStreak?,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<Insight>,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsInsightsImpl implements _AnalyticsInsights {
  const _$AnalyticsInsightsImpl(
      {required this.period,
      final List<ProductivityTrend> productivityTrends = const [],
      final List<StatusDistribution> statusDistribution = const [],
      final List<PriorityDistribution> priorityDistribution = const [],
      final List<ActiveHour> activeHours = const [],
      final List<ActiveDay> activeDays = const [],
      this.overdueTasks,
      this.avgTasksPerDay,
      this.completionStreak,
      final List<Insight> insights = const [],
      this.workspaceId})
      : _productivityTrends = productivityTrends,
        _statusDistribution = statusDistribution,
        _priorityDistribution = priorityDistribution,
        _activeHours = activeHours,
        _activeDays = activeDays,
        _insights = insights;

  factory _$AnalyticsInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsInsightsImplFromJson(json);

  @override
  final AnalyticsPeriod period;
  final List<ProductivityTrend> _productivityTrends;
  @override
  @JsonKey()
  List<ProductivityTrend> get productivityTrends {
    if (_productivityTrends is EqualUnmodifiableListView)
      return _productivityTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productivityTrends);
  }

  final List<StatusDistribution> _statusDistribution;
  @override
  @JsonKey()
  List<StatusDistribution> get statusDistribution {
    if (_statusDistribution is EqualUnmodifiableListView)
      return _statusDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusDistribution);
  }

  final List<PriorityDistribution> _priorityDistribution;
  @override
  @JsonKey()
  List<PriorityDistribution> get priorityDistribution {
    if (_priorityDistribution is EqualUnmodifiableListView)
      return _priorityDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_priorityDistribution);
  }

  final List<ActiveHour> _activeHours;
  @override
  @JsonKey()
  List<ActiveHour> get activeHours {
    if (_activeHours is EqualUnmodifiableListView) return _activeHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeHours);
  }

  final List<ActiveDay> _activeDays;
  @override
  @JsonKey()
  List<ActiveDay> get activeDays {
    if (_activeDays is EqualUnmodifiableListView) return _activeDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeDays);
  }

  @override
  final OverdueTasks? overdueTasks;
  @override
  final AvgTasksPerDay? avgTasksPerDay;
  @override
  final CompletionStreak? completionStreak;
  final List<Insight> _insights;
  @override
  @JsonKey()
  List<Insight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  final String? workspaceId;

  @override
  String toString() {
    return 'AnalyticsInsights(period: $period, productivityTrends: $productivityTrends, statusDistribution: $statusDistribution, priorityDistribution: $priorityDistribution, activeHours: $activeHours, activeDays: $activeDays, overdueTasks: $overdueTasks, avgTasksPerDay: $avgTasksPerDay, completionStreak: $completionStreak, insights: $insights, workspaceId: $workspaceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsInsightsImpl &&
            (identical(other.period, period) || other.period == period) &&
            const DeepCollectionEquality()
                .equals(other._productivityTrends, _productivityTrends) &&
            const DeepCollectionEquality()
                .equals(other._statusDistribution, _statusDistribution) &&
            const DeepCollectionEquality()
                .equals(other._priorityDistribution, _priorityDistribution) &&
            const DeepCollectionEquality()
                .equals(other._activeHours, _activeHours) &&
            const DeepCollectionEquality()
                .equals(other._activeDays, _activeDays) &&
            (identical(other.overdueTasks, overdueTasks) ||
                other.overdueTasks == overdueTasks) &&
            (identical(other.avgTasksPerDay, avgTasksPerDay) ||
                other.avgTasksPerDay == avgTasksPerDay) &&
            (identical(other.completionStreak, completionStreak) ||
                other.completionStreak == completionStreak) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      period,
      const DeepCollectionEquality().hash(_productivityTrends),
      const DeepCollectionEquality().hash(_statusDistribution),
      const DeepCollectionEquality().hash(_priorityDistribution),
      const DeepCollectionEquality().hash(_activeHours),
      const DeepCollectionEquality().hash(_activeDays),
      overdueTasks,
      avgTasksPerDay,
      completionStreak,
      const DeepCollectionEquality().hash(_insights),
      workspaceId);

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsInsightsImplCopyWith<_$AnalyticsInsightsImpl> get copyWith =>
      __$$AnalyticsInsightsImplCopyWithImpl<_$AnalyticsInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsInsightsImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsInsights implements AnalyticsInsights {
  const factory _AnalyticsInsights(
      {required final AnalyticsPeriod period,
      final List<ProductivityTrend> productivityTrends,
      final List<StatusDistribution> statusDistribution,
      final List<PriorityDistribution> priorityDistribution,
      final List<ActiveHour> activeHours,
      final List<ActiveDay> activeDays,
      final OverdueTasks? overdueTasks,
      final AvgTasksPerDay? avgTasksPerDay,
      final CompletionStreak? completionStreak,
      final List<Insight> insights,
      final String? workspaceId}) = _$AnalyticsInsightsImpl;

  factory _AnalyticsInsights.fromJson(Map<String, dynamic> json) =
      _$AnalyticsInsightsImpl.fromJson;

  @override
  AnalyticsPeriod get period;
  @override
  List<ProductivityTrend> get productivityTrends;
  @override
  List<StatusDistribution> get statusDistribution;
  @override
  List<PriorityDistribution> get priorityDistribution;
  @override
  List<ActiveHour> get activeHours;
  @override
  List<ActiveDay> get activeDays;
  @override
  OverdueTasks? get overdueTasks;
  @override
  AvgTasksPerDay? get avgTasksPerDay;
  @override
  CompletionStreak? get completionStreak;
  @override
  List<Insight> get insights;
  @override
  String? get workspaceId;

  /// Create a copy of AnalyticsInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsInsightsImplCopyWith<_$AnalyticsInsightsImpl> get copyWith =>
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

ProductivityTrend _$ProductivityTrendFromJson(Map<String, dynamic> json) {
  return _ProductivityTrend.fromJson(json);
}

/// @nodoc
mixin _$ProductivityTrend {
  DateTime get weekStart => throw _privateConstructorUsedError;
  int get tasksCreated => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  int get totalEvents => throw _privateConstructorUsedError;

  /// Serializes this ProductivityTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductivityTrendCopyWith<ProductivityTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductivityTrendCopyWith<$Res> {
  factory $ProductivityTrendCopyWith(
          ProductivityTrend value, $Res Function(ProductivityTrend) then) =
      _$ProductivityTrendCopyWithImpl<$Res, ProductivityTrend>;
  @useResult
  $Res call(
      {DateTime weekStart,
      int tasksCreated,
      int tasksCompleted,
      double completionRate,
      int totalEvents});
}

/// @nodoc
class _$ProductivityTrendCopyWithImpl<$Res, $Val extends ProductivityTrend>
    implements $ProductivityTrendCopyWith<$Res> {
  _$ProductivityTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? completionRate = null,
    Object? totalEvents = null,
  }) {
    return _then(_value.copyWith(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductivityTrendImplCopyWith<$Res>
    implements $ProductivityTrendCopyWith<$Res> {
  factory _$$ProductivityTrendImplCopyWith(_$ProductivityTrendImpl value,
          $Res Function(_$ProductivityTrendImpl) then) =
      __$$ProductivityTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime weekStart,
      int tasksCreated,
      int tasksCompleted,
      double completionRate,
      int totalEvents});
}

/// @nodoc
class __$$ProductivityTrendImplCopyWithImpl<$Res>
    extends _$ProductivityTrendCopyWithImpl<$Res, _$ProductivityTrendImpl>
    implements _$$ProductivityTrendImplCopyWith<$Res> {
  __$$ProductivityTrendImplCopyWithImpl(_$ProductivityTrendImpl _value,
      $Res Function(_$ProductivityTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? completionRate = null,
    Object? totalEvents = null,
  }) {
    return _then(_$ProductivityTrendImpl(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductivityTrendImpl implements _ProductivityTrend {
  const _$ProductivityTrendImpl(
      {required this.weekStart,
      required this.tasksCreated,
      required this.tasksCompleted,
      required this.completionRate,
      required this.totalEvents});

  factory _$ProductivityTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductivityTrendImplFromJson(json);

  @override
  final DateTime weekStart;
  @override
  final int tasksCreated;
  @override
  final int tasksCompleted;
  @override
  final double completionRate;
  @override
  final int totalEvents;

  @override
  String toString() {
    return 'ProductivityTrend(weekStart: $weekStart, tasksCreated: $tasksCreated, tasksCompleted: $tasksCompleted, completionRate: $completionRate, totalEvents: $totalEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductivityTrendImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.tasksCreated, tasksCreated) ||
                other.tasksCreated == tasksCreated) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.totalEvents, totalEvents) ||
                other.totalEvents == totalEvents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, weekStart, tasksCreated,
      tasksCompleted, completionRate, totalEvents);

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductivityTrendImplCopyWith<_$ProductivityTrendImpl> get copyWith =>
      __$$ProductivityTrendImplCopyWithImpl<_$ProductivityTrendImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductivityTrendImplToJson(
      this,
    );
  }
}

abstract class _ProductivityTrend implements ProductivityTrend {
  const factory _ProductivityTrend(
      {required final DateTime weekStart,
      required final int tasksCreated,
      required final int tasksCompleted,
      required final double completionRate,
      required final int totalEvents}) = _$ProductivityTrendImpl;

  factory _ProductivityTrend.fromJson(Map<String, dynamic> json) =
      _$ProductivityTrendImpl.fromJson;

  @override
  DateTime get weekStart;
  @override
  int get tasksCreated;
  @override
  int get tasksCompleted;
  @override
  double get completionRate;
  @override
  int get totalEvents;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductivityTrendImplCopyWith<_$ProductivityTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusDistribution _$StatusDistributionFromJson(Map<String, dynamic> json) {
  return _StatusDistribution.fromJson(json);
}

/// @nodoc
mixin _$StatusDistribution {
  String get status => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this StatusDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusDistributionCopyWith<StatusDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusDistributionCopyWith<$Res> {
  factory $StatusDistributionCopyWith(
          StatusDistribution value, $Res Function(StatusDistribution) then) =
      _$StatusDistributionCopyWithImpl<$Res, StatusDistribution>;
  @useResult
  $Res call({String status, int taskCount, double percentage});
}

/// @nodoc
class _$StatusDistributionCopyWithImpl<$Res, $Val extends StatusDistribution>
    implements $StatusDistributionCopyWith<$Res> {
  _$StatusDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatusDistributionImplCopyWith<$Res>
    implements $StatusDistributionCopyWith<$Res> {
  factory _$$StatusDistributionImplCopyWith(_$StatusDistributionImpl value,
          $Res Function(_$StatusDistributionImpl) then) =
      __$$StatusDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int taskCount, double percentage});
}

/// @nodoc
class __$$StatusDistributionImplCopyWithImpl<$Res>
    extends _$StatusDistributionCopyWithImpl<$Res, _$StatusDistributionImpl>
    implements _$$StatusDistributionImplCopyWith<$Res> {
  __$$StatusDistributionImplCopyWithImpl(_$StatusDistributionImpl _value,
      $Res Function(_$StatusDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(_$StatusDistributionImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
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
class _$StatusDistributionImpl implements _StatusDistribution {
  const _$StatusDistributionImpl(
      {required this.status,
      required this.taskCount,
      required this.percentage});

  factory _$StatusDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusDistributionImplFromJson(json);

  @override
  final String status;
  @override
  final int taskCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'StatusDistribution(status: $status, taskCount: $taskCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusDistributionImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, taskCount, percentage);

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusDistributionImplCopyWith<_$StatusDistributionImpl> get copyWith =>
      __$$StatusDistributionImplCopyWithImpl<_$StatusDistributionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusDistributionImplToJson(
      this,
    );
  }
}

abstract class _StatusDistribution implements StatusDistribution {
  const factory _StatusDistribution(
      {required final String status,
      required final int taskCount,
      required final double percentage}) = _$StatusDistributionImpl;

  factory _StatusDistribution.fromJson(Map<String, dynamic> json) =
      _$StatusDistributionImpl.fromJson;

  @override
  String get status;
  @override
  int get taskCount;
  @override
  double get percentage;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusDistributionImplCopyWith<_$StatusDistributionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriorityDistribution _$PriorityDistributionFromJson(Map<String, dynamic> json) {
  return _PriorityDistribution.fromJson(json);
}

/// @nodoc
mixin _$PriorityDistribution {
  String get priority => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this PriorityDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriorityDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriorityDistributionCopyWith<PriorityDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriorityDistributionCopyWith<$Res> {
  factory $PriorityDistributionCopyWith(PriorityDistribution value,
          $Res Function(PriorityDistribution) then) =
      _$PriorityDistributionCopyWithImpl<$Res, PriorityDistribution>;
  @useResult
  $Res call({String priority, int taskCount, double percentage});
}

/// @nodoc
class _$PriorityDistributionCopyWithImpl<$Res,
        $Val extends PriorityDistribution>
    implements $PriorityDistributionCopyWith<$Res> {
  _$PriorityDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriorityDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priority = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriorityDistributionImplCopyWith<$Res>
    implements $PriorityDistributionCopyWith<$Res> {
  factory _$$PriorityDistributionImplCopyWith(_$PriorityDistributionImpl value,
          $Res Function(_$PriorityDistributionImpl) then) =
      __$$PriorityDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String priority, int taskCount, double percentage});
}

/// @nodoc
class __$$PriorityDistributionImplCopyWithImpl<$Res>
    extends _$PriorityDistributionCopyWithImpl<$Res, _$PriorityDistributionImpl>
    implements _$$PriorityDistributionImplCopyWith<$Res> {
  __$$PriorityDistributionImplCopyWithImpl(_$PriorityDistributionImpl _value,
      $Res Function(_$PriorityDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriorityDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priority = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(_$PriorityDistributionImpl(
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      taskCount: null == taskCount
          ? _value.taskCount
          : taskCount // ignore: cast_nullable_to_non_nullable
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
class _$PriorityDistributionImpl implements _PriorityDistribution {
  const _$PriorityDistributionImpl(
      {required this.priority,
      required this.taskCount,
      required this.percentage});

  factory _$PriorityDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriorityDistributionImplFromJson(json);

  @override
  final String priority;
  @override
  final int taskCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'PriorityDistribution(priority: $priority, taskCount: $taskCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriorityDistributionImpl &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, priority, taskCount, percentage);

  /// Create a copy of PriorityDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriorityDistributionImplCopyWith<_$PriorityDistributionImpl>
      get copyWith =>
          __$$PriorityDistributionImplCopyWithImpl<_$PriorityDistributionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriorityDistributionImplToJson(
      this,
    );
  }
}

abstract class _PriorityDistribution implements PriorityDistribution {
  const factory _PriorityDistribution(
      {required final String priority,
      required final int taskCount,
      required final double percentage}) = _$PriorityDistributionImpl;

  factory _PriorityDistribution.fromJson(Map<String, dynamic> json) =
      _$PriorityDistributionImpl.fromJson;

  @override
  String get priority;
  @override
  int get taskCount;
  @override
  double get percentage;

  /// Create a copy of PriorityDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriorityDistributionImplCopyWith<_$PriorityDistributionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActiveHour _$ActiveHourFromJson(Map<String, dynamic> json) {
  return _ActiveHour.fromJson(json);
}

/// @nodoc
mixin _$ActiveHour {
  int get hourOfDay => throw _privateConstructorUsedError;
  int get eventCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this ActiveHour to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveHourCopyWith<ActiveHour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveHourCopyWith<$Res> {
  factory $ActiveHourCopyWith(
          ActiveHour value, $Res Function(ActiveHour) then) =
      _$ActiveHourCopyWithImpl<$Res, ActiveHour>;
  @useResult
  $Res call({int hourOfDay, int eventCount, double percentage});
}

/// @nodoc
class _$ActiveHourCopyWithImpl<$Res, $Val extends ActiveHour>
    implements $ActiveHourCopyWith<$Res> {
  _$ActiveHourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourOfDay = null,
    Object? eventCount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActiveHourImplCopyWith<$Res>
    implements $ActiveHourCopyWith<$Res> {
  factory _$$ActiveHourImplCopyWith(
          _$ActiveHourImpl value, $Res Function(_$ActiveHourImpl) then) =
      __$$ActiveHourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hourOfDay, int eventCount, double percentage});
}

/// @nodoc
class __$$ActiveHourImplCopyWithImpl<$Res>
    extends _$ActiveHourCopyWithImpl<$Res, _$ActiveHourImpl>
    implements _$$ActiveHourImplCopyWith<$Res> {
  __$$ActiveHourImplCopyWithImpl(
      _$ActiveHourImpl _value, $Res Function(_$ActiveHourImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourOfDay = null,
    Object? eventCount = null,
    Object? percentage = null,
  }) {
    return _then(_$ActiveHourImpl(
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
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
class _$ActiveHourImpl implements _ActiveHour {
  const _$ActiveHourImpl(
      {required this.hourOfDay,
      required this.eventCount,
      required this.percentage});

  factory _$ActiveHourImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveHourImplFromJson(json);

  @override
  final int hourOfDay;
  @override
  final int eventCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'ActiveHour(hourOfDay: $hourOfDay, eventCount: $eventCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveHourImpl &&
            (identical(other.hourOfDay, hourOfDay) ||
                other.hourOfDay == hourOfDay) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hourOfDay, eventCount, percentage);

  /// Create a copy of ActiveHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveHourImplCopyWith<_$ActiveHourImpl> get copyWith =>
      __$$ActiveHourImplCopyWithImpl<_$ActiveHourImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveHourImplToJson(
      this,
    );
  }
}

abstract class _ActiveHour implements ActiveHour {
  const factory _ActiveHour(
      {required final int hourOfDay,
      required final int eventCount,
      required final double percentage}) = _$ActiveHourImpl;

  factory _ActiveHour.fromJson(Map<String, dynamic> json) =
      _$ActiveHourImpl.fromJson;

  @override
  int get hourOfDay;
  @override
  int get eventCount;
  @override
  double get percentage;

  /// Create a copy of ActiveHour
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveHourImplCopyWith<_$ActiveHourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActiveDay _$ActiveDayFromJson(Map<String, dynamic> json) {
  return _ActiveDay.fromJson(json);
}

/// @nodoc
mixin _$ActiveDay {
  int get dayOfWeek => throw _privateConstructorUsedError;
  String get dayName => throw _privateConstructorUsedError;
  int get eventCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this ActiveDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveDayCopyWith<ActiveDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveDayCopyWith<$Res> {
  factory $ActiveDayCopyWith(ActiveDay value, $Res Function(ActiveDay) then) =
      _$ActiveDayCopyWithImpl<$Res, ActiveDay>;
  @useResult
  $Res call({int dayOfWeek, String dayName, int eventCount, double percentage});
}

/// @nodoc
class _$ActiveDayCopyWithImpl<$Res, $Val extends ActiveDay>
    implements $ActiveDayCopyWith<$Res> {
  _$ActiveDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? dayName = null,
    Object? eventCount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActiveDayImplCopyWith<$Res>
    implements $ActiveDayCopyWith<$Res> {
  factory _$$ActiveDayImplCopyWith(
          _$ActiveDayImpl value, $Res Function(_$ActiveDayImpl) then) =
      __$$ActiveDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dayOfWeek, String dayName, int eventCount, double percentage});
}

/// @nodoc
class __$$ActiveDayImplCopyWithImpl<$Res>
    extends _$ActiveDayCopyWithImpl<$Res, _$ActiveDayImpl>
    implements _$$ActiveDayImplCopyWith<$Res> {
  __$$ActiveDayImplCopyWithImpl(
      _$ActiveDayImpl _value, $Res Function(_$ActiveDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? dayName = null,
    Object? eventCount = null,
    Object? percentage = null,
  }) {
    return _then(_$ActiveDayImpl(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      eventCount: null == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
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
class _$ActiveDayImpl implements _ActiveDay {
  const _$ActiveDayImpl(
      {required this.dayOfWeek,
      required this.dayName,
      required this.eventCount,
      required this.percentage});

  factory _$ActiveDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveDayImplFromJson(json);

  @override
  final int dayOfWeek;
  @override
  final String dayName;
  @override
  final int eventCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'ActiveDay(dayOfWeek: $dayOfWeek, dayName: $dayName, eventCount: $eventCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveDayImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayOfWeek, dayName, eventCount, percentage);

  /// Create a copy of ActiveDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveDayImplCopyWith<_$ActiveDayImpl> get copyWith =>
      __$$ActiveDayImplCopyWithImpl<_$ActiveDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveDayImplToJson(
      this,
    );
  }
}

abstract class _ActiveDay implements ActiveDay {
  const factory _ActiveDay(
      {required final int dayOfWeek,
      required final String dayName,
      required final int eventCount,
      required final double percentage}) = _$ActiveDayImpl;

  factory _ActiveDay.fromJson(Map<String, dynamic> json) =
      _$ActiveDayImpl.fromJson;

  @override
  int get dayOfWeek;
  @override
  String get dayName;
  @override
  int get eventCount;
  @override
  double get percentage;

  /// Create a copy of ActiveDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveDayImplCopyWith<_$ActiveDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverdueTasks _$OverdueTasksFromJson(Map<String, dynamic> json) {
  return _OverdueTasks.fromJson(json);
}

/// @nodoc
mixin _$OverdueTasks {
  int get overdueCount => throw _privateConstructorUsedError;
  int get overdueHighPriority => throw _privateConstructorUsedError;
  int get totalActiveTasks => throw _privateConstructorUsedError;

  /// Serializes this OverdueTasks to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverdueTasks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverdueTasksCopyWith<OverdueTasks> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverdueTasksCopyWith<$Res> {
  factory $OverdueTasksCopyWith(
          OverdueTasks value, $Res Function(OverdueTasks) then) =
      _$OverdueTasksCopyWithImpl<$Res, OverdueTasks>;
  @useResult
  $Res call({int overdueCount, int overdueHighPriority, int totalActiveTasks});
}

/// @nodoc
class _$OverdueTasksCopyWithImpl<$Res, $Val extends OverdueTasks>
    implements $OverdueTasksCopyWith<$Res> {
  _$OverdueTasksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverdueTasks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overdueCount = null,
    Object? overdueHighPriority = null,
    Object? totalActiveTasks = null,
  }) {
    return _then(_value.copyWith(
      overdueCount: null == overdueCount
          ? _value.overdueCount
          : overdueCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueHighPriority: null == overdueHighPriority
          ? _value.overdueHighPriority
          : overdueHighPriority // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveTasks: null == totalActiveTasks
          ? _value.totalActiveTasks
          : totalActiveTasks // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverdueTasksImplCopyWith<$Res>
    implements $OverdueTasksCopyWith<$Res> {
  factory _$$OverdueTasksImplCopyWith(
          _$OverdueTasksImpl value, $Res Function(_$OverdueTasksImpl) then) =
      __$$OverdueTasksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int overdueCount, int overdueHighPriority, int totalActiveTasks});
}

/// @nodoc
class __$$OverdueTasksImplCopyWithImpl<$Res>
    extends _$OverdueTasksCopyWithImpl<$Res, _$OverdueTasksImpl>
    implements _$$OverdueTasksImplCopyWith<$Res> {
  __$$OverdueTasksImplCopyWithImpl(
      _$OverdueTasksImpl _value, $Res Function(_$OverdueTasksImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverdueTasks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overdueCount = null,
    Object? overdueHighPriority = null,
    Object? totalActiveTasks = null,
  }) {
    return _then(_$OverdueTasksImpl(
      overdueCount: null == overdueCount
          ? _value.overdueCount
          : overdueCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueHighPriority: null == overdueHighPriority
          ? _value.overdueHighPriority
          : overdueHighPriority // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveTasks: null == totalActiveTasks
          ? _value.totalActiveTasks
          : totalActiveTasks // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverdueTasksImpl implements _OverdueTasks {
  const _$OverdueTasksImpl(
      {required this.overdueCount,
      required this.overdueHighPriority,
      required this.totalActiveTasks});

  factory _$OverdueTasksImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverdueTasksImplFromJson(json);

  @override
  final int overdueCount;
  @override
  final int overdueHighPriority;
  @override
  final int totalActiveTasks;

  @override
  String toString() {
    return 'OverdueTasks(overdueCount: $overdueCount, overdueHighPriority: $overdueHighPriority, totalActiveTasks: $totalActiveTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverdueTasksImpl &&
            (identical(other.overdueCount, overdueCount) ||
                other.overdueCount == overdueCount) &&
            (identical(other.overdueHighPriority, overdueHighPriority) ||
                other.overdueHighPriority == overdueHighPriority) &&
            (identical(other.totalActiveTasks, totalActiveTasks) ||
                other.totalActiveTasks == totalActiveTasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, overdueCount, overdueHighPriority, totalActiveTasks);

  /// Create a copy of OverdueTasks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverdueTasksImplCopyWith<_$OverdueTasksImpl> get copyWith =>
      __$$OverdueTasksImplCopyWithImpl<_$OverdueTasksImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverdueTasksImplToJson(
      this,
    );
  }
}

abstract class _OverdueTasks implements OverdueTasks {
  const factory _OverdueTasks(
      {required final int overdueCount,
      required final int overdueHighPriority,
      required final int totalActiveTasks}) = _$OverdueTasksImpl;

  factory _OverdueTasks.fromJson(Map<String, dynamic> json) =
      _$OverdueTasksImpl.fromJson;

  @override
  int get overdueCount;
  @override
  int get overdueHighPriority;
  @override
  int get totalActiveTasks;

  /// Create a copy of OverdueTasks
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverdueTasksImplCopyWith<_$OverdueTasksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvgTasksPerDay _$AvgTasksPerDayFromJson(Map<String, dynamic> json) {
  return _AvgTasksPerDay.fromJson(json);
}

/// @nodoc
mixin _$AvgTasksPerDay {
  double get avgCreatedPerDay => throw _privateConstructorUsedError;
  double get avgCompletedPerDay => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;

  /// Serializes this AvgTasksPerDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvgTasksPerDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvgTasksPerDayCopyWith<AvgTasksPerDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvgTasksPerDayCopyWith<$Res> {
  factory $AvgTasksPerDayCopyWith(
          AvgTasksPerDay value, $Res Function(AvgTasksPerDay) then) =
      _$AvgTasksPerDayCopyWithImpl<$Res, AvgTasksPerDay>;
  @useResult
  $Res call(
      {double avgCreatedPerDay, double avgCompletedPerDay, int totalDays});
}

/// @nodoc
class _$AvgTasksPerDayCopyWithImpl<$Res, $Val extends AvgTasksPerDay>
    implements $AvgTasksPerDayCopyWith<$Res> {
  _$AvgTasksPerDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvgTasksPerDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgCreatedPerDay = null,
    Object? avgCompletedPerDay = null,
    Object? totalDays = null,
  }) {
    return _then(_value.copyWith(
      avgCreatedPerDay: null == avgCreatedPerDay
          ? _value.avgCreatedPerDay
          : avgCreatedPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletedPerDay: null == avgCompletedPerDay
          ? _value.avgCompletedPerDay
          : avgCompletedPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvgTasksPerDayImplCopyWith<$Res>
    implements $AvgTasksPerDayCopyWith<$Res> {
  factory _$$AvgTasksPerDayImplCopyWith(_$AvgTasksPerDayImpl value,
          $Res Function(_$AvgTasksPerDayImpl) then) =
      __$$AvgTasksPerDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double avgCreatedPerDay, double avgCompletedPerDay, int totalDays});
}

/// @nodoc
class __$$AvgTasksPerDayImplCopyWithImpl<$Res>
    extends _$AvgTasksPerDayCopyWithImpl<$Res, _$AvgTasksPerDayImpl>
    implements _$$AvgTasksPerDayImplCopyWith<$Res> {
  __$$AvgTasksPerDayImplCopyWithImpl(
      _$AvgTasksPerDayImpl _value, $Res Function(_$AvgTasksPerDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvgTasksPerDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgCreatedPerDay = null,
    Object? avgCompletedPerDay = null,
    Object? totalDays = null,
  }) {
    return _then(_$AvgTasksPerDayImpl(
      avgCreatedPerDay: null == avgCreatedPerDay
          ? _value.avgCreatedPerDay
          : avgCreatedPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      avgCompletedPerDay: null == avgCompletedPerDay
          ? _value.avgCompletedPerDay
          : avgCompletedPerDay // ignore: cast_nullable_to_non_nullable
              as double,
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvgTasksPerDayImpl implements _AvgTasksPerDay {
  const _$AvgTasksPerDayImpl(
      {required this.avgCreatedPerDay,
      required this.avgCompletedPerDay,
      required this.totalDays});

  factory _$AvgTasksPerDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvgTasksPerDayImplFromJson(json);

  @override
  final double avgCreatedPerDay;
  @override
  final double avgCompletedPerDay;
  @override
  final int totalDays;

  @override
  String toString() {
    return 'AvgTasksPerDay(avgCreatedPerDay: $avgCreatedPerDay, avgCompletedPerDay: $avgCompletedPerDay, totalDays: $totalDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvgTasksPerDayImpl &&
            (identical(other.avgCreatedPerDay, avgCreatedPerDay) ||
                other.avgCreatedPerDay == avgCreatedPerDay) &&
            (identical(other.avgCompletedPerDay, avgCompletedPerDay) ||
                other.avgCompletedPerDay == avgCompletedPerDay) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, avgCreatedPerDay, avgCompletedPerDay, totalDays);

  /// Create a copy of AvgTasksPerDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvgTasksPerDayImplCopyWith<_$AvgTasksPerDayImpl> get copyWith =>
      __$$AvgTasksPerDayImplCopyWithImpl<_$AvgTasksPerDayImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvgTasksPerDayImplToJson(
      this,
    );
  }
}

abstract class _AvgTasksPerDay implements AvgTasksPerDay {
  const factory _AvgTasksPerDay(
      {required final double avgCreatedPerDay,
      required final double avgCompletedPerDay,
      required final int totalDays}) = _$AvgTasksPerDayImpl;

  factory _AvgTasksPerDay.fromJson(Map<String, dynamic> json) =
      _$AvgTasksPerDayImpl.fromJson;

  @override
  double get avgCreatedPerDay;
  @override
  double get avgCompletedPerDay;
  @override
  int get totalDays;

  /// Create a copy of AvgTasksPerDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvgTasksPerDayImplCopyWith<_$AvgTasksPerDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompletionStreak _$CompletionStreakFromJson(Map<String, dynamic> json) {
  return _CompletionStreak.fromJson(json);
}

/// @nodoc
mixin _$CompletionStreak {
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastCompletionDate => throw _privateConstructorUsedError;

  /// Serializes this CompletionStreak to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompletionStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionStreakCopyWith<CompletionStreak> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionStreakCopyWith<$Res> {
  factory $CompletionStreakCopyWith(
          CompletionStreak value, $Res Function(CompletionStreak) then) =
      _$CompletionStreakCopyWithImpl<$Res, CompletionStreak>;
  @useResult
  $Res call(
      {int currentStreak, int longestStreak, DateTime? lastCompletionDate});
}

/// @nodoc
class _$CompletionStreakCopyWithImpl<$Res, $Val extends CompletionStreak>
    implements $CompletionStreakCopyWith<$Res> {
  _$CompletionStreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletionStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompletionDate = freezed,
  }) {
    return _then(_value.copyWith(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCompletionDate: freezed == lastCompletionDate
          ? _value.lastCompletionDate
          : lastCompletionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletionStreakImplCopyWith<$Res>
    implements $CompletionStreakCopyWith<$Res> {
  factory _$$CompletionStreakImplCopyWith(_$CompletionStreakImpl value,
          $Res Function(_$CompletionStreakImpl) then) =
      __$$CompletionStreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStreak, int longestStreak, DateTime? lastCompletionDate});
}

/// @nodoc
class __$$CompletionStreakImplCopyWithImpl<$Res>
    extends _$CompletionStreakCopyWithImpl<$Res, _$CompletionStreakImpl>
    implements _$$CompletionStreakImplCopyWith<$Res> {
  __$$CompletionStreakImplCopyWithImpl(_$CompletionStreakImpl _value,
      $Res Function(_$CompletionStreakImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletionStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompletionDate = freezed,
  }) {
    return _then(_$CompletionStreakImpl(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCompletionDate: freezed == lastCompletionDate
          ? _value.lastCompletionDate
          : lastCompletionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletionStreakImpl implements _CompletionStreak {
  const _$CompletionStreakImpl(
      {required this.currentStreak,
      required this.longestStreak,
      this.lastCompletionDate});

  factory _$CompletionStreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletionStreakImplFromJson(json);

  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime? lastCompletionDate;

  @override
  String toString() {
    return 'CompletionStreak(currentStreak: $currentStreak, longestStreak: $longestStreak, lastCompletionDate: $lastCompletionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionStreakImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCompletionDate, lastCompletionDate) ||
                other.lastCompletionDate == lastCompletionDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentStreak, longestStreak, lastCompletionDate);

  /// Create a copy of CompletionStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionStreakImplCopyWith<_$CompletionStreakImpl> get copyWith =>
      __$$CompletionStreakImplCopyWithImpl<_$CompletionStreakImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletionStreakImplToJson(
      this,
    );
  }
}

abstract class _CompletionStreak implements CompletionStreak {
  const factory _CompletionStreak(
      {required final int currentStreak,
      required final int longestStreak,
      final DateTime? lastCompletionDate}) = _$CompletionStreakImpl;

  factory _CompletionStreak.fromJson(Map<String, dynamic> json) =
      _$CompletionStreakImpl.fromJson;

  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastCompletionDate;

  /// Create a copy of CompletionStreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionStreakImplCopyWith<_$CompletionStreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Insight _$InsightFromJson(Map<String, dynamic> json) {
  return _Insight.fromJson(json);
}

/// @nodoc
mixin _$Insight {
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get detail => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;

  /// Serializes this Insight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightCopyWith<Insight> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightCopyWith<$Res> {
  factory $InsightCopyWith(Insight value, $Res Function(Insight) then) =
      _$InsightCopyWithImpl<$Res, Insight>;
  @useResult
  $Res call(
      {String type,
      String title,
      String value,
      String? detail,
      String? severity});
}

/// @nodoc
class _$InsightCopyWithImpl<$Res, $Val extends Insight>
    implements $InsightCopyWith<$Res> {
  _$InsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? value = null,
    Object? detail = freezed,
    Object? severity = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightImplCopyWith<$Res> implements $InsightCopyWith<$Res> {
  factory _$$InsightImplCopyWith(
          _$InsightImpl value, $Res Function(_$InsightImpl) then) =
      __$$InsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String title,
      String value,
      String? detail,
      String? severity});
}

/// @nodoc
class __$$InsightImplCopyWithImpl<$Res>
    extends _$InsightCopyWithImpl<$Res, _$InsightImpl>
    implements _$$InsightImplCopyWith<$Res> {
  __$$InsightImplCopyWithImpl(
      _$InsightImpl _value, $Res Function(_$InsightImpl) _then)
      : super(_value, _then);

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? value = null,
    Object? detail = freezed,
    Object? severity = freezed,
  }) {
    return _then(_$InsightImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightImpl implements _Insight {
  const _$InsightImpl(
      {required this.type,
      required this.title,
      required this.value,
      this.detail,
      this.severity});

  factory _$InsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightImplFromJson(json);

  @override
  final String type;
  @override
  final String title;
  @override
  final String value;
  @override
  final String? detail;
  @override
  final String? severity;

  @override
  String toString() {
    return 'Insight(type: $type, title: $title, value: $value, detail: $detail, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, title, value, detail, severity);

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightImplCopyWith<_$InsightImpl> get copyWith =>
      __$$InsightImplCopyWithImpl<_$InsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightImplToJson(
      this,
    );
  }
}

abstract class _Insight implements Insight {
  const factory _Insight(
      {required final String type,
      required final String title,
      required final String value,
      final String? detail,
      final String? severity}) = _$InsightImpl;

  factory _Insight.fromJson(Map<String, dynamic> json) = _$InsightImpl.fromJson;

  @override
  String get type;
  @override
  String get title;
  @override
  String get value;
  @override
  String? get detail;
  @override
  String? get severity;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightImplCopyWith<_$InsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamActivity _$TeamActivityFromJson(Map<String, dynamic> json) {
  return _TeamActivity.fromJson(json);
}

/// @nodoc
mixin _$TeamActivity {
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get totalEvents => throw _privateConstructorUsedError;
  int get tasksCreated => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  int get commentsAdded => throw _privateConstructorUsedError;
  DateTime get lastActive => throw _privateConstructorUsedError;

  /// Serializes this TeamActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamActivityCopyWith<TeamActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamActivityCopyWith<$Res> {
  factory $TeamActivityCopyWith(
          TeamActivity value, $Res Function(TeamActivity) then) =
      _$TeamActivityCopyWithImpl<$Res, TeamActivity>;
  @useResult
  $Res call(
      {String userId,
      String fullName,
      int totalEvents,
      int tasksCreated,
      int tasksCompleted,
      int commentsAdded,
      DateTime lastActive});
}

/// @nodoc
class _$TeamActivityCopyWithImpl<$Res, $Val extends TeamActivity>
    implements $TeamActivityCopyWith<$Res> {
  _$TeamActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? totalEvents = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? commentsAdded = null,
    Object? lastActive = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      commentsAdded: null == commentsAdded
          ? _value.commentsAdded
          : commentsAdded // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamActivityImplCopyWith<$Res>
    implements $TeamActivityCopyWith<$Res> {
  factory _$$TeamActivityImplCopyWith(
          _$TeamActivityImpl value, $Res Function(_$TeamActivityImpl) then) =
      __$$TeamActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String fullName,
      int totalEvents,
      int tasksCreated,
      int tasksCompleted,
      int commentsAdded,
      DateTime lastActive});
}

/// @nodoc
class __$$TeamActivityImplCopyWithImpl<$Res>
    extends _$TeamActivityCopyWithImpl<$Res, _$TeamActivityImpl>
    implements _$$TeamActivityImplCopyWith<$Res> {
  __$$TeamActivityImplCopyWithImpl(
      _$TeamActivityImpl _value, $Res Function(_$TeamActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeamActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? totalEvents = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? commentsAdded = null,
    Object? lastActive = null,
  }) {
    return _then(_$TeamActivityImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      commentsAdded: null == commentsAdded
          ? _value.commentsAdded
          : commentsAdded // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamActivityImpl implements _TeamActivity {
  const _$TeamActivityImpl(
      {required this.userId,
      required this.fullName,
      required this.totalEvents,
      required this.tasksCreated,
      required this.tasksCompleted,
      required this.commentsAdded,
      required this.lastActive});

  factory _$TeamActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamActivityImplFromJson(json);

  @override
  final String userId;
  @override
  final String fullName;
  @override
  final int totalEvents;
  @override
  final int tasksCreated;
  @override
  final int tasksCompleted;
  @override
  final int commentsAdded;
  @override
  final DateTime lastActive;

  @override
  String toString() {
    return 'TeamActivity(userId: $userId, fullName: $fullName, totalEvents: $totalEvents, tasksCreated: $tasksCreated, tasksCompleted: $tasksCompleted, commentsAdded: $commentsAdded, lastActive: $lastActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActivityImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.totalEvents, totalEvents) ||
                other.totalEvents == totalEvents) &&
            (identical(other.tasksCreated, tasksCreated) ||
                other.tasksCreated == tasksCreated) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.commentsAdded, commentsAdded) ||
                other.commentsAdded == commentsAdded) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, fullName, totalEvents,
      tasksCreated, tasksCompleted, commentsAdded, lastActive);

  /// Create a copy of TeamActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActivityImplCopyWith<_$TeamActivityImpl> get copyWith =>
      __$$TeamActivityImplCopyWithImpl<_$TeamActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamActivityImplToJson(
      this,
    );
  }
}

abstract class _TeamActivity implements TeamActivity {
  const factory _TeamActivity(
      {required final String userId,
      required final String fullName,
      required final int totalEvents,
      required final int tasksCreated,
      required final int tasksCompleted,
      required final int commentsAdded,
      required final DateTime lastActive}) = _$TeamActivityImpl;

  factory _TeamActivity.fromJson(Map<String, dynamic> json) =
      _$TeamActivityImpl.fromJson;

  @override
  String get userId;
  @override
  String get fullName;
  @override
  int get totalEvents;
  @override
  int get tasksCreated;
  @override
  int get tasksCompleted;
  @override
  int get commentsAdded;
  @override
  DateTime get lastActive;

  /// Create a copy of TeamActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamActivityImplCopyWith<_$TeamActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceAnalytics _$WorkspaceAnalyticsFromJson(Map<String, dynamic> json) {
  return _WorkspaceAnalytics.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceAnalytics {
  String get workspaceId => throw _privateConstructorUsedError;
  AnalyticsPeriod get period => throw _privateConstructorUsedError;
  int get totalEvents => throw _privateConstructorUsedError;
  int get totalMembers => throw _privateConstructorUsedError;
  List<TeamActivity> get topContributors => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceAnalyticsCopyWith<WorkspaceAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceAnalyticsCopyWith<$Res> {
  factory $WorkspaceAnalyticsCopyWith(
          WorkspaceAnalytics value, $Res Function(WorkspaceAnalytics) then) =
      _$WorkspaceAnalyticsCopyWithImpl<$Res, WorkspaceAnalytics>;
  @useResult
  $Res call(
      {String workspaceId,
      AnalyticsPeriod period,
      int totalEvents,
      int totalMembers,
      List<TeamActivity> topContributors});

  $AnalyticsPeriodCopyWith<$Res> get period;
}

/// @nodoc
class _$WorkspaceAnalyticsCopyWithImpl<$Res, $Val extends WorkspaceAnalytics>
    implements $WorkspaceAnalyticsCopyWith<$Res> {
  _$WorkspaceAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceId = null,
    Object? period = null,
    Object? totalEvents = null,
    Object? totalMembers = null,
    Object? topContributors = null,
  }) {
    return _then(_value.copyWith(
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      topContributors: null == topContributors
          ? _value.topContributors
          : topContributors // ignore: cast_nullable_to_non_nullable
              as List<TeamActivity>,
    ) as $Val);
  }

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsPeriodCopyWith<$Res> get period {
    return $AnalyticsPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkspaceAnalyticsImplCopyWith<$Res>
    implements $WorkspaceAnalyticsCopyWith<$Res> {
  factory _$$WorkspaceAnalyticsImplCopyWith(_$WorkspaceAnalyticsImpl value,
          $Res Function(_$WorkspaceAnalyticsImpl) then) =
      __$$WorkspaceAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String workspaceId,
      AnalyticsPeriod period,
      int totalEvents,
      int totalMembers,
      List<TeamActivity> topContributors});

  @override
  $AnalyticsPeriodCopyWith<$Res> get period;
}

/// @nodoc
class __$$WorkspaceAnalyticsImplCopyWithImpl<$Res>
    extends _$WorkspaceAnalyticsCopyWithImpl<$Res, _$WorkspaceAnalyticsImpl>
    implements _$$WorkspaceAnalyticsImplCopyWith<$Res> {
  __$$WorkspaceAnalyticsImplCopyWithImpl(_$WorkspaceAnalyticsImpl _value,
      $Res Function(_$WorkspaceAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceId = null,
    Object? period = null,
    Object? totalEvents = null,
    Object? totalMembers = null,
    Object? topContributors = null,
  }) {
    return _then(_$WorkspaceAnalyticsImpl(
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsPeriod,
      totalEvents: null == totalEvents
          ? _value.totalEvents
          : totalEvents // ignore: cast_nullable_to_non_nullable
              as int,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      topContributors: null == topContributors
          ? _value._topContributors
          : topContributors // ignore: cast_nullable_to_non_nullable
              as List<TeamActivity>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceAnalyticsImpl implements _WorkspaceAnalytics {
  const _$WorkspaceAnalyticsImpl(
      {required this.workspaceId,
      required this.period,
      required this.totalEvents,
      required this.totalMembers,
      final List<TeamActivity> topContributors = const []})
      : _topContributors = topContributors;

  factory _$WorkspaceAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceAnalyticsImplFromJson(json);

  @override
  final String workspaceId;
  @override
  final AnalyticsPeriod period;
  @override
  final int totalEvents;
  @override
  final int totalMembers;
  final List<TeamActivity> _topContributors;
  @override
  @JsonKey()
  List<TeamActivity> get topContributors {
    if (_topContributors is EqualUnmodifiableListView) return _topContributors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topContributors);
  }

  @override
  String toString() {
    return 'WorkspaceAnalytics(workspaceId: $workspaceId, period: $period, totalEvents: $totalEvents, totalMembers: $totalMembers, topContributors: $topContributors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceAnalyticsImpl &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.totalEvents, totalEvents) ||
                other.totalEvents == totalEvents) &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            const DeepCollectionEquality()
                .equals(other._topContributors, _topContributors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workspaceId, period, totalEvents,
      totalMembers, const DeepCollectionEquality().hash(_topContributors));

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceAnalyticsImplCopyWith<_$WorkspaceAnalyticsImpl> get copyWith =>
      __$$WorkspaceAnalyticsImplCopyWithImpl<_$WorkspaceAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceAnalytics implements WorkspaceAnalytics {
  const factory _WorkspaceAnalytics(
      {required final String workspaceId,
      required final AnalyticsPeriod period,
      required final int totalEvents,
      required final int totalMembers,
      final List<TeamActivity> topContributors}) = _$WorkspaceAnalyticsImpl;

  factory _WorkspaceAnalytics.fromJson(Map<String, dynamic> json) =
      _$WorkspaceAnalyticsImpl.fromJson;

  @override
  String get workspaceId;
  @override
  AnalyticsPeriod get period;
  @override
  int get totalEvents;
  @override
  int get totalMembers;
  @override
  List<TeamActivity> get topContributors;

  /// Create a copy of WorkspaceAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceAnalyticsImplCopyWith<_$WorkspaceAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
