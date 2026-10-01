import 'package:dio/dio.dart';
import '../errors/app_failure.dart';

/// Maps API errors to AppFailure types
class ApiErrorMapper {
  ApiErrorMapper._();

  static AppFailure mapDioError(DioException error) {
    // Network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AppFailure.timeout();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const AppFailure.noInternet();
    }

    // Response errors
    final response = error.response;
    if (response == null) {
      return const AppFailure.serverUnreachable();
    }

    final errorData = response.data;
    final errorCode = errorData is Map && errorData['error'] != null
        ? (errorData['error'] as Map)['code']
        : null;

    // Map backend error codes to failures
    switch (errorCode) {
      // Authentication
      case 'AUTH_REQUIRED':
        return const AppFailure.authRequired();
      case 'AUTH_EXPIRED':
        return const AppFailure.authExpired();
      case 'INVALID_CREDENTIALS':
        return const AppFailure.invalidCredentials();

      // Authorization
      case 'NOT_A_MEMBER':
        return const AppFailure.notAMember();
      case 'FORBIDDEN':
        return const AppFailure.forbidden();
      case 'LAST_ADMIN':
        return const AppFailure.lastAdmin();

      // Invite codes
      case 'INVALID_CODE':
        return const AppFailure.invalidCode();
      case 'CODE_EXPIRED':
        return const AppFailure.codeExpired();
      case 'CODE_REVOKED':
        return const AppFailure.codeRevoked();
      case 'CODE_USED_UP':
        return const AppFailure.codeUsedUp();
      case 'ALREADY_MEMBER':
        return const AppFailure.alreadyMember();

      // Files
      case 'FILE_TOO_LARGE':
        return const AppFailure.fileTooLarge();
      case 'FILE_TYPE_NOT_ALLOWED':
        return const AppFailure.fileTypeNotAllowed();

      // Resources
      case 'NOT_FOUND':
      case 'TASK_NOT_FOUND':
        return const AppFailure.taskNotFound();
      case 'WORKSPACE_NOT_FOUND':
        return const AppFailure.workspaceNotFound();

      // Validation
      case 'VALIDATION_FAILED':
        final fields = errorData['error']?['details']?['fields'] as List?;
        final fieldMap = <String, String>{};
        if (fields != null) {
          for (final field in fields) {
            if (field is Map) {
              fieldMap[field['field'] ?? ''] = field['message'] ?? '';
            }
          }
        }
        return AppFailure.validationFailed(fields: fieldMap);

      // Conflicts
      case 'CONFLICT':
        return AppFailure.conflict(message: errorData['error']?['message']);
      case 'FOLDER_NOT_EMPTY':
        return const AppFailure.folderNotEmpty();

      // System
      case 'PAYLOAD_TOO_LARGE':
        return const AppFailure.payloadTooLarge();
      case 'RATE_LIMITED':
        return const AppFailure.rateLimited();
      case 'INTERNAL_ERROR':
        return const AppFailure.internalError();
      case 'UPSTREAM_ERROR':
        return const AppFailure.upstreamError();
      case 'SERVICE_UNAVAILABLE':
        return const AppFailure.serviceUnavailable();

      default:
        // Fallback to HTTP status codes
        switch (response.statusCode) {
          case 401:
            return const AppFailure.authRequired();
          case 403:
            return const AppFailure.forbidden();
          case 404:
            return const AppFailure.notFound();
          case 429:
            return const AppFailure.rateLimited();
          case 500:
            return const AppFailure.internalError();
          case 502:
          case 503:
            return const AppFailure.serviceUnavailable();
          default:
            return AppFailure.unknown(
              message: errorData['error']?['message'] ?? 'Unknown error',
            );
        }
    }
  }
}
