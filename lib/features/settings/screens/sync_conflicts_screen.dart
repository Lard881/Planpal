import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/sync/sync_engine.dart' as sync;
import '../../../shared/widgets/sync_conflict_dialog.dart';

/// Screen showing all pending sync conflicts
class SyncConflictsScreen extends ConsumerStatefulWidget {
  const SyncConflictsScreen({super.key});

  @override
  ConsumerState<SyncConflictsScreen> createState() => _SyncConflictsScreenState();
}

class _SyncConflictsScreenState extends ConsumerState<SyncConflictsScreen> {
  final List<sync.SyncConflict> _conflicts = [];

  @override
  void initState() {
    super.initState();
    _listenToConflicts();
  }

  void _listenToConflicts() {
    final syncEngine = ref.read(syncEngineProvider);
    
    syncEngine.conflicts.listen((conflict) {
      if (mounted) {
        setState(() {
          _conflicts.add(conflict);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Conflicts'),
        actions: [
          if (_conflicts.isNotEmpty)
            TextButton.icon(
              onPressed: _resolveAllWithServer,
              icon: const Icon(Icons.cloud_done),
              label: const Text('Use Server for All'),
            ),
        ],
      ),
      body: _conflicts.isEmpty
          ? _buildEmptyState(context)
          : _buildConflictsList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Conflicts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All your data is synchronized',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _conflicts.length,
      itemBuilder: (context, index) {
        final conflict = _conflicts[index];
        return _buildConflictCard(context, conflict, index);
      },
    );
  }

  Widget _buildConflictCard(BuildContext context, sync.SyncConflict conflict, int index) {
    final isNewer = conflict.localUpdatedAt.isAfter(conflict.remoteUpdatedAt);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showConflictDialog(conflict, index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getConflictTitle(conflict),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Type: ${conflict.entityType}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildVersionChip(
                      context,
                      'Local',
                      conflict.localUpdatedAt,
                      Colors.blue,
                      isNewer: isNewer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildVersionChip(
                      context,
                      'Server',
                      conflict.remoteUpdatedAt,
                      Colors.green,
                      isNewer: !isNewer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionChip(
    BuildContext context,
    String label,
    DateTime updatedAt,
    Color color, {
    bool isNewer = false,
  }) {
    final timeAgo = _getTimeAgo(updatedAt);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: isNewer ? color : color.withValues(alpha: 0.3),
          width: isNewer ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                label == 'Local' ? Icons.phone_android : Icons.cloud,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (isNewer) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Newer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  String _getConflictTitle(sync.SyncConflict conflict) {
    final data = conflict.localData;
    if (data.containsKey('title')) {
      return data['title']?.toString() ?? 'Untitled';
    }
    if (data.containsKey('name')) {
      return data['name']?.toString() ?? 'Unnamed';
    }
    return conflict.entityId;
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showConflictDialog(sync.SyncConflict conflict, int index) {
    showConflictDialog(context, conflict);
    
    // Remove resolved conflict from list after dialog is closed
    // Note: In a real implementation, you'd want to listen for actual resolution
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _conflicts.length > index) {
        // Conflict might have been resolved, check if it should be removed
        // This is a simplified approach
      }
    });
  }

  Future<void> _resolveAllWithServer() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use Server Version for All?'),
        content: Text(
          'This will apply the server version for all ${_conflicts.length} conflicts. '
          'Your local changes will be overwritten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Use Server'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final syncEngine = ref.read(syncEngineProvider);
    
    for (final conflict in _conflicts) {
      try {
        await syncEngine.resolveConflict(conflict, false);
      } catch (e) {
        // Continue with next conflict even if one fails
        debugPrint('Failed to resolve conflict: $e');
      }
    }

    if (mounted) {
      setState(() {
        _conflicts.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All conflicts resolved with server version'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
