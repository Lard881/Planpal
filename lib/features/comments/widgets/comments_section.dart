import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../../../core/providers/app_providers.dart';
import 'comment_input.dart';
import 'comment_list.dart';

/// Complete comments section for a task
class CommentsSection extends ConsumerStatefulWidget {
  final String taskId;

  const CommentsSection({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends ConsumerState<CommentsSection> {
  bool _isLoading = true;
  List<Comment> _comments = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(commentRepositoryProvider);
      final response = await repository.getTaskComments(widget.taskId);
      
      if (mounted) {
        setState(() {
          _comments = response.comments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addComment(String content, List<String> mentions, String? parentId) async {
    try {
      final repository = ref.read(commentRepositoryProvider);
      final request = CreateCommentRequest(
        taskId: widget.taskId,
        content: content,
        parentId: parentId,
        mentions: mentions, // Include mentions
      );

      await repository.createComment(request);

      if (mounted) {
        // Reload to get updated thread structure
        await _loadComments();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(parentId != null ? 'Reply added' : 'Comment added'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _editComment(Comment comment, String newContent) async {
    try {
      final repository = ref.read(commentRepositoryProvider);
      final request = UpdateCommentRequest(content: newContent);

      await repository.updateComment(comment.id, request);

      if (mounted) {
        await _loadComments();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment updated'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update comment: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    try {
      final repository = ref.read(commentRepositoryProvider);
      await repository.deleteComment(comment.id);

      if (mounted) {
        await _loadComments();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete comment: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.comment,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Comments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (_comments.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_comments.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                iconSize: 20,
                onPressed: _isLoading ? null : _loadComments,
                tooltip: 'Refresh comments',
              ),
            ],
          ),
        ),

        const Divider(),

        // Error state
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load comments',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _error!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadComments,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Comment input for new comments
        if (_error == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CommentInput(
              placeholder: 'Add a comment...',
              onSubmit: (content, mentions) => _addComment(content, mentions, null),
            ),
          ),

        const SizedBox(height: 8),

        // Comments list
        if (_error == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CommentList(
              comments: _comments,
              currentUserId: currentUser?.id,
              onAddComment: (content, parentId) => _addComment(content, [], parentId),
              onEditComment: _editComment,
              onDeleteComment: _deleteComment,
              isLoading: _isLoading,
              emptyMessage: 'No comments yet',
            ),
          ),
      ],
    );
  }
}
