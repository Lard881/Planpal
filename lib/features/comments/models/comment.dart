import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// Represents a comment on a task with support for threading (replies)
@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String taskId,
    required String authorId,
    required String content,
    String? parentId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    @Default([]) List<String> mentions,
    
    // Populated from joins
    CommentAuthor? author,
    @Default([]) List<Comment> replies,
    int? replyCount,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

/// Author information for a comment
@freezed
class CommentAuthor with _$CommentAuthor {
  const factory CommentAuthor({
    required String id,
    required String name,
    String? avatarUrl,
    String? email,
  }) = _CommentAuthor;

  factory CommentAuthor.fromJson(Map<String, dynamic> json) => _$CommentAuthorFromJson(json);
}

/// Request to create a new comment
@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    String? id,
    required String taskId,
    required String content,
    String? parentId,
    @Default([]) List<String> mentions,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);

  factory CreateCommentRequest.toCreate({
    String? id,
    required String taskId,
    required String content,
    String? parentId,
    List<String>? mentions,
  }) {
    return CreateCommentRequest(
      id: id,
      taskId: taskId,
      content: content,
      parentId: parentId,
      mentions: mentions ?? [],
    );
  }
}

/// Request to update a comment
@freezed
class UpdateCommentRequest with _$UpdateCommentRequest {
  const factory UpdateCommentRequest({
    required String content,
  }) = _UpdateCommentRequest;

  factory UpdateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCommentRequestFromJson(json);
}

/// Response containing list of comments
@freezed
class CommentsResponse with _$CommentsResponse {
  const factory CommentsResponse({
    required List<Comment> comments,
    int? total,
    CommentsPagination? pagination,
  }) = _CommentsResponse;

  factory CommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentsResponseFromJson(json);
}

/// Pagination info for comments
@freezed
class CommentsPagination with _$CommentsPagination {
  const factory CommentsPagination({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
  }) = _CommentsPagination;

  factory CommentsPagination.fromJson(Map<String, dynamic> json) =>
      _$CommentsPaginationFromJson(json);
}
