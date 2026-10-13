// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get navHome => 'Home';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navChat => 'Chat';

  @override
  String get navDocuments => 'Documents';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navTeam => 'Team';

  @override
  String get navSettings => 'Settings';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchPlaceholder => 'Search tasks, docs, people...';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get btnSave => 'Save';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnCreate => 'Create';

  @override
  String get btnConfirm => 'Confirm';

  @override
  String get btnRetry => 'Try again';

  @override
  String get btnViewAll => 'View All';

  @override
  String get btnDetails => 'Details';

  @override
  String get btnCopy => 'Copy';

  @override
  String get btnCopied => 'Copied';

  @override
  String get btnAddTask => '+ Add Task';

  @override
  String get btnCreateTask => 'Create Task';

  @override
  String get btnUpload => 'Upload File';

  @override
  String get emptyStateNoTasks => 'No tasks yet';

  @override
  String get emptyStateNoTasksDesc => 'Create your first task to get started.';

  @override
  String get emptyStateNoEvents => 'No events this week';

  @override
  String get emptyStateNoMessages => 'No messages yet';

  @override
  String get emptyStateNoDocuments => 'No documents yet';

  @override
  String get emptyStateNoNotifications => 'You\'re all caught up';

  @override
  String get emptyStateNoResults => 'No results found';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorServer => 'Server error. Please try again in a moment.';

  @override
  String get errorPermission => 'You don\'t have permission to do this.';

  @override
  String get errorNotFound => 'This item no longer exists.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get bannerOffline =>
      'You\'re offline. Your changes are saved on this device and will sync when you\'re back online.';

  @override
  String get bannerServerUnreachable =>
      'Can\'t reach the server. Check your connection.';

  @override
  String get bannerWakingUp =>
      'Waking up the server, this can take up to a minute.';

  @override
  String get bannerBackOnline => 'Back online. Syncing...';

  @override
  String syncWaiting(int count) {
    return 'Waiting to sync $count';
  }

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get statusTodo => 'Todo';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get roleGuest => 'Guest';

  @override
  String get workspacePersonal => 'Personal';

  @override
  String get workspaceTeam => 'Team';

  @override
  String workspaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get overdue => 'Overdue';

  @override
  String get all => 'All';

  @override
  String get pageLoading => 'Loading...';

  @override
  String errorCode(String code) {
    return 'Error code: $code';
  }

  @override
  String requestId(String id) {
    return 'Request ID: $id';
  }

  @override
  String get confirmDeleteTitle => 'Delete this item?';

  @override
  String get confirmDeleteBody => 'This action cannot be undone.';

  @override
  String get logIn => 'Log In';

  @override
  String get logOut => 'Log Out';

  @override
  String get signUp => 'Create Account';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get letsGetStarted => 'Let\'s make today productive.';
}
