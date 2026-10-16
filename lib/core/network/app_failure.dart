// app/lib/core/network/app_failure.dart
// Sealed failure types covering every backend error code + network cases.
sealed class AppFailure {
  final String message;
  final String? requestId;
  const AppFailure(this.message, {this.requestId});
}

// Network / connectivity
class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection. Check your network and try again.']);
}

class ServerUnreachableFailure extends AppFailure {
  const ServerUnreachableFailure([super.message = 'Can\'t reach the server. Check your connection.']);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = 'Request timed out. The server may be starting up — try again in a moment.']);
}

// Auth
class AuthRequiredFailure extends AppFailure {
  const AuthRequiredFailure([super.message = 'You need to log in to continue.']);
}

class AuthExpiredFailure extends AppFailure {
  const AuthExpiredFailure([super.message = 'Your session has expired. Please log in again.']);
}

enum AuthFailureReason {
  invalidCredentials,
  emailNotConfirmed,
  accountAlreadyExists,
  weakPassword,
  rateLimited,
  invalidCode,
  network,
  googleSignInFailed,
  unknown,
}

class AuthFailure extends AppFailure {
  final AuthFailureReason reason;

  const AuthFailure(this.reason) : super('');
}

// Permission
class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure([super.message = 'You don\'t have permission to do this.', String? requestId]) : super(requestId: requestId);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'This item no longer exists.', String? requestId]) : super(requestId: requestId);
}

class ConflictFailure extends AppFailure {
  const ConflictFailure(super.message, {super.requestId});
}

// Validation
class ValidationFailure extends AppFailure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors, super.requestId});
}

// Server
class ServerFailure extends AppFailure {
  final String? code;
  const ServerFailure(super.message, {this.code, super.requestId});
}

// Unknown
class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.', String? requestId]) : super(requestId: requestId);
}
