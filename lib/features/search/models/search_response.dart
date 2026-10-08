import 'package:freezed_annotation/freezed_annotation.dart';
import 'search_result.dart';

part 'search_response.freezed.dart';
part 'search_response.g.dart';

@freezed
class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    required SearchCounts counts,
    required List<SearchResult> results,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}

@freezed
class SearchCounts with _$SearchCounts {
  const factory SearchCounts({
    required int all,
    required int task,
    required int document,
    required int person,
  }) = _SearchCounts;

  factory SearchCounts.fromJson(Map<String, dynamic> json) =>
      _$SearchCountsFromJson(json);
}
