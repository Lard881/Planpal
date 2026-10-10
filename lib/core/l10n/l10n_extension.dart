import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Extension on BuildContext for quick access to AppLocalizations
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Fallback getters for AppLocalizations when keys are not in ARB files
extension AppLocalizationsFallbacks on AppLocalizations {
  String get fieldRequired => 'This field is required';
  String get workspaceCodeLength => 'Invite code must be 6 characters';
  String get workspaceCodeFormat => 'Code must be alphanumeric';
  String get workspaceJoinTitle => 'Join Workspace';
  String get workspaceJoinDescription => 'Enter an invite code to join an existing workspace';
  String get workspaceInviteCode => 'Invite Code';
  String get workspaceInviteCodeHint => 'e.g. ABC123';
  String get workspaceCodeHelper => 'Ask your workspace admin for an invite code';
  String get workspaceJoinButton => 'Join Workspace';
  String get or => 'or';
  String get workspaceCreateNew => 'Create a new workspace instead';
  String get workspaceNameTaken => 'Workspace name already taken';
}

