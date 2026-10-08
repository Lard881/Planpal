import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../../../core/network/api_client.dart';
import '../models/attachment.dart';

/// Service for uploading files to the server with progress tracking
class FileUploadService {
  final ApiClient _apiClient;
  final Dio _dio;

  FileUploadService({
    required ApiClient apiClient,
  })  : _apiClient = apiClient,
        _dio = Dio();

  /// Upload a file to a task
  /// 
  /// Returns the created Attachment and provides progress updates via callback
  Future<Attachment> uploadFile({
    required String taskId,
    required File file,
    required Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final fileSize = await file.length();

      debugPrint('[FileUploadService] Starting upload: $fileName ($fileSize bytes)');

      // Create multipart form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      // Get access token for authentication
      final accessToken = _apiClient.accessToken;
      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      // Upload with progress tracking
      final response = await _dio.post(
        '${_apiClient.baseUrl}/tasks/$taskId/attachments',
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => status! < 500,
        ),
        onSendProgress: (sent, total) {
          final progress = sent / total;
          onProgress(progress);
          debugPrint('[FileUploadService] Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        },
      );

      if (response.statusCode == 201) {
        final attachmentData = response.data['attachment'] as Map<String, dynamic>;
        final attachment = Attachment.fromJson(attachmentData);
        
        debugPrint('[FileUploadService] Upload complete: ${attachment.id}');
        return attachment;
      } else {
        final error = response.data['error'] ?? 'Upload failed';
        final message = response.data['message'] ?? 'Unknown error';
        throw FileUploadException(
          message: message,
          statusCode: response.statusCode,
          error: error,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw FileUploadException(
          message: 'Upload cancelled',
          statusCode: 0,
          error: 'cancelled',
        );
      }
      
      debugPrint('[FileUploadService] Upload error: ${e.message}');
      throw FileUploadException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
        error: 'network_error',
      );
    } catch (e) {
      debugPrint('[FileUploadService] Unexpected error: $e');
      throw FileUploadException(
        message: e.toString(),
        statusCode: 0,
        error: 'unknown_error',
      );
    }
  }

  /// Upload multiple files to a task
  /// 
  /// Returns a stream of upload results with progress for each file
  Stream<FileUploadResult> uploadMultipleFiles({
    required String taskId,
    required List<File> files,
    CancelToken? cancelToken,
  }) async* {
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final fileName = path.basename(file.path);

      try {
        yield FileUploadResult.uploading(
          fileName: fileName,
          progress: 0.0,
          currentFile: i + 1,
          totalFiles: files.length,
        );

        final attachment = await uploadFile(
          taskId: taskId,
          file: file,
          onProgress: (progress) {
            // Note: This won't emit to the stream, but caller can track per-file
          },
          cancelToken: cancelToken,
        );

        yield FileUploadResult.completed(
          fileName: fileName,
          attachment: attachment,
          currentFile: i + 1,
          totalFiles: files.length,
        );
      } catch (e) {
        yield FileUploadResult.failed(
          fileName: fileName,
          error: e.toString(),
          currentFile: i + 1,
          totalFiles: files.length,
        );
      }
    }
  }

  /// Validate file before upload
  /// 
  /// Returns null if valid, error message if invalid
  Future<String?> validateFile(File file) async {
    try {
      // Check if file exists
      if (!await file.exists()) {
        return 'File does not exist';
      }

      // Check file size (50MB limit)
      final fileSize = await file.length();
      const maxSize = 50 * 1024 * 1024; // 50MB

      if (fileSize > maxSize) {
        final sizeMB = fileSize / (1024 * 1024);
        return 'File too large (${sizeMB.toStringAsFixed(1)}MB). Maximum size is 50MB';
      }

      if (fileSize == 0) {
        return 'File is empty';
      }

      // Check file extension
      final fileName = path.basename(file.path);
      final extension = path.extension(fileName).toLowerCase();

      const allowedExtensions = [
        // Images
        '.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg',
        // Documents
        '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
        // Text
        '.txt', '.csv', '.json',
        // Archives
        '.zip',
      ];

      if (!allowedExtensions.contains(extension)) {
        return 'File type not supported: $extension';
      }

      return null; // Valid
    } catch (e) {
      return 'Error validating file: $e';
    }
  }

  /// Validate multiple files
  /// 
  /// Returns map of filename to error message (empty if all valid)
  Future<Map<String, String>> validateFiles(List<File> files) async {
    final errors = <String, String>{};

    for (final file in files) {
      final fileName = path.basename(file.path);
      final error = await validateFile(file);
      
      if (error != null) {
        errors[fileName] = error;
      }
    }

    return errors;
  }

  /// Get MIME type from file extension
  String? getMimeType(File file) {
    final extension = path.extension(file.path).toLowerCase();

    const mimeTypes = {
      // Images
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      // Documents
      '.pdf': 'application/pdf',
      '.doc': 'application/msword',
      '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      '.xls': 'application/vnd.ms-excel',
      '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      '.ppt': 'application/vnd.ms-powerpoint',
      '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      // Text
      '.txt': 'text/plain',
      '.csv': 'text/csv',
      '.json': 'application/json',
      // Archives
      '.zip': 'application/zip',
    };

    return mimeTypes[extension];
  }
}

/// Result of a file upload operation
class FileUploadResult {
  final String fileName;
  final FileUploadStatus status;
  final double progress;
  final Attachment? attachment;
  final String? error;
  final int currentFile;
  final int totalFiles;

  FileUploadResult({
    required this.fileName,
    required this.status,
    required this.progress,
    this.attachment,
    this.error,
    required this.currentFile,
    required this.totalFiles,
  });

  factory FileUploadResult.uploading({
    required String fileName,
    required double progress,
    required int currentFile,
    required int totalFiles,
  }) {
    return FileUploadResult(
      fileName: fileName,
      status: FileUploadStatus.uploading,
      progress: progress,
      currentFile: currentFile,
      totalFiles: totalFiles,
    );
  }

  factory FileUploadResult.completed({
    required String fileName,
    required Attachment attachment,
    required int currentFile,
    required int totalFiles,
  }) {
    return FileUploadResult(
      fileName: fileName,
      status: FileUploadStatus.completed,
      progress: 1.0,
      attachment: attachment,
      currentFile: currentFile,
      totalFiles: totalFiles,
    );
  }

  factory FileUploadResult.failed({
    required String fileName,
    required String error,
    required int currentFile,
    required int totalFiles,
  }) {
    return FileUploadResult(
      fileName: fileName,
      status: FileUploadStatus.failed,
      progress: 0.0,
      error: error,
      currentFile: currentFile,
      totalFiles: totalFiles,
    );
  }

  bool get isCompleted => status == FileUploadStatus.completed;
  bool get isFailed => status == FileUploadStatus.failed;
  bool get isUploading => status == FileUploadStatus.uploading;
}

/// Status of file upload
enum FileUploadStatus {
  uploading,
  completed,
  failed,
}

/// Exception thrown during file upload
class FileUploadException implements Exception {
  final String message;
  final int? statusCode;
  final String error;

  FileUploadException({
    required this.message,
    this.statusCode,
    required this.error,
  });

  @override
  String toString() => 'FileUploadException: $message (status: $statusCode, error: $error)';

  bool get isCancelled => error == 'cancelled';
  bool get isNetworkError => error == 'network_error';
  bool get isServerError => (statusCode ?? 0) >= 500;
  bool get isClientError => (statusCode ?? 0) >= 400 && (statusCode ?? 0) < 500;
}
