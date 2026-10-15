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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('zh'),
    Locale('ko'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'PlanPal'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get navDocuments;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get navTeam;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search tasks, docs, people...'**
  String get searchPlaceholder;

  /// No description provided for @searchCtrlK.
  ///
  /// In en, this message translates to:
  /// **'Ctrl K'**
  String get searchCtrlK;

  /// No description provided for @searchChats.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChats;

  /// No description provided for @searchFiles.
  ///
  /// In en, this message translates to:
  /// **'Search files...'**
  String get searchFiles;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasks;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;

  /// No description provided for @btnCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get btnCreate;

  /// No description provided for @btnConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btnConfirm;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get btnRetry;

  /// No description provided for @btnViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get btnViewAll;

  /// No description provided for @btnViewAllTasks.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks'**
  String get btnViewAllTasks;

  /// No description provided for @btnDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get btnDetails;

  /// No description provided for @btnCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get btnCopy;

  /// No description provided for @btnCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get btnCopied;

  /// No description provided for @btnAddTask.
  ///
  /// In en, this message translates to:
  /// **'+ Add Task'**
  String get btnAddTask;

  /// No description provided for @btnCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get btnCreateTask;

  /// No description provided for @btnUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get btnUpload;

  /// No description provided for @btnNewDocument.
  ///
  /// In en, this message translates to:
  /// **'+ New Document'**
  String get btnNewDocument;

  /// No description provided for @btnScheduleEvent.
  ///
  /// In en, this message translates to:
  /// **'+ Schedule Event'**
  String get btnScheduleEvent;

  /// No description provided for @btnSaveEvent.
  ///
  /// In en, this message translates to:
  /// **'Save Event'**
  String get btnSaveEvent;

  /// No description provided for @btnSaveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get btnSaveSettings;

  /// No description provided for @btnSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get btnSignOut;

  /// No description provided for @btnDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get btnDeleteAccount;

  /// No description provided for @btnMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get btnMarkAllRead;

  /// No description provided for @btnMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get btnMarkComplete;

  /// No description provided for @btnDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get btnDeleteSelected;

  /// No description provided for @btnInviteWithCode.
  ///
  /// In en, this message translates to:
  /// **'Invite with code'**
  String get btnInviteWithCode;

  /// No description provided for @btnNewCode.
  ///
  /// In en, this message translates to:
  /// **'+ New code'**
  String get btnNewCode;

  /// No description provided for @btnJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get btnJoin;

  /// No description provided for @btnCreateWorkspace.
  ///
  /// In en, this message translates to:
  /// **'+ Create workspace'**
  String get btnCreateWorkspace;

  /// No description provided for @btnJoinWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get btnJoinWithCode;

  /// No description provided for @btnUploadNew.
  ///
  /// In en, this message translates to:
  /// **'Upload New'**
  String get btnUploadNew;

  /// No description provided for @btnRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get btnRemove;

  /// No description provided for @btnRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get btnRevoke;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @btnOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get btnOpen;

  /// No description provided for @btnDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get btnDiscard;

  /// No description provided for @btnSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get btnSkipForNow;

  /// No description provided for @btnContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue ->'**
  String get btnContinueWith;

  /// No description provided for @btnGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started ->'**
  String get btnGetStarted;

  /// No description provided for @btnCreateCode.
  ///
  /// In en, this message translates to:
  /// **'Create code'**
  String get btnCreateCode;

  /// No description provided for @emptyStateNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get emptyStateNoTasks;

  /// No description provided for @emptyStateNoTasksDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first task to get started.'**
  String get emptyStateNoTasksDesc;

  /// No description provided for @emptyStateNoTasksToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing due today.'**
  String get emptyStateNoTasksToday;

  /// No description provided for @emptyStateNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events this week'**
  String get emptyStateNoEvents;

  /// No description provided for @emptyStateNoEventsDay.
  ///
  /// In en, this message translates to:
  /// **'No events this day.'**
  String get emptyStateNoEventsDay;

  /// No description provided for @emptyStateNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get emptyStateNoMessages;

  /// No description provided for @emptyStateNoDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get emptyStateNoDocuments;

  /// No description provided for @emptyStateNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get emptyStateNoNotifications;

  /// No description provided for @emptyStateNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get emptyStateNoResults;

  /// No description provided for @emptyStateNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String emptyStateNoResultsFor(String query);

  /// No description provided for @emptyStateNoInviteCodes.
  ///
  /// In en, this message translates to:
  /// **'No invite codes'**
  String get emptyStateNoInviteCodes;

  /// No description provided for @emptyStateNoInviteCodesDesc.
  ///
  /// In en, this message translates to:
  /// **'Create one to invite teammates.'**
  String get emptyStateNoInviteCodesDesc;

  /// No description provided for @emptyStateNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get emptyStateNoMembers;

  /// No description provided for @emptyStateNoAnalytics.
  ///
  /// In en, this message translates to:
  /// **'No analytics yet'**
  String get emptyStateNoAnalytics;

  /// No description provided for @emptyStateNoAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete some tasks to see your statistics.'**
  String get emptyStateNoAnalyticsDesc;

  /// No description provided for @emptyStateNoChannels.
  ///
  /// In en, this message translates to:
  /// **'No channels yet'**
  String get emptyStateNoChannels;

  /// No description provided for @emptyStateNoChannelsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a channel to get started.'**
  String get emptyStateNoChannelsDesc;

  /// No description provided for @emptyStateSelectChannel.
  ///
  /// In en, this message translates to:
  /// **'Select a channel'**
  String get emptyStateSelectChannel;

  /// No description provided for @emptyStateSelectChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a channel to start messaging.'**
  String get emptyStateSelectChannelDesc;

  /// No description provided for @emptyStateChatTeamOnly.
  ///
  /// In en, this message translates to:
  /// **'Chat is for teams'**
  String get emptyStateChatTeamOnly;

  /// No description provided for @emptyStateChatTeamOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat is only available in team workspaces.'**
  String get emptyStateChatTeamOnlyDesc;

  /// No description provided for @emptyStateTeamOnly.
  ///
  /// In en, this message translates to:
  /// **'Team is for team workspaces'**
  String get emptyStateTeamOnly;

  /// No description provided for @emptyStateTeamOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team workspace to see members.'**
  String get emptyStateTeamOnlyDesc;

  /// No description provided for @emptyStateTaskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get emptyStateTaskNotFound;

  /// No description provided for @emptyStateDocNotFound.
  ///
  /// In en, this message translates to:
  /// **'Document not found'**
  String get emptyStateDocNotFound;

  /// No description provided for @emptyStateNothingUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Nothing coming up.'**
  String get emptyStateNothingUpcoming;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get errorPermission;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This item no longer exists.'**
  String get errorNotFound;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @bannerOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Your changes are saved on this device and will sync when you\'re back online.'**
  String get bannerOffline;

  /// No description provided for @bannerServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection.'**
  String get bannerServerUnreachable;

  /// No description provided for @bannerWakingUp.
  ///
  /// In en, this message translates to:
  /// **'Waking up the server, this can take up to a minute.'**
  String get bannerWakingUp;

  /// No description provided for @bannerBackOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online. Syncing...'**
  String get bannerBackOnline;

  /// No description provided for @syncWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting to sync {count}'**
  String syncWaiting(int count);

  /// No description provided for @syncSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get syncSaved;

  /// No description provided for @syncSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get syncSaving;

  /// No description provided for @syncWaitingShort.
  ///
  /// In en, this message translates to:
  /// **'Waiting to sync'**
  String get syncWaitingShort;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @statusTodo.
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get statusTodo;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get roleGuest;

  /// No description provided for @workspacePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get workspacePersonal;

  /// No description provided for @workspaceTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get workspaceTeam;

  /// No description provided for @workspaceMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String workspaceMembers(int count);

  /// No description provided for @workspaceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace name'**
  String get workspaceNameLabel;

  /// No description provided for @workspaceNameHint.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get workspaceNameHint;

  /// No description provided for @workspaceSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch workspace'**
  String get workspaceSwitchTitle;

  /// No description provided for @workspaceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create workspace'**
  String get workspaceCreateTitle;

  /// No description provided for @workspaceCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your new space a friendly name.'**
  String get workspaceCreateSubtitle;

  /// No description provided for @workspaceCreateTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: you can invite teammates right after creating it.'**
  String get workspaceCreateTip;

  /// No description provided for @workspaceJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get workspaceJoinTitle;

  /// No description provided for @workspaceJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask your teammate for the 8-character invite code.'**
  String get workspaceJoinSubtitle;

  /// No description provided for @workspaceJoinedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined {name}!'**
  String workspaceJoinedSuccess(String name);

  /// No description provided for @workspaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Workspace Settings'**
  String get workspaceSettings;

  /// No description provided for @workspaceSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} · Manage people and access'**
  String workspaceSettingsSubtitle(String name);

  /// No description provided for @tabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get tabMembers;

  /// No description provided for @tabInviteCodes.
  ///
  /// In en, this message translates to:
  /// **'Invite codes'**
  String get tabInviteCodes;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @pageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get pageLoading;

  /// No description provided for @errorCode.
  ///
  /// In en, this message translates to:
  /// **'Error code: {code}'**
  String errorCode(String code);

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID: {id}'**
  String requestId(String id);

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get confirmDeleteBody;

  /// No description provided for @confirmDeleteTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete selected tasks?'**
  String get confirmDeleteTasksTitle;

  /// No description provided for @confirmRemoveMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get confirmRemoveMemberTitle;

  /// No description provided for @confirmRemoveMemberBody.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from this workspace?'**
  String confirmRemoveMemberBody(String name);

  /// No description provided for @confirmDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard change?'**
  String get confirmDiscardTitle;

  /// No description provided for @confirmDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'This change will be permanently removed.'**
  String get confirmDiscardBody;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @createOrJoinTeam.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team workspace'**
  String get createOrJoinTeam;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitleMobile.
  ///
  /// In en, this message translates to:
  /// **'Log in to keep the day on track.'**
  String get loginSubtitleMobile;

  /// No description provided for @loginSubtitleDesktop.
  ///
  /// In en, this message translates to:
  /// **'Log in to pick up where you left off.'**
  String get loginSubtitleDesktop;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get loginNewHere;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @loginCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm days, done tasks.'**
  String get loginCalm;

  /// No description provided for @loginCalmDesc.
  ///
  /// In en, this message translates to:
  /// **'PlanPal keeps tasks, calendar and chat in one friendly place.'**
  String get loginCalmDesc;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signupTitle;

  /// No description provided for @signupTeamworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Teamwork, minus the chaos.'**
  String get signupTeamworkTitle;

  /// No description provided for @signupTeamworkDesc.
  ///
  /// In en, this message translates to:
  /// **'Tasks, calendar, chat, docs and insights — designed to feel calm.'**
  String get signupTeamworkDesc;

  /// No description provided for @signupHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get signupHaveAccount;

  /// No description provided for @signupTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get signupTermsPrefix;

  /// No description provided for @signupTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get signupTerms;

  /// No description provided for @signupTermsAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get signupTermsAnd;

  /// No description provided for @signupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get signupPrivacy;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @fieldFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Maya Chen'**
  String get fieldFullNameHint;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get fieldEmailHint;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••••'**
  String get fieldPasswordHint;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// No description provided for @fieldConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get fieldConfirmNewPassword;

  /// No description provided for @fieldTaskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get fieldTaskName;

  /// No description provided for @fieldTaskNameHint.
  ///
  /// In en, this message translates to:
  /// **'Plan team offsite'**
  String get fieldTaskNameHint;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @fieldDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Venue, date, agenda...'**
  String get fieldDescriptionHint;

  /// No description provided for @fieldDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get fieldDueDate;

  /// No description provided for @fieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTime;

  /// No description provided for @fieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get fieldPriority;

  /// No description provided for @fieldAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get fieldAssignee;

  /// No description provided for @fieldAssigneeOptional.
  ///
  /// In en, this message translates to:
  /// **'Assignee (optional)'**
  String get fieldAssigneeOptional;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get fieldLabel;

  /// No description provided for @fieldLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get fieldLabelOptional;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Design review'**
  String get fieldTitleHint;

  /// No description provided for @fieldStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get fieldStarts;

  /// No description provided for @fieldEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get fieldEnds;

  /// No description provided for @fieldAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get fieldAllDay;

  /// No description provided for @fieldReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get fieldReminder;

  /// No description provided for @fieldChannelName.
  ///
  /// In en, this message translates to:
  /// **'Channel name'**
  String get fieldChannelName;

  /// No description provided for @fieldDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Document title'**
  String get fieldDocTitle;

  /// No description provided for @fieldUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get fieldUntitled;

  /// No description provided for @fieldStartWriting.
  ///
  /// In en, this message translates to:
  /// **'Start writing...'**
  String get fieldStartWriting;

  /// No description provided for @fieldAddDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Add details...'**
  String get fieldAddDetailsHint;

  /// No description provided for @fieldWriteComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get fieldWriteComment;

  /// No description provided for @fieldMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get fieldMessageHint;

  /// No description provided for @fieldSubtaskHint.
  ///
  /// In en, this message translates to:
  /// **'Subtask title'**
  String get fieldSubtaskHint;

  /// No description provided for @fieldMessageChannelHint.
  ///
  /// In en, this message translates to:
  /// **'Message #{channel}...'**
  String fieldMessageChannelHint(String channel);

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordsNoMatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required.'**
  String get validationNameRequired;

  /// No description provided for @validationTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Privacy Policy.'**
  String get validationTermsRequired;

  /// No description provided for @validationTaskNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Task name is required.'**
  String get validationTaskNameRequired;

  /// No description provided for @validationWorkspaceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Workspace name is required.'**
  String get validationWorkspaceNameRequired;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email linked to your account.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of 3'**
  String forgotPasswordStep(int current);

  /// No description provided for @forgotPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get forgotPasswordSendCode;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get forgotPasswordEnterCode;

  /// No description provided for @forgotPasswordCodeSent.
  ///
  /// In en, this message translates to:
  /// **'6-digit code sent to your email.'**
  String get forgotPasswordCodeSent;

  /// No description provided for @forgotPasswordContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get forgotPasswordContinue;

  /// No description provided for @forgotPasswordSetNew.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get forgotPasswordSetNew;

  /// No description provided for @forgotPasswordSaveNew.
  ///
  /// In en, this message translates to:
  /// **'Save New Password'**
  String get forgotPasswordSaveNew;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSentDesktop.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String verifyEmailSentDesktop(String email);

  /// No description provided for @verifyEmailSentMobile.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {email}'**
  String verifyEmailSentMobile(String email);

  /// No description provided for @verifyEmailVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyEmailVerify;

  /// No description provided for @verifyEmailResend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it? Resend code'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResendCooldown.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it? Resend in {seconds}s'**
  String verifyEmailResendCooldown(int seconds);

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to start?'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can always switch or create more later.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'My Personal workspace'**
  String get onboardingPersonalTitle;

  /// No description provided for @onboardingPersonalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Private tasks and notes.'**
  String get onboardingPersonalSubtitle;

  /// No description provided for @onboardingPersonalTitleDesktop.
  ///
  /// In en, this message translates to:
  /// **'Continue with my Personal workspace'**
  String get onboardingPersonalTitleDesktop;

  /// No description provided for @onboardingPersonalSubtitleDesktop.
  ///
  /// In en, this message translates to:
  /// **'A calm private space for your own tasks and notes.'**
  String get onboardingPersonalSubtitleDesktop;

  /// No description provided for @onboardingTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Create or join a team'**
  String get onboardingTeamTitle;

  /// No description provided for @onboardingTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share work with others.'**
  String get onboardingTeamSubtitle;

  /// No description provided for @onboardingTeamSubtitleDesktop.
  ///
  /// In en, this message translates to:
  /// **'Invite teammates, share tasks and chat together.'**
  String get onboardingTeamSubtitleDesktop;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksDueToday.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task · 1 due today} other{{count} tasks · {dueToday} due today}}'**
  String tasksDueToday(int count, int dueToday);

  /// No description provided for @tasksSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task selected} other{{count} tasks selected}}'**
  String tasksSelected(int count);

  /// No description provided for @tasksNoResultsFilters.
  ///
  /// In en, this message translates to:
  /// **'No results for these filters'**
  String get tasksNoResultsFilters;

  /// No description provided for @tasksClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get tasksClearFilters;

  /// No description provided for @tasksAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'+ Add Subtask'**
  String get tasksAddSubtask;

  /// No description provided for @tasksAddSubtaskHint.
  ///
  /// In en, this message translates to:
  /// **'+ Add subtask...'**
  String get tasksAddSubtaskHint;

  /// No description provided for @tasksSubtasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtasks {done}/{total}'**
  String tasksSubtasksLabel(int done, int total);

  /// No description provided for @tasksSubtasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get tasksSubtasksTitle;

  /// No description provided for @tasksDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Task details'**
  String get tasksDetailTitle;

  /// No description provided for @tasksNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get tasksNewTitle;

  /// No description provided for @tasksDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tasksDescriptionLabel;

  /// No description provided for @tasksNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description.'**
  String get tasksNoDescription;

  /// No description provided for @tasksComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get tasksComments;

  /// No description provided for @tasksAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get tasksAttachments;

  /// No description provided for @tasksAssigneeLabel.
  ///
  /// In en, this message translates to:
  /// **'Assignee & Label'**
  String get tasksAssigneeLabel;

  /// No description provided for @tasksUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksUnassigned;

  /// No description provided for @tasksDoneDate.
  ///
  /// In en, this message translates to:
  /// **'Done {date}'**
  String tasksDoneDate(String date);

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get calendarTodaySchedule;

  /// No description provided for @calendarScheduleFor.
  ///
  /// In en, this message translates to:
  /// **'Schedule · {date}'**
  String calendarScheduleFor(String date);

  /// No description provided for @scheduleEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Event'**
  String get scheduleEventTitle;

  /// No description provided for @reminderNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get reminderNone;

  /// No description provided for @reminderFiveMin.
  ///
  /// In en, this message translates to:
  /// **'5 minutes before'**
  String get reminderFiveMin;

  /// No description provided for @reminderFifteenMin.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get reminderFifteenMin;

  /// No description provided for @reminderThirtyMin.
  ///
  /// In en, this message translates to:
  /// **'30 minutes before'**
  String get reminderThirtyMin;

  /// No description provided for @reminderOneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get reminderOneHour;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get documentsRecent;

  /// No description provided for @documentsRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Documents'**
  String get documentsRecentTitle;

  /// No description provided for @documentEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get documentEditorSave;

  /// No description provided for @documentEditorStartWriting.
  ///
  /// In en, this message translates to:
  /// **'Start writing...'**
  String get documentEditorStartWriting;

  /// No description provided for @documentNewFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get documentNewFolderTitle;

  /// No description provided for @documentNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Document'**
  String get documentNewTitle;

  /// No description provided for @documentUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get documentUploadFile;

  /// No description provided for @documentNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get documentNewFolder;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatTitle;

  /// No description provided for @chatNewChannel.
  ///
  /// In en, this message translates to:
  /// **'New Channel'**
  String get chatNewChannel;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsAll;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnread;

  /// No description provided for @notificationsTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get notificationsTasks;

  /// No description provided for @notificationsMentions.
  ///
  /// In en, this message translates to:
  /// **'Mentions'**
  String get notificationsMentions;

  /// No description provided for @notificationsMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notificationsMarkRead;

  /// No description provided for @notificationsMarkUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get notificationsMarkUnread;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get analyticsExportCSV;

  /// No description provided for @analyticsLastSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get analyticsLastSevenDays;

  /// No description provided for @analyticsLastThirtyDays.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get analyticsLastThirtyDays;

  /// No description provided for @analyticsLastNinetyDays.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get analyticsLastNinetyDays;

  /// No description provided for @analyticsTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed'**
  String get analyticsTasksCompleted;

  /// No description provided for @analyticsAvgTime.
  ///
  /// In en, this message translates to:
  /// **'Avg. Completion Time'**
  String get analyticsAvgTime;

  /// No description provided for @analyticsVelocity.
  ///
  /// In en, this message translates to:
  /// **'Team Velocity'**
  String get analyticsVelocity;

  /// No description provided for @analyticsStreak.
  ///
  /// In en, this message translates to:
  /// **'Productive Streak'**
  String get analyticsStreak;

  /// No description provided for @analyticsWeeklyOutput.
  ///
  /// In en, this message translates to:
  /// **'Weekly Task Output'**
  String get analyticsWeeklyOutput;

  /// No description provided for @analyticsCategoryMix.
  ///
  /// In en, this message translates to:
  /// **'Category Mix'**
  String get analyticsCategoryMix;

  /// No description provided for @homeYourTasksToday.
  ///
  /// In en, this message translates to:
  /// **'Your Tasks Today'**
  String get homeYourTasksToday;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get homeOverview;

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeUpcoming;

  /// No description provided for @homeStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get homeStats;

  /// No description provided for @homeDocs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get homeDocs;

  /// No description provided for @homeSevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get homeSevenDays;

  /// No description provided for @homeThirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get homeThirtyDays;

  /// No description provided for @homeTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed'**
  String get homeTasksCompleted;

  /// No description provided for @homeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeCompleted;

  /// No description provided for @homeInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get homeInProgress;

  /// No description provided for @homeOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeOverdue;

  /// No description provided for @homeProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get homeProductivity;

  /// No description provided for @teamDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Directory'**
  String get teamDirectoryTitle;

  /// No description provided for @teamLatestUpdates.
  ///
  /// In en, this message translates to:
  /// **'Latest Updates'**
  String get teamLatestUpdates;

  /// No description provided for @teamNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get teamNoActivity;

  /// No description provided for @teamPresenceOnline.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get teamPresenceOnline;

  /// No description provided for @teamPresenceAway.
  ///
  /// In en, this message translates to:
  /// **'Away'**
  String get teamPresenceAway;

  /// No description provided for @teamPresenceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get teamPresenceOffline;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get settingsWorkspace;

  /// No description provided for @settingsSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get settingsSyncStatus;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAvatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated!'**
  String get settingsAvatarUpdated;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and all data.'**
  String get settingsDeleteAccountDesc;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{section} settings coming soon.'**
  String settingsComingSoon(String section);

  /// No description provided for @syncStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatusTitle;

  /// No description provided for @syncConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get syncConnection;

  /// No description provided for @syncOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get syncOnline;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncOffline;

  /// No description provided for @syncServerWaking.
  ///
  /// In en, this message translates to:
  /// **'Server waking up...'**
  String get syncServerWaking;

  /// No description provided for @syncServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Server unreachable'**
  String get syncServerUnreachable;

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {time}'**
  String syncLastSynced(String time);

  /// No description provided for @syncPendingChanges.
  ///
  /// In en, this message translates to:
  /// **'Pending changes'**
  String get syncPendingChanges;

  /// No description provided for @syncNoPending.
  ///
  /// In en, this message translates to:
  /// **'No pending changes.'**
  String get syncNoPending;

  /// No description provided for @syncFailedChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed changes'**
  String get syncFailedChanges;

  /// No description provided for @syncNoFailed.
  ///
  /// In en, this message translates to:
  /// **'No failed changes.'**
  String get syncNoFailed;

  /// No description provided for @syncRetryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry all'**
  String get syncRetryAll;

  /// No description provided for @syncCouldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Could not be saved. You may no longer have access.'**
  String get syncCouldNotSave;

  /// No description provided for @syncJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get syncJustNow;

  /// No description provided for @avatarCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop your photo'**
  String get avatarCropTitle;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make today productive.'**
  String get letsGetStarted;
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
    'that was used.',
  );
}
