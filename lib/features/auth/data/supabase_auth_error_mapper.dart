import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_failure.dart';

/// Maps Supabase authentication errors to AppFailure types
class SupabaseAuthErrorMapper {
  /// Map Supabase AuthException to AppFailure
  static AppFailure mapAuthException(AuthException error) {
    final message = error.message.toLowerCase();
    final statusCode = error.statusCode;

    // Check status code first
    if (statusCode != null) {
      switch (statusCode) {
        case '400':
          return _map400Error(message);
        case '401':
          return _map401Error(message);
        case '422':
          return _map422Error(message);
        case '429':
          return const AppFailure.rateLimited();
        case '500':
        case '502':
        case '503':
          return const AppFailure.serverError();
      }
    }

    // Check error message content
    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return const AppFailure.invalidCredentials();
    }

    if (message.contains('email not confirmed') ||
        message.contains('email confirmation required')) {
      return const AppFailure.emailNotConfirmed();
    }

    if (message.contains('user already registered') ||
        message.contains('user with this email already exists')) {
      return const AppFailure.userAlreadyExists();
    }

    if (message.contains('email address is already in use') ||
        message.contains('email already exists')) {
      return const AppFailure.emailAlreadyInUse();
    }

    if (message.contains('password is too weak') ||
        message.contains('password should be at least')) {
      return const AppFailure.weakPassword();
    }

    if (message.contains('invalid email') ||
        message.contains('unable to validate email address')) {
      return const AppFailure.validationError(message: 'Invalid email format');
    }

    if (message.contains('email rate limit exceeded') ||
        message.contains('too many requests')) {
      return const AppFailure.rateLimited();
    }

    if (message.contains('otp expired') ||
        message.contains('token has expired')) {
      return const AppFailure.codeExpired();
    }

    if (message.contains('invalid otp') ||
        message.contains('invalid token') ||
        message.contains('token not found')) {
      return const AppFailure.invalidCode();
    }

    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout')) {
      return const AppFailure.networkError();
    }

    if (message.contains('user not found')) {
      return const AppFailure.notFound(resource: 'User');
    }

    if (message.contains('session expired') ||
        message.contains('refresh token expired')) {
      return const AppFailure.authExpired();
    }

    if (message.contains('session not found') ||
        message.contains('no session')) {
      return const AppFailure.authRequired();
    }

    if (message.contains('cancelled') ||
        message.contains('user cancelled')) {
      return const AppFailure.authCancelled();
    }

    // Default to unknown error with the original message
    return AppFailure.unknown(message: error.message);
  }

  /// Map 400 Bad Request errors
  static AppFailure _map400Error(String message) {
    if (message.contains('password')) {
      return const AppFailure.weakPassword();
    }
    if (message.contains('email')) {
      return const AppFailure.validationError(message: 'Invalid email');
    }
    return const AppFailure.validationError(message: 'Invalid request');
  }

  /// Map 401 Unauthorized errors
  static AppFailure _map401Error(String message) {
    if (message.contains('invalid login credentials')) {
      return const AppFailure.invalidCredentials();
    }
    if (message.contains('email not confirmed')) {
      return const AppFailure.emailNotConfirmed();
    }
    if (message.contains('expired')) {
      return const AppFailure.authExpired();
    }
    return const AppFailure.authRequired();
  }

  /// Map 422 Unprocessable Entity errors
  static AppFailure _map422Error(String message) {
    if (message.contains('email')) {
      return const AppFailure.emailAlreadyInUse();
    }
    if (message.contains('user already registered')) {
      return const AppFailure.userAlreadyExists();
    }
    return const AppFailure.validationError(message: 'Validation failed');
  }

  /// Map generic exceptions to AppFailure
  static AppFailure mapException(Object error) {
    if (error is AuthException) {
      return mapAuthException(error);
    }

    // Check error string for common patterns
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socket')) {
      return const AppFailure.noInternet();
    }

    if (errorString.contains('timeout')) {
      return const AppFailure.timeout();
    }

    if (errorString.contains('cancelled')) {
      return const AppFailure.authCancelled();
    }

    // Default unknown error
    return AppFailure.unknown(message: error.toString());
  }
}
