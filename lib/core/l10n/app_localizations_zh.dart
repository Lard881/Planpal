// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'PlanPal';

  @override
  String get welcome => '欢迎';

  @override
  String get login => '登录';

  @override
  String get signup => '注册';

  @override
  String get email => '电子邮件';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get createAccount => '创建账户';

  @override
  String get orContinueWith => '或继续使用';

  @override
  String get google => 'Google';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get dontHaveAccount => '没有账户？';

  @override
  String get home => '首页';

  @override
  String get tasks => '任务';

  @override
  String get calendar => '日历';

  @override
  String get chat => '聊天';

  @override
  String get documents => '文档';

  @override
  String get analytics => '分析';

  @override
  String get team => '团队';

  @override
  String get settings => '设置';

  @override
  String get profile => '个人资料';

  @override
  String get notifications => '通知';

  @override
  String get logout => '登出';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get create => '创建';

  @override
  String get search => '搜索';

  @override
  String get filter => '筛选';

  @override
  String get sort => '排序';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get offline => '离线';

  @override
  String get online => '在线';

  @override
  String get syncing => '同步中...';

  @override
  String get noData => '无可用数据';

  @override
  String get noResults => '未找到结果';

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
