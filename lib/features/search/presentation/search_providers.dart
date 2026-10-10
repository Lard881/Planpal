import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/providers/sync_providers.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../features/auth/presentation/auth_providers.dart';
import '../data/search_repository.dart';
import '../models/search_response.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final accessToken = ref.watch(accessTokenProvider);
  final database = ref.watch(appDatabaseProvider);
  return SearchRepository(
    dio: dio,
    accessToken: accessToken,
    database: database,
  );
});

/// Current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Current search type filter
final searchTypeProvider = StateProvider<SearchType>((ref) => SearchType.all);

/// Workspace scope: null = all workspaces, specific ID = that workspace only
final searchWorkspaceProvider = StateProvider<String?>((ref) => null);

/// Search results - debounced and cached
/// Automatically switches to offline search when no connection
final searchResultsProvider = FutureProvider.autoDispose<SearchResponse>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final type = ref.watch(searchTypeProvider);
  final workspaceId = ref.watch(searchWorkspaceProvider);
  final repository = ref.watch(searchRepositoryProvider);
  final connectivity = ref.watch(connectivityProvider);

  // Don't search if query is too short
  if (query.trim().length < 2) {
    return const SearchResponse(
      counts: SearchCounts(all: 0, task: 0, document: 0, person: 0),
      results: [],
    );
  }

  // Debounce: wait a bit before searching
  await Future.delayed(const Duration(milliseconds: 300));

  // Check if the query changed during the delay
  if (ref.state.isRefreshing) {
    return ref.state.value ??
        const SearchResponse(
          counts: SearchCounts(all: 0, task: 0, document: 0, person: 0),
          results: [],
        );
  }

  // Check connectivity and use offline search if needed
  final isOffline = connectivity.currentState != ConnectivityState.online;

  if (isOffline) {
    // Use offline search
    return repository.searchOffline(
      query: query.trim(),
      workspaceId: workspaceId,
      type: type,
    );
  }

  // Use online search
  try {
    return await repository.search(
      query: query.trim(),
      workspaceId: workspaceId,
      type: type,
    );
  } catch (e) {
    // Fallback to offline search on error
    return repository.searchOffline(
      query: query.trim(),
      workspaceId: workspaceId,
      type: type,
    );
  }
});

/// Offline search results (explicitly for offline mode display)
final offlineSearchResultsProvider = FutureProvider.autoDispose<SearchResponse>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final type = ref.watch(searchTypeProvider);
  final workspaceId = ref.watch(searchWorkspaceProvider);
  final repository = ref.watch(searchRepositoryProvider);

  if (query.trim().length < 2) {
    return const SearchResponse(
      counts: SearchCounts(all: 0, task: 0, document: 0, person: 0),
      results: [],
    );
  }

  return repository.searchOffline(
    query: query.trim(),
    workspaceId: workspaceId,
    type: type,
  );
});

/// Check if currently using offline search
final isOfflineSearchProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.currentState != ConnectivityState.online;
});
