import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attachment.dart';
import '../repositories/attachment_repository.dart';
import '../../core/providers/app_providers.dart';
import 'file_icon.dart';

/// Card widget that displays a single attachment with preview, name, size, and actions
class AttachmentCard extends ConsumerStatefulWidget {
  final Attachment attachment;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDelete;

  const AttachmentCard({
    Key? key,
    required this.attachment,
    this.onTap,
    this.onDelete,
    this.showDelete = true,
  }) : super(key: key);

  @override
  ConsumerState<AttachmentCard> createState() => _AttachmentCardState();
}

class _AttachmentCardState extends ConsumerState<AttachmentCard> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isImage = widget.attachment.mimeType.startsWith('image/');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _isDeleting ? null : widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Thumbnail or file icon
              _buildPreview(isImage),
              const SizedBox(width: 12),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.attachment.fileName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatFileSize(widget.attachment.fileSize),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              if (widget.showDelete)
                _isDeleting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: _handleDelete,
                        tooltip: 'Delete attachment',
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(bool isImage) {
    if (isImage && widget.attachment.thumbnailPath != null) {
      // Show thumbnail for images
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.file(
          File(widget.attachment.thumbnailPath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to file icon if thumbnail fails to load
            return Center(
              child: FileIcon(
                mimeType: widget.attachment.mimeType,
                fileName: widget.attachment.fileName,
                size: 32,
              ),
            );
          },
        ),
      );
    }

    // Show file icon for non-images or if no thumbnail
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: FileIcon(
          mimeType: widget.attachment.mimeType,
          fileName: widget.attachment.fileName,
          size: 32,
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  Future<void> _handleDelete() async {
    if (_isDeleting) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: Text(
          'Are you sure you want to delete "${widget.attachment.fileName}"?',
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

    if (confirmed != true || !mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final repository = ref.read(attachmentRepositoryProvider);
      await repository.deleteAttachment(widget.attachment.id);

      if (mounted) {
        widget.onDelete?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attachment deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete attachment: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }
}
