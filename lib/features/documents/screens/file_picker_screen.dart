import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:mime/mime.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../features/auth/presentation/auth_providers.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../providers/document_providers.dart';
import '../services/file_upload_service.dart';
import '../repositories/document_repository.dart';

class FilePickerScreen extends ConsumerStatefulWidget {
  const FilePickerScreen({super.key});

  @override
  ConsumerState<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends ConsumerState<FilePickerScreen> {
  bool _isDragging = false;
  final List<String> _taskIds = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWindows = Platform.isWindows;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadFile),
      ),
      body: isWindows
          ? _buildDragDropArea(context, l10n)
          : _buildMobileUpload(context, l10n),
    );
  }

  Widget _buildDragDropArea(BuildContext context, AppLocalizations l10n) {
    return DropTarget(
      onDragEntered: (details) {
        setState(() => _isDragging = true);
      },
      onDragExited: (details) {
        setState(() => _isDragging = false);
      },
      onDragDone: (details) async {
        setState(() => _isDragging = false);

        for (final file in details.files) {
          await _uploadFile(File(file.path));
        }

        if (mounted && _taskIds.isNotEmpty) {
          // Start uploads
          for (final taskId in _taskIds) {
            ref.read(fileUploadServiceProvider).startUpload(taskId);
          }

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.uploadStarted(_taskIds.length)),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDragging ? Theme.of(context).primaryColor : Colors.grey,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _isDragging
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload,
                size: 64,
                color: _isDragging
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                _isDragging
                    ? l10n.dropFilesHere
                    : l10n.dragAndDropFiles,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.orClickToBrowse,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.file_upload),
                label: Text(l10n.browseFiles),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileUpload(BuildContext context, AppLocalizations l10n) {
    // Check connectivity (simplified - in production use connectivity_plus)
    final isOnline = true; // TODO: Implement actual connectivity check

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isOnline) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.offlineUploadsDisabled,
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            Icon(
              Icons.cloud_upload,
              size: 64,
              color: isOnline
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.selectFilesToUpload,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: isOnline ? _pickFiles : null,
              icon: const Icon(Icons.file_upload),
              label: Text(l10n.browseFiles),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', 'gif', 'webp', // images
        'pdf', // documents
        'doc', 'docx', 'xls', 'xlsx', // office
        'txt', 'csv', // text
        'zip', // archive
      ],
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.path != null) {
        await _uploadFile(File(file.path!));
      }
    }

    if (mounted && _taskIds.isNotEmpty) {
      // Start uploads
      for (final taskId in _taskIds) {
        ref.read(fileUploadServiceProvider).startUpload(taskId);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.uploadStarted(_taskIds.length)),
        ),
      );
    }
  }

  Future<void> _uploadFile(File file) async {
    final workspaceId = ref.read(currentWorkspaceIdProvider);
    final folderId = ref.read(currentFolderIdProvider);
    final userId = ref.read(currentUserIdProvider);

    if (workspaceId == null || userId == null) return;

    final fileName = file.path.split(Platform.pathSeparator).last;
    final fileSize = await file.length();
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    // Add to upload queue
    final taskId = ref.read(fileUploadServiceProvider).addFile(
          filePath: file.path,
          fileName: fileName,
          fileSize: fileSize,
          mimeType: mimeType,
          workspaceId: workspaceId,
          folderId: folderId,
        );

    _taskIds.add(taskId);
  }
}
