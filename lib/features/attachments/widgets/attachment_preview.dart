import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/attachment.dart';
import '../repositories/attachment_repository.dart';
import '../../core/providers/app_providers.dart';
import 'file_icon.dart';

/// Full-screen preview for attachments (images, PDFs, and other files)
class AttachmentPreview extends ConsumerStatefulWidget {
  final Attachment attachment;

  const AttachmentPreview({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  @override
  ConsumerState<AttachmentPreview> createState() => _AttachmentPreviewState();
}

class _AttachmentPreviewState extends ConsumerState<AttachmentPreview> {
  bool _isDownloading = false;
  String? _downloadUrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDownloadUrl();
  }

  Future<void> _loadDownloadUrl() async {
    try {
      final repository = ref.read(attachmentRepositoryProvider);
      final url = await repository.getDownloadUrl(widget.attachment.id);

      if (mounted) {
        setState(() {
          _downloadUrl = url;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load download URL: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isImage = widget.attachment.mimeType.startsWith('image/');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.attachment.fileName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _isDownloading ? null : _handleDownload,
            icon: _isDownloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download),
            tooltip: 'Download',
          ),
          IconButton(
            onPressed: _handleShare,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
        ],
      ),
      body: _buildBody(isImage),
    );
  }

  Widget _buildBody(bool isImage) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDownloadUrl,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (isImage) {
      return _buildImagePreview();
    }

    return _buildFilePreview();
  }

  Widget _buildImagePreview() {
    // Use thumbnail or storage path
    final imagePath =
        widget.attachment.thumbnailPath ?? widget.attachment.storagePath;

    if (imagePath == null) {
      return const Center(
        child: Text(
          'No image available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.file(
          File(imagePath),
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load image',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FileIcon(
            mimeType: widget.attachment.mimeType,
            fileName: widget.attachment.fileName,
            size: 80,
            color: Colors.white70,
          ),
          const SizedBox(height: 24),
          Text(
            widget.attachment.fileName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _formatFileSize(widget.attachment.fileSize),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isDownloading ? null : _handleDownload,
            icon: _isDownloading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download),
            label: Text(_isDownloading ? 'Downloading...' : 'Download File'),
          ),
        ],
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

  Future<void> _handleDownload() async {
    if (_downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download URL not available')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      final uri = Uri.parse(_downloadUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch download URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _handleShare() async {
    if (_downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Share URL not available')),
      );
      return;
    }

    // TODO: Implement sharing functionality when share_plus is added
    // For now, just copy to clipboard or show URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share functionality coming soon'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
