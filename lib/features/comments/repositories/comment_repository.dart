import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/comment.dart';

/// Repository for managing comments
class CommentRepository {
  final ApiClient _apiClient;

  CommentRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Get comments for a task with threading
  Future<CommentsResponse> getTaskComments(String taskId) async {
    try {
      final response = await _apiClient.get('/comments/task/$taskId');
      return CommentsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get comments with filters
  Future<CommentsResponse> getComments({
    String? taskId,
    String? authorId,
    String? parentId,
    int page = 1,
    int limit = 50,
    DateTime? updatedSince,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (taskId != null) queryParams['task_id'] = taskId;
      if (authorId != null) queryParams['author_id'] = authorId;
      if (parentId != null) {
        queryParams['parent_id'] = parentId;
      } else if (parentId == null) {
        // Get only top-level comments
        queryParams['parent_id'] = 'null';
      }
      if (updatedSince != null) {
        queryParams['updated_since'] = updatedSince.toIso8601String();
      }

      final response = await _apiClient.get(
        '/comments',
        queryParameters: queryParams,
      );

      return CommentsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single comment by ID
  Future<Comment> getComment(String id) async {
    try {
      final response = await _apiClient.get('/comments/$id');
      return Comment.fromJson(response.data['comment']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new comment
  Future<Comment> createComment(CreateCommentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/comments',
        data: request.toJson(),
      );
      return Comment.fromJson(response.data['comment']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update a comment
  Future<Comment> updateComment(
    String id,
    UpdateCommentRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/comments/$id',
        data: request.toJson(),
      );
      return Comment.fromJson(response.data['comment']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a comment
  Future<void> deleteComment(String id) async {
    try {
      await _apiClient.delete('/comments/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get replies for a comment
  Future<List<Comment>> getReplies(String parentId) async {
    try {
      final response = await _apiClient.get(
        '/comments',
        queryParameters: {
          'parent_id': parentId,
          'limit': 100, // Get all replies
        },
      );

      final data = CommentsResponse.fromJson(response.data);
      return data.comments;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle API errors
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      String? message;
      if (data is Map && data['error'] is Map) {
        message = data['error']['message'] as String?;
      }
      return Exception(message ?? 'Failed to process comment request');
    }
    return Exception('Network error: ${error.message}');
  }
}
