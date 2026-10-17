import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';

const _pendingAppearanceKey = 'planpal_pending_appearance';
const _secureStorage = FlutterSecureStorage();

enum AppearanceSaveResult { saved, queued, failed }

class AppearanceSettingsRepository {
  final Dio dio;
  final Future<String?> Function() readPending;
  final Future<void> Function(String value) writePending;
  final Future<void> Function() clearPending;

  AppearanceSettingsRepository({
    required this.dio,
    Future<String?> Function()? readPending,
    Future<void> Function(String value)? writePending,
    Future<void> Function()? clearPending,
  }) : readPending =
           readPending ??
           (() => _secureStorage.read(key: _pendingAppearanceKey)),
       writePending =
           writePending ??
           ((value) =>
               _secureStorage.write(key: _pendingAppearanceKey, value: value)),
       clearPending =
           clearPending ??
           (() => _secureStorage.delete(key: _pendingAppearanceKey));

  Future<AppearanceSaveResult> save({
    required String theme,
    required String language,
  }) async {
    final values = {'theme': theme, 'language': language};
    try {
      await dio.patch('/me', data: values);
      await clearPending();
      return AppearanceSaveResult.saved;
    } on DioException catch (error) {
      if (!_isRetryable(error)) return AppearanceSaveResult.failed;
      try {
        await writePending(jsonEncode(values));
        return AppearanceSaveResult.queued;
      } catch (_) {
        return AppearanceSaveResult.failed;
      }
    } catch (_) {
      return AppearanceSaveResult.failed;
    }
  }

  Future<bool> syncPending() async {
    final encoded = await readPending();
    if (encoded == null) return true;
    try {
      final values = jsonDecode(encoded) as Map<String, dynamic>;
      await dio.patch('/me', data: values);
      await clearPending();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isRetryable(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    final status = error.response?.statusCode;
    return status == 429 || (status != null && status >= 500);
  }
}

final appearanceSettingsRepositoryProvider =
    Provider<AppearanceSettingsRepository>(
      (ref) =>
          AppearanceSettingsRepository(dio: ref.watch(apiClientProvider).dio),
    );
