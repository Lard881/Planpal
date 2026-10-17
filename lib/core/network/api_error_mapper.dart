// app/lib/core/network/api_error_mapper.dart
// Maps Dio errors and backend error codes to AppFailure sealed types.
import 'package:dio/dio.dart';
import 'app_failure.dart';

const _apiErrorPrefix = '__PLANPAL_API_ERROR__:';

String apiErrorMessage(String? code) =>
    '$_apiErrorPrefix${code?.isNotEmpty == true ? code : 'UNKNOWN'}';

AppFailure mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutFailure(apiErrorMessage('TIMEOUT'));
    case DioExceptionType.connectionError:
      return NetworkFailure(apiErrorMessage('NETWORK'));
    case DioExceptionType.badResponse:
      return _mapResponse(e.response);
    default:
      return const UnknownFailure();
  }
}

AppFailure _mapResponse(Response? response) {
  if (response == null) {
    return ServerUnreachableFailure(apiErrorMessage('SERVER_UNREACHABLE'));
  }

  final data = response.data;
  final rawError = data is Map ? data['error'] : null;
  final Map? errorMap = rawError is Map ? rawError : null;
  final rawCode = errorMap?['code'];
  final rawRequestId = errorMap?['requestId'];
  final String? code = rawCode is String ? rawCode : null;
  final String? requestId = rawRequestId is String ? rawRequestId : null;

  if (response.statusCode == 400) {
    return ValidationFailure(
      apiErrorMessage(code ?? 'INVALID_REQUEST'),
      requestId: requestId,
    );
  } else if (response.statusCode == 401) {
    if (code == 'AUTH_EXPIRED') {
      return AuthExpiredFailure(apiErrorMessage(code));
    }
    return AuthRequiredFailure(apiErrorMessage(code ?? 'AUTH_REQUIRED'));
  } else if (response.statusCode == 403) {
    return ForbiddenFailure(apiErrorMessage(code ?? 'FORBIDDEN'), requestId);
  } else if (response.statusCode == 404) {
    return NotFoundFailure(apiErrorMessage(code ?? 'NOT_FOUND'), requestId);
  } else if (response.statusCode == 409) {
    return ConflictFailure(
      apiErrorMessage(code ?? 'CONFLICT'),
      requestId: requestId,
    );
  } else if (response.statusCode == 429) {
    return ServerFailure(
      apiErrorMessage(code ?? 'RATE_LIMITED'),
      code: code ?? 'RATE_LIMITED',
      requestId: requestId,
    );
  } else if (response.statusCode != null &&
      (response.statusCode! >= 500 && response.statusCode! < 600)) {
    return ServerFailure(
      apiErrorMessage(code ?? 'SERVER_ERROR'),
      code: code,
      requestId: requestId,
    );
  }
  return ServerFailure(
    apiErrorMessage(code ?? 'UNKNOWN'),
    code: code,
    requestId: requestId,
  );
}
