import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    @JsonKey(name: 'entity_id') required String entityId,
    @JsonKey(name: 'entity_type') required String entityType,
    required String title,
    String? subtitle,
    @JsonKey(name: 'workspace_id') String? workspaceId,
    @JsonKey(name: 'workspace_name') String? workspaceName,
    @JsonKey(name: 'match_rank') double? matchRank,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

extension SearchResultX on SearchResult {
  /// Get match percentage (0-100)
  int get matchPercentage {
    if (matchRank == null) return 0;
    // matchRank is typically between 0 and 1 from ts_rank
    return (matchRank! * 100).clamp(0, 100).round();
  }

  /// Get entity type label
  String get entityTypeLabel {
    switch (entityType) {
      case 'task':
        return 'Task';
      case 'document':
        return 'Document';
      case 'person':
        return 'Person';
      default:
        return entityType;
    }
  }

  /// Get icon for entity type
  String get iconName {
    switch (entityType) {
      case 'task':
        return 'check_circle';
      case 'document':
        return 'description';
      case 'person':
        return 'person';
      default:
        return 'help_outline';
    }
  }
}
