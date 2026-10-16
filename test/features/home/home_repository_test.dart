import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/home/data/home_repository.dart';

void main() {
  test(
    'requests the workspace overview endpoint with the selected range',
    () async {
      late RequestOptions request;
      final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              request = options;
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                ),
              );
            },
          ),
        );

      final (_, failure) = await HomeRepository(
        dio,
      ).getOverview('workspace-1', '30d');

      expect(request.uri.path, '/api/v1/workspaces/workspace-1/overview');
      expect(request.queryParameters['range'], '30d');
      expect(failure, isNotNull);
    },
  );
}
