import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/config/env.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/db/app_database.dart';
import '../models/search_response.dart';
import '../models/search_result.dart';

class SearchRepository {
  final Dio _dio;
  final String? _accessToken;
  final AppDatabase? _database;

  SearchRepository({
    required Dio dio,
    String? accessToken,
    AppDatabase? database,
  })  : _dio = dio,
        _accessToken = accessToken,
        _database = database;

  /// Search across all entity types
  Future<SearchResponse> search({
    required String query,
    String? workspaceId,
    SearchType type = SearchType.all,
    int limit = 20,
  }) async {
    if (_accessToken == null) {
      return throw const AppFailure.authRequired();
    }

    try {
      final response = await _dio.get(
        '${Env.apiBaseUrl}/search',
        queryParameters: {
          'q': query,
          if (workspaceId != null) 'workspaceId': workspaceId,
          'type': type.value,
          'limit': limit,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
        ),
      );

      return SearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AppFailure.authExpired();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const AppFailure.timeout();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const AppFailure.noNetwork();
      }
      throw AppFailure.serverError(
        message: e.response?.data?['message'] ?? 'Search failed',
      );
    } catch (e) {
      throw AppFailure.unknown(message: e.toString());
    }
  }

  /// Search offline in local database (Drift)
  Future<SearchResponse> searchOffline({
    required String query,
    String? workspaceId,
    SearchType type = SearchType.all,
  }) async {
    if (_database == null) {
      return const SearchResponse(
        counts: SearchCounts(all: 0, task: 0, document: 0, person: 0),
        results: [],
      );
    }

    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];

    // Search tasks
    if (type == SearchType.all || type == SearchType.task) {
      final tasksQuery = _database.select(_database.tasks).join([
        drift.leftOuterJoin(
          _database.workspaces,
          _database.workspaces.id.equalsExp(_database.tasks.workspaceId),
        ),
      ]);

      if (workspaceId != null) {
        tasksQuery.where(_database.tasks.workspaceId.equals(workspaceId));
      }

      final taskRows = await tasksQuery.get();

      for (final row in taskRows) {
        final task = row.readTable(_database.tasks);
        final workspace = row.readTableOrNull(_database.workspaces);

        if (task.title.toLowerCase().contains(lowerQuery) ||
            (task.description?.toLowerCase().contains(lowerQuery) ?? false)) {
          results.add(SearchResult(
            entityId: task.id,
            entityType: 'task',
            title: task.title,
            subtitle: task.description,
            workspaceId: task.workspaceId,
            workspaceName: workspace?.name,
            matchRank: _calculateLocalMatchRank(
              query: lowerQuery,
              title: task.title.toLowerCase(),
              content: task.description?.toLowerCase(),
            ),
          ));
        }
      }
    }

    // Search documents
    if (type == SearchType.all || type == SearchType.document) {
      final docsQuery = _database.select(_database.documents).join([
        drift.leftOuterJoin(
          _database.workspaces,
          _database.workspaces.id.equalsExp(_database.documents.workspaceId),
        ),
      ]);

      if (workspaceId != null) {
        docsQuery.where(_database.documents.workspaceId.equals(workspaceId));
      }

      final docRows = await docsQuery.get();

      for (final row in docRows) {
        final doc = row.readTable(_database.documents);
        final workspace = row.readTableOrNull(_database.workspaces);

        if (doc.title.toLowerCase().contains(lowerQuery) ||
            (doc.content?.toLowerCase().contains(lowerQuery) ?? false)) {
          results.add(SearchResult(
            entityId: doc.id,
            entityType: 'document',
            title: doc.title,
            subtitle: doc.content != null && doc.content!.length > 100
                ? '${doc.content!.substring(0, 100)}...'
                : doc.content,
            workspaceId: doc.workspaceId,
            workspaceName: workspace?.name,
            matchRank: _calculateLocalMatchRank(
              query: lowerQuery,
              title: doc.title.toLowerCase(),
              content: doc.content?.toLowerCase(),
            ),
          ));
        }
      }
    }

    // Search people (profiles)
    if (type == SearchType.all || type == SearchType.person) {
      if (workspaceId != null) {
        // Filter profiles by workspace membership
        final profilesQuery = _database.select(_database.profiles).join([
          drift.innerJoin(
            _database.workspaceMembers,
            _database.workspaceMembers.userId.equalsExp(_database.profiles.id),
          ),
        ])
          ..where(_database.workspaceMembers.workspaceId.equals(workspaceId));

        final profileRows = await profilesQuery.get();

        for (final row in profileRows) {
          final profile = row.readTable(_database.profiles);

          if (profile.fullName.toLowerCase().contains(lowerQuery) ||
              profile.email.toLowerCase().contains(lowerQuery)) {
            results.add(SearchResult(
              entityId: profile.id,
              entityType: 'person',
              title: profile.fullName,
              subtitle: profile.email,
              workspaceId: workspaceId,
              avatarUrl: profile.avatarUrl,
              matchRank: _calculateLocalMatchRank(
                query: lowerQuery,
                title: profile.fullName.toLowerCase(),
                content: profile.email.toLowerCase(),
              ),
            ));
          }
        }
      } else {
        // No workspace filter - search all profiles
        final profilesQuery = _database.select(_database.profiles);
        final profiles = await profilesQuery.get();

        for (final profile in profiles) {
          if (profile.fullName.toLowerCase().contains(lowerQuery) ||
              profile.email.toLowerCase().contains(lowerQuery)) {
            results.add(SearchResult(
              entityId: profile.id,
              entityType: 'person',
              title: profile.fullName,
              subtitle: profile.email,
              avatarUrl: profile.avatarUrl,
              matchRank: _calculateLocalMatchRank(
                query: lowerQuery,
                title: profile.fullName.toLowerCase(),
                content: profile.email.toLowerCase(),
              ),
            ));
          }
        }
      }
    }

    // Sort by match rank descending
    results.sort((a, b) => (b.matchRank ?? 0).compareTo(a.matchRank ?? 0));

    // Calculate counts
    final taskCount =
        results.where((r) => r.entityType == 'task').length;
    final documentCount =
        results.where((r) => r.entityType == 'document').length;
    final personCount =
        results.where((r) => r.entityType == 'person').length;

    return SearchResponse(
      counts: SearchCounts(
        all: results.length,
        task: taskCount,
        document: documentCount,
        person: personCount,
      ),
      results: results,
    );
  }

  /// Calculate a simple match rank for local search (0.0 to 1.0)
  double _calculateLocalMatchRank({
    required String query,
    required String title,
    String? content,
  }) {
    double rank = 0.0;

    // Exact title match = 1.0
    if (title == query) {
      rank = 1.0;
    }
    // Title starts with query = 0.8
    else if (title.startsWith(query)) {
      rank = 0.8;
    }
    // Title contains query = 0.6
    else if (title.contains(query)) {
      rank = 0.6;
    }
    // Content contains query = 0.4
    else if (content != null && content.contains(query)) {
      rank = 0.4;
    }
    // Partial match = 0.2
    else {
      rank = 0.2;
    }

    return rank;
  }
}

enum SearchType {
  all('all'),
  task('task'),
  document('document'),
  person('person');

  final String value;
  const SearchType(this.value);

  static SearchType fromString(String value) {
    return SearchType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SearchType.all,
    );
  }
}
