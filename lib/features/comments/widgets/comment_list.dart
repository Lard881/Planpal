import 'package:flutter/material.dart';
import '../models/comment.dart';
import 'comment_card.dart';
import 'comment_input.dart';

/// Widget displaying a threaded list of comments
class CommentList extends StatefulWidget {
  final List<Comment> comments;
  final String? currentUserId;
  final Function(String content, String? parentId) onAddComment;
  final Function(Comment comment, String newContent) onEditComment;
  final Function(Comment comment) onDeleteComment;
  final bool isLoading;
  final String? emptyMessage;

  const CommentList({
    super.key,
    required this.comments,
    this.currentUserId,
    required this.onAddComment,
    required this.onEditComment,
    required this.onDeleteComment,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  String? _replyingToId;
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.comments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.comment_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                widget.emptyMessage ?? 'No comments yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to comment!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return _buildCommentThread(comment);
      },
    );
  }

  Widget _buildCommentThread(Comment comment) {
    final isEditing = _editingId == comment.id;
    final isReplying = _replyingToId == comment.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        if (!isEditing)
          CommentCard(
            comment: comment,
            currentUserId: widget.currentUserId,
            onReply: () {
              setState(() {
                _replyingToId = comment.id;
                _editingId = null;
              });
            },
            onEdit: widget.currentUserId == comment.authorId
                ? () {
                    setState(() {
                      _editingId = comment.id;
                      _replyingToId = null;
                    });
                  }
                : null,
            onDelete: () => _showDeleteDialog(comment),
          )
        else
          // Edit mode
          CommentInput(
            initialValue: comment.content,
            autoFocus: true,
            placeholder: 'Edit your comment...',
            onCancel: () {
              setState(() => _editingId = null);
            },
            onSubmit: (content, mentions) {
              widget.onEditComment(comment, content);
              setState(() => _editingId = null);
            },
          ),

        // Reply input
        if (isReplying)
          CommentInput(
            isReply: true,
            replyToName: comment.author?.name,
            autoFocus: true,
            onCancel: () {
              setState(() => _replyingToId = null);
            },
            onSubmit: (content, mentions) {
              widget.onAddComment(content, comment.id);
              setState(() => _replyingToId = null);
            },
          ),

        // Replies
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              children: comment.replies.map((reply) {
                final isEditingReply = _editingId == reply.id;
                return Column(
                  children: [
                    if (!isEditingReply)
                      CommentCard(
                        comment: reply,
                        currentUserId: widget.currentUserId,
                        isReply: true,
                        onEdit: widget.currentUserId == reply.authorId
                            ? () {
                                setState(() {
                                  _editingId = reply.id;
                                  _replyingToId = null;
                                });
                              }
                            : null,
                        onDelete: () => _showDeleteDialog(reply),
                      )
                    else
                      CommentInput(
                        initialValue: reply.content,
                        autoFocus: true,
                        isReply: true,
                        placeholder: 'Edit your reply...',
                        onCancel: () {
                          setState(() => _editingId = null);
                        },
                        onSubmit: (content, mentions) {
                          widget.onEditComment(reply, content);
                          setState(() => _editingId = null);
                        },
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Future<void> _showDeleteDialog(Comment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment?'),
        content: const Text(
          'This comment will be permanently deleted. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      widget.onDeleteComment(comment);
    }
  }
}
