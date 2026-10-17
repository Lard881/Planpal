// app/lib/features/search/data/search_repository.dart
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/search_models.dart';

class SearchRepository {
  final Dio _dio;
  final AppDatabase _db;
  SearchRepository(this._dio, this._db);

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

      final raw = res.data['results'] as List? ?? [];

      final all = raw
          .map((r) => SearchResult.fromJson(r as Map<String, dynamic>))
          .toList();
      final counts = res.data['counts'] as Map<String, dynamic>? ?? const {};
      final tasks = all.where((r) => r.kind == 'task').toList();
      final documents = all.where((r) => r.kind == 'document').toList();
      final people = all.where((r) => r.kind == 'person').toList();

      return (SearchResults(
        tasks: tasks,
        documents: documents,
        people: people,
        totalCount: (counts['all'] as num?)?.toInt() ?? all.length,
        taskCount: (counts['task'] as num?)?.toInt() ?? tasks.length,
        documentCount:
            (counts['document'] as num?)?.toInt() ?? documents.length,
        peopleCount: (counts['person'] as num?)?.toInt() ?? people.length,
      ), null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NetworkFailure ||
          failure is TimeoutFailure ||
          failure is ServerUnreachableFailure) {
        return (await _searchLocal(query, workspaceId), null);
      }
      return (const SearchResults(), failure);
    }
  }

  Future<SearchResults> _searchLocal(String query, String? workspaceId) async {
    final pattern = '%${query.trim()}%';
    final tasksQuery = _db.select(_db.tasks)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.title.like(pattern) &
            (workspaceId == null
                ? const Constant<bool>(true)
                : row.workspaceId.equals(workspaceId)),
      );
    final documentsQuery = _db.select(_db.documents)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.title.like(pattern) &
            (workspaceId == null
                ? const Constant<bool>(true)
                : row.workspaceId.equals(workspaceId)),
      );
    final taskRows = await tasksQuery.get();
    final documentRows = await documentsQuery.get();
    final tasks = taskRows
        .map(
          (row) => SearchResult(
            id: row.id,
            kind: 'task',
            workspaceId: row.workspaceId,
            title: row.title,
            subtitle: row.status,
            at: row.updatedAt,
          ),
        )
        .toList();
    final documents = documentRows
        .map(
          (row) => SearchResult(
            id: row.id,
            kind: 'document',
            workspaceId: row.workspaceId,
            title: row.title,
            at: row.updatedAt,
          ),
        )
        .toList();
    return SearchResults(
      tasks: tasks,
      documents: documents,
      totalCount: tasks.length + documents.length,
      taskCount: tasks.length,
      documentCount: documents.length,
      isOffline: true,
    );
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
  );
});
