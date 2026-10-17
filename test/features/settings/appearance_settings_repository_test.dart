import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/settings/data/appearance_settings_repository.dart';

void main() {
  group('AppearanceSettingsRepository', () {
    test(
      'queues a transient failure and sends it when connectivity returns',
      () async {
        String? queued;
        final failingDio = Dio()
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    type: DioExceptionType.connectionError,
                  ),
                );
              },
            ),
          );
        final repository = AppearanceSettingsRepository(
          dio: failingDio,
          readPending: () async => queued,
          writePending: (value) async => queued = value,
          clearPending: () async => queued = null,
        );

        final result = await repository.save(theme: 'dark', language: 'fr');

        expect(result, AppearanceSaveResult.queued);
        expect(jsonDecode(queued!), {'theme': 'dark', 'language': 'fr'});

        final successfulDio = Dio()
          ..options.baseUrl = 'https://unit.test'
          ..httpClientAdapter = _SuccessAdapter();
        final syncRepository = AppearanceSettingsRepository(
          dio: successfulDio,
          readPending: () async => queued,
          writePending: (value) async => queued = value,
          clearPending: () async => queued = null,
        );

        expect(await syncRepository.syncPending(), isTrue);
        expect(queued, isNull);
      },
    );

    test('does not report a permanent server rejection as saved', () async {
      final rejectedDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(requestOptions: options, statusCode: 403),
                  type: DioExceptionType.badResponse,
                ),
              );
            },
          ),
        );
      String? queued;
      final repository = AppearanceSettingsRepository(
        dio: rejectedDio,
        readPending: () async => queued,
        writePending: (value) async => queued = value,
        clearPending: () async => queued = null,
      );

      expect(
        await repository.save(theme: 'light', language: 'en'),
        AppearanceSaveResult.failed,
      );
      expect(queued, isNull);
    });
  });
}

class _SuccessAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    '{"ok":true}',
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}
