import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/l10n/app_localizations_en.dart';
import 'package:planpal/core/network/api_error_mapper.dart';
import 'package:planpal/core/network/failure_localizer.dart';

void main() {
  test('maps stable backend codes to localized messages, not server text', () {
    const translations = {
      'CODE_EXPIRED': 'This invite code has expired.',
      'INVALID_CODE': 'This invite code is invalid.',
      'CODE_REVOKED': 'This invite code has been revoked.',
      'CODE_USED_UP': 'This invite code has reached its use limit.',
      'ALREADY_MEMBER': 'You are already a member of this workspace.',
      'RATE_LIMITED': 'Too many requests. Please wait and try again.',
      'TRANSFER_ADMIN_FIRST':
          'Transfer workspace ownership before deleting your account.',
      'CHAT_NOT_AVAILABLE_IN_PERSONAL':
          'Chat is only available in team workspaces.',
    };
    const statusCodes = {
      'CODE_EXPIRED': 400,
      'INVALID_CODE': 400,
      'CODE_REVOKED': 400,
      'CODE_USED_UP': 400,
      'ALREADY_MEMBER': 409,
      'RATE_LIMITED': 429,
      'TRANSFER_ADMIN_FIRST': 403,
      'CHAT_NOT_AVAILABLE_IN_PERSONAL': 403,
    };

    for (final entry in translations.entries) {
      final failure = mapDioError(
        _failure(statusCodes[entry.key]!, entry.key, 'English backend detail'),
      );
      expect(
        localizedFailureMessage(AppLocalizationsEn(), failure),
        entry.value,
        reason: entry.key,
      );
      expect(failure.message, isNot(contains('English backend detail')));
    }
  });
}

DioException _failure(int status, String code, String message) => DioException(
  requestOptions: RequestOptions(path: '/'),
  response: Response(
    requestOptions: RequestOptions(path: '/'),
    statusCode: status,
    data: {
      'error': {'code': code, 'message': message},
    },
  ),
  type: DioExceptionType.badResponse,
);
