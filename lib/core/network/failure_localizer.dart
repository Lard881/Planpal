import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import 'api_error_mapper.dart';
import 'app_failure.dart';

String localizeFailureText(AppLocalizations l10n, String text) {
  if (!text.startsWith(_apiErrorPrefix)) return text;
  final code = text.substring(_apiErrorPrefix.length);
  return switch (code) {
    'NETWORK' => l10n.errorNetwork,
    'TIMEOUT' => l10n.errorTimeout,
    'SERVER_UNREACHABLE' => l10n.bannerServerUnreachable,
    'AUTH_EXPIRED' => l10n.errorSessionExpired,
    'AUTH_REQUIRED' => l10n.errorAuthRequired,
    'INVALID_CODE' => l10n.errorInvalidInviteCode,
    'CODE_EXPIRED' => l10n.errorInviteCodeExpired,
    'CODE_REVOKED' => l10n.errorInviteCodeRevoked,
    'CODE_USED_UP' => l10n.errorInviteCodeExhausted,
    'ALREADY_MEMBER' => l10n.errorAlreadyMember,
    'RATE_LIMITED' => l10n.errorRateLimited,
    'TRANSFER_ADMIN_FIRST' => l10n.errorTransferAdminFirst,
    'CHAT_NOT_AVAILABLE_IN_PERSONAL' => l10n.errorChatPersonalOnly,
    'INVALID_REQUEST' || 'VALIDATION_ERROR' => l10n.errorInvalidRequest,
    'FORBIDDEN' || 'PERMISSION_DENIED' => l10n.errorPermission,
    'NOT_FOUND' => l10n.errorNotFound,
    'FOLDER_NOT_EMPTY' => l10n.errorFolderNotEmpty,
    'CONFLICT' => l10n.errorConflict,
    'SERVER_ERROR' ||
    'INTERNAL_ERROR' ||
    'SERVICE_UNAVAILABLE' => l10n.errorServer,
    _ => l10n.errorGeneric,
  };
}

String localizedFailureMessage(AppLocalizations l10n, AppFailure failure) {
  if (failure.message.startsWith(_apiErrorPrefix)) {
    return localizeFailureText(l10n, failure.message);
  }
  return switch (failure) {
    NetworkFailure() => l10n.errorNetwork,
    ServerUnreachableFailure() => l10n.bannerServerUnreachable,
    TimeoutFailure() => l10n.errorTimeout,
    AuthRequiredFailure() => l10n.errorAuthRequired,
    AuthExpiredFailure() => l10n.errorSessionExpired,
    ForbiddenFailure() => l10n.errorPermission,
    NotFoundFailure() => l10n.errorNotFound,
    ValidationFailure() => l10n.errorInvalidRequest,
    ConflictFailure() => l10n.errorConflict,
    ServerFailure(:final code) => localizeFailureText(
      l10n,
      apiErrorMessage(code),
    ),
    _ => l10n.errorGeneric,
  };
}

extension LocalizedAppFailure on AppFailure {
  String localizedMessage(BuildContext context) =>
      localizedFailureMessage(AppLocalizations.of(context), this);
}

const _apiErrorPrefix = '__PLANPAL_API_ERROR__:';
