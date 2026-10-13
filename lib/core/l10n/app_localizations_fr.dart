// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get navHome => 'Accueil';

  @override
  String get navTasks => 'Tâches';

  @override
  String get navCalendar => 'Calendrier';

  @override
  String get navChat => 'Chat';

  @override
  String get navDocuments => 'Documents';

  @override
  String get navAnalytics => 'Analytique';

  @override
  String get navTeam => 'Équipe';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navProfile => 'Profil';

  @override
  String get searchPlaceholder => 'Rechercher tâches, docs, personnes...';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get searchChats => 'Search chats...';

  @override
  String get searchFiles => 'Search files...';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String get btnSave => 'Enregistrer';

  @override
  String get btnCancel => 'Annuler';

  @override
  String get btnDelete => 'Supprimer';

  @override
  String get btnCreate => 'Créer';

  @override
  String get btnConfirm => 'Confirmer';

  @override
  String get btnRetry => 'Réessayer';

  @override
  String get btnViewAll => 'Voir tout';

  @override
  String get btnViewAllTasks => 'View All Tasks';

  @override
  String get btnDetails => 'Détails';

  @override
  String get btnCopy => 'Copier';

  @override
  String get btnCopied => 'Copié';

  @override
  String get btnAddTask => '+ Ajouter une tâche';

  @override
  String get btnCreateTask => 'Créer une tâche';

  @override
  String get btnUpload => 'Téléverser un fichier';

  @override
  String get btnNewDocument => '+ New Document';

  @override
  String get btnScheduleEvent => '+ Schedule Event';

  @override
  String get btnSaveEvent => 'Save Event';

  @override
  String get btnSaveSettings => 'Save Settings';

  @override
  String get btnSignOut => 'Sign out';

  @override
  String get btnDeleteAccount => 'Delete account';

  @override
  String get btnMarkAllRead => 'Mark all as read';

  @override
  String get btnMarkComplete => 'Mark Complete';

  @override
  String get btnDeleteSelected => 'Delete Selected';

  @override
  String get btnInviteWithCode => 'Invite with code';

  @override
  String get btnNewCode => '+ New code';

  @override
  String get btnJoin => 'Join';

  @override
  String get btnCreateWorkspace => '+ Create workspace';

  @override
  String get btnJoinWithCode => 'Join with code';

  @override
  String get btnUploadNew => 'Upload New';

  @override
  String get btnRemove => 'Remove';

  @override
  String get btnRevoke => 'Revoke';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnOpen => 'Open';

  @override
  String get btnDiscard => 'Discard';

  @override
  String get btnSkipForNow => 'Skip for now';

  @override
  String get btnContinueWith => 'Continue ->';

  @override
  String get btnGetStarted => 'Get started ->';

  @override
  String get btnCreateCode => 'Create code';

  @override
  String get emptyStateNoTasks => 'Aucune tâche';

  @override
  String get emptyStateNoTasksDesc =>
      'Créez votre première tâche pour commencer.';

  @override
  String get emptyStateNoTasksToday => 'Nothing due today.';

  @override
  String get emptyStateNoEvents => 'Aucun événement cette semaine';

  @override
  String get emptyStateNoEventsDay => 'No events this day.';

  @override
  String get emptyStateNoMessages => 'Aucun message pour l\'instant';

  @override
  String get emptyStateNoDocuments => 'Aucun document pour l\'instant';

  @override
  String get emptyStateNoNotifications => 'Vous êtes à jour';

  @override
  String get emptyStateNoResults => 'Aucun résultat';

  @override
  String emptyStateNoResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get emptyStateNoInviteCodes => 'No invite codes';

  @override
  String get emptyStateNoInviteCodesDesc => 'Create one to invite teammates.';

  @override
  String get emptyStateNoMembers => 'No members found';

  @override
  String get emptyStateNoAnalytics => 'No analytics yet';

  @override
  String get emptyStateNoAnalyticsDesc =>
      'Complete some tasks to see your statistics.';

  @override
  String get emptyStateNoChannels => 'No channels yet';

  @override
  String get emptyStateNoChannelsDesc => 'Create a channel to get started.';

  @override
  String get emptyStateSelectChannel => 'Select a channel';

  @override
  String get emptyStateSelectChannelDesc =>
      'Choose a channel to start messaging.';

  @override
  String get emptyStateChatTeamOnly => 'Chat is for teams';

  @override
  String get emptyStateChatTeamOnlyDesc =>
      'Chat is only available in team workspaces.';

  @override
  String get emptyStateTeamOnly => 'Team is for team workspaces';

  @override
  String get emptyStateTeamOnlyDesc =>
      'Create or join a team workspace to see members.';

  @override
  String get emptyStateTaskNotFound => 'Task not found';

  @override
  String get emptyStateDocNotFound => 'Document not found';

  @override
  String get emptyStateNothingUpcoming => 'Nothing coming up.';

  @override
  String get errorGeneric =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get errorServer =>
      'Erreur serveur. Veuillez réessayer dans un moment.';

  @override
  String get errorPermission => 'Vous n\'avez pas la permission de faire cela.';

  @override
  String get errorNotFound => 'Cet élément n\'existe plus.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get bannerOffline =>
      'Vous êtes hors ligne. Vos modifications sont sauvegardées et se synchroniseront dès votre retour.';

  @override
  String get bannerServerUnreachable => 'Impossible d\'atteindre le serveur.';

  @override
  String get bannerWakingUp =>
      'Démarrage du serveur, cela peut prendre jusqu\'à une minute.';

  @override
  String get bannerBackOnline => 'De retour en ligne. Synchronisation...';

  @override
  String syncWaiting(int count) {
    return 'En attente de synchronisation $count';
  }

  @override
  String get syncSaved => 'Saved';

  @override
  String get syncSaving => 'Saving...';

  @override
  String get syncWaitingShort => 'Waiting to sync';

  @override
  String get priorityHigh => 'Haute';

  @override
  String get priorityMedium => 'Moyenne';

  @override
  String get priorityLow => 'Faible';

  @override
  String get statusTodo => 'À faire';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Membre';

  @override
  String get roleGuest => 'Invité';

  @override
  String get workspacePersonal => 'Personnel';

  @override
  String get workspaceTeam => 'Équipe';

  @override
  String workspaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get workspaceNameLabel => 'Workspace name';

  @override
  String get workspaceNameHint => 'Acme Studio';

  @override
  String get workspaceSwitchTitle => 'Switch workspace';

  @override
  String get workspaceCreateTitle => 'Create workspace';

  @override
  String get workspaceCreateSubtitle => 'Give your new space a friendly name.';

  @override
  String get workspaceCreateTip =>
      'Tip: you can invite teammates right after creating it.';

  @override
  String get workspaceJoinTitle => 'Join with code';

  @override
  String get workspaceJoinSubtitle =>
      'Ask your teammate for the 8-character invite code.';

  @override
  String workspaceJoinedSuccess(String name) {
    return 'Joined $name!';
  }

  @override
  String get workspaceSettings => 'Workspace Settings';

  @override
  String workspaceSettingsSubtitle(String name) {
    return '$name · Manage people and access';
  }

  @override
  String get tabMembers => 'Members';

  @override
  String get tabInviteCodes => 'Invite codes';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get overdue => 'En retard';

  @override
  String get all => 'Tout';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get pageLoading => 'Chargement...';

  @override
  String errorCode(String code) {
    return 'Code d\'erreur: $code';
  }

  @override
  String requestId(String id) {
    return 'ID de requête: $id';
  }

  @override
  String get confirmDeleteTitle => 'Supprimer cet élément?';

  @override
  String get confirmDeleteBody => 'Cette action ne peut pas être annulée.';

  @override
  String get confirmDeleteTasksTitle => 'Delete selected tasks?';

  @override
  String get confirmRemoveMemberTitle => 'Remove member?';

  @override
  String confirmRemoveMemberBody(String name) {
    return 'Remove $name from this workspace?';
  }

  @override
  String get confirmDiscardTitle => 'Discard change?';

  @override
  String get confirmDiscardBody => 'This change will be permanently removed.';

  @override
  String get logIn => 'Se connecter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get createOrJoinTeam => 'Create or join a team workspace';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitleMobile => 'Log in to keep the day on track.';

  @override
  String get loginSubtitleDesktop => 'Log in to pick up where you left off.';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginNewHere => 'New here?';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get loginCalm => 'Calm days, done tasks.';

  @override
  String get loginCalmDesc =>
      'PlanPal keeps tasks, calendar and chat in one friendly place.';

  @override
  String get signupTitle => 'Create your account';

  @override
  String get signupTeamworkTitle => 'Teamwork, minus the chaos.';

  @override
  String get signupTeamworkDesc =>
      'Tasks, calendar, chat, docs and insights — designed to feel calm.';

  @override
  String get signupHaveAccount => 'Have an account?';

  @override
  String get signupTermsPrefix => 'I agree to the';

  @override
  String get signupTerms => 'Terms';

  @override
  String get signupTermsAnd => 'and';

  @override
  String get signupPrivacy => 'Privacy Policy';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldFullNameHint => 'Maya Chen';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailHint => 'maya.chen@planpal.io';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPasswordHint => '••••••••••';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get fieldConfirmNewPassword => 'Confirm new password';

  @override
  String get fieldTaskName => 'Task Name';

  @override
  String get fieldTaskNameHint => 'Plan team offsite';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldDescriptionHint => 'Venue, date, agenda...';

  @override
  String get fieldDueDate => 'Due Date';

  @override
  String get fieldTime => 'Time';

  @override
  String get fieldPriority => 'Priority';

  @override
  String get fieldAssignee => 'Assignee';

  @override
  String get fieldAssigneeOptional => 'Assignee (optional)';

  @override
  String get fieldLabel => 'Label';

  @override
  String get fieldLabelOptional => 'Label (optional)';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTitleHint => 'Design review';

  @override
  String get fieldStarts => 'Starts';

  @override
  String get fieldEnds => 'Ends';

  @override
  String get fieldAllDay => 'All day';

  @override
  String get fieldReminder => 'Reminder';

  @override
  String get fieldChannelName => 'Channel name';

  @override
  String get fieldDocTitle => 'Document title';

  @override
  String get fieldUntitled => 'Untitled';

  @override
  String get fieldStartWriting => 'Start writing...';

  @override
  String get fieldAddDetailsHint => 'Add details...';

  @override
  String get fieldWriteComment => 'Write a comment...';

  @override
  String get fieldMessageHint => 'Message...';

  @override
  String get fieldSubtaskHint => 'Subtask title';

  @override
  String fieldMessageChannelHint(String channel) {
    return 'Message #$channel...';
  }

  @override
  String get validationEmailRequired => 'Email is required.';

  @override
  String get validationEmailInvalid => 'Enter a valid email.';

  @override
  String get validationPasswordRequired => 'Password is required.';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get validationPasswordsNoMatch => 'Passwords do not match.';

  @override
  String get validationNameRequired => 'Full name is required.';

  @override
  String get validationTermsRequired =>
      'Please agree to the Terms and Privacy Policy.';

  @override
  String get validationTaskNameRequired => 'Task name is required.';

  @override
  String get validationWorkspaceNameRequired => 'Workspace name is required.';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter the email linked to your account.';

  @override
  String forgotPasswordStep(int current) {
    return 'Step $current of 3';
  }

  @override
  String get forgotPasswordSendCode => 'Send Code';

  @override
  String get forgotPasswordBackToLogin => 'Back to log in';

  @override
  String get forgotPasswordEnterCode => 'Enter code';

  @override
  String get forgotPasswordCodeSent => '6-digit code sent to your email.';

  @override
  String get forgotPasswordContinue => 'Continue';

  @override
  String get forgotPasswordSetNew => 'Set new password';

  @override
  String get forgotPasswordSaveNew => 'Save New Password';

  @override
  String get verifyEmailTitle => 'Check your inbox';

  @override
  String verifyEmailSentDesktop(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String verifyEmailSentMobile(String email) {
    return 'Code sent to $email';
  }

  @override
  String get verifyEmailVerify => 'Verify';

  @override
  String get verifyEmailResend => 'Didn\'t get it? Resend code';

  @override
  String verifyEmailResendCooldown(int seconds) {
    return 'Didn\'t get it? Resend in ${seconds}s';
  }

  @override
  String get onboardingTitle => 'Where do you want to start?';

  @override
  String get onboardingSubtitle =>
      'You can always switch or create more later.';

  @override
  String get onboardingPersonalTitle => 'My Personal workspace';

  @override
  String get onboardingPersonalSubtitle => 'Private tasks and notes.';

  @override
  String get onboardingPersonalTitleDesktop =>
      'Continue with my Personal workspace';

  @override
  String get onboardingPersonalSubtitleDesktop =>
      'A calm private space for your own tasks and notes.';

  @override
  String get onboardingTeamTitle => 'Create or join a team';

  @override
  String get onboardingTeamSubtitle => 'Share work with others.';

  @override
  String get onboardingTeamSubtitleDesktop =>
      'Invite teammates, share tasks and chat together.';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String tasksDueToday(int count, int dueToday) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks · $dueToday due today',
      one: '1 task · 1 due today',
    );
    return '$_temp0';
  }

  @override
  String tasksSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks selected',
      one: '1 task selected',
    );
    return '$_temp0';
  }

  @override
  String get tasksNoResultsFilters => 'No results for these filters';

  @override
  String get tasksClearFilters => 'Clear filters';

  @override
  String get tasksAddSubtask => '+ Add Subtask';

  @override
  String get tasksAddSubtaskHint => '+ Add subtask...';

  @override
  String tasksSubtasksLabel(int done, int total) {
    return 'Subtasks $done/$total';
  }

  @override
  String get tasksDetailTitle => 'Task details';

  @override
  String get tasksNewTitle => 'New Task';

  @override
  String get tasksDescriptionLabel => 'Description';

  @override
  String get tasksNoDescription => 'No description.';

  @override
  String get tasksComments => 'Comments';

  @override
  String get tasksAttachments => 'Attachments';

  @override
  String get tasksAssigneeLabel => 'Assignee & Label';

  @override
  String get tasksUnassigned => 'Unassigned';

  @override
  String tasksDoneDate(String date) {
    return 'Done $date';
  }

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarTodaySchedule => 'Today\'s Schedule';

  @override
  String calendarScheduleFor(String date) {
    return 'Schedule · $date';
  }

  @override
  String get scheduleEventTitle => 'Schedule Event';

  @override
  String get reminderNone => 'None';

  @override
  String get reminderFiveMin => '5 minutes before';

  @override
  String get reminderFifteenMin => '15 minutes before';

  @override
  String get reminderThirtyMin => '30 minutes before';

  @override
  String get reminderOneHour => '1 hour before';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsRecent => 'Recent';

  @override
  String get documentsRecentTitle => 'Recent Documents';

  @override
  String get documentEditorSave => 'Save';

  @override
  String get documentEditorStartWriting => 'Start writing...';

  @override
  String get documentNewFolderTitle => 'New Folder';

  @override
  String get documentNewTitle => 'New Document';

  @override
  String get documentUploadFile => 'Upload File';

  @override
  String get documentNewFolder => 'New Folder';

  @override
  String get chatTitle => 'Messages';

  @override
  String get chatNewChannel => 'New Channel';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsAll => 'All';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String get notificationsTasks => 'Tasks';

  @override
  String get notificationsMentions => 'Mentions';

  @override
  String get notificationsMarkRead => 'Mark as read';

  @override
  String get notificationsMarkUnread => 'Mark as unread';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsExportCSV => 'Export CSV';

  @override
  String get analyticsLastSevenDays => 'Last 7 days';

  @override
  String get analyticsLastThirtyDays => 'Last 30 days';

  @override
  String get analyticsLastNinetyDays => 'Last 90 days';

  @override
  String get analyticsTasksCompleted => 'Tasks Completed';

  @override
  String get analyticsAvgTime => 'Avg. Completion Time';

  @override
  String get analyticsVelocity => 'Team Velocity';

  @override
  String get analyticsStreak => 'Productive Streak';

  @override
  String get analyticsWeeklyOutput => 'Weekly Task Output';

  @override
  String get analyticsCategoryMix => 'Category Mix';

  @override
  String get homeYourTasksToday => 'Your Tasks Today';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeOverview => 'Overview';

  @override
  String get homeUpcoming => 'Upcoming';

  @override
  String get homeStats => 'Stats';

  @override
  String get homeDocs => 'Docs';

  @override
  String get homeSevenDays => '7 days';

  @override
  String get homeThirtyDays => '30 days';

  @override
  String get homeTasksCompleted => 'Tasks Completed';

  @override
  String get homeCompleted => 'Completed';

  @override
  String get homeInProgress => 'In Progress';

  @override
  String get homeOverdue => 'Overdue';

  @override
  String get homeProductivity => 'Productivity';

  @override
  String get teamDirectoryTitle => 'Team Directory';

  @override
  String get teamLatestUpdates => 'Latest Updates';

  @override
  String get teamNoActivity => 'No recent activity';

  @override
  String get teamPresenceOnline => 'Active now';

  @override
  String get teamPresenceAway => 'Away';

  @override
  String get teamPresenceOffline => 'Offline';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsWorkspace => 'Workspace';

  @override
  String get settingsSyncStatus => 'Sync status';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAvatarUpdated => 'Avatar updated!';

  @override
  String get settingsDeleteAccountTitle => 'Delete account';

  @override
  String get settingsDeleteAccountDesc =>
      'This permanently deletes your account and all data.';

  @override
  String settingsComingSoon(String section) {
    return '$section settings coming soon.';
  }

  @override
  String get syncStatusTitle => 'Sync status';

  @override
  String get syncConnection => 'Connection';

  @override
  String get syncOnline => 'Online';

  @override
  String get syncOffline => 'Offline';

  @override
  String get syncServerWaking => 'Server waking up...';

  @override
  String get syncServerUnreachable => 'Server unreachable';

  @override
  String syncLastSynced(String time) {
    return 'Last synced: $time';
  }

  @override
  String get syncPendingChanges => 'Pending changes';

  @override
  String get syncNoPending => 'No pending changes.';

  @override
  String get syncFailedChanges => 'Failed changes';

  @override
  String get syncNoFailed => 'No failed changes.';

  @override
  String get syncRetryAll => 'Retry all';

  @override
  String get syncCouldNotSave =>
      'Could not be saved. You may no longer have access.';

  @override
  String get syncJustNow => 'Just now';

  @override
  String get avatarCropTitle => 'Crop your photo';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get letsGetStarted => 'Rendons cette journée productive.';
}
