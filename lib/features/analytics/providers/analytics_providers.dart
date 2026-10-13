// app/lib/features/analytics/providers/analytics_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/analytics_repository.dart';
import '../models/analytics_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

class AnalyticsState {
  final String range; // 7d|30d|90d
  final AnalyticsData? data;
  final bool loading;
  final String? error;

  const AnalyticsState({
    this.range = '30d',
    this.data,
    this.loading = false,
    this.error,
  });

  AnalyticsState copyWith({
    String? range, AnalyticsData? data,
    bool? loading, String? error, bool clearError = false,
  }) => AnalyticsState(
    range: range ?? this.range,
    data: data ?? this.data,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsRepository _repo;
  final String workspaceId;

  AnalyticsNotifier(this._repo, this.workspaceId)
      : super(const AnalyticsState()) {
    load();
  }

  Future<void> load({String? range}) async {
    final r = range ?? state.range;
    state = state.copyWith(loading: true, clearError: true, range: r);
    final (data, err) = await _repo.getAnalytics(workspaceId, r);
    state = state.copyWith(
      data: data,
      loading: false,
      error: err?.message,
    );
  }

  void setRange(String range) => load(range: range);
}

final analyticsProvider =
    StateNotifierProvider.autoDispose<AnalyticsNotifier, AnalyticsState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
  return AnalyticsNotifier(ref.watch(analyticsRepositoryProvider), wsId);
});
