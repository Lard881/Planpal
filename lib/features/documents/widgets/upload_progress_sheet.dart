import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../providers/document_providers.dart';
import '../services/file_upload_service.dart';

class UploadProgressSheet extends ConsumerWidget {
  const UploadProgressSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(uploadTasksProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.uploads,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Tasks list
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noUploads,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // File name
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task.fileName,
                                    style: Theme.of(context).textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Actions
                                if (task.status == UploadStatus.uploading)
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      ref
                                          .read(fileUploadServiceProvider)
                                          .cancelUpload(task.id);
                                    },
                                  ),
                                if (task.status == UploadStatus.failed)
                                  IconButton(
                                    icon: const Icon(Icons.refresh, size: 20),
                                    onPressed: () async {
                                      await ref
                                          .read(fileUploadServiceProvider)
                                          .retryUpload(task.id);
                                    },
                                  ),
                                if (task.status == UploadStatus.completed ||
                                    task.status == UploadStatus.cancelled)
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () {
                                      ref
                                          .read(fileUploadServiceProvider)
                                          .removeTask(task.id);
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Progress bar
                            if (task.status == UploadStatus.uploading)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: task.progress,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(task.progress * 100).toStringAsFixed(0)}%',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),

                            // Status
                            if (task.status != UploadStatus.uploading)
                              Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(task.status),
                                    size: 16,
                                    color: _getStatusColor(task.status),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _getStatusText(task.status, l10n),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: _getStatusColor(task.status),
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                            // Error message
                            if (task.error != null && task.status == UploadStatus.failed)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  task.error!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(l10n.errorLoadingData)),
            ),
          ),

          // Actions
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(fileUploadServiceProvider).clearCompleted();
                  },
                  child: Text(l10n.clearCompleted),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(fileUploadServiceProvider).clearFailed();
                  },
                  child: Text(l10n.clearFailed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(UploadStatus status) {
    switch (status) {
      case UploadStatus.completed:
        return Icons.check_circle;
      case UploadStatus.failed:
        return Icons.error;
      case UploadStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  Color _getStatusColor(UploadStatus status) {
    switch (status) {
      case UploadStatus.completed:
        return Colors.green;
      case UploadStatus.failed:
        return Colors.red;
      case UploadStatus.cancelled:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(UploadStatus status, AppLocalizations l10n) {
    switch (status) {
      case UploadStatus.completed:
        return l10n.uploadCompleted;
      case UploadStatus.failed:
        return l10n.uploadFailed;
      case UploadStatus.cancelled:
        return l10n.uploadCancelled;
      case UploadStatus.idle:
        return l10n.waiting;
      case UploadStatus.uploading:
        return l10n.uploading;
    }
  }
}
