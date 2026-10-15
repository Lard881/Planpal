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
  String get navHome => '主页';

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
  String get searchChats => '搜索聊天...';

  @override
  String get searchFiles => '搜索文件...';

  @override
  String get searchTasks => '搜索任务...';

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
  String get btnViewAllTasks => '查看所有任务';

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
  String get btnNewDocument => '+ 新建文档';

  @override
  String get btnScheduleEvent => '+ 安排活动';

  @override
  String get btnSaveEvent => '保存活动';

  @override
  String get btnSaveSettings => '保存设置';

  @override
  String get btnSignOut => '退出登录';

  @override
  String get btnDeleteAccount => '删除账户';

  @override
  String get btnMarkAllRead => '全部标为已读';

  @override
  String get btnMarkComplete => '标为完成';

  @override
  String get btnDeleteSelected => '删除所选';

  @override
  String get btnInviteWithCode => '用代码邀请';

  @override
  String get btnNewCode => '+ 新代码';

  @override
  String get btnJoin => '加入';

  @override
  String get btnCreateWorkspace => '+ 创建空间';

  @override
  String get btnJoinWithCode => '用代码加入';

  @override
  String get btnUploadNew => '上传新文件';

  @override
  String get btnRemove => '移除';

  @override
  String get btnRevoke => '撤销';

  @override
  String get btnAdd => '添加';

  @override
  String get btnOpen => '打开';

  @override
  String get btnDiscard => '放弃';

  @override
  String get btnSkipForNow => '暂时跳过';

  @override
  String get btnContinueWith => '继续 ->';

  @override
  String get btnGetStarted => '开始 ->';

  @override
  String get btnCreateCode => '创建代码';

  @override
  String get emptyStateNoTasks => '暂无任务';

  @override
  String get emptyStateNoTasksDesc => '创建您的第一个任务以开始。';

  @override
  String get emptyStateNoTasksToday => '今天没有待办。';

  @override
  String get emptyStateNoEvents => '本周没有活动';

  @override
  String get emptyStateNoEventsDay => '今天没有活动。';

  @override
  String get emptyStateNoMessages => '暂无消息。';

  @override
  String get emptyStateNoDocuments => '暂无文档';

  @override
  String get emptyStateNoNotifications => '您已全部跟进';

  @override
  String get emptyStateNoResults => '未找到结果';

  @override
  String emptyStateNoResultsFor(String query) {
    return '\"$query\"没有结果';
  }

  @override
  String get emptyStateNoInviteCodes => '没有邀请码';

  @override
  String get emptyStateNoInviteCodesDesc => '创建一个以邀请队友。';

  @override
  String get emptyStateNoMembers => '未找到成员';

  @override
  String get emptyStateNoAnalytics => '暂无分析数据';

  @override
  String get emptyStateNoAnalyticsDesc => '完成一些任务即可查看您的统计数据。';

  @override
  String get emptyStateNoChannels => '暂无频道';

  @override
  String get emptyStateNoChannelsDesc => '创建一个频道开始。';

  @override
  String get emptyStateSelectChannel => '选择一个频道';

  @override
  String get emptyStateSelectChannelDesc => '选择一个频道开始聊天。';

  @override
  String get emptyStateChatTeamOnly => '聊天仅限团队';

  @override
  String get emptyStateChatTeamOnlyDesc => '聊天仅在团队空间中可用。';

  @override
  String get emptyStateTeamOnly => '团队功能仅限团队空间';

  @override
  String get emptyStateTeamOnlyDesc => '创建或加入团队空间以查看成员。';

  @override
  String get emptyStateTaskNotFound => '未找到任务';

  @override
  String get emptyStateDocNotFound => '未找到文档';

  @override
  String get emptyStateNothingUpcoming => '没有即将到来的事项。';

  @override
  String get errorGeneric => '出现错误，请重试。';

  @override
  String get errorNetwork => '无网络连接，请检查网络后重试。';

  @override
  String get errorServer => '服务器错误，请稍后重试。';

  @override
  String get errorPermission => '您没有权限执行此操作。';

  @override
  String get errorNotFound => '该条目不再存在。';

  @override
  String get errorSessionExpired => '您的会话已过期，请重新登录。';

  @override
  String get bannerOffline => '您处于离线状态。更改已保存在设备上，联网后将自动同步。';

  @override
  String get bannerServerUnreachable => '无法连接到服务器，请检查连接。';

  @override
  String get bannerWakingUp => '正在唤醒服务器，可能需要最多一分钟。';

  @override
  String get bannerBackOnline => '已重新连接，正在同步...';

  @override
  String syncWaiting(int count) {
    return '等待同步 $count';
  }

  @override
  String get syncSaved => '已保存';

  @override
  String get syncSaving => '保存中...';

  @override
  String get syncWaitingShort => '等待同步';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成员',
      one: '1 位成员',
    );
    return '$_temp0';
  }

  @override
  String get workspaceNameLabel => '空间名称';

  @override
  String get workspaceNameHint => '我的团队';

  @override
  String get workspaceSwitchTitle => '切换空间';

  @override
  String get workspaceCreateTitle => '创建空间';

  @override
  String get workspaceCreateSubtitle => '为您的新空间起个好名字。';

  @override
  String get workspaceCreateTip => '提示：创建后可以立即邀请队友。';

  @override
  String get workspaceJoinTitle => '用代码加入';

  @override
  String get workspaceJoinSubtitle => '向队友索取 8 位邀请码。';

  @override
  String workspaceJoinedSuccess(String name) {
    return '已加入 $name！';
  }

  @override
  String get workspaceSettings => '空间设置';

  @override
  String workspaceSettingsSubtitle(String name) {
    return '$name · 管理人员和访问权限';
  }

  @override
  String get tabMembers => '成员';

  @override
  String get tabInviteCodes => '邀请码';

  @override
  String get today => '今天';

  @override
  String get thisWeek => '本周';

  @override
  String get overdue => '已逾期';

  @override
  String get all => '全部';

  @override
  String get yesterday => '昨天';

  @override
  String get tomorrow => '明天';

  @override
  String get pageLoading => '加载中...';

  @override
  String errorCode(String code) {
    return '错误代码：$code';
  }

  @override
  String requestId(String id) {
    return '请求 ID：$id';
  }

  @override
  String get confirmDeleteTitle => '删除此项目？';

  @override
  String get confirmDeleteBody => '此操作无法撤销。';

  @override
  String get confirmDeleteTasksTitle => '删除所选任务？';

  @override
  String get confirmRemoveMemberTitle => '移除成员？';

  @override
  String confirmRemoveMemberBody(String name) {
    return '将 $name 从此空间移除？';
  }

  @override
  String get confirmDiscardTitle => '放弃更改？';

  @override
  String get confirmDiscardBody => '此更改将被永久删除。';

  @override
  String get logIn => '登录';

  @override
  String get logOut => '退出登录';

  @override
  String get signUp => '创建账户';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String get createOrJoinTeam => '创建或加入团队空间';

  @override
  String get loginTitle => '欢迎回来';

  @override
  String get loginSubtitleMobile => '登录以继续今天的工作。';

  @override
  String get loginSubtitleDesktop => '登录，从上次停下的地方继续。';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginNewHere => '新用户？';

  @override
  String get loginCreateAccount => '创建账户';

  @override
  String get loginCalm => '平静的一天，完成的任务。';

  @override
  String get loginCalmDesc => 'PlanPal 将任务、日历和聊天整合在一个友好的地方。';

  @override
  String get signupTitle => '创建您的账户';

  @override
  String get signupTeamworkTitle => '团队合作，没有混乱。';

  @override
  String get signupTeamworkDesc => '任务、日历、聊天、文档和洞察——专为平静而设计。';

  @override
  String get signupHaveAccount => '已有账户？';

  @override
  String get signupTermsPrefix => '我同意';

  @override
  String get signupTerms => '服务条款';

  @override
  String get signupTermsAnd => '和';

  @override
  String get signupPrivacy => '隐私政策';

  @override
  String get fieldFullName => '全名';

  @override
  String get fieldFullNameHint => '姓名';

  @override
  String get fieldEmail => '电子邮件';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => '密码';

  @override
  String get fieldPasswordHint => '••••••••••';

  @override
  String get fieldConfirmPassword => '确认密码';

  @override
  String get fieldNewPassword => '新密码';

  @override
  String get fieldConfirmNewPassword => '确认新密码';

  @override
  String get fieldTaskName => '任务名称';

  @override
  String get fieldTaskNameHint => '计划团队活动';

  @override
  String get fieldDescription => '描述';

  @override
  String get fieldDescriptionHint => '地点、日期、议程...';

  @override
  String get fieldDueDate => '截止日期';

  @override
  String get fieldTime => '时间';

  @override
  String get fieldPriority => '优先级';

  @override
  String get fieldAssignee => '负责人';

  @override
  String get fieldAssigneeOptional => '负责人（可选）';

  @override
  String get fieldLabel => '标签';

  @override
  String get fieldLabelOptional => '标签（可选）';

  @override
  String get fieldTitle => '标题';

  @override
  String get fieldTitleHint => '设计评审';

  @override
  String get fieldStarts => '开始';

  @override
  String get fieldEnds => '结束';

  @override
  String get fieldAllDay => '全天';

  @override
  String get fieldReminder => '提醒';

  @override
  String get fieldChannelName => '频道名称';

  @override
  String get fieldDocTitle => '文档标题';

  @override
  String get fieldUntitled => '无标题';

  @override
  String get fieldStartWriting => '开始写作...';

  @override
  String get fieldAddDetailsHint => '添加详情...';

  @override
  String get fieldWriteComment => '写评论...';

  @override
  String get fieldMessageHint => '消息...';

  @override
  String get fieldSubtaskHint => '子任务标题';

  @override
  String fieldMessageChannelHint(String channel) {
    return '消息 #$channel...';
  }

  @override
  String get validationEmailRequired => '电子邮件为必填项。';

  @override
  String get validationEmailInvalid => '请输入有效的电子邮件。';

  @override
  String get validationPasswordRequired => '密码为必填项。';

  @override
  String get validationPasswordTooShort => '密码至少需要 8 个字符。';

  @override
  String get validationPasswordsNoMatch => '密码不匹配。';

  @override
  String get validationNameRequired => '全名为必填项。';

  @override
  String get validationTermsRequired => '请同意服务条款和隐私政策。';

  @override
  String get validationTaskNameRequired => '任务名称为必填项。';

  @override
  String get validationWorkspaceNameRequired => '空间名称为必填项。';

  @override
  String get forgotPasswordTitle => '重置密码';

  @override
  String get forgotPasswordSubtitle => '输入与您账户关联的电子邮件。';

  @override
  String forgotPasswordStep(int current) {
    return '第 $current 步，共 3 步';
  }

  @override
  String get forgotPasswordSendCode => '发送验证码';

  @override
  String get forgotPasswordBackToLogin => '返回登录';

  @override
  String get forgotPasswordEnterCode => '输入验证码';

  @override
  String get forgotPasswordCodeSent => '6 位验证码已发送到您的电子邮件。';

  @override
  String get forgotPasswordContinue => '继续';

  @override
  String get forgotPasswordSetNew => '设置新密码';

  @override
  String get forgotPasswordSaveNew => '保存新密码';

  @override
  String get verifyEmailTitle => '查看您的收件箱';

  @override
  String verifyEmailSentDesktop(String email) {
    return '我们已向 $email 发送了 6 位验证码';
  }

  @override
  String verifyEmailSentMobile(String email) {
    return '验证码已发送至 $email';
  }

  @override
  String get verifyEmailVerify => '验证';

  @override
  String get verifyEmailResend => '没收到？重新发送验证码';

  @override
  String verifyEmailResendCooldown(int seconds) {
    return '没收到？$seconds 秒后重新发送';
  }

  @override
  String get onboardingTitle => '您想从哪里开始？';

  @override
  String get onboardingSubtitle => '您随时可以切换或创建更多。';

  @override
  String get onboardingPersonalTitle => '我的个人空间';

  @override
  String get onboardingPersonalSubtitle => '私人任务和笔记。';

  @override
  String get onboardingPersonalTitleDesktop => '继续使用我的个人空间';

  @override
  String get onboardingPersonalSubtitleDesktop => '一个平静私密的空间，用于您自己的任务和笔记。';

  @override
  String get onboardingTeamTitle => '创建或加入团队';

  @override
  String get onboardingTeamSubtitle => '与他人共享工作。';

  @override
  String get onboardingTeamSubtitleDesktop => '邀请队友，共享任务，一起聊天。';

  @override
  String get tasksTitle => '任务';

  @override
  String tasksDueToday(int count, int dueToday) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个任务 · 今天 $dueToday 个到期',
      one: '1 个任务 · 今天 1 个到期',
    );
    return '$_temp0';
  }

  @override
  String tasksSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选择 $count 个任务',
      one: '已选择 1 个任务',
    );
    return '$_temp0';
  }

  @override
  String get tasksNoResultsFilters => '这些筛选条件没有结果';

  @override
  String get tasksClearFilters => '清除筛选';

  @override
  String get tasksAddSubtask => '+ 添加子任务';

  @override
  String get tasksAddSubtaskHint => '+ 添加子任务...';

  @override
  String tasksSubtasksLabel(int done, int total) {
    return '子任务 $done/$total';
  }

  @override
  String get tasksSubtasksTitle => '子任务';

  @override
  String get tasksDetailTitle => '任务详情';

  @override
  String get tasksNewTitle => '新建任务';

  @override
  String get tasksDescriptionLabel => '描述';

  @override
  String get tasksNoDescription => '无描述。';

  @override
  String get tasksComments => '评论';

  @override
  String get tasksAttachments => '附件';

  @override
  String get tasksAssigneeLabel => '负责人与标签';

  @override
  String get tasksUnassigned => '未分配';

  @override
  String tasksDoneDate(String date) {
    return '$date 完成';
  }

  @override
  String get calendarTitle => '日历';

  @override
  String get calendarToday => '今天';

  @override
  String get calendarTodaySchedule => '今日日程';

  @override
  String calendarScheduleFor(String date) {
    return '日程 · $date';
  }

  @override
  String get scheduleEventTitle => '安排活动';

  @override
  String get reminderNone => '无提醒';

  @override
  String get reminderFiveMin => '提前 5 分钟';

  @override
  String get reminderFifteenMin => '提前 15 分钟';

  @override
  String get reminderThirtyMin => '提前 30 分钟';

  @override
  String get reminderOneHour => '提前 1 小时';

  @override
  String get documentsTitle => '文档';

  @override
  String get documentsRecent => '最近';

  @override
  String get documentsRecentTitle => '最近文档';

  @override
  String get documentEditorSave => '保存';

  @override
  String get documentEditorStartWriting => '开始写作...';

  @override
  String get documentNewFolderTitle => '新建文件夹';

  @override
  String get documentNewTitle => '新建文档';

  @override
  String get documentUploadFile => '上传文件';

  @override
  String get documentNewFolder => '新建文件夹';

  @override
  String get chatTitle => '消息';

  @override
  String get chatNewChannel => '新建频道';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsAll => '全部';

  @override
  String get notificationsUnread => '未读';

  @override
  String get notificationsTasks => '任务';

  @override
  String get notificationsMentions => '提及';

  @override
  String get notificationsMarkRead => '标为已读';

  @override
  String get notificationsMarkUnread => '标为未读';

  @override
  String get analyticsTitle => '分析';

  @override
  String get analyticsExportCSV => '导出 CSV';

  @override
  String get analyticsLastSevenDays => '最近 7 天';

  @override
  String get analyticsLastThirtyDays => '最近 30 天';

  @override
  String get analyticsLastNinetyDays => '最近 90 天';

  @override
  String get analyticsTasksCompleted => '已完成任务';

  @override
  String get analyticsAvgTime => '平均完成时间';

  @override
  String get analyticsVelocity => '团队速度';

  @override
  String get analyticsStreak => '生产力连续天数';

  @override
  String get analyticsWeeklyOutput => '每周任务产出';

  @override
  String get analyticsCategoryMix => '类别分布';

  @override
  String get homeYourTasksToday => '今日任务';

  @override
  String get homeQuickActions => '快捷操作';

  @override
  String get homeOverview => '概览';

  @override
  String get homeUpcoming => '即将到来';

  @override
  String get homeStats => '统计';

  @override
  String get homeDocs => '文档';

  @override
  String get homeSevenDays => '7 天';

  @override
  String get homeThirtyDays => '30 天';

  @override
  String get homeTasksCompleted => '已完成任务';

  @override
  String get homeCompleted => '已完成';

  @override
  String get homeInProgress => '进行中';

  @override
  String get homeOverdue => '已逾期';

  @override
  String get homeProductivity => '生产力';

  @override
  String get teamDirectoryTitle => '团队目录';

  @override
  String get teamLatestUpdates => '最新动态';

  @override
  String get teamNoActivity => '暂无最近活动';

  @override
  String get teamPresenceOnline => '在线';

  @override
  String get teamPresenceAway => '离开';

  @override
  String get teamPresenceOffline => '离线';

  @override
  String get settingsProfile => '个人资料';

  @override
  String get settingsAccount => '账户';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsWorkspace => '工作空间';

  @override
  String get settingsSyncStatus => '同步状态';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsAvatarUpdated => '头像已更新！';

  @override
  String get settingsDeleteAccountTitle => '删除账户';

  @override
  String get settingsDeleteAccountDesc => '这将永久删除您的账户和所有数据。';

  @override
  String settingsComingSoon(String section) {
    return '$section 设置即将推出。';
  }

  @override
  String get syncStatusTitle => '同步状态';

  @override
  String get syncConnection => '连接';

  @override
  String get syncOnline => '在线';

  @override
  String get syncOffline => '离线';

  @override
  String get syncServerWaking => '服务器启动中...';

  @override
  String get syncServerUnreachable => '服务器不可达';

  @override
  String syncLastSynced(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncPendingChanges => '待同步更改';

  @override
  String get syncNoPending => '无待同步更改。';

  @override
  String get syncFailedChanges => '失败的更改';

  @override
  String get syncNoFailed => '无失败的更改。';

  @override
  String get syncRetryAll => '全部重试';

  @override
  String get syncCouldNotSave => '无法保存。您可能已失去访问权限。';

  @override
  String get syncJustNow => '刚刚';

  @override
  String get avatarCropTitle => '裁剪头像';

  @override
  String get codeCopied => '代码已复制';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get letsGetStarted => '让今天充满效率。';
}
