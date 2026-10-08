import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/errors/app_failure.dart';
import 'package:planpal/core/network/api_error_mapper.dart';

void main() {
  group('ApiErrorMapper', () {
    group('HTTP Status Code and Error Code Mapping', () {
      test('AUTH_REQUIRED maps to authRequired', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'error': {'code': 'AUTH_REQUIRED'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<AuthRequiredFailure>());
      });

      test('AUTH_EXPIRED maps to authExpired', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'error': {'code': 'AUTH_EXPIRED'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<AuthExpiredFailure>());
      });

      test('INVALID_CREDENTIALS maps to invalidCredentials', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'error': {'code': 'INVALID_CREDENTIALS'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<InvalidCredentialsFailure>());
      });

      test('FORBIDDEN maps to forbidden', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'error': {'code': 'FORBIDDEN'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<ForbiddenFailure>());
      });

      test('NOT_FOUND maps to taskNotFound', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {'error': {'code': 'NOT_FOUND'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<TaskNotFoundFailure>());
      });

      test('VALIDATION_FAILED maps to validationFailed', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {
            'error': {
              'code': 'VALIDATION_FAILED',
              'details': {
                'fields': [
                  {'field': 'email', 'message': 'Invalid email'},
                ]
              },
            }
          },
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<ValidationFailedFailure>());
        expect((failure as ValidationFailedFailure).fields['email'], 'Invalid email');
      });

      test('CONFLICT maps to conflict', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 409,
          data: {'error': {'code': 'CONFLICT', 'message': 'Sync conflict'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<ConflictFailure>());
      });

      test('INTERNAL_ERROR maps to internalError', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {'error': {'code': 'INTERNAL_ERROR'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<InternalErrorFailure>());
      });
    });

    group('Network Error Cases', () {
      test('Connection timeout maps to timeout', () {
        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(failure, isA<TimeoutFailure>());
      });

      test('Send timeout maps to timeout', () {
        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.sendTimeout,
          ),
        );

        expect(failure, isA<TimeoutFailure>());
      });

      test('Receive timeout maps to timeout', () {
        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.receiveTimeout,
          ),
        );

        expect(failure, isA<TimeoutFailure>());
      });

      test('Connection error maps to noInternet', () {
        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        );

        expect(failure, isA<NoInternetFailure>());
      });

      test('No response maps to serverUnreachable', () {
        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<ServerUnreachableFailure>());
      });
    });

    group('Specific Error Code Mapping', () {
      test('FILE_TOO_LARGE maps to fileTooLarge', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': {'code': 'FILE_TOO_LARGE'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<FileTooLargeFailure>());
      });

      test('NOT_A_MEMBER maps to notAMember', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'error': {'code': 'NOT_A_MEMBER'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<NotAMemberFailure>());
      });

      test('WORKSPACE_NOT_FOUND maps to workspaceNotFound', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {'error': {'code': 'WORKSPACE_NOT_FOUND'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<WorkspaceNotFoundFailure>());
      });

      test('INVALID_CODE maps to invalidCode', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': {'code': 'INVALID_CODE'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<InvalidCodeFailure>());
      });

      test('CODE_EXPIRED maps to codeExpired', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': {'code': 'CODE_EXPIRED'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<CodeExpiredFailure>());
      });

      test('LAST_ADMIN maps to lastAdmin', () {
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'error': {'code': 'LAST_ADMIN'}},
        );

        final failure = ApiErrorMapper.mapDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );

        expect(failure, isA<LastAdminFailure>());
      });
    });
  });
}

