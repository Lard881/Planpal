import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_overview.freezed.dart';
part 'dashboard_overview.g.dart';

/// Dashboard overview data model
/// Lighter version of analytics for home screen
@freezed
class DashboardOverview with _$DashboardOverview {
  const factory DashboardOverview({
    required DashboardCounts counts,
    required int productivityPercent,
    required List<DailyDataPoint> dailySeries,
  }) = _DashboardOverview;

  factory DashboardOverview.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewFromJson(json);
}

@freezed
class DashboardCounts with _$DashboardCounts {
  const factory DashboardCounts({
    required int completed,
    required int inProgress,
    required int overdue,
  }) = _DashboardCounts;

  factory DashboardCounts.fromJson(Map<String, dynamic> json) =>
      _$DashboardCountsFromJson(json);
}

@freezed
class DailyDataPoint with _$DailyDataPoint {
  const factory DailyDataPoint({
    required String date,
    required int completed,
    required int created,
    @JsonKey(name: 'completion_rate') required double completionRate,
  }) = _DailyDataPoint;

  factory DailyDataPoint.fromJson(Map<String, dynamic> json) =>
      _$DailyDataPointFromJson(json);
}
