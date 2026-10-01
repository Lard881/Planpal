import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

/// Search result type enum
enum SearchResultType {
  task,
  document,
  person,
}

/// Extension for parsing search result type
extension SearchResultTypeExtension on SearchResultType {
  String get value {
    switch (this) {
      case SearchResultType.task:
        return 'task';
      case SearchResultType.document:
        return 'document';
      case SearchResultType.person:
        return 'person';
    }
  }

  static SearchResultType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'task':
        return SearchResultType.task;
      case 'document':
        return SearchResultType.document;
      case 'person':
        return SearchResultType.person;
      default:
        return SearchResultType.task;
    }
  }
}

/// Base search result item
@freezed
class SearchResultItem with _$SearchResultItem {
  const factory SearchResultItem({
    required String id,
    required SearchResultType type,
    required String title,
    String? description,
    required int matchScore,
    String? workspaceId,
    String? workspaceName,
    Map<String, dynamic>? metadata,
  }) = _SearchResultItem;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemFromJson(json);
}

/// Task search result
@freezed
class TaskSearchResult with _$TaskSearchResult {
  const factory TaskSearchResult({
    required String id,
    required String title,
    String? description,
    required String status,
    String? priority,
    DateTime? dueDate,
    required String workspaceId,
    String? workspaceName,
    String? projectId,
    String? assignedTo,
    required DateTime createdAt,
    required int matchScore,
  }) = _TaskSearchResult;

  factory TaskSearchResult.fromJson(Map<String, dynamic> json) =>
      _$TaskSearchResultFromJson(json);
}

/// Document search result
@freezed
class DocumentSearchResult with _$DocumentSearchResult {
  const factory DocumentSearchResult({
    required String id,
    required String title,
    String? content,
    required String workspaceId,
    String? workspaceName,
    String? folderId,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int matchScore,
  }) = _DocumentSearchResult;

  factory DocumentSearchResult.fromJson(Map<String, dynamic> json) =>
      _$DocumentSearchResultFromJson(json);
}

/// Person workspace info
@freezed
class PersonWorkspace with _$PersonWorkspace {
  const factory PersonWorkspace({
    required String id,
    required String name,
    required String role,
  }) = _PersonWorkspace;

  factory PersonWorkspace.fromJson(Map<String, dynamic> json) =>
      _$PersonWorkspaceFromJson(json);
}

/// Person search result
@freezed
class PersonSearchResult with _$PersonSearchResult {
  const factory PersonSearchResult({
    required String id,
    required String fullName,
    required String email,
    String? avatarUrl,
    required List<PersonWorkspace> workspaces,
    required int matchScore,
  }) = _PersonSearchResult;

  factory PersonSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PersonSearchResultFromJson(json);
}

/// Search results container
@freezed
class SearchResults with _$SearchResults {
  const factory SearchResults({
    required String query,
    required String type,
    String? workspaceId,
    required int totalCount,
    required SearchResultsGroup tasks,
    required SearchResultsGroup documents,
    required SearchResultsGroup people,
  }) = _SearchResults;

  factory SearchResults.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsFromJson(json);
}

/// Search results group (for each type)
@freezed
class SearchResultsGroup with _$SearchResultsGroup {
  const factory SearchResultsGroup({
    required List<dynamic> items,
    required int count,
  }) = _SearchResultsGroup;

  factory SearchResultsGroup.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsGroupFromJson(json);
}

/// Search filter options
@freezed
class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    @Default('all') String type,
    String? workspaceId,
    @Default(20) int limit,
    @Default(0) int offset,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);
}
