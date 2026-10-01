import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_link.dart';
import '../repositories/attachment_repository.dart';
import '../../core/providers/app_providers.dart';
import 'link_card.dart';

/// List widget that displays all links for a task
class LinkList extends ConsumerStatefulWidget {
  final String taskId;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const LinkList({
    Key? key,
    required this.taskId,
    this.showAddButton = true,
    this.onAddPressed,
  }) : super(key: key);

  @override
  ConsumerState<LinkList> createState() => _LinkListState();
}

class _LinkListState extends ConsumerState<LinkList> {
  List<TaskLink>? _links;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(attachmentRepositoryProvider);
      final links = await repository.getTaskLinks(widget.taskId);

      if (mounted) {
        setState(() {
          _links = links;
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
                'Failed to load links',
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
                onPressed: _loadLinks,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_links == null || _links!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No links',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add links to reference external resources',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              if (widget.showAddButton && widget.onAddPressed != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Link'),
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
                'Links (${_links!.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.showAddButton && widget.onAddPressed != null)
                IconButton(
                  onPressed: widget.onAddPressed,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add link',
                ),
            ],
          ),
        ),

        // Link list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: _links!.length,
          itemBuilder: (context, index) {
            final link = _links![index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: LinkCard(
                link: link,
                onDelete: _loadLinks, // Reload after delete
              ),
            );
          },
        ),
      ],
    );
  }
}
