// app/lib/features/search/models/search_models.dart
class SearchResult {
  final String id;
  final String kind; // 'task' | 'document' | 'person'
  final String workspaceId;
  final String title;
  final String subtitle;
  final double score;
  final DateTime? at;

  const SearchResult({
    required this.id,
    required this.kind,
    required this.workspaceId,
    required this.title,
    this.subtitle = '',
    this.score = 0,
    this.at,
  });

  factory SearchResult.fromJson(Map<String, dynamic> j) => SearchResult(
    id: j['id'] as String,
    kind: j['kind'] as String? ?? 'task',
    workspaceId: j['workspace_id'] as String? ?? '',
    title: j['title'] as String? ?? '',
    subtitle: j['subtitle'] as String? ?? '',
    score: (j['score'] as num?)?.toDouble() ?? 0,
    at: j['at'] != null ? DateTime.parse(j['at'] as String) : null,
  );
}

class SearchResults {
  final List<SearchResult> tasks;
  final List<SearchResult> documents;
  final List<SearchResult> people;
  final int totalCount;
  final bool isOffline;

  const SearchResults({
    this.tasks = const [],
    this.documents = const [],
    this.people = const [],
    this.totalCount = 0,
    this.isOffline = false,
  });

  List<SearchResult> get all => [...tasks, ...documents, ...people];

  // Score as percentage relative to max
  int scorePercent(SearchResult result) {
    final allScores = all.map((r) => r.score).toList();
    if (allScores.isEmpty) return 0;
    final maxScore = allScores.reduce((a, b) => a > b ? a : b);
    if (maxScore == 0) return 0;
    return (100 * result.score / maxScore).round().clamp(1, 100);
  }
}
