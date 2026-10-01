import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PlanPal'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @notificationTitleTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'Task Assigned'**
  String get notificationTitleTaskAssigned;

  /// No description provided for @notificationTitleTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task Completed'**
  String get notificationTitleTaskCompleted;

  /// No description provided for @notificationTitleTaskOverdue.
  ///
  /// In en, this message translates to:
  /// **'Task Overdue'**
  String get notificationTitleTaskOverdue;

  /// No description provided for @notificationTitleTaskDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Task Due Soon'**
  String get notificationTitleTaskDueSoon;

  /// No description provided for @notificationTitleTaskCommented.
  ///
  /// In en, this message translates to:
  /// **'New Comment'**
  String get notificationTitleTaskCommented;

  /// No description provided for @notificationTitleTaskStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Task Status Changed'**
  String get notificationTitleTaskStatusChanged;

  /// No description provided for @notificationTitleProjectInvite.
  ///
  /// In en, this message translates to:
  /// **'Project Invitation'**
  String get notificationTitleProjectInvite;

  /// No description provided for @notificationTitleProjectUpdated.
  ///
  /// In en, this message translates to:
  /// **'Project Updated'**
  String get notificationTitleProjectUpdated;

  /// No description provided for @notificationTitleProjectDeadline.
  ///
  /// In en, this message translates to:
  /// **'Project Deadline'**
  String get notificationTitleProjectDeadline;

  /// No description provided for @notificationTitleEventReminder.
  ///
  /// In en, this message translates to:
  /// **'Event Reminder'**
  String get notificationTitleEventReminder;

  /// No description provided for @notificationTitleEventStartingSoon.
  ///
  /// In en, this message translates to:
  /// **'Event Starting Soon'**
  String get notificationTitleEventStartingSoon;

  /// No description provided for @notificationTitleEventUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event Updated'**
  String get notificationTitleEventUpdated;

  /// No description provided for @notificationTitleEventCancelled.
  ///
  /// In en, this message translates to:
  /// **'Event Cancelled'**
  String get notificationTitleEventCancelled;

  /// No description provided for @notificationTitleChatMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get notificationTitleChatMessage;

  /// No description provided for @notificationTitleChatMention.
  ///
  /// In en, this message translates to:
  /// **'You Were Mentioned'**
  String get notificationTitleChatMention;

  /// No description provided for @notificationTitleWorkspaceInvite.
  ///
  /// In en, this message translates to:
  /// **'Workspace Invitation'**
  String get notificationTitleWorkspaceInvite;

  /// No description provided for @notificationTitleWorkspaceRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'Role Changed'**
  String get notificationTitleWorkspaceRoleChanged;

  /// No description provided for @notificationTitleSystem.
  ///
  /// In en, this message translates to:
  /// **'System Notification'**
  String get notificationTitleSystem;

  /// No description provided for @notificationTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationTitleDefault;

  /// No description provided for @notificationBodyTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'{actor} assigned you to \"{task}\"'**
  String notificationBodyTaskAssigned(String actor, String task);

  /// No description provided for @notificationBodyTaskAssignedGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have been assigned to a new task'**
  String get notificationBodyTaskAssignedGeneric;

  /// No description provided for @notificationBodyTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'{actor} completed \"{task}\"'**
  String notificationBodyTaskCompleted(String actor, String task);

  /// No description provided for @notificationBodyTaskCompletedGeneric.
  ///
  /// In en, this message translates to:
  /// **'A task has been completed'**
  String get notificationBodyTaskCompletedGeneric;

  /// No description provided for @notificationBodyTaskOverdue.
  ///
  /// In en, this message translates to:
  /// **'\"{task}\" is overdue'**
  String notificationBodyTaskOverdue(String task);

  /// No description provided for @notificationBodyTaskOverdueGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have overdue tasks'**
  String get notificationBodyTaskOverdueGeneric;

  /// No description provided for @notificationBodyTaskDueSoon.
  ///
  /// In en, this message translates to:
  /// **'\"{task}\" is due {time}'**
  String notificationBodyTaskDueSoon(String task, String time);

  /// No description provided for @notificationBodyTaskDueSoonGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have tasks due soon'**
  String get notificationBodyTaskDueSoonGeneric;

  /// No description provided for @notificationBodyTaskCommented.
  ///
  /// In en, this message translates to:
  /// **'{actor} commented on \"{task}\"'**
  String notificationBodyTaskCommented(String actor, String task);

  /// No description provided for @notificationBodyTaskCommentedGeneric.
  ///
  /// In en, this message translates to:
  /// **'New comment on a task'**
  String get notificationBodyTaskCommentedGeneric;

  /// No description provided for @notificationBodyTaskStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'\"{task}\" status changed to {status}'**
  String notificationBodyTaskStatusChanged(String task, String status);

  /// No description provided for @notificationBodyTaskStatusChangedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Task status has changed'**
  String get notificationBodyTaskStatusChangedGeneric;

  /// No description provided for @notificationBodyProjectInvite.
  ///
  /// In en, this message translates to:
  /// **'{actor} invited you to join \"{project}\"'**
  String notificationBodyProjectInvite(String actor, String project);

  /// No description provided for @notificationBodyProjectInviteGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have been invited to a project'**
  String get notificationBodyProjectInviteGeneric;

  /// No description provided for @notificationBodyProjectUpdated.
  ///
  /// In en, this message translates to:
  /// **'\"{project}\" has been updated'**
  String notificationBodyProjectUpdated(String project);

  /// No description provided for @notificationBodyProjectUpdatedGeneric.
  ///
  /// In en, this message translates to:
  /// **'A project has been updated'**
  String get notificationBodyProjectUpdatedGeneric;

  /// No description provided for @notificationBodyProjectDeadline.
  ///
  /// In en, this message translates to:
  /// **'\"{project}\" deadline is {time}'**
  String notificationBodyProjectDeadline(String project, String time);

  /// No description provided for @notificationBodyProjectDeadlineGeneric.
  ///
  /// In en, this message translates to:
  /// **'Project deadline approaching'**
  String get notificationBodyProjectDeadlineGeneric;

  /// No description provided for @notificationBodyEventReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder: \"{event}\" starts {time}'**
  String notificationBodyEventReminder(String event, String time);

  /// No description provided for @notificationBodyEventReminderGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have an upcoming event'**
  String get notificationBodyEventReminderGeneric;

  /// No description provided for @notificationBodyEventStartingSoon.
  ///
  /// In en, this message translates to:
  /// **'\"{event}\" starts {time}'**
  String notificationBodyEventStartingSoon(String event, String time);

  /// No description provided for @notificationBodyEventStartingSoonGeneric.
  ///
  /// In en, this message translates to:
  /// **'An event is starting soon'**
  String get notificationBodyEventStartingSoonGeneric;

  /// No description provided for @notificationBodyEventUpdated.
  ///
  /// In en, this message translates to:
  /// **'\"{event}\" has been updated'**
  String notificationBodyEventUpdated(String event);

  /// No description provided for @notificationBodyEventUpdatedGeneric.
  ///
  /// In en, this message translates to:
  /// **'An event has been updated'**
  String get notificationBodyEventUpdatedGeneric;

  /// No description provided for @notificationBodyEventCancelled.
  ///
  /// In en, this message translates to:
  /// **'\"{event}\" has been cancelled'**
  String notificationBodyEventCancelled(String event);

  /// No description provided for @notificationBodyEventCancelledGeneric.
  ///
  /// In en, this message translates to:
  /// **'An event has been cancelled'**
  String get notificationBodyEventCancelledGeneric;

  /// No description provided for @notificationBodyChatMessage.
  ///
  /// In en, this message translates to:
  /// **'{actor} sent you a message'**
  String notificationBodyChatMessage(String actor);

  /// No description provided for @notificationBodyChatMessageGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have a new message'**
  String get notificationBodyChatMessageGeneric;

  /// No description provided for @notificationBodyChatMention.
  ///
  /// In en, this message translates to:
  /// **'{actor} mentioned you in a chat'**
  String notificationBodyChatMention(String actor);

  /// No description provided for @notificationBodyChatMentionGeneric.
  ///
  /// In en, this message translates to:
  /// **'You were mentioned in a chat'**
  String get notificationBodyChatMentionGeneric;

  /// No description provided for @notificationBodyWorkspaceInvite.
  ///
  /// In en, this message translates to:
  /// **'{actor} invited you to join \"{workspace}\"'**
  String notificationBodyWorkspaceInvite(String actor, String workspace);

  /// No description provided for @notificationBodyWorkspaceInviteGeneric.
  ///
  /// In en, this message translates to:
  /// **'You have been invited to a workspace'**
  String get notificationBodyWorkspaceInviteGeneric;

  /// No description provided for @notificationBodyWorkspaceRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'Your role in \"{workspace}\" changed to {role}'**
  String notificationBodyWorkspaceRoleChanged(String workspace, String role);

  /// No description provided for @notificationBodyWorkspaceRoleChangedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Your workspace role has changed'**
  String get notificationBodyWorkspaceRoleChangedGeneric;

  /// No description provided for @notificationBodySystemGeneric.
  ///
  /// In en, this message translates to:
  /// **'System notification'**
  String get notificationBodySystemGeneric;

  /// No description provided for @notificationBodyDefault.
  ///
  /// In en, this message translates to:
  /// **'You have a new notification'**
  String get notificationBodyDefault;

  /// No description provided for @timeRemainingDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} {days, plural, =1{day} other{days}}'**
  String timeRemainingDays(int days);

  /// No description provided for @timeRemainingHours.
  ///
  /// In en, this message translates to:
  /// **'in {hours} {hours, plural, =1{hour} other{hours}}'**
  String timeRemainingHours(int hours);

  /// No description provided for @timeRemainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes} {minutes, plural, =1{minute} other{minutes}}'**
  String timeRemainingMinutes(int minutes);

  /// No description provided for @timeOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'{days} {days, plural, =1{day} other{days}} overdue'**
  String timeOverdueDays(int days);

  /// No description provided for @timeOverdueHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} {hours, plural, =1{hour} other{hours}} overdue'**
  String timeOverdueHours(int hours);

  /// No description provided for @timeOverdueMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} {minutes, plural, =1{minute} other{minutes}} overdue'**
  String timeOverdueMinutes(int minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
