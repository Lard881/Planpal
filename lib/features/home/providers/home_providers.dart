// app/lib/features/home/providers/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/home_repository.dart';
import '../models/home_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

class HomeState {
  final String range;
  final HomeOverview? overview;
  final bool loading;
  final String? error;

  const HomeState({
    this.range = '7d',
    this.overview,
    this.loading = false,
    this.error,
  });

  HomeState copyWith({
    String? range, HomeOverview? overview,
    bool? loading, String? error, bool clearError = false,
  }) => HomeState(
    range: range ?? this.range,
    overview: overview ?? this.overview,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repo;
  final String workspaceId;

  HomeNotifier(this._repo, this.workspaceId) : super(const HomeState()) {
    load();
  }

  Future<void> load({String? range}) async {
    final r = range ?? state.range;
    state = state.copyWith(loading: true, clearError: true, range: r);
    final (overview, err) = await _repo.getOverview(workspaceId, r);
    state = state.copyWith(
      overview: overview,
      loading: false,
      error: err?.message,
    );
  }

  void setRange(String range) => load(range: range);
}

final homeProvider =
    StateNotifierProvider.autoDispose<HomeNotifier, HomeState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
  return HomeNotifier(ref.watch(homeRepositoryProvider), wsId);
});
