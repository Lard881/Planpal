// app/lib/core/services/avatar_upload_service.dart
// Uploads an avatar image: get signed URL from backend, upload to Supabase storage.
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/app_failure.dart';
import '../network/api_error_mapper.dart';

const _allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
const _maxSizeBytes = 5 * 1024 * 1024; // 5 MB

class AvatarUploadService {
  final Dio _dio;
  AvatarUploadService(this._dio);

  Future<(String?, AppFailure?)> upload(File file, String mimeType) async {
    // Validate
    if (!_allowedMimeTypes.contains(mimeType)) {
      return (null, const ValidationFailure(
          'Only JPEG, PNG, GIF and WebP images are allowed.'));
    }
    final size = await file.length();
    if (size > _maxSizeBytes) {
      return (null, const ValidationFailure('Image must be 5 MB or smaller.'));
    }

    try {
      // Step 1: get signed upload URL from backend
      final urlRes = await _dio.post('/me/avatar-upload-url',
          data: {'mimeType': mimeType});
      final uploadUrl = urlRes.data['upload_url'] as String;
      final storagePath = urlRes.data['path'] as String? ??
          urlRes.data['storage_path'] as String? ?? '';

      // Step 2: upload directly to storage
      final uploadDio = Dio();
      await uploadDio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(headers: {
          'Content-Type': mimeType,
          'Content-Length': size,
        }),
      );

      // Step 3: save the path to the profile
      await _dio.patch('/me', data: {'avatarUrl': storagePath});

      return (storagePath, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> removeAvatar() async {
    try {
      await _dio.delete('/me/avatar');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final avatarUploadServiceProvider = Provider<AvatarUploadService>((ref) {
  return AvatarUploadService(ref.watch(apiClientProvider).dio);
});
