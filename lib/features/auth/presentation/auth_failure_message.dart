import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/app_failure.dart';

String authFailureMessage(AppLocalizations l10n, AppFailure failure) {
  if (failure is AuthFailure) {
    return switch (failure.reason) {
      AuthFailureReason.invalidCredentials => l10n.authInvalidCredentials,
      AuthFailureReason.emailNotConfirmed => l10n.authEmailNotConfirmed,
      AuthFailureReason.accountAlreadyExists => l10n.authAccountAlreadyExists,
      AuthFailureReason.weakPassword => l10n.authWeakPassword,
      AuthFailureReason.rateLimited => l10n.authTooManyAttempts,
      AuthFailureReason.invalidCode => l10n.authInvalidCode,
      AuthFailureReason.network => l10n.errorNetwork,
      AuthFailureReason.googleSignInFailed => l10n.authGoogleBrowserFailure,
      AuthFailureReason.unknown => l10n.errorGeneric,
    };
  }
  if (failure is NetworkFailure) return l10n.errorNetwork;
  if (failure is TimeoutFailure || failure is ServerUnreachableFailure) {
    return l10n.errorServer;
  }
  if (failure is AuthExpiredFailure) return l10n.errorSessionExpired;
  return l10n.errorGeneric;
}
