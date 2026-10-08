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

  /// No description provided for @errorNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please check your device\'s network settings.'**
  String get errorNoNetwork;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your Wi-Fi or mobile data.'**
  String get errorNoInternet;

  /// No description provided for @errorServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Server is unreachable. It may be starting up, please wait a moment.'**
  String get errorServerUnreachable;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorAuthRequired.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to do this.'**
  String get errorAuthRequired;

  /// No description provided for @errorAuthExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorAuthExpired;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email address before signing in.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorUserAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errorUserAlreadyExists;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get errorWeakPassword;

  /// No description provided for @errorAuthCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign in was cancelled.'**
  String get errorAuthCancelled;

  /// No description provided for @errorNotAMember.
  ///
  /// In en, this message translates to:
  /// **'You are not a member of this workspace.'**
  String get errorNotAMember;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get errorForbidden;

  /// No description provided for @errorLastAdmin.
  ///
  /// In en, this message translates to:
  /// **'Cannot remove the last admin. Promote another member first.'**
  String get errorLastAdmin;

  /// No description provided for @errorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid invite code. Please check and try again.'**
  String get errorInvalidCode;

  /// No description provided for @errorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This invite code has expired.'**
  String get errorCodeExpired;

  /// No description provided for @errorCodeRevoked.
  ///
  /// In en, this message translates to:
  /// **'This invite code has been revoked.'**
  String get errorCodeRevoked;

  /// No description provided for @errorCodeUsedUp.
  ///
  /// In en, this message translates to:
  /// **'This invite code has reached its maximum uses.'**
  String get errorCodeUsedUp;

  /// No description provided for @errorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this workspace.'**
  String get errorAlreadyMember;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large. Maximum size is 20 MB.'**
  String get errorFileTooLarge;

  /// No description provided for @errorFileTypeNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This file type is not allowed.'**
  String get errorFileTypeNotAllowed;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item not found.'**
  String get errorNotFound;

  /// No description provided for @errorNotFoundWithResource.
  ///
  /// In en, this message translates to:
  /// **'{resource} not found.'**
  String errorNotFoundWithResource(String resource);

  /// No description provided for @errorTaskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found.'**
  String get errorTaskNotFound;

  /// No description provided for @errorWorkspaceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Workspace not found.'**
  String get errorWorkspaceNotFound;

  /// No description provided for @errorValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please check the form and try again.'**
  String get errorValidationFailed;

  /// No description provided for @errorSyncConflict.
  ///
  /// In en, this message translates to:
  /// **'This item was changed elsewhere. Please refresh and try again.'**
  String get errorSyncConflict;

  /// No description provided for @errorWorkspaceNameTaken.
  ///
  /// In en, this message translates to:
  /// **'A workspace with this name already exists.'**
  String get errorWorkspaceNameTaken;

  /// No description provided for @errorChatNotAvailableInPersonal.
  ///
  /// In en, this message translates to:
  /// **'Chat is not available in Personal workspaces. Create or join a team workspace to use chat.'**
  String get errorChatNotAvailableInPersonal;

  /// No description provided for @chatNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Chat Not Available'**
  String get chatNotAvailable;

  /// No description provided for @errorChannelNotFound.
  ///
  /// In en, this message translates to:
  /// **'Channel not found.'**
  String get errorChannelNotFound;

  /// No description provided for @errorMessageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Message not found.'**
  String get errorMessageNotFound;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServerError;

  /// No description provided for @errorTitleNetwork.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get errorTitleNetwork;

  /// No description provided for @errorTitleServer.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get errorTitleServer;

  /// No description provided for @errorTitleTimeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get errorTitleTimeout;

  /// No description provided for @errorTitleAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get errorTitleAuth;

  /// No description provided for @errorTitlePermission.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get errorTitlePermission;

  /// No description provided for @errorTitleInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Invite Code'**
  String get errorTitleInviteCode;

  /// No description provided for @errorTitleFile.
  ///
  /// In en, this message translates to:
  /// **'File Error'**
  String get errorTitleFile;

  /// No description provided for @errorTitleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get errorTitleNotFound;

  /// No description provided for @errorTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get errorTitleValidation;

  /// No description provided for @errorTitleSync.
  ///
  /// In en, this message translates to:
  /// **'Sync Error'**
  String get errorTitleSync;

  /// No description provided for @errorTitleChat.
  ///
  /// In en, this message translates to:
  /// **'Chat Error'**
  String get errorTitleChat;

  /// No description provided for @errorDetails.
  ///
  /// In en, this message translates to:
  /// **'Error Details'**
  String get errorDetails;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get technicalDetails;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Error details copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String validationPasswordMinLength(int minLength);

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get validationPasswordMatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms of Service and Privacy Policy'**
  String get validationTermsRequired;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to PlanPal'**
  String get authSignInToContinue;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authSignUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started with PlanPal'**
  String get authSignUpToGetStarted;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authEnterYourName;

  /// No description provided for @authEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterYourEmail;

  /// No description provided for @authEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterYourPassword;

  /// No description provided for @authConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get authConfirmYourPassword;

  /// No description provided for @authAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms} and {privacy}'**
  String authAgreeToTerms(String terms, String privacy);

  /// No description provided for @authTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsOfService;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyPolicy;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get authVerifyEmail;

  /// No description provided for @authVerifyEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String authVerifyEmailDesc(String email);

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get authResendCode;

  /// No description provided for @authResendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String authResendCodeIn(int seconds);

  /// No description provided for @authVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerifyButton;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset code'**
  String get authResetPasswordDesc;

  /// No description provided for @authSendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get authSendResetCode;

  /// No description provided for @authEnterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Reset Code'**
  String get authEnterResetCode;

  /// No description provided for @authEnterResetCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email'**
  String get authEnterResetCodeDesc;

  /// No description provided for @authEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get authEnterNewPassword;

  /// No description provided for @authEnterNewPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account'**
  String get authEnterNewPasswordDesc;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authResetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get authResetPasswordSuccess;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authSigningIn;

  /// No description provided for @authSigningUp.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get authSigningUp;

  /// No description provided for @authVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get authVerifying;

  /// No description provided for @authResetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting password...'**
  String get authResetting;

  /// No description provided for @authLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get authLoginSuccess;

  /// No description provided for @authSignupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get authSignupSuccess;

  /// No description provided for @authVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully'**
  String get authVerificationSuccess;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get authPasswordResetSuccess;

  /// No description provided for @authCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email'**
  String get authCodeSent;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session...'**
  String get sessionRestoring;

  /// No description provided for @sessionCheckingAuth.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get sessionCheckingAuth;

  /// No description provided for @workspaceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Workspace'**
  String get workspaceCreateTitle;

  /// No description provided for @workspaceCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new workspace for your team'**
  String get workspaceCreateDescription;

  /// No description provided for @workspaceCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Workspace'**
  String get workspaceCreateButton;

  /// No description provided for @workspaceName.
  ///
  /// In en, this message translates to:
  /// **'Workspace Name'**
  String get workspaceName;

  /// No description provided for @workspaceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Product Team'**
  String get workspaceNameHint;

  /// No description provided for @workspaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get workspaceDescription;

  /// No description provided for @workspaceDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is this workspace for?'**
  String get workspaceDescriptionHint;

  /// No description provided for @workspaceCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Workspace created successfully'**
  String get workspaceCreateSuccess;

  /// No description provided for @workspaceCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create workspace'**
  String get workspaceCreateError;

  /// No description provided for @workspaceJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Workspace'**
  String get workspaceJoinTitle;

  /// No description provided for @workspaceJoinDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code to join a workspace'**
  String get workspaceJoinDescription;

  /// No description provided for @workspaceJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join Workspace'**
  String get workspaceJoinButton;

  /// No description provided for @workspaceInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get workspaceInviteCode;

  /// No description provided for @workspaceCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'Get this code from a team member'**
  String get workspaceCodeHelper;

  /// No description provided for @workspaceCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 characters'**
  String get workspaceCodeLength;

  /// No description provided for @workspaceCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Code must contain only letters and numbers'**
  String get workspaceCodeFormat;

  /// No description provided for @workspaceCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid invite code'**
  String get workspaceCodeInvalid;

  /// No description provided for @workspaceCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This invite code has expired'**
  String get workspaceCodeExpired;

  /// No description provided for @workspaceAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this workspace'**
  String get workspaceAlreadyMember;

  /// No description provided for @workspaceJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined workspace successfully'**
  String get workspaceJoinSuccess;

  /// No description provided for @workspaceJoinError.
  ///
  /// In en, this message translates to:
  /// **'Failed to join workspace'**
  String get workspaceJoinError;

  /// No description provided for @workspaceCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create New Workspace'**
  String get workspaceCreateNew;

  /// No description provided for @workspaceMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get workspaceMembers;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get noMembersYet;

  /// No description provided for @memberRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'Member role changed successfully'**
  String get memberRoleChanged;

  /// No description provided for @memberRoleChangeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to change member role'**
  String get memberRoleChangeError;

  /// No description provided for @memberRemoveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get memberRemoveConfirmTitle;

  /// No description provided for @memberRemoveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from this workspace?'**
  String memberRemoveConfirmMessage(String name);

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed successfully'**
  String get memberRemoved;

  /// No description provided for @memberRemoveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove member'**
  String get memberRemoveError;

  /// No description provided for @workspaceLeaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Workspace'**
  String get workspaceLeaveConfirmTitle;

  /// No description provided for @workspaceLeaveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this workspace?'**
  String get workspaceLeaveConfirmMessage;

  /// No description provided for @workspaceLeft.
  ///
  /// In en, this message translates to:
  /// **'You have left the workspace'**
  String get workspaceLeft;

  /// No description provided for @workspaceLeaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to leave workspace'**
  String get workspaceLeaveError;

  /// No description provided for @workspaceLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave Workspace'**
  String get workspaceLeave;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMember;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleAdminDescription.
  ///
  /// In en, this message translates to:
  /// **'Can manage workspace and members'**
  String get roleAdminDescription;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleMemberDescription.
  ///
  /// In en, this message translates to:
  /// **'Can view and create content'**
  String get roleMemberDescription;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @errorLoadingMembers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load members'**
  String get errorLoadingMembers;

  /// No description provided for @inviteCodes.
  ///
  /// In en, this message translates to:
  /// **'Invite Codes'**
  String get inviteCodes;

  /// No description provided for @noInviteCodesYet.
  ///
  /// In en, this message translates to:
  /// **'No invite codes yet'**
  String get noInviteCodesYet;

  /// No description provided for @createInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Create Invite Code'**
  String get createInviteCode;

  /// No description provided for @inviteCodeCreated.
  ///
  /// In en, this message translates to:
  /// **'Invite code created successfully'**
  String get inviteCodeCreated;

  /// No description provided for @inviteCodeCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create invite code'**
  String get inviteCodeCreateError;

  /// No description provided for @inviteCodeRevokeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke Invite Code'**
  String get inviteCodeRevokeConfirmTitle;

  /// No description provided for @inviteCodeRevokeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke this invite code? It will no longer work.'**
  String get inviteCodeRevokeConfirmMessage;

  /// No description provided for @inviteCodeRevoked.
  ///
  /// In en, this message translates to:
  /// **'Invite code revoked successfully'**
  String get inviteCodeRevoked;

  /// No description provided for @inviteCodeRevokeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke invite code'**
  String get inviteCodeRevokeError;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied to clipboard'**
  String get inviteCodeCopied;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @revokeCode.
  ///
  /// In en, this message translates to:
  /// **'Revoke Code'**
  String get revokeCode;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get statusRevoked;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusMaxedOut.
  ///
  /// In en, this message translates to:
  /// **'Max Uses Reached'**
  String get statusMaxedOut;

  /// No description provided for @uses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get uses;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @inviteCodeMaxUses.
  ///
  /// In en, this message translates to:
  /// **'Maximum Uses'**
  String get inviteCodeMaxUses;

  /// No description provided for @inviteCodeExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expires In'**
  String get inviteCodeExpiry;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @errorLoadingInviteCodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invite codes'**
  String get errorLoadingInviteCodes;

  /// No description provided for @workspaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Workspace Settings'**
  String get workspaceSettings;

  /// No description provided for @workspaceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Workspace updated successfully'**
  String get workspaceUpdated;

  /// No description provided for @workspaceUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update workspace'**
  String get workspaceUpdateError;

  /// No description provided for @workspaceNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get workspaceNameTooShort;

  /// No description provided for @workspaceNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get workspaceNameTooLong;

  /// No description provided for @workspaceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get workspaceType;

  /// No description provided for @workspaceTypePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get workspaceTypePersonal;

  /// No description provided for @workspaceTypeTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get workspaceTypeTeam;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdAt;

  /// No description provided for @adminOnlySettings.
  ///
  /// In en, this message translates to:
  /// **'Only workspace admins can edit settings'**
  String get adminOnlySettings;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Delete Workspace'**
  String get deleteWorkspace;

  /// No description provided for @workspaceDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Workspace?'**
  String get workspaceDeleteConfirmTitle;

  /// No description provided for @workspaceDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this workspace? This action cannot be undone.'**
  String get workspaceDeleteConfirmMessage;

  /// No description provided for @workspaceDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'All tasks, projects, and data in this workspace will be permanently deleted.'**
  String get workspaceDeleteWarning;

  /// No description provided for @workspaceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Workspace deleted successfully'**
  String get workspaceDeleted;

  /// No description provided for @workspaceDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete workspace'**
  String get workspaceDeleteError;

  /// No description provided for @workspaceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Workspace not found'**
  String get workspaceNotFound;

  /// No description provided for @errorLoadingWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Failed to load workspace'**
  String get errorLoadingWorkspace;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get lastSync;

  /// No description provided for @pendingChanges.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingChanges;

  /// No description provided for @failedChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedChanges;

  /// No description provided for @failedItems.
  ///
  /// In en, this message translates to:
  /// **'Failed Items'**
  String get failedItems;

  /// No description provided for @retryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry All'**
  String get retryAll;

  /// No description provided for @discardAll.
  ///
  /// In en, this message translates to:
  /// **'Discard All'**
  String get discardAll;

  /// No description provided for @discardChange.
  ///
  /// In en, this message translates to:
  /// **'Discard Change?'**
  String get discardChange;

  /// No description provided for @discardAllChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard All Changes?'**
  String get discardAllChanges;

  /// No description provided for @discardAllWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently discard all failed changes. This cannot be undone.'**
  String get discardAllWarning;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @uploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// No description provided for @noUploads.
  ///
  /// In en, this message translates to:
  /// **'No uploads'**
  String get noUploads;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get uploading;

  /// No description provided for @uploadCompleted.
  ///
  /// In en, this message translates to:
  /// **'Upload completed'**
  String get uploadCompleted;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @uploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Upload cancelled'**
  String get uploadCancelled;

  /// No description provided for @uploadStarted.
  ///
  /// In en, this message translates to:
  /// **'Upload started for {count} file(s)'**
  String uploadStarted(int count);

  /// No description provided for @clearCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear Completed'**
  String get clearCompleted;

  /// No description provided for @clearFailed.
  ///
  /// In en, this message translates to:
  /// **'Clear Failed'**
  String get clearFailed;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @noRecentDocuments.
  ///
  /// In en, this message translates to:
  /// **'No recent documents'**
  String get noRecentDocuments;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get noDocuments;

  /// No description provided for @uploadFileToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Upload a file to get started'**
  String get uploadFileToGetStarted;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get folderName;

  /// No description provided for @enterFolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get enterFolderName;

  /// No description provided for @folderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Folder name is required'**
  String get folderNameRequired;

  /// No description provided for @folderNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Folder name is too long (max 200 characters)'**
  String get folderNameTooLong;

  /// No description provided for @folderCreated.
  ///
  /// In en, this message translates to:
  /// **'Folder created successfully'**
  String get folderCreated;

  /// No description provided for @selectFilesToUpload.
  ///
  /// In en, this message translates to:
  /// **'Select files to upload'**
  String get selectFilesToUpload;

  /// No description provided for @browseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse Files'**
  String get browseFiles;

  /// No description provided for @dragAndDropFiles.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop files here'**
  String get dragAndDropFiles;

  /// No description provided for @dropFilesHere.
  ///
  /// In en, this message translates to:
  /// **'Drop files here'**
  String get dropFilesHere;

  /// No description provided for @orClickToBrowse.
  ///
  /// In en, this message translates to:
  /// **'or click to browse'**
  String get orClickToBrowse;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started'**
  String get downloadStarted;

  /// No description provided for @confirmDeleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get confirmDeleteDocument;

  /// No description provided for @confirmDeleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder? It must be empty.'**
  String get confirmDeleteFolder;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeleted;

  /// No description provided for @folderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Folder deleted successfully'**
  String get folderDeleted;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name'**
  String get documentName;

  /// No description provided for @documentNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Document name is required'**
  String get documentNameRequired;

  /// No description provided for @folderRenamed.
  ///
  /// In en, this message translates to:
  /// **'Folder renamed successfully'**
  String get folderRenamed;

  /// No description provided for @documentRenamed.
  ///
  /// In en, this message translates to:
  /// **'Document renamed successfully'**
  String get documentRenamed;

  /// No description provided for @moveToFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to Folder'**
  String get moveToFolder;

  /// No description provided for @rootFolder.
  ///
  /// In en, this message translates to:
  /// **'Root Folder'**
  String get rootFolder;

  /// No description provided for @noFoldersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No folders available'**
  String get noFoldersAvailable;

  /// No description provided for @folderMoved.
  ///
  /// In en, this message translates to:
  /// **'Folder moved successfully'**
  String get folderMoved;

  /// No description provided for @documentMoved.
  ///
  /// In en, this message translates to:
  /// **'Document moved successfully'**
  String get documentMoved;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long (max 200 characters)'**
  String get nameTooLong;

  /// No description provided for @noWorkspaceSelected.
  ///
  /// In en, this message translates to:
  /// **'No workspace selected'**
  String get noWorkspaceSelected;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSaved;

  /// No description provided for @savedAt.
  ///
  /// In en, this message translates to:
  /// **'Saved {time}'**
  String savedAt(String time);

  /// No description provided for @openWithSystemApp.
  ///
  /// In en, this message translates to:
  /// **'Open with System App'**
  String get openWithSystemApp;

  /// No description provided for @errorLoadingFile.
  ///
  /// In en, this message translates to:
  /// **'Error loading file'**
  String get errorLoadingFile;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @errorLoadingImage.
  ///
  /// In en, this message translates to:
  /// **'Error loading image'**
  String get errorLoadingImage;

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// No description provided for @fileDocument.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fileDocument;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach File'**
  String get attachFile;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments'**
  String get noAttachments;

  /// No description provided for @attachmentAdded.
  ///
  /// In en, this message translates to:
  /// **'Attachment added'**
  String get attachmentAdded;

  /// No description provided for @attachmentRemoved.
  ///
  /// In en, this message translates to:
  /// **'Attachment removed'**
  String get attachmentRemoved;

  /// No description provided for @offlineUploadsDisabled.
  ///
  /// In en, this message translates to:
  /// **'File uploads are disabled while offline'**
  String get offlineUploadsDisabled;

  /// No description provided for @notificationTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'Task Assigned'**
  String get notificationTaskAssigned;

  /// No description provided for @notificationTaskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task Updated'**
  String get notificationTaskUpdated;

  /// No description provided for @notificationTaskComment.
  ///
  /// In en, this message translates to:
  /// **'New Comment'**
  String get notificationTaskComment;

  /// No description provided for @notificationDeadlineApproaching.
  ///
  /// In en, this message translates to:
  /// **'Deadline Approaching'**
  String get notificationDeadlineApproaching;

  /// No description provided for @notificationTaskOverdue.
  ///
  /// In en, this message translates to:
  /// **'Task Overdue'**
  String get notificationTaskOverdue;

  /// No description provided for @notificationMention.
  ///
  /// In en, this message translates to:
  /// **'You were mentioned'**
  String get notificationMention;

  /// No description provided for @notificationChatMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get notificationChatMessage;

  /// No description provided for @notificationEventReminder.
  ///
  /// In en, this message translates to:
  /// **'Event Reminder'**
  String get notificationEventReminder;

  /// No description provided for @notificationWorkspaceInvite.
  ///
  /// In en, this message translates to:
  /// **'Workspace Invite'**
  String get notificationWorkspaceInvite;

  /// No description provided for @notificationTaskAssignedBody.
  ///
  /// In en, this message translates to:
  /// **'A task has been assigned to you'**
  String get notificationTaskAssignedBody;

  /// No description provided for @notificationTaskUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'A task has been updated'**
  String get notificationTaskUpdatedBody;

  /// No description provided for @notificationTaskCommentBody.
  ///
  /// In en, this message translates to:
  /// **'Someone commented on a task'**
  String get notificationTaskCommentBody;

  /// No description provided for @notificationDeadlineApproachingBody.
  ///
  /// In en, this message translates to:
  /// **'A task deadline is approaching'**
  String get notificationDeadlineApproachingBody;

  /// No description provided for @notificationTaskOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'A task is overdue'**
  String get notificationTaskOverdueBody;

  /// No description provided for @notificationMentionBody.
  ///
  /// In en, this message translates to:
  /// **'Someone mentioned you'**
  String get notificationMentionBody;

  /// No description provided for @notificationChatMessageBody.
  ///
  /// In en, this message translates to:
  /// **'You have a new message'**
  String get notificationChatMessageBody;

  /// No description provided for @notificationEventReminderBody.
  ///
  /// In en, this message translates to:
  /// **'You have an upcoming event'**
  String get notificationEventReminderBody;
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
