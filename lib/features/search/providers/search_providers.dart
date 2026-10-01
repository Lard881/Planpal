import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/providers/app_providers.dart';
import '../repositories/search_repository.dart';
import '../models/search_result.dart';

/// Search repository provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final database = ref.watch(databaseProvider);
  final connectivity = ref.watch(connectivityProvider);
  
  return SearchRepository(
    apiClient: apiClient,
    database: database,
    connectivity: connectivity,
  );
});

/// Current search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Debounced search query provider (300ms delay)
final debouncedSearchQueryProvider = StreamProvider<String>((ref) {
  final controller = StreamController<String>();
  Timer? debounceTimer;

  // Listen to search query changes
  ref.listen<String>(
    searchQueryProvider,
    (previous, next) {
      // Cancel previous timer
      debounceTimer?.cancel();

      // If query is too short, emit immediately
      if (next.trim().length < 2) {
        controller.add(next);
        return;
      }

      // Debounce for 300ms
      debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (!controller.isClosed) {
          controller.add(next);
        }
      });
    },
  );

  // Cleanup
  ref.onDispose(() {
    debounceTimer?.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Current search filter provider
final searchFilterProvider = StateProvider<SearchFilter>((ref) {
  // Initialize with current workspace by default
  final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);
  return SearchFilter(workspaceId: currentWorkspaceId);
});

/// Search results provider (uses debounced query)
final searchResultsProvider = FutureProvider.autoDispose<SearchResults?>((ref) async {
  // Watch debounced query instead of raw query
  final debouncedQueryAsync = ref.watch(debouncedSearchQueryProvider);
  
  return debouncedQueryAsync.when(
    data: (query) async {
      // Don't search if query is too short
      if (query.trim().length < 2) {
        return null;
      }

      final filter = ref.watch(searchFilterProvider);
      final repository = ref.watch(searchRepositoryProvider);
      
      try {
        return await repository.search(
          query: query.trim(),
          type: filter.type,
          workspaceId: filter.workspaceId,
          limit: filter.limit,
          offset: filter.offset,
        );
      } catch (e) {
        // Re-throw to let UI handle the error
        rethrow;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Search loading state provider
final searchLoadingProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(searchResultsProvider);
  return asyncValue.isLoading;
});

/// Search error provider
final searchErrorProvider = Provider<String?>((ref) {
  final asyncValue = ref.watch(searchResultsProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

/// Recent searches provider (stored locally)
final recentSearchesProvider = StateProvider<List<String>>((ref) {
  // TODO: Load from shared preferences
  return [];
});

/// Add search to recent searches
void addRecentSearch(WidgetRef ref, String query) {
  if (query.trim().length < 2) return;
  
  final recent = ref.read(recentSearchesProvider);
  final updated = [
    query.trim(),
    ...recent.where((q) => q != query.trim()).take(9),
  ];
  
  ref.read(recentSearchesProvider.notifier).state = updated;
  // TODO: Save to shared preferences
}

/// Clear recent searches
void clearRecentSearches(WidgetRef ref) {
  ref.read(recentSearchesProvider.notifier).state = [];
  // TODO: Clear from shared preferences
}
