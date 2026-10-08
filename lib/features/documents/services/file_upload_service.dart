import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/errors/app_failure.dart';

const uuid = Uuid();

/// Upload status
enum UploadStatus {
  idle,
  uploading,
  completed,
  failed,
  cancelled,
}

/// Upload task
class UploadTask {
  final String id;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String mimeType;
  final String workspaceId;
  final String? folderId;
  double progress;
  UploadStatus status;
  String? error;
  CancelToken? cancelToken;
  String? uploadedFileId;

  UploadTask({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.mimeType,
    required this.workspaceId,
    this.folderId,
    this.progress = 0.0,
    this.status = UploadStatus.idle,
    this.error,
    this.cancelToken,
    this.uploadedFileId,
  });

  UploadTask copyWith({
    double? progress,
    UploadStatus? status,
    String? error,
    CancelToken? cancelToken,
    String? uploadedFileId,
  }) {
    return UploadTask(
      id: id,
      fileName: fileName,
      filePath: filePath,
      fileSize: fileSize,
      mimeType: mimeType,
      workspaceId: workspaceId,
      folderId: folderId,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
      cancelToken: cancelToken ?? this.cancelToken,
      uploadedFileId: uploadedFileId ?? this.uploadedFileId,
    );
  }
}

/// File upload service
class FileUploadService {
  final ApiClient _apiClient;
  final Map<String, UploadTask> _tasks = {};
  final StreamController<List<UploadTask>> _tasksController =
      StreamController<List<UploadTask>>.broadcast();

  FileUploadService(this._apiClient);

  Stream<List<UploadTask>> get tasksStream => _tasksController.stream;

  List<UploadTask> get tasks => _tasks.values.toList();

  /// Add file to upload queue
  String addFile({
    required String filePath,
    required String fileName,
    required int fileSize,
    required String mimeType,
    required String workspaceId,
    String? folderId,
    bool checkOnline = true,
  }) {
    // Check if online when adding (optional check for offline mode)
    if (checkOnline) {
      // In production, check connectivity here
      // For now, always allow adding to queue
    }

    final taskId = uuid.v4();
    final task = UploadTask(
      id: taskId,
      fileName: fileName,
      filePath: filePath,
      fileSize: fileSize,
      mimeType: mimeType,
      workspaceId: workspaceId,
      folderId: folderId,
    );

    _tasks[taskId] = task;
    _notifyListeners();
    return taskId;
  }

  /// Start upload
  Future<String?> startUpload(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) return null;

    // Check file size limit (25 MB)
    if (task.fileSize > 25 * 1024 * 1024) {
      _updateTask(
        taskId,
        status: UploadStatus.failed,
        error: 'File size exceeds 25 MB limit',
      );
      return null;
    }

    try {
      // Update status
      _updateTask(
        taskId,
        status: UploadStatus.uploading,
        cancelToken: CancelToken(),
      );

      // Step 1: Get upload URL from backend
      final response = await _apiClient.post(
        '/workspaces/${task.workspaceId}/files/upload-url',
        data: {
          'name': task.fileName,
          'mimeType': task.mimeType,
          'sizeBytes': task.fileSize,
        },
      );

      final fileId = response.data['fileId'] as String;
      final uploadUrl = response.data['uploadUrl'] as String;
      final token = response.data['token'] as String?;

      // Step 2: Upload file to Supabase Storage
      final file = File(task.filePath);
      final dio = Dio();

      final currentTask = _tasks[taskId];
      if (currentTask == null) return null;

      await dio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': task.mimeType,
            'Content-Length': task.fileSize,
            if (token != null) 'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 300,
        ),
        cancelToken: currentTask.cancelToken,
        onSendProgress: (sent, total) {
          final progress = sent / total;
          _updateTask(taskId, progress: progress);
        },
      );

      // Upload completed
      _updateTask(
        taskId,
        status: UploadStatus.completed,
        progress: 1.0,
        uploadedFileId: fileId,
      );

      return fileId;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _updateTask(
          taskId,
          status: UploadStatus.cancelled,
          error: 'Upload cancelled',
        );
      } else {
        final errorMsg = _extractErrorMessage(e);
        _updateTask(
          taskId,
          status: UploadStatus.failed,
          error: errorMsg,
        );
      }
      return null;
    } catch (e) {
      _updateTask(
        taskId,
        status: UploadStatus.failed,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Cancel upload
  void cancelUpload(String taskId) {
    final task = _tasks[taskId];
    if (task == null || task.status != UploadStatus.uploading) return;

    task.cancelToken?.cancel('Cancelled by user');
    _updateTask(
      taskId,
      status: UploadStatus.cancelled,
      error: 'Upload cancelled',
    );
  }

  /// Retry upload
  Future<String?> retryUpload(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) return null;

    // Reset task state
    _updateTask(
      taskId,
      status: UploadStatus.idle,
      progress: 0.0,
      error: null,
    );

    // Start upload
    return startUpload(taskId);
  }

  /// Remove task
  void removeTask(String taskId) {
    _tasks.remove(taskId);
    _notifyListeners();
  }

  /// Clear completed tasks
  void clearCompleted() {
    _tasks.removeWhere((key, task) => task.status == UploadStatus.completed);
    _notifyListeners();
  }

  /// Clear failed tasks
  void clearFailed() {
    _tasks.removeWhere((key, task) => task.status == UploadStatus.failed);
    _notifyListeners();
  }

  /// Get task by ID
  UploadTask? getTask(String taskId) => _tasks[taskId];

  void _updateTask(
    String taskId, {
    double? progress,
    UploadStatus? status,
    String? error,
    CancelToken? cancelToken,
    String? uploadedFileId,
  }) {
    final task = _tasks[taskId];
    if (task == null) return;

    _tasks[taskId] = task.copyWith(
      progress: progress,
      status: status,
      error: error,
      cancelToken: cancelToken,
      uploadedFileId: uploadedFileId,
    );

    _notifyListeners();
  }

  void _notifyListeners() {
    _tasksController.add(tasks);
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
      if (data is Map && data.containsKey('error')) {
        final error = data['error'];
        if (error is Map && error.containsKey('message')) {
          return error['message'] as String;
        }
        return error.toString();
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Upload cancelled';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'Upload failed. Please try again.';
    }
  }

  void dispose() {
    _tasksController.close();
  }
}

/// Provider
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FileUploadService(apiClient);
});
