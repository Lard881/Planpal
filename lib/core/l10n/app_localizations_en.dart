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
  String get welcome => 'Welcome';

  @override
  String get login => 'Sign In';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get tasks => 'Tasks';

  @override
  String get calendar => 'Calendar';

  @override
  String get chat => 'Chat';

  @override
  String get documents => 'Documents';

  @override
  String get analytics => 'Analytics';

  @override
  String get team => 'Team';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get logout => 'Sign Out';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get syncing => 'Syncing...';

  @override
  String get noData => 'No data available';

  @override
  String get noResults => 'No results found';

  @override
  String get notificationTitleTaskAssigned => 'Task Assigned';

  @override
  String get notificationTitleTaskCompleted => 'Task Completed';

  @override
  String get notificationTitleTaskOverdue => 'Task Overdue';

  @override
  String get notificationTitleTaskDueSoon => 'Task Due Soon';

  @override
  String get notificationTitleTaskCommented => 'New Comment';

  @override
  String get notificationTitleTaskStatusChanged => 'Task Status Changed';

  @override
  String get notificationTitleProjectInvite => 'Project Invitation';

  @override
  String get notificationTitleProjectUpdated => 'Project Updated';

  @override
  String get notificationTitleProjectDeadline => 'Project Deadline';

  @override
  String get notificationTitleEventReminder => 'Event Reminder';

  @override
  String get notificationTitleEventStartingSoon => 'Event Starting Soon';

  @override
  String get notificationTitleEventUpdated => 'Event Updated';

  @override
  String get notificationTitleEventCancelled => 'Event Cancelled';

  @override
  String get notificationTitleChatMessage => 'New Message';

  @override
  String get notificationTitleChatMention => 'You Were Mentioned';

  @override
  String get notificationTitleWorkspaceInvite => 'Workspace Invitation';

  @override
  String get notificationTitleWorkspaceRoleChanged => 'Role Changed';

  @override
  String get notificationTitleSystem => 'System Notification';

  @override
  String get notificationTitleDefault => 'Notification';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor assigned you to \"$task\"';
  }

  @override
  String get notificationBodyTaskAssignedGeneric =>
      'You have been assigned to a new task';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor completed \"$task\"';
  }

  @override
  String get notificationBodyTaskCompletedGeneric =>
      'A task has been completed';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\" is overdue';
  }

  @override
  String get notificationBodyTaskOverdueGeneric => 'You have overdue tasks';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\" is due $time';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric => 'You have tasks due soon';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor commented on \"$task\"';
  }

  @override
  String get notificationBodyTaskCommentedGeneric => 'New comment on a task';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return '\"$task\" status changed to $status';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric =>
      'Task status has changed';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor invited you to join \"$project\"';
  }

  @override
  String get notificationBodyProjectInviteGeneric =>
      'You have been invited to a project';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\" has been updated';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric =>
      'A project has been updated';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return '\"$project\" deadline is $time';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric =>
      'Project deadline approaching';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return 'Reminder: \"$event\" starts $time';
  }

  @override
  String get notificationBodyEventReminderGeneric =>
      'You have an upcoming event';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\" starts $time';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric =>
      'An event is starting soon';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\" has been updated';
  }

  @override
  String get notificationBodyEventUpdatedGeneric => 'An event has been updated';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\" has been cancelled';
  }

  @override
  String get notificationBodyEventCancelledGeneric =>
      'An event has been cancelled';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor sent you a message';
  }

  @override
  String get notificationBodyChatMessageGeneric => 'You have a new message';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor mentioned you in a chat';
  }

  @override
  String get notificationBodyChatMentionGeneric =>
      'You were mentioned in a chat';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor invited you to join \"$workspace\"';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric =>
      'You have been invited to a workspace';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return 'Your role in \"$workspace\" changed to $role';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric =>
      'Your workspace role has changed';

  @override
  String get notificationBodySystemGeneric => 'System notification';

  @override
  String get notificationBodyDefault => 'You have a new notification';

  @override
  String timeRemainingDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'in $days $_temp0';
  }

  @override
  String timeRemainingHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return 'in $hours $_temp0';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'in $minutes $_temp0';
  }

  @override
  String timeOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$days $_temp0 overdue';
  }

  @override
  String timeOverdueHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$hours $_temp0 overdue';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$minutes $_temp0 overdue';
  }

  @override
  String get errorNoNetwork =>
      'No network connection. Please check your device\'s network settings.';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your Wi-Fi or mobile data.';

  @override
  String get errorServerUnreachable =>
      'Server is unreachable. It may be starting up, please wait a moment.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorAuthRequired => 'You need to be signed in to do this.';

  @override
  String get errorAuthExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorInvalidCredentials =>
      'Invalid email or password. Please try again.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email address before signing in.';

  @override
  String get errorUserAlreadyExists =>
      'An account with this email already exists.';

  @override
  String get errorEmailAlreadyInUse => 'This email is already in use.';

  @override
  String get errorWeakPassword =>
      'Password must be at least 8 characters long.';

  @override
  String get errorAuthCancelled => 'Sign in was cancelled.';

  @override
  String get errorNotAMember => 'You are not a member of this workspace.';

  @override
  String get errorForbidden => 'You don\'t have permission to do this.';

  @override
  String get errorLastAdmin =>
      'Cannot remove the last admin. Promote another member first.';

  @override
  String get errorInvalidCode =>
      'Invalid invite code. Please check and try again.';

  @override
  String get errorCodeExpired => 'This invite code has expired.';

  @override
  String get errorCodeRevoked => 'This invite code has been revoked.';

  @override
  String get errorCodeUsedUp =>
      'This invite code has reached its maximum uses.';

  @override
  String get errorAlreadyMember =>
      'You are already a member of this workspace.';

  @override
  String get errorFileTooLarge => 'File is too large. Maximum size is 20 MB.';

  @override
  String get errorFileTypeNotAllowed => 'This file type is not allowed.';

  @override
  String get errorNotFound => 'Item not found.';

  @override
  String errorNotFoundWithResource(String resource) {
    return '$resource not found.';
  }

  @override
  String get errorTaskNotFound => 'Task not found.';

  @override
  String get errorWorkspaceNotFound => 'Workspace not found.';

  @override
  String get errorValidationFailed => 'Please check the form and try again.';

  @override
  String get errorSyncConflict =>
      'This item was changed elsewhere. Please refresh and try again.';

  @override
  String get errorWorkspaceNameTaken =>
      'A workspace with this name already exists.';

  @override
  String get errorChatNotAvailableInPersonal =>
      'Chat is not available in Personal workspaces. Create or join a team workspace to use chat.';

  @override
  String get chatNotAvailable => 'Chat Not Available';

  @override
  String get errorChannelNotFound => 'Channel not found.';

  @override
  String get errorMessageNotFound => 'Message not found.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorServerError => 'Server error. Please try again later.';

  @override
  String get errorTitleNetwork => 'Connection Error';

  @override
  String get errorTitleServer => 'Server Error';

  @override
  String get errorTitleTimeout => 'Timeout';

  @override
  String get errorTitleAuth => 'Authentication Error';

  @override
  String get errorTitlePermission => 'Permission Denied';

  @override
  String get errorTitleInviteCode => 'Invalid Invite Code';

  @override
  String get errorTitleFile => 'File Error';

  @override
  String get errorTitleNotFound => 'Not Found';

  @override
  String get errorTitleValidation => 'Validation Error';

  @override
  String get errorTitleSync => 'Sync Error';

  @override
  String get errorTitleChat => 'Chat Error';

  @override
  String get errorDetails => 'Error Details';

  @override
  String get technicalDetails => 'Technical Details';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get copiedToClipboard => 'Error details copied to clipboard';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get validationPasswordMatch => 'Passwords must match';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get validationTermsRequired =>
      'You must agree to the Terms of Service and Privacy Policy';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authSignInToContinue => 'Sign in to continue to PlanPal';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignUpToGetStarted => 'Sign up to get started with PlanPal';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authEnterYourName => 'Enter your full name';

  @override
  String get authEnterYourEmail => 'Enter your email';

  @override
  String get authEnterYourPassword => 'Enter your password';

  @override
  String get authConfirmYourPassword => 'Confirm your password';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'I agree to the $terms and $privacy';
  }

  @override
  String get authTermsOfService => 'Terms of Service';

  @override
  String get authPrivacyPolicy => 'Privacy Policy';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authVerifyEmail => 'Verify Your Email';

  @override
  String authVerifyEmailDesc(String email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get authResendCode => 'Resend Code';

  @override
  String authResendCodeIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get authVerifyButton => 'Verify';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authResetPasswordDesc =>
      'Enter your email to receive a reset code';

  @override
  String get authSendResetCode => 'Send Reset Code';

  @override
  String get authEnterResetCode => 'Enter Reset Code';

  @override
  String get authEnterResetCodeDesc =>
      'Enter the 6-digit code sent to your email';

  @override
  String get authEnterNewPassword => 'Enter New Password';

  @override
  String get authEnterNewPasswordDesc =>
      'Choose a new password for your account';

  @override
  String get authNewPassword => 'New Password';

  @override
  String get authResetPasswordSuccess => 'Password reset successfully';

  @override
  String get authSigningIn => 'Signing in...';

  @override
  String get authSigningUp => 'Creating account...';

  @override
  String get authVerifying => 'Verifying...';

  @override
  String get authResetting => 'Resetting password...';

  @override
  String get authLoginSuccess => 'Signed in successfully';

  @override
  String get authSignupSuccess => 'Account created successfully';

  @override
  String get authVerificationSuccess => 'Email verified successfully';

  @override
  String get authPasswordResetSuccess => 'Password reset successfully';

  @override
  String get authCodeSent => 'Verification code sent to your email';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get sessionExpiredTitle => 'Session Expired';

  @override
  String get sessionRestoring => 'Restoring your session...';

  @override
  String get sessionCheckingAuth => 'Checking authentication...';

  @override
  String get workspaceCreateTitle => 'Create Workspace';

  @override
  String get workspaceCreateDescription =>
      'Create a new workspace for your team';

  @override
  String get workspaceCreateButton => 'Create Workspace';

  @override
  String get workspaceName => 'Workspace Name';

  @override
  String get workspaceNameHint => 'e.g., Product Team';

  @override
  String get workspaceDescription => 'Description';

  @override
  String get workspaceDescriptionHint => 'What is this workspace for?';

  @override
  String get workspaceCreateSuccess => 'Workspace created successfully';

  @override
  String get workspaceCreateError => 'Failed to create workspace';

  @override
  String get workspaceJoinTitle => 'Join Workspace';

  @override
  String get workspaceJoinDescription =>
      'Enter the invite code to join a workspace';

  @override
  String get workspaceJoinButton => 'Join Workspace';

  @override
  String get workspaceInviteCode => 'Invite Code';

  @override
  String get workspaceCodeHelper => 'Get this code from a team member';

  @override
  String get workspaceCodeLength => 'Code must be 6 characters';

  @override
  String get workspaceCodeFormat =>
      'Code must contain only letters and numbers';

  @override
  String get workspaceCodeInvalid => 'Invalid invite code';

  @override
  String get workspaceCodeExpired => 'This invite code has expired';

  @override
  String get workspaceAlreadyMember =>
      'You are already a member of this workspace';

  @override
  String get workspaceJoinSuccess => 'Joined workspace successfully';

  @override
  String get workspaceJoinError => 'Failed to join workspace';

  @override
  String get workspaceCreateNew => 'Create New Workspace';

  @override
  String get workspaceMembers => 'Members';

  @override
  String get noMembersYet => 'No members yet';

  @override
  String get memberRoleChanged => 'Member role changed successfully';

  @override
  String get memberRoleChangeError => 'Failed to change member role';

  @override
  String get memberRemoveConfirmTitle => 'Remove Member';

  @override
  String memberRemoveConfirmMessage(String name) {
    return 'Are you sure you want to remove $name from this workspace?';
  }

  @override
  String get memberRemoved => 'Member removed successfully';

  @override
  String get memberRemoveError => 'Failed to remove member';

  @override
  String get workspaceLeaveConfirmTitle => 'Leave Workspace';

  @override
  String get workspaceLeaveConfirmMessage =>
      'Are you sure you want to leave this workspace?';

  @override
  String get workspaceLeft => 'You have left the workspace';

  @override
  String get workspaceLeaveError => 'Failed to leave workspace';

  @override
  String get workspaceLeave => 'Leave Workspace';

  @override
  String get changeRole => 'Change Role';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleAdminDescription => 'Can manage workspace and members';

  @override
  String get roleMember => 'Member';

  @override
  String get roleMemberDescription => 'Can view and create content';

  @override
  String get you => 'You';

  @override
  String get errorLoadingMembers => 'Failed to load members';

  @override
  String get inviteCodes => 'Invite Codes';

  @override
  String get noInviteCodesYet => 'No invite codes yet';

  @override
  String get createInviteCode => 'Create Invite Code';

  @override
  String get inviteCodeCreated => 'Invite code created successfully';

  @override
  String get inviteCodeCreateError => 'Failed to create invite code';

  @override
  String get inviteCodeRevokeConfirmTitle => 'Revoke Invite Code';

  @override
  String get inviteCodeRevokeConfirmMessage =>
      'Are you sure you want to revoke this invite code? It will no longer work.';

  @override
  String get inviteCodeRevoked => 'Invite code revoked successfully';

  @override
  String get inviteCodeRevokeError => 'Failed to revoke invite code';

  @override
  String get inviteCodeCopied => 'Invite code copied to clipboard';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get revokeCode => 'Revoke Code';

  @override
  String get statusActive => 'Active';

  @override
  String get statusRevoked => 'Revoked';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusMaxedOut => 'Max Uses Reached';

  @override
  String get uses => 'Uses';

  @override
  String get expires => 'Expires';

  @override
  String get inviteCodeMaxUses => 'Maximum Uses';

  @override
  String get inviteCodeExpiry => 'Expires In';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get never => 'Never';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get errorLoadingInviteCodes => 'Failed to load invite codes';

  @override
  String get workspaceSettings => 'Workspace Settings';

  @override
  String get workspaceUpdated => 'Workspace updated successfully';

  @override
  String get workspaceUpdateError => 'Failed to update workspace';

  @override
  String get workspaceNameTooShort => 'Name must be at least 3 characters';

  @override
  String get workspaceNameTooLong => 'Name must be less than 50 characters';

  @override
  String get workspaceType => 'Type';

  @override
  String get workspaceTypePersonal => 'Personal';

  @override
  String get workspaceTypeTeam => 'Team';

  @override
  String get createdAt => 'Created';

  @override
  String get adminOnlySettings => 'Only workspace admins can edit settings';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteWorkspace => 'Delete Workspace';

  @override
  String get workspaceDeleteConfirmTitle => 'Delete Workspace?';

  @override
  String get workspaceDeleteConfirmMessage =>
      'Are you sure you want to delete this workspace? This action cannot be undone.';

  @override
  String get workspaceDeleteWarning =>
      'All tasks, projects, and data in this workspace will be permanently deleted.';

  @override
  String get workspaceDeleted => 'Workspace deleted successfully';

  @override
  String get workspaceDeleteError => 'Failed to delete workspace';

  @override
  String get workspaceNotFound => 'Workspace not found';

  @override
  String get errorLoadingWorkspace => 'Failed to load workspace';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get lastSync => 'Last sync';

  @override
  String get pendingChanges => 'Pending';

  @override
  String get failedChanges => 'Failed';

  @override
  String get failedItems => 'Failed Items';

  @override
  String get retryAll => 'Retry All';

  @override
  String get discardAll => 'Discard All';

  @override
  String get discardChange => 'Discard Change?';

  @override
  String get discardAllChanges => 'Discard All Changes?';

  @override
  String get discardAllWarning =>
      'This will permanently discard all failed changes. This cannot be undone.';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get uploads => 'Uploads';

  @override
  String get noUploads => 'No uploads';

  @override
  String get uploading => 'Uploading';

  @override
  String get uploadCompleted => 'Upload completed';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get uploadCancelled => 'Upload cancelled';

  @override
  String uploadStarted(int count) {
    return 'Upload started for $count file(s)';
  }

  @override
  String get clearCompleted => 'Clear Completed';

  @override
  String get clearFailed => 'Clear Failed';

  @override
  String get waiting => 'Waiting';

  @override
  String get recent => 'Recent';

  @override
  String get noRecentDocuments => 'No recent documents';

  @override
  String get noDocuments => 'No documents';

  @override
  String get uploadFileToGetStarted => 'Upload a file to get started';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get folderName => 'Folder Name';

  @override
  String get enterFolderName => 'Enter folder name';

  @override
  String get folderNameRequired => 'Folder name is required';

  @override
  String get folderNameTooLong =>
      'Folder name is too long (max 200 characters)';

  @override
  String get folderCreated => 'Folder created successfully';

  @override
  String get selectFilesToUpload => 'Select files to upload';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String get dragAndDropFiles => 'Drag and drop files here';

  @override
  String get dropFilesHere => 'Drop files here';

  @override
  String get orClickToBrowse => 'or click to browse';

  @override
  String get rename => 'Rename';

  @override
  String get move => 'Move';

  @override
  String get download => 'Download';

  @override
  String get downloadStarted => 'Download started';

  @override
  String get confirmDeleteDocument =>
      'Are you sure you want to delete this document?';

  @override
  String get confirmDeleteFolder =>
      'Are you sure you want to delete this folder? It must be empty.';

  @override
  String get documentDeleted => 'Document deleted successfully';

  @override
  String get folderDeleted => 'Folder deleted successfully';

  @override
  String get documentName => 'Document Name';

  @override
  String get documentNameRequired => 'Document name is required';

  @override
  String get folderRenamed => 'Folder renamed successfully';

  @override
  String get documentRenamed => 'Document renamed successfully';

  @override
  String get moveToFolder => 'Move to Folder';

  @override
  String get rootFolder => 'Root Folder';

  @override
  String get noFoldersAvailable => 'No folders available';

  @override
  String get folderMoved => 'Folder moved successfully';

  @override
  String get documentMoved => 'Document moved successfully';

  @override
  String get nameTooLong => 'Name is too long (max 200 characters)';

  @override
  String get noWorkspaceSelected => 'No workspace selected';

  @override
  String get close => 'Close';

  @override
  String get documentSaved => 'Document saved';

  @override
  String savedAt(String time) {
    return 'Saved $time';
  }

  @override
  String get openWithSystemApp => 'Open with System App';

  @override
  String get errorLoadingFile => 'Error loading file';

  @override
  String get downloading => 'Downloading...';

  @override
  String get errorLoadingImage => 'Error loading image';

  @override
  String get pdfDocument => 'PDF Document';

  @override
  String get fileDocument => 'File';

  @override
  String get attachFile => 'Attach File';

  @override
  String get attachments => 'Attachments';

  @override
  String get noAttachments => 'No attachments';

  @override
  String get attachmentAdded => 'Attachment added';

  @override
  String get attachmentRemoved => 'Attachment removed';

  @override
  String get offlineUploadsDisabled =>
      'File uploads are disabled while offline';

  @override
  String get notificationTaskAssigned => 'Task Assigned';

  @override
  String get notificationTaskUpdated => 'Task Updated';

  @override
  String get notificationTaskComment => 'New Comment';

  @override
  String get notificationDeadlineApproaching => 'Deadline Approaching';

  @override
  String get notificationTaskOverdue => 'Task Overdue';

  @override
  String get notificationMention => 'You were mentioned';

  @override
  String get notificationChatMessage => 'New Message';

  @override
  String get notificationEventReminder => 'Event Reminder';

  @override
  String get notificationWorkspaceInvite => 'Workspace Invite';

  @override
  String get notificationTaskAssignedBody => 'A task has been assigned to you';

  @override
  String get notificationTaskUpdatedBody => 'A task has been updated';

  @override
  String get notificationTaskCommentBody => 'Someone commented on a task';

  @override
  String get notificationDeadlineApproachingBody =>
      'A task deadline is approaching';

  @override
  String get notificationTaskOverdueBody => 'A task is overdue';

  @override
  String get notificationMentionBody => 'Someone mentioned you';

  @override
  String get notificationChatMessageBody => 'You have a new message';

  @override
  String get notificationEventReminderBody => 'You have an upcoming event';
}
