// app/lib/core/network/api_error_mapper.dart
// Maps Dio errors and backend error codes to AppFailure sealed types.
import 'package:dio/dio.dart';
import 'app_failure.dart';

AppFailure mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      return _mapResponse(e.response);
    default:
      return const UnknownFailure();
  }
}

AppFailure _mapResponse(Response? response) {
  if (response == null) return const ServerUnreachableFailure();

  final data = response.data;
  final Map? errorMap = (data is Map) ? data['error'] as Map? : null;
  final String? code = errorMap?['code'] as String?;
  final String? msg = errorMap?['message'] as String?;
  final String? requestId = errorMap?['requestId'] as String?;

  if (response.statusCode == 400) {
    return ValidationFailure(msg ?? 'Invalid request.', requestId: requestId);
  } else if (response.statusCode == 401) {
    if (code == 'AUTH_EXPIRED') return const AuthExpiredFailure();
    return const AuthRequiredFailure();
  } else if (response.statusCode == 403) {
    return ForbiddenFailure(msg ?? "You don't have permission to do this.", requestId);
  } else if (response.statusCode == 404) {
    return NotFoundFailure(msg ?? 'This item no longer exists.', requestId);
  } else if (response.statusCode == 409) {
    return ConflictFailure(msg ?? 'This item already exists.', requestId: requestId);
  } else if (response.statusCode == 429) {
    return const ServerFailure('Too many requests. Please slow down.', code: 'RATE_LIMITED');
  } else if (response.statusCode != null &&
      (response.statusCode! >= 500 && response.statusCode! < 600)) {
    return ServerFailure(msg ?? 'Server error. Please try again in a moment.',
        code: code, requestId: requestId);
  }
  return ServerFailure(
      msg ?? 'Unexpected error (${response.statusCode}).',
      code: code, requestId: requestId);
}
