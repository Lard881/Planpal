import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Extension on BuildContext for quick access to AppLocalizations
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}


