// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResponseImpl _$$SearchResponseImplFromJson(Map<String, dynamic> json) =>
    _$SearchResponseImpl(
      counts: SearchCounts.fromJson(json['counts'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SearchResponseImplToJson(
        _$SearchResponseImpl instance) =>
    <String, dynamic>{
      'counts': instance.counts,
      'results': instance.results,
    };

_$SearchCountsImpl _$$SearchCountsImplFromJson(Map<String, dynamic> json) =>
    _$SearchCountsImpl(
      all: (json['all'] as num).toInt(),
      task: (json['task'] as num).toInt(),
      document: (json['document'] as num).toInt(),
      person: (json['person'] as num).toInt(),
    );

Map<String, dynamic> _$$SearchCountsImplToJson(_$SearchCountsImpl instance) =>
    <String, dynamic>{
      'all': instance.all,
      'task': instance.task,
      'document': instance.document,
      'person': instance.person,
    };
