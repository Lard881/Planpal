import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/task_link.dart';
import '../repositories/attachment_repository.dart';
import '../../core/providers/app_providers.dart';

/// Card widget that displays a task link with favicon, title, description, and actions
class LinkCard extends ConsumerStatefulWidget {
  final TaskLink link;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDelete;

  const LinkCard({
    Key? key,
    required this.link,
    this.onTap,
    this.onDelete,
    this.showDelete = true,
  }) : super(key: key);

  @override
  ConsumerState<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends ConsumerState<LinkCard> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _isDeleting ? null : (widget.onTap ?? _handleOpenLink),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Favicon or link icon
              _buildFavicon(),
              const SizedBox(width: 12),

              // Link info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      widget.link.title ?? _getDomainFromUrl(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description
                    if (widget.link.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.link.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // URL
                    const SizedBox(height: 4),
                    Text(
                      widget.link.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Open in browser
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: _isDeleting ? null : _handleOpenLink,
                    tooltip: 'Open link',
                  ),

                  // Delete
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
                            tooltip: 'Delete link',
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavicon() {
    if (widget.link.faviconUrl != null) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.link.faviconUrl!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildLinkIcon();
            },
          ),
        ),
      );
    }

    return _buildLinkIcon();
  }

  Widget _buildLinkIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.link,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _getDomainFromUrl() {
    try {
      final uri = Uri.parse(widget.link.url);
      return uri.host;
    } catch (e) {
      return widget.link.url;
    }
  }

  Future<void> _handleOpenLink() async {
    try {
      final uri = Uri.parse(widget.link.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete() async {
    if (_isDeleting) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Link'),
        content: Text(
          'Are you sure you want to delete this link?\n\n${widget.link.title ?? widget.link.url}',
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
      await repository.deleteLink(widget.link.id);

      if (mounted) {
        widget.onDelete?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete link: $e'),
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
