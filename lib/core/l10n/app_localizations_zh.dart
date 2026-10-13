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
  String get navHome => '首页';

  @override
  String get navTasks => '任务';

  @override
  String get navCalendar => '日历';

  @override
  String get navChat => '聊天';

  @override
  String get navDocuments => '文档';

  @override
  String get navAnalytics => '分析';

  @override
  String get navTeam => '团队';

  @override
  String get navSettings => '设置';

  @override
  String get navProfile => '个人资料';

  @override
  String get searchPlaceholder => '搜索任务、文档、人员...';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get btnSave => '保存';

  @override
  String get btnCancel => '取消';

  @override
  String get btnDelete => '删除';

  @override
  String get btnCreate => '创建';

  @override
  String get btnConfirm => '确认';

  @override
  String get btnRetry => '重试';

  @override
  String get btnViewAll => '查看全部';

  @override
  String get btnDetails => '详情';

  @override
  String get btnCopy => '复制';

  @override
  String get btnCopied => '已复制';

  @override
  String get btnAddTask => '+ 添加任务';

  @override
  String get btnCreateTask => '创建任务';

  @override
  String get btnUpload => '上传文件';

  @override
  String get emptyStateNoTasks => '暂无任务';

  @override
  String get emptyStateNoTasksDesc => '创建您的第一个任务以开始。';

  @override
  String get emptyStateNoEvents => '本周没有事件';

  @override
  String get emptyStateNoMessages => '暂无消息';

  @override
  String get emptyStateNoDocuments => '暂无文档';

  @override
  String get emptyStateNoNotifications => '您已全部处理完毕';

  @override
  String get emptyStateNoResults => '未找到结果';

  @override
  String get errorGeneric => '出了些问题，请重试。';

  @override
  String get errorNetwork => '无网络连接，请检查您的网络。';

  @override
  String get errorServer => '服务器错误，请稍后重试。';

  @override
  String get errorPermission => '您没有执行此操作的权限。';

  @override
  String get errorNotFound => '此项目已不存在。';

  @override
  String get errorSessionExpired => '您的会话已过期，请重新登录。';

  @override
  String get bannerOffline => '您已离线。您的更改已保存在设备上，联网后将自动同步。';

  @override
  String get bannerServerUnreachable => '无法连接到服务器。';

  @override
  String get bannerWakingUp => '正在启动服务器，最多需要一分钟。';

  @override
  String get bannerBackOnline => '已重新连接，正在同步...';

  @override
  String syncWaiting(int count) {
    return '等待同步 $count';
  }

  @override
  String get priorityHigh => '高';

  @override
  String get priorityMedium => '中';

  @override
  String get priorityLow => '低';

  @override
  String get statusTodo => '待办';

  @override
  String get statusInProgress => '进行中';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusOverdue => '已逾期';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleMember => '成员';

  @override
  String get roleGuest => '访客';

  @override
  String get workspacePersonal => '个人';

  @override
  String get workspaceTeam => '团队';

  @override
  String workspaceMembers(int count) {
    return '$count位成员';
  }

  @override
  String get today => '今天';

  @override
  String get thisWeek => '本周';

  @override
  String get overdue => '逾期';

  @override
  String get all => '全部';

  @override
  String get pageLoading => '加载中...';

  @override
  String errorCode(String code) {
    return '错误代码：$code';
  }

  @override
  String requestId(String id) {
    return '请求ID：$id';
  }

  @override
  String get confirmDeleteTitle => '删除此项目？';

  @override
  String get confirmDeleteBody => '此操作无法撤销。';

  @override
  String get logIn => '登录';

  @override
  String get logOut => '退出登录';

  @override
  String get signUp => '创建账户';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get letsGetStarted => '让今天充满效率。';
}
