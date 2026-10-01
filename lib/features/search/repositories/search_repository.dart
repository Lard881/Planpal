import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/connectivity_service.dart';
import '../models/search_result.dart';
import '../services/offline_search_service.dart';

/// Repository for search operations
/// Supports both online (API) and offline (local DB) search
class SearchRepository {
  final ApiClient _apiClient;
  final AppDatabase? _database;
  final ConnectivityService? _connectivity;
  late final OfflineSearchService? _offlineSearch;

  SearchRepository({
    required ApiClient apiClient,
    AppDatabase? database,
    ConnectivityService? connectivity,
  })  : _apiClient = apiClient,
        _database = database,
        _connectivity = connectivity {
    _offlineSearch = database != null
        ? OfflineSearchService(database: database)
        : null;
  }

  /// Search across all content types
  /// Automatically falls back to offline search when network is unavailable
  Future<SearchResults> search({
    required String query,
    String type = 'all',
    String? workspaceId,
    int limit = 20,
    int offset = 0,
  }) async {
    // Check connectivity
    final isOnline = _connectivity != null
        ? await _connectivity!.isConnected
        : true; // Assume online if connectivity service not provided

    // Try offline search if offline and available
    if (!isOnline && _offlineSearch != null) {
      return await _offlineSearch!.search(
        query: query,
        type: type,
        workspaceId: workspaceId,
        limit: limit,
        offset: offset,
      );
    }

    // Try online search
    try {
      final queryParams = {
        'query': query,
        'type': type,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (workspaceId != null) {
        queryParams['workspaceId'] = workspaceId;
      }

      final response = await _apiClient.get(
        '/search',
        queryParameters: queryParams,
      );

      return SearchResults.fromJson(response.data);
    } on DioException catch (e) {
      // Fall back to offline search if network error and offline search available
      if (_offlineSearch != null &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.unknown)) {
        return await _offlineSearch!.search(
          query: query,
          type: type,
          workspaceId: workspaceId,
          limit: limit,
          offset: offset,
        );
      }

      if (e.response?.statusCode == 400) {
        throw SearchValidationException(
          e.response?.data['error'] ?? 'Invalid search query',
        );
      }
      throw SearchException('Search failed: ${e.message}');
    } catch (e) {
      // Last resort: try offline search if available
      if (_offlineSearch != null) {
        try {
          return await _offlineSearch!.search(
            query: query,
            type: type,
            workspaceId: workspaceId,
            limit: limit,
            offset: offset,
          );
        } catch (offlineError) {
          // If offline search also fails, throw original error
          throw SearchException('Search failed: $e');
        }
      }
      throw SearchException('Search failed: $e');
    }
  }

  /// Search tasks only
  Future<List<TaskSearchResult>> searchTasks({
    required String query,
    String? workspaceId,
    int limit = 20,
  }) async {
    final results = await search(
      query: query,
      type: 'tasks',
      workspaceId: workspaceId,
      limit: limit,
    );

    return results.tasks.items
        .map((item) => TaskSearchResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Search documents only
  Future<List<DocumentSearchResult>> searchDocuments({
    required String query,
    String? workspaceId,
    int limit = 20,
  }) async {
    final results = await search(
      query: query,
      type: 'documents',
      workspaceId: workspaceId,
      limit: limit,
    );

    return results.documents.items
        .map((item) =>
            DocumentSearchResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Search people only
  Future<List<PersonSearchResult>> searchPeople({
    required String query,
    String? workspaceId,
    int limit = 20,
  }) async {
    final results = await search(
      query: query,
      type: 'people',
      workspaceId: workspaceId,
      limit: limit,
    );

    return results.people.items
        .map((item) => PersonSearchResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Check if offline search is available
  bool get hasOfflineSearch => _offlineSearch?.isAvailable ?? false;

  /// Get count of searchable items (offline only)
  Future<Map<String, int>> getSearchableCounts({String? workspaceId}) async {
    if (_offlineSearch == null) {
      return {'tasks': 0, 'documents': 0, 'people': 0, 'total': 0};
    }
    return await _offlineSearch!.getSearchableCounts(workspaceId: workspaceId);
  }
}

/// Search exception
class SearchException implements Exception {
  final String message;
  SearchException(this.message);

  @override
  String toString() => message;
}

/// Search validation exception
class SearchValidationException extends SearchException {
  SearchValidationException(super.message);
}
