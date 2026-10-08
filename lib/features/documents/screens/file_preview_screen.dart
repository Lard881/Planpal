import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/db/app_database.dart';
import '../repositories/document_repository.dart';

class FilePreviewScreen extends ConsumerStatefulWidget {
  final Document document;

  const FilePreviewScreen({
    super.key,
    required this.document,
  });

  @override
  ConsumerState<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends ConsumerState<FilePreviewScreen> {
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _downloadUrl;
  String? _localFilePath;
  String? _error;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDownloadUrl();
  }

  Future<void> _loadDownloadUrl() async {
    try {
      final url = await ref
          .read(documentRepositoryProvider)
          .getDownloadUrl(widget.document.fileId!);

      setState(() {
        _downloadUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadAndOpen() async {
    if (_downloadUrl == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      // Get file from Drift to get name
      final file = await ref
          .read(documentRepositoryProvider)
          .getFile(widget.document.fileId!);

      if (file == null) throw Exception('File not found');

      // Download to temp directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${file.name}';

      final dio = Dio();
      await dio.download(
        _downloadUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _localFilePath = filePath;
        _isDownloading = false;
      });

      // Open with system app
      await _openWithSystemApp(filePath);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isDownloading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openWithSystemApp(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Cannot open this file type');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isImageFile() {
    final mimeType = widget.document.fileId; // We'd need to get actual mime from Files table
    // For now, check by extension from title
    final title = widget.document.title.toLowerCase();
    return title.endsWith('.jpg') ||
        title.endsWith('.jpeg') ||
        title.endsWith('.png') ||
        title.endsWith('.gif') ||
        title.endsWith('.webp');
  }

  bool _isPdfFile() {
    return widget.document.title.toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        actions: [
          if (_downloadUrl != null && !_isDownloading)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: l10n.openWithSystemApp,
              onPressed: _downloadAndOpen,
            ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(l10n.errorLoadingFile),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _loadDownloadUrl();
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_isDownloading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(l10n.downloading),
            const SizedBox(height: 8),
            Text('${(_downloadProgress * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(value: _downloadProgress),
            ),
          ],
        ),
      );
    }

    // Image preview
    if (_isImageFile() && _downloadUrl != null) {
      return Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: _downloadUrl!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(l10n.errorLoadingImage),
              ],
            ),
          ),
        ),
      );
    }

    // For PDF and other files, show download button
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileIcon(),
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 24),
          Text(
            widget.document.title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _isPdfFile() ? l10n.pdfDocument : l10n.fileDocument,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _downloadAndOpen,
            icon: const Icon(Icons.open_in_new),
            label: Text(l10n.openWithSystemApp),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    if (_isPdfFile()) return Icons.picture_as_pdf;
    final title = widget.document.title.toLowerCase();
    if (title.endsWith('.doc') || title.endsWith('.docx')) {
      return Icons.description;
    }
    if (title.endsWith('.xls') || title.endsWith('.xlsx')) {
      return Icons.table_chart;
    }
    if (title.endsWith('.zip')) {
      return Icons.folder_zip;
    }
    return Icons.insert_drive_file;
  }
}
