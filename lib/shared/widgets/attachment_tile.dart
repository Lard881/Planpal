import 'package:flutter/material.dart';

/// Attachment tile component
/// Shows file attachment with name, size, and actions
class AttachmentTile extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;
  final bool isUploading;
  final double? uploadProgress;

  const AttachmentTile({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.onTap,
    this.onDownload,
    this.onDelete,
    this.isUploading = false,
    this.uploadProgress,
  });

  IconData _getFileIcon() {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor() {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return const Color(0xFFEF4444);
      case 'doc':
      case 'docx':
        return const Color(0xFF3B82F6);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF10B981);
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileColor = _getFileColor();
    final fileIcon = _getFileIcon();

    return InkWell(
      onTap: isUploading ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // File icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: fileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(fileIcon, color: fileColor, size: 20),
            ),
            const SizedBox(width: 12),

            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (isUploading && uploadProgress != null)
                    LinearProgressIndicator(value: uploadProgress)
                  else
                    Text(
                      fileSize,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),

            // Actions
            if (!isUploading) ...[
              if (onDownload != null)
                IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  onPressed: onDownload,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
