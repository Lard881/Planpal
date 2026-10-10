import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'app_failure.dart';

/// Maps AppFailure to localized user-friendly messages
class FailureMessages {
  FailureMessages._();

  /// Get localized message for a failure
  static String getMessage(BuildContext context, AppFailure failure) {
    // TODO: Implement full error mapping
    // For now, return a generic message based on failure type
    return failure.maybeWhen(
      noNetwork: () => 'No network connection',
      noInternet: () => 'No internet connection',
      serverUnreachable: () => 'Server unreachable',
      timeout: () => 'Request timed out',
      forbidden: () => 'Access forbidden',
      notFound: (_) => 'Resource not found',
      orElse: () => 'An error occurred: ${failure.toString()}',
    );
  }

  /// Get short title for a failure
  static String getTitle(BuildContext context, AppFailure failure) {
    // TODO: Implement full title mapping
    return failure.maybeWhen(
      noNetwork: () => 'No Connection',
      noInternet: () => 'No Internet',
      forbidden: () => 'Access Denied',
      notFound: (_) => 'Not Found',
      orElse: () => 'Error',
    );
  }
}
