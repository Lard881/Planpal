import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for generating thumbnails from images
class ThumbnailService {
  static const int thumbnailSize = 200; // Square thumbnail size
  static const int quality = 85; // JPEG quality (0-100)

  /// Generate a thumbnail from an image file
  /// 
  /// Returns the thumbnail file, or null if generation fails
  Future<File?> generateThumbnail(File imageFile) async {
    try {
      debugPrint('[ThumbnailService] Generating thumbnail for: ${imageFile.path}');

      // Read the image file
      final bytes = await imageFile.readAsBytes();
      
      // Decode the image
      final image = await compute(_decodeImage, bytes);
      
      if (image == null) {
        debugPrint('[ThumbnailService] Failed to decode image');
        return null;
      }

      // Generate thumbnail
      final thumbnail = await compute(_generateThumbnailIsolate, image);
      
      if (thumbnail == null) {
        debugPrint('[ThumbnailService] Failed to generate thumbnail');
        return null;
      }

      // Encode thumbnail as JPEG
      final thumbnailBytes = await compute(_encodeJpeg, thumbnail);

      // Save thumbnail to temp file
      final thumbnailFile = await _saveThumbnailToTemp(
        imageFile,
        thumbnailBytes,
      );

      final originalSize = bytes.length;
      final thumbnailFileSize = await thumbnailFile.length();
      final compressionRatio = ((1 - thumbnailFileSize / originalSize) * 100).toStringAsFixed(1);
      
      debugPrint('[ThumbnailService] Thumbnail generated: ${thumbnailFile.path}');
      debugPrint('[ThumbnailService] Original: ${_formatBytes(originalSize)}, Thumbnail: ${_formatBytes(thumbnailFileSize)} ($compressionRatio% smaller)');

      return thumbnailFile;
    } catch (e) {
      debugPrint('[ThumbnailService] Error generating thumbnail: $e');
      return null;
    }
  }

  /// Generate thumbnails for multiple images
  /// 
  /// Returns a map of original file path to thumbnail file
  Future<Map<String, File>> generateMultipleThumbnails(List<File> imageFiles) async {
    final thumbnails = <String, File>{};

    for (final imageFile in imageFiles) {
      final thumbnail = await generateThumbnail(imageFile);
      if (thumbnail != null) {
        thumbnails[imageFile.path] = thumbnail;
      }
    }

    return thumbnails;
  }

  /// Check if a file is an image that can have a thumbnail
  bool canGenerateThumbnail(File file) {
    final extension = path.extension(file.path).toLowerCase();
    
    const supportedFormats = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
    ];

    return supportedFormats.contains(extension);
  }

  /// Save thumbnail to temporary directory
  Future<File> _saveThumbnailToTemp(File originalFile, Uint8List thumbnailBytes) async {
    final tempDir = await getTemporaryDirectory();
    final originalName = path.basenameWithoutExtension(originalFile.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final thumbnailPath = path.join(
      tempDir.path,
      'thumbnails',
      '${originalName}_thumb_$timestamp.jpg',
    );

    // Create thumbnails directory if it doesn't exist
    final thumbnailDir = Directory(path.dirname(thumbnailPath));
    if (!await thumbnailDir.exists()) {
      await thumbnailDir.create(recursive: true);
    }

    final thumbnailFile = File(thumbnailPath);
    await thumbnailFile.writeAsBytes(thumbnailBytes);

    return thumbnailFile;
  }

  /// Clean up old thumbnails from temp directory
  Future<void> cleanupOldThumbnails({Duration maxAge = const Duration(days: 7)}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailDir = Directory(path.join(tempDir.path, 'thumbnails'));

      if (!await thumbnailDir.exists()) {
        return;
      }

      final now = DateTime.now();
      int deletedCount = 0;

      await for (final entity in thumbnailDir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          final age = now.difference(stat.modified);

          if (age > maxAge) {
            await entity.delete();
            deletedCount++;
          }
        }
      }

      if (deletedCount > 0) {
        debugPrint('[ThumbnailService] Cleaned up $deletedCount old thumbnails');
      }
    } catch (e) {
      debugPrint('[ThumbnailService] Error cleaning up thumbnails: $e');
    }
  }

  /// Format bytes for display
  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Isolate functions for compute()

  /// Decode image in isolate
  static img.Image? _decodeImage(Uint8List bytes) {
    return img.decodeImage(bytes);
  }

  /// Generate thumbnail in isolate
  static img.Image? _generateThumbnailIsolate(img.Image image) {
    // Calculate dimensions maintaining aspect ratio
    int targetWidth = thumbnailSize;
    int targetHeight = thumbnailSize;

    if (image.width > image.height) {
      targetHeight = (thumbnailSize * image.height / image.width).round();
    } else if (image.height > image.width) {
      targetWidth = (thumbnailSize * image.width / image.height).round();
    }

    // Resize image
    final resized = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    return resized;
  }

  /// Encode image as JPEG in isolate
  static Uint8List _encodeJpeg(img.Image image) {
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }
}

/// Result of thumbnail generation
class ThumbnailResult {
  final File? thumbnailFile;
  final bool success;
  final String? error;
  final int? originalSize;
  final int? thumbnailSize;

  ThumbnailResult({
    this.thumbnailFile,
    required this.success,
    this.error,
    this.originalSize,
    this.thumbnailSize,
  });

  factory ThumbnailResult.success({
    required File thumbnailFile,
    required int originalSize,
    required int thumbnailSize,
  }) {
    return ThumbnailResult(
      thumbnailFile: thumbnailFile,
      success: true,
      originalSize: originalSize,
      thumbnailSize: thumbnailSize,
    );
  }

  factory ThumbnailResult.failure(String error) {
    return ThumbnailResult(
      success: false,
      error: error,
    );
  }

  double? get compressionRatio {
    if (originalSize != null && thumbnailSize != null && originalSize! > 0) {
      return 1 - (thumbnailSize! / originalSize!);
    }
    return null;
  }

  String? get compressionPercentage {
    final ratio = compressionRatio;
    if (ratio != null) {
      return '${(ratio * 100).toStringAsFixed(1)}%';
    }
    return null;
  }
}

/// Thumbnail generation options
class ThumbnailOptions {
  final int size;
  final int quality;
  final bool maintainAspectRatio;

  const ThumbnailOptions({
    this.size = 200,
    this.quality = 85,
    this.maintainAspectRatio = true,
  });

  static const ThumbnailOptions small = ThumbnailOptions(size: 100);
  static const ThumbnailOptions medium = ThumbnailOptions(size: 200);
  static const ThumbnailOptions large = ThumbnailOptions(size: 400);
}
