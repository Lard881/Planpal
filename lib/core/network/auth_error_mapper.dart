import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_failure.dart';

AuthFailure mapAuthException(AuthException error, {bool otpOperation = false}) {
  final code = error.code?.toLowerCase() ?? '';
  final message = error.message.toLowerCase();

  if (code == 'invalid_credentials' ||
      message.contains('invalid login') ||
      message.contains('invalid credentials')) {
    return const AuthFailure(AuthFailureReason.invalidCredentials);
  }
  if (code == 'email_not_confirmed' || message.contains('email not confirmed')) {
    return const AuthFailure(AuthFailureReason.emailNotConfirmed);
  }
  if (code == 'user_already_exists' ||
      message.contains('user already registered')) {
    return const AuthFailure(AuthFailureReason.accountAlreadyExists);
  }
  if (code == 'weak_password' ||
      message.contains('password should be at least')) {
    return const AuthFailure(AuthFailureReason.weakPassword);
  }
  if (code == 'over_request_rate_limit' ||
      message.contains('rate limit') ||
      message.contains('too many requests')) {
    return const AuthFailure(AuthFailureReason.rateLimited);
  }
  if (code == 'network_failure' ||
      message.contains('network') ||
      message.contains('connection')) {
    return const AuthFailure(AuthFailureReason.network);
  }
  if (otpOperation &&
      (code == 'otp_expired' ||
          code == 'token_expired' ||
          code == 'otp_invalid' ||
          code == 'invalid_otp' ||
          ((message.contains('token') || message.contains('otp')) &&
              (message.contains('expired') || message.contains('invalid'))))) {
    return const AuthFailure(AuthFailureReason.invalidCode);
  }
  return const AuthFailure(AuthFailureReason.unknown);
}
