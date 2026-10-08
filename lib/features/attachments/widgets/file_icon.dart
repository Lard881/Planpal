import 'package:flutter/material.dart';

/// Widget that displays an appropriate icon for a file based on its MIME type or extension
class FileIcon extends StatelessWidget {
  final String? mimeType;
  final String? fileName;
  final double size;
  final Color? color;

  const FileIcon({
    Key? key,
    this.mimeType,
    this.fileName,
    this.size = 40.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconForFile();
    final iconColor = color ?? _getColorForFile(context);

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }

  IconData _getIconForFile() {
    // Check MIME type first
    if (mimeType != null) {
      if (mimeType!.startsWith('image/')) {
        return Icons.image;
      } else if (mimeType!.startsWith('video/')) {
        return Icons.video_file;
      } else if (mimeType!.startsWith('audio/')) {
        return Icons.audio_file;
      } else if (mimeType == 'application/pdf') {
        return Icons.picture_as_pdf;
      } else if (mimeType == 'application/msword' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
        return Icons.description;
      } else if (mimeType == 'application/vnd.ms-excel' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
        return Icons.table_chart;
      } else if (mimeType == 'application/vnd.ms-powerpoint' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.presentationml.presentation') {
        return Icons.slideshow;
      } else if (mimeType == 'application/zip' ||
          mimeType == 'application/x-zip-compressed') {
        return Icons.folder_zip;
      } else if (mimeType == 'text/plain') {
        return Icons.text_snippet;
      } else if (mimeType == 'application/json') {
        return Icons.code;
      } else if (mimeType == 'text/csv') {
        return Icons.table_rows;
      }
    }

    // Fall back to file extension
    if (fileName != null) {
      final extension = fileName!.split('.').last.toLowerCase();
      switch (extension) {
        case 'jpg':
        case 'jpeg':
        case 'png':
        case 'gif':
        case 'webp':
        case 'svg':
          return Icons.image;
        case 'pdf':
          return Icons.picture_as_pdf;
        case 'doc':
        case 'docx':
          return Icons.description;
        case 'xls':
        case 'xlsx':
          return Icons.table_chart;
        case 'ppt':
        case 'pptx':
          return Icons.slideshow;
        case 'zip':
          return Icons.folder_zip;
        case 'txt':
          return Icons.text_snippet;
        case 'json':
          return Icons.code;
        case 'csv':
          return Icons.table_rows;
        default:
          return Icons.insert_drive_file;
      }
    }

    // Default file icon
    return Icons.insert_drive_file;
  }

  Color _getColorForFile(BuildContext context) {
    final theme = Theme.of(context);

    if (mimeType != null) {
      if (mimeType!.startsWith('image/')) {
        return Colors.purple;
      } else if (mimeType!.startsWith('video/')) {
        return Colors.red;
      } else if (mimeType!.startsWith('audio/')) {
        return Colors.orange;
      } else if (mimeType == 'application/pdf') {
        return Colors.red.shade700;
      } else if (mimeType == 'application/msword' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
        return Colors.blue.shade700;
      } else if (mimeType == 'application/vnd.ms-excel' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
        return Colors.green.shade700;
      } else if (mimeType == 'application/vnd.ms-powerpoint' ||
          mimeType ==
              'application/vnd.openxmlformats-officedocument.presentationml.presentation') {
        return Colors.orange.shade700;
      } else if (mimeType == 'application/zip' ||
          mimeType == 'application/x-zip-compressed') {
        return Colors.amber.shade700;
      } else if (mimeType == 'text/plain') {
        return Colors.blueGrey;
      } else if (mimeType == 'application/json') {
        return Colors.teal;
      } else if (mimeType == 'text/csv') {
        return Colors.green;
      }
    }

    // Default color
    return theme.colorScheme.onSurface.withOpacity(0.6);
  }
}
