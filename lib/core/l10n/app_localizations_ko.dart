// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get welcome => '환영합니다';

  @override
  String get login => '로그인';

  @override
  String get signup => '가입하기';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get orContinueWith => '또는 계속하기';

  @override
  String get google => 'Google';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get dontHaveAccount => '계정이 없으신가요?';

  @override
  String get home => '홈';

  @override
  String get tasks => '작업';

  @override
  String get calendar => '캘린더';

  @override
  String get chat => '채팅';

  @override
  String get documents => '문서';

  @override
  String get analytics => '분석';

  @override
  String get team => '팀';

  @override
  String get settings => '설정';

  @override
  String get profile => '프로필';

  @override
  String get notifications => '알림';

  @override
  String get logout => '로그아웃';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get create => '만들기';

  @override
  String get search => '검색';

  @override
  String get filter => '필터';

  @override
  String get sort => '정렬';

  @override
  String get loading => '로딩 중...';

  @override
  String get retry => '다시 시도';

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get offline => '오프라인';

  @override
  String get online => '온라인';

  @override
  String get syncing => '동기화 중...';

  @override
  String get noData => '사용 가능한 데이터 없음';

  @override
  String get noResults => '결과를 찾을 수 없음';

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
}
