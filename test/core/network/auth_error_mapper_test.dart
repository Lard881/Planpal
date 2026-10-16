import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:planpal/core/network/app_failure.dart';
import 'package:planpal/core/network/auth_error_mapper.dart';

void main() {
  group('mapAuthException', () {
    test('maps invalid credentials without exposing server text', () {
      final failure = mapAuthException(
        AuthException('sensitive server detail', code: 'invalid_credentials'),
      );

      expect(failure.reason, AuthFailureReason.invalidCredentials);
      expect(failure.message, isEmpty);
    });

    test('maps unconfirmed email', () {
      final failure = mapAuthException(
        AuthException('Email not confirmed', code: 'email_not_confirmed'),
      );

      expect(failure.reason, AuthFailureReason.emailNotConfirmed);
    });

    test('maps duplicate accounts and weak passwords', () {
      expect(
        mapAuthException(
          AuthException('User already registered', code: 'user_already_exists'),
        ).reason,
        AuthFailureReason.accountAlreadyExists,
      );
      expect(
        mapAuthException(
          AuthException('Password too short', code: 'weak_password'),
        ).reason,
        AuthFailureReason.weakPassword,
      );
    });

    test('maps rate limits and network errors', () {
      expect(
        mapAuthException(
          AuthException('Please wait', code: 'over_request_rate_limit'),
        ).reason,
        AuthFailureReason.rateLimited,
      );
      expect(
        mapAuthException(
          AuthException('Network connection failed', code: 'unexpected'),
        ).reason,
        AuthFailureReason.network,
      );
    });

    test('maps invalid OTP only for OTP operations', () {
      final error = AuthException('Invalid token', code: 'otp_invalid');

      expect(
        mapAuthException(error, otpOperation: true).reason,
        AuthFailureReason.invalidCode,
      );
      expect(
        mapAuthException(error).reason,
        AuthFailureReason.unknown,
      );
    });

    test('uses a safe generic reason for unknown server messages', () {
      final failure = mapAuthException(
        AuthException('internal server details', code: 'unrecognized'),
      );

      expect(failure.reason, AuthFailureReason.unknown);
      expect(failure.message, isEmpty);
    });
  });
}
