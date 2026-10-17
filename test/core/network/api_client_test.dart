import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/network/api_client.dart';

void main() {
  group('ApiClient authorization', () {
    test('uses the current access token and refreshes/retries once', () async {
      final adapter = _SequenceAdapter([
        _jsonResponse(401, {
          'error': {'code': 'AUTH_EXPIRED'},
        }),
        _jsonResponse(200, {'ok': true}),
      ]);
      var refreshCount = 0;
      var expiredCount = 0;
      final client = ApiClient(
        onSessionExpired: () => expiredCount++,
        accessTokenProvider: () async => 'old-access-token',
        refreshAccessToken: () async {
          refreshCount++;
          return 'new-access-token';
        },
        signOut: () async {},
      );
      client.dio.options.baseUrl = 'https://unit.test';
      client.dio.httpClientAdapter = adapter;

      final response = await client.dio.get('/protected');

      expect(response.data, {'ok': true});
      expect(adapter.authorizationHeaders, [
        'Bearer old-access-token',
        'Bearer new-access-token',
      ]);
      expect(refreshCount, 1);
      expect(expiredCount, 0);
      expect(adapter.requestCount, 2);
    });

    test('does not retry more than once and expires the session', () async {
      final adapter = _SequenceAdapter([
        _jsonResponse(401, {
          'error': {'code': 'AUTH_EXPIRED'},
        }),
        _jsonResponse(401, {
          'error': {'code': 'AUTH_EXPIRED'},
        }),
      ]);
      var refreshCount = 0;
      var expiredCount = 0;
      var signOutCount = 0;
      final client = ApiClient(
        onSessionExpired: () => expiredCount++,
        accessTokenProvider: () async => 'old-access-token',
        refreshAccessToken: () async {
          refreshCount++;
          return 'new-access-token';
        },
        signOut: () async {
          signOutCount++;
        },
      );
      client.dio.options.baseUrl = 'https://unit.test';
      client.dio.httpClientAdapter = adapter;

      await expectLater(
        client.dio.get('/protected'),
        throwsA(isA<DioException>()),
      );

      expect(refreshCount, 1);
      expect(expiredCount, 1);
      expect(signOutCount, 1);
      expect(adapter.requestCount, 2);
    });

    test('omits authorization when there is no session token', () async {
      final adapter = _SequenceAdapter([
        _jsonResponse(200, {'ok': true}),
      ]);
      final client = ApiClient(
        onSessionExpired: () {},
        accessTokenProvider: () async => null,
        refreshAccessToken: () async => null,
        signOut: () async {},
      );
      client.dio.options.baseUrl = 'https://unit.test';
      client.dio.httpClientAdapter = adapter;

      await client.dio.get('/public');

      expect(adapter.authorizationHeaders.single, isNull);
    });
  });
}

ResponseBody _jsonResponse(int status, Map<String, dynamic> data) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

class _SequenceAdapter implements HttpClientAdapter {
  final List<ResponseBody> _responses;
  final authorizationHeaders = <String?>[];
  int requestCount = 0;

  _SequenceAdapter(this._responses);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authorizationHeaders.add(options.headers['Authorization'] as String?);
    return _responses[requestCount++];
  }

  @override
  void close({bool force = false}) {}
}
