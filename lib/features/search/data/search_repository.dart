// app/lib/features/search/data/search_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/search_models.dart';

class SearchRepository {
  final Dio _dio;
  SearchRepository(this._dio);

  Future<(SearchResults, AppFailure?)> search(
    String query, {
    String? workspaceId,
    String? type,
  }) async {
    try {
      final params = <String, dynamic>{'q': query};
      if (workspaceId != null) params['workspaceId'] = workspaceId;
      if (type != null && type != 'all') params['type'] = type;

      final res = await _dio.get('/search', queryParameters: params);

      // Handle known backend issue — results may use 'results' or 'data' key
      final raw = res.data['results'] as List? ??
          res.data['data'] as List? ?? [];
      final counts = res.data['counts'] as Map? ?? {};

      final all = raw
          .map((r) => SearchResult.fromJson(r as Map<String, dynamic>))
          .toList();

      return (SearchResults(
        tasks: all.where((r) => r.kind == 'task').toList(),
        documents: all.where((r) => r.kind == 'document').toList(),
        people: all.where((r) => r.kind == 'person').toList(),
        totalCount: all.length,
      ), null);
    } on DioException catch (e) {
      return (const SearchResults(), mapDioError(e));
    }
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(apiClientProvider).dio);
});
