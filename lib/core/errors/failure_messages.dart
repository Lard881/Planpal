import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'app_failure.dart';

/// Maps AppFailure to localized user-friendly messages
class FailureMessages {
  FailureMessages._();

  /// Get localized message for a failure
  static String getMessage(BuildContext context, AppFailure failure) {
    final l10n = AppLocalizations.of(context)!;

    return failure.when(
      // Network & Connectivity
      noNetwork: () => l10n.errorNoNetwork,
      noInternet: () => l10n.errorNoInternet,
      serverUnreachable: () => l10n.errorServerUnreachable,
      timeout: () => l10n.errorTimeout,

      // Authentication
      authRequired: () => l10n.errorAuthRequired,
      authExpired: () => l10n.errorAuthExpired,
      invalidCredentials: () => l10n.errorInvalidCredentials,
      emailNotConfirmed: () => l10n.errorEmailNotConfirmed,
      userAlreadyExists: () => l10n.errorUserAlreadyExists,
      emailAlreadyInUse: () => l10n.errorEmailAlreadyInUse,
      weakPassword: () => l10n.errorWeakPassword,
      authCancelled: () => l10n.errorAuthCancelled,

      // Authorization
      notAMember: () => l10n.errorNotAMember,
      forbidden: () => l10n.errorForbidden,
      lastAdmin: () => l10n.errorLastAdmin,

      // Invite Codes
      invalidCode: () => l10n.errorInvalidCode,
      codeExpired: () => l10n.errorCodeExpired,
      codeRevoked: () => l10n.errorCodeRevoked,
      codeUsedUp: () => l10n.errorCodeUsedUp,
      alreadyMember: () => l10n.errorAlreadyMember,

      // Files
      fileTooLarge: () => l10n.errorFileTooLarge,
      fileTypeNotAllowed: () => l10n.errorFileTypeNotAllowed,

      // Resources
      notFound: (resource) => resource != null
          ? l10n.errorNotFoundWithResource(resource)
          : l10n.errorNotFound,
      taskNotFound: () => l10n.errorTaskNotFound,
      workspaceNotFound: () => l10n.errorWorkspaceNotFound,

      // Validation
      validationFailed: (fields) {
        if (fields.isEmpty) return l10n.errorValidationFailed;
        final fieldErrors = fields.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', ');
        return '${l10n.errorValidationFailed}\n$fieldErrors';
      },

      // Conflicts
      syncConflict: (message) =>
          message ?? l10n.errorSyncConflict,
      workspaceNameTaken: () => l10n.errorWorkspaceNameTaken,

      // Chat
      chatNotAvailableInPersonal: () => l10n.errorChatNotAvailableInPersonal,
      channelNotFound: () => l10n.errorChannelNotFound,
      messageNotFound: () => l10n.errorMessageNotFound,

      // System
      unknown: (message) => message ?? l10n.errorUnknown,
      serverError: (message) => message ?? l10n.errorServerError,
    );
  }

  /// Get a short title for the failure type
  static String getTitle(BuildContext context, AppFailure failure) {
    final l10n = AppLocalizations.of(context)!;

    return failure.when(
      // Network & Connectivity
      noNetwork: () => l10n.errorTitleNetwork,
      noInternet: () => l10n.errorTitleNetwork,
      serverUnreachable: () => l10n.errorTitleServer,
      timeout: () => l10n.errorTitleTimeout,

      // Authentication
      authRequired: () => l10n.errorTitleAuth,
      authExpired: () => l10n.errorTitleAuth,
      invalidCredentials: () => l10n.errorTitleAuth,
      emailNotConfirmed: () => l10n.errorTitleAuth,
      userAlreadyExists: () => l10n.errorTitleAuth,
      emailAlreadyInUse: () => l10n.errorTitleAuth,
      weakPassword: () => l10n.errorTitleAuth,
      authCancelled: () => l10n.errorTitleAuth,

      // Authorization
      notAMember: () => l10n.errorTitlePermission,
      forbidden: () => l10n.errorTitlePermission,
      lastAdmin: () => l10n.errorTitlePermission,

      // Invite Codes
      invalidCode: () => l10n.errorTitleInviteCode,
      codeExpired: () => l10n.errorTitleInviteCode,
      codeRevoked: () => l10n.errorTitleInviteCode,
      codeUsedUp: () => l10n.errorTitleInviteCode,
      alreadyMember: () => l10n.errorTitleInviteCode,

      // Files
      fileTooLarge: () => l10n.errorTitleFile,
      fileTypeNotAllowed: () => l10n.errorTitleFile,

      // Resources
      notFound: (_) => l10n.errorTitleNotFound,
      taskNotFound: () => l10n.errorTitleNotFound,
      workspaceNotFound: () => l10n.errorTitleNotFound,

      // Validation
      validationFailed: (_) => l10n.errorTitleValidation,

      // Conflicts
      syncConflict: (_) => l10n.errorTitleSync,
      workspaceNameTaken: () => l10n.errorTitleSync,

      // Chat
      chatNotAvailableInPersonal: () => l10n.errorTitleChat,
      channelNotFound: () => l10n.errorTitleChat,
      messageNotFound: () => l10n.errorTitleChat,

      // System
      unknown: (_) => l10n.error,
      serverError: (_) => l10n.errorTitleServer,
    );
  }
}
