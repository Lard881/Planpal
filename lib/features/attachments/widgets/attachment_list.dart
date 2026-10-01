import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attachment.dart';
import '../repositories/attachment_repository.dart';
import '../../core/providers/app_providers.dart';
import 'attachment_card.dart';
import 'attachment_preview.dart';

/// List widget that displays all attachments for a task
class AttachmentList extends ConsumerStatefulWidget {
  final String taskId;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const AttachmentList({
    Key? key,
    required this.taskId,
    this.showAddButton = true,
    this.onAddPressed,
  }) : super(key: key);

  @override
  ConsumerState<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState extends ConsumerState<AttachmentList> {
  List<Attachment>? _attachments;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(attachmentRepositoryProvider);
      final attachments = await repository.getTaskAttachments(widget.taskId);

      if (mounted) {
        setState(() {
          _attachments = attachments;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load attachments',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadAttachments,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_attachments == null || _attachments!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_file,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No attachments',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add files or links to this task',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              if (widget.showAddButton && widget.onAddPressed != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Attachment'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with count and add button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'Attachments (${_attachments!.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.showAddButton && widget.onAddPressed != null)
                IconButton(
                  onPressed: widget.onAddPressed,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add attachment',
                ),
            ],
          ),
        ),

        // Attachment list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: _attachments!.length,
          itemBuilder: (context, index) {
            final attachment = _attachments![index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AttachmentCard(
                attachment: attachment,
                onTap: () => _showAttachmentPreview(attachment),
                onDelete: _loadAttachments, // Reload after delete
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAttachmentPreview(Attachment attachment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AttachmentPreview(attachment: attachment),
      ),
    );
  }
}
