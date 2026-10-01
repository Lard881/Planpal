import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/sync/sync_log.dart';

/// Screen for viewing sync logs and error history
class SyncLogsScreen extends ConsumerStatefulWidget {
  const SyncLogsScreen({super.key});

  @override
  ConsumerState<SyncLogsScreen> createState() => _SyncLogsScreenState();
}

class _SyncLogsScreenState extends ConsumerState<SyncLogsScreen> {
  SyncLogLevel? _filterLevel;
  SyncLogType? _filterType;
  bool _showErrorsOnly = false;

  @override
  Widget build(BuildContext context) {
    final syncEngine = ref.watch(syncEngineProvider);
    final logger = syncEngine.logger;
    
    final logs = _showErrorsOnly
        ? logger.getErrorLogs()
        : _filterLevel != null
            ? logger.getLogsByLevel(_filterLevel!)
            : _filterType != null
                ? logger.getLogsByType(_filterType!)
                : logger.getRecentLogs(count: 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Logs'),
        actions: [
          // Error filter toggle
          IconButton(
            icon: Icon(
              _showErrorsOnly ? Icons.error : Icons.error_outline,
              color: _showErrorsOnly ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _showErrorsOnly = !_showErrorsOnly;
                if (_showErrorsOnly) {
                  _filterLevel = null;
                  _filterType = null;
                }
              });
            },
            tooltip: 'Show errors only',
          ),
          // Filter menu
          PopupMenuButton<String>(
            icon: Icon(
              _filterLevel != null || _filterType != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onSelected: (value) {
              setState(() {
                _showErrorsOnly = false;
                if (value.startsWith('level_')) {
                  _filterLevel = SyncLogLevel.values[int.parse(value.split('_')[1])];
                  _filterType = null;
                } else if (value.startsWith('type_')) {
                  _filterType = SyncLogType.values[int.parse(value.split('_')[1])];
                  _filterLevel = null;
                } else if (value == 'clear') {
                  _filterLevel = null;
                  _filterType = null;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Filters'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Level',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              for (int i = 0; i < SyncLogLevel.values.length; i++)
                PopupMenuItem(
                  value: 'level_$i',
                  child: Text(SyncLogLevel.values[i].label),
                ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              for (int i = 0; i < 6 && i < SyncLogType.values.length; i++)
                PopupMenuItem(
                  value: 'type_$i',
                  child: Text(SyncLogType.values[i].label),
                ),
            ],
          ),
          // Clear logs
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearDialog(context, logger),
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics card
          _buildStatisticsCard(context, logger),
          
          // Active filter chip
          if (_filterLevel != null || _filterType != null || _showErrorsOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Chip(
                    label: Text(_showErrorsOnly
                        ? 'Errors Only'
                        : _filterLevel?.label ?? _filterType?.label ?? ''),
                    onDeleted: () {
                      setState(() {
                        _filterLevel = null;
                        _filterType = null;
                        _showErrorsOnly = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          
          const Divider(height: 1),
          
          // Logs list
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No logs to display',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: logs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final log = logs[logs.length - 1 - index]; // Reverse order (newest first)
                      return _buildLogCard(context, log);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, dynamic logger) {
    final stats = logger.getStatistics();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatChip(
                  context,
                  'Total',
                  stats['totalLogs'].toString(),
                  Colors.blue,
                ),
                _buildStatChip(
                  context,
                  'Errors',
                  stats['errorCount'].toString(),
                  Colors.red,
                ),
                _buildStatChip(
                  context,
                  'Warnings',
                  stats['warningCount'].toString(),
                  Colors.orange,
                ),
                _buildStatChip(
                  context,
                  'Info',
                  stats['infoCount'].toString(),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, String label, String value, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      label: Text(label),
    );
  }

  Widget _buildLogCard(BuildContext context, SyncLog log) {
    final color = Color(log.level.colorValue);
    
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: InkWell(
        onTap: () => _showLogDetails(context, log),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.level.label.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.type.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Timestamp
                  Text(
                    DateFormat('HH:mm:ss').format(log.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Message
              Text(
                log.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Entity info
              if (log.entityType != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${log.entityType}${log.entityId != null ? ': ${log.entityId}' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              // Error indicator
              if (log.errorDetails != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to view error details',
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(BuildContext context, SyncLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(log.type.label),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Level', log.level.label),
              _buildDetailRow('Time', DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)),
              _buildDetailRow('Message', log.message),
              if (log.entityType != null) _buildDetailRow('Entity Type', log.entityType!),
              if (log.entityId != null) _buildDetailRow('Entity ID', log.entityId!),
              if (log.workspaceId != null) _buildDetailRow('Workspace', log.workspaceId!),
              if (log.errorDetails != null) ...[
                const Divider(),
                const Text(
                  'Error Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    log.errorDetails!,
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
              ],
              if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                const Divider(),
                const Text(
                  'Metadata:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...log.metadata!.entries.map((e) => _buildDetailRow(e.key, e.value.toString())),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context, dynamic logger) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs?'),
        content: const Text('This will permanently delete all sync logs. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      logger.clearAllLogs();
      if (context.mounted) {
        setState(() {}); // Refresh UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All logs cleared')),
        );
      }
    }
  }
}
