// app/lib/features/search/providers/search_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/search_repository.dart';
import '../models/search_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

class SearchState {
  final String query;
  final String filter; // all|task|document|person
  final bool scopeAll; // false = this workspace, true = all workspaces
  final SearchResults results;
  final bool loading;
  final String? error;

  const SearchState({
    this.query = '',
    this.filter = 'all',
    this.scopeAll = false,
    this.results = const SearchResults(),
    this.loading = false,
    this.error,
  });

  SearchState copyWith({
    String? query, String? filter, bool? scopeAll,
    SearchResults? results, bool? loading, String? error,
    bool clearError = false,
  }) => SearchState(
    query: query ?? this.query,
    filter: filter ?? this.filter,
    scopeAll: scopeAll ?? this.scopeAll,
    results: results ?? this.results,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );

  List get filteredResults {
    switch (filter) {
      case 'task': return results.tasks;
      case 'document': return results.documents;
      case 'person': return results.people;
      default: return results.all;
    }
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repo;
  final String? workspaceId;

  SearchNotifier(this._repo, this.workspaceId) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.length < 2) {
      state = state.copyWith(query: query, results: const SearchResults());
      return;
    }
    state = state.copyWith(query: query, loading: true, clearError: true);
    final wsId = state.scopeAll ? null : workspaceId;
    final (results, err) = await _repo.search(query, workspaceId: wsId);
    state = state.copyWith(
      results: results,
      loading: false,
      error: err?.message,
    );
  }

  void setFilter(String filter) => state = state.copyWith(filter: filter);

  Future<void> toggleScope() async {
    state = state.copyWith(scopeAll: !state.scopeAll);
    if (state.query.length >= 2) await search(state.query);
  }
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider);
  return SearchNotifier(ref.watch(searchRepositoryProvider), wsId);
});
