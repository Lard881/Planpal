// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardOverviewImpl _$$DashboardOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardOverviewImpl(
      counts: DashboardCounts.fromJson(json['counts'] as Map<String, dynamic>),
      productivityPercent: (json['productivityPercent'] as num).toInt(),
      dailySeries: (json['dailySeries'] as List<dynamic>)
          .map((e) => DailyDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardOverviewImplToJson(
        _$DashboardOverviewImpl instance) =>
    <String, dynamic>{
      'counts': instance.counts,
      'productivityPercent': instance.productivityPercent,
      'dailySeries': instance.dailySeries,
    };

_$DashboardCountsImpl _$$DashboardCountsImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardCountsImpl(
      completed: (json['completed'] as num).toInt(),
      inProgress: (json['inProgress'] as num).toInt(),
      overdue: (json['overdue'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardCountsImplToJson(
        _$DashboardCountsImpl instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'inProgress': instance.inProgress,
      'overdue': instance.overdue,
    };

_$DailyDataPointImpl _$$DailyDataPointImplFromJson(Map<String, dynamic> json) =>
    _$DailyDataPointImpl(
      date: json['date'] as String,
      completed: (json['completed'] as num).toInt(),
      created: (json['created'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyDataPointImplToJson(
        _$DailyDataPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'completed': instance.completed,
      'created': instance.created,
      'completion_rate': instance.completionRate,
    };
