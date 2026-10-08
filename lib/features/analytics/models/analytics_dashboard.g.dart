// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDashboardImpl _$$AnalyticsDashboardImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsDashboardImpl(
      period: AnalyticsPeriod.fromJson(json['period'] as Map<String, dynamic>),
      taskMetrics:
          TaskMetrics.fromJson(json['taskMetrics'] as Map<String, dynamic>),
      eventCounts: (json['eventCounts'] as List<dynamic>?)
              ?.map((e) => EventCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyActivity: (json['dailyActivity'] as List<dynamic>?)
              ?.map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      workspaceId: json['workspaceId'] as String?,
    );

Map<String, dynamic> _$$AnalyticsDashboardImplToJson(
        _$AnalyticsDashboardImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'taskMetrics': instance.taskMetrics,
      'eventCounts': instance.eventCounts,
      'dailyActivity': instance.dailyActivity,
      'workspaceId': instance.workspaceId,
    };

_$AnalyticsPeriodImpl _$$AnalyticsPeriodImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsPeriodImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$AnalyticsPeriodImplToJson(
        _$AnalyticsPeriodImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

_$TaskMetricsImpl _$$TaskMetricsImplFromJson(Map<String, dynamic> json) =>
    _$TaskMetricsImpl(
      totalCreated: (json['totalCreated'] as num?)?.toInt() ?? 0,
      totalCompleted: (json['totalCompleted'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
      avgCompletionTimeHours:
          (json['avgCompletionTimeHours'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TaskMetricsImplToJson(_$TaskMetricsImpl instance) =>
    <String, dynamic>{
      'totalCreated': instance.totalCreated,
      'totalCompleted': instance.totalCompleted,
      'completionRate': instance.completionRate,
      'avgCompletionTimeHours': instance.avgCompletionTimeHours,
    };

_$EventCountImpl _$$EventCountImplFromJson(Map<String, dynamic> json) =>
    _$EventCountImpl(
      eventType: json['eventType'] as String,
      eventCount: (json['eventCount'] as num).toInt(),
    );

Map<String, dynamic> _$$EventCountImplToJson(_$EventCountImpl instance) =>
    <String, dynamic>{
      'eventType': instance.eventType,
      'eventCount': instance.eventCount,
    };

_$DailyActivityImpl _$$DailyActivityImplFromJson(Map<String, dynamic> json) =>
    _$DailyActivityImpl(
      activityDate: DateTime.parse(json['activityDate'] as String),
      eventCount: (json['eventCount'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyActivityImplToJson(_$DailyActivityImpl instance) =>
    <String, dynamic>{
      'activityDate': instance.activityDate.toIso8601String(),
      'eventCount': instance.eventCount,
    };
