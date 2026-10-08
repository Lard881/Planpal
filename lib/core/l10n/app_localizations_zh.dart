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
  String get noData => '暂无数据';

  @override
  String get noResults => '未找到结果';

  @override
  String get notificationTitleTaskAssigned => '任务已分配';

  @override
  String get notificationTitleTaskCompleted => '任务已完成';

  @override
  String get notificationTitleTaskOverdue => '任务逾期';

  @override
  String get notificationTitleTaskDueSoon => '任务即将到期';

  @override
  String get notificationTitleTaskCommented => '新评论';

  @override
  String get notificationTitleTaskStatusChanged => '任务状态已更改';

  @override
  String get notificationTitleProjectInvite => '项目邀请';

  @override
  String get notificationTitleProjectUpdated => '项目已更新';

  @override
  String get notificationTitleProjectDeadline => '项目截止日期';

  @override
  String get notificationTitleEventReminder => '事件提醒';

  @override
  String get notificationTitleEventStartingSoon => '事件即将开始';

  @override
  String get notificationTitleEventUpdated => '事件已更新';

  @override
  String get notificationTitleEventCancelled => '事件已取消';

  @override
  String get notificationTitleChatMessage => '新消息';

  @override
  String get notificationTitleChatMention => '有人@了你';

  @override
  String get notificationTitleWorkspaceInvite => '工作空间邀请';

  @override
  String get notificationTitleWorkspaceRoleChanged => '角色已更改';

  @override
  String get notificationTitleSystem => '系统通知';

  @override
  String get notificationTitleDefault => '通知';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor 将您分配到 \"$task\"';
  }

  @override
  String get notificationBodyTaskAssignedGeneric => '您被分配了新任务';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor 完成了 \"$task\"';
  }

  @override
  String get notificationBodyTaskCompletedGeneric => '任务已完成';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\" 已逾期';
  }

  @override
  String get notificationBodyTaskOverdueGeneric => '您有逾期任务';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\" 将在 $time 到期';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric => '您有即将到期的任务';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor 评论了 \"$task\"';
  }

  @override
  String get notificationBodyTaskCommentedGeneric => '任务有新评论';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return '\"$task\" 的状态更改为 $status';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric => '任务状态已更改';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor 邀请您加入 \"$project\"';
  }

  @override
  String get notificationBodyProjectInviteGeneric => '您被邀请加入项目';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\" 已更新';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric => '项目已更新';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return '\"$project\" 的截止日期是 $time';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric => '项目截止日期临近';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return '提醒：\"$event\" 将在 $time 开始';
  }

  @override
  String get notificationBodyEventReminderGeneric => '您有即将到来的事件';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\" 将在 $time 开始';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric => '事件即将开始';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\" 已更新';
  }

  @override
  String get notificationBodyEventUpdatedGeneric => '事件已更新';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\" 已取消';
  }

  @override
  String get notificationBodyEventCancelledGeneric => '事件已取消';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor 给您发送了消息';
  }

  @override
  String get notificationBodyChatMessageGeneric => '您有新消息';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor 在聊天中@了你';
  }

  @override
  String get notificationBodyChatMentionGeneric => '您在聊天中被@';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor 邀请您加入 \"$workspace\"';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric => '您被邀请加入工作空间';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return '您在 \"$workspace\" 中的角色更改为 $role';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric => '您的工作空间角色已更改';

  @override
  String get notificationBodySystemGeneric => '系统通知';

  @override
  String get notificationBodyDefault => '您有新通知';

  @override
  String timeRemainingDays(int days) {
    return '$days 天后';
  }

  @override
  String timeRemainingHours(int hours) {
    return '$hours 小时后';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    return '$minutes 分钟后';
  }

  @override
  String timeOverdueDays(int days) {
    return '逾期 $days 天';
  }

  @override
  String timeOverdueHours(int hours) {
    return '逾期 $hours 小时';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    return '逾期 $minutes 分钟';
  }

  @override
  String get errorNoNetwork => '无网络连接。请检查设备的网络设置。';

  @override
  String get errorNoInternet => '无互联网连接。请检查Wi-Fi或移动数据。';

  @override
  String get errorServerUnreachable => '服务器无法访问。可能正在启动，请稍候。';

  @override
  String get errorTimeout => '请求超时。请重试。';

  @override
  String get errorAuthRequired => '您需要登录才能执行此操作。';

  @override
  String get errorAuthExpired => '您的会话已过期。请重新登录。';

  @override
  String get errorInvalidCredentials => '电子邮件或密码无效。请重试。';

  @override
  String get errorEmailNotConfirmed => '请先确认您的电子邮件地址，然后再登录。';

  @override
  String get errorUserAlreadyExists => '此电子邮件的账户已存在。';

  @override
  String get errorEmailAlreadyInUse => '此电子邮件已被使用。';

  @override
  String get errorWeakPassword => '密码必须至少8个字符。';

  @override
  String get errorAuthCancelled => '登录已取消。';

  @override
  String get errorNotAMember => '您不是此工作空间的成员。';

  @override
  String get errorForbidden => '您没有权限执行此操作。';

  @override
  String get errorLastAdmin => '无法删除最后一个管理员。请先提升另一个成员。';

  @override
  String get errorInvalidCode => '邀请码无效。请检查并重试。';

  @override
  String get errorCodeExpired => '此邀请码已过期。';

  @override
  String get errorCodeRevoked => '此邀请码已被撤销。';

  @override
  String get errorCodeUsedUp => '此邀请码已达到最大使用次数。';

  @override
  String get errorAlreadyMember => '您已经是此工作空间的成员。';

  @override
  String get errorFileTooLarge => '文件太大。最大大小为20 MB。';

  @override
  String get errorFileTypeNotAllowed => '不允许此文件类型。';

  @override
  String get errorNotFound => '未找到项目。';

  @override
  String errorNotFoundWithResource(String resource) {
    return '未找到$resource。';
  }

  @override
  String get errorTaskNotFound => '未找到任务。';

  @override
  String get errorWorkspaceNotFound => '未找到工作空间。';

  @override
  String get errorValidationFailed => '请检查表单并重试。';

  @override
  String get errorSyncConflict => '此项目在其他地方已更改。请刷新并重试。';

  @override
  String get errorWorkspaceNameTaken => '此名称的工作空间已存在。';

  @override
  String get errorChatNotAvailableInPersonal =>
      '个人工作空间中不可用聊天。创建或加入团队工作空间以使用聊天。';

  @override
  String get chatNotAvailable => '聊天不可用';

  @override
  String get errorChannelNotFound => '未找到频道。';

  @override
  String get errorMessageNotFound => '未找到消息。';

  @override
  String get errorUnknown => '出了点问题。请重试。';

  @override
  String get errorServerError => '服务器错误。请稍后重试。';

  @override
  String get errorTitleNetwork => '连接错误';

  @override
  String get errorTitleServer => '服务器错误';

  @override
  String get errorTitleTimeout => '超时';

  @override
  String get errorTitleAuth => '身份验证错误';

  @override
  String get errorTitlePermission => '权限被拒绝';

  @override
  String get errorTitleInviteCode => '邀请码无效';

  @override
  String get errorTitleFile => '文件错误';

  @override
  String get errorTitleNotFound => '未找到';

  @override
  String get errorTitleValidation => '验证错误';

  @override
  String get errorTitleSync => '同步错误';

  @override
  String get errorTitleChat => '聊天错误';

  @override
  String get errorDetails => '错误详情';

  @override
  String get technicalDetails => '技术详情';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get copiedToClipboard => '错误详情已复制到剪贴板';

  @override
  String get validationEmailRequired => '电子邮件是必填项';

  @override
  String get validationEmailInvalid => '请输入有效的电子邮件地址';

  @override
  String get validationPasswordRequired => '密码是必填项';

  @override
  String validationPasswordMinLength(int minLength) {
    return '密码必须至少包含 $minLength 个字符';
  }

  @override
  String get validationPasswordMatch => '密码必须匹配';

  @override
  String get validationNameRequired => '姓名是必填项';

  @override
  String get validationTermsRequired => '您必须同意服务条款和隐私政策';

  @override
  String get authWelcomeBack => '欢迎回来';

  @override
  String get authSignInToContinue => '登录以继续使用 PlanPal';

  @override
  String get authCreateAccount => '创建账户';

  @override
  String get authSignUpToGetStarted => '注册以开始使用 PlanPal';

  @override
  String get authFullName => '全名';

  @override
  String get authEnterYourName => '输入您的全名';

  @override
  String get authEnterYourEmail => '输入您的电子邮件';

  @override
  String get authEnterYourPassword => '输入您的密码';

  @override
  String get authConfirmYourPassword => '确认您的密码';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return '我同意$terms和$privacy';
  }

  @override
  String get authTermsOfService => '服务条款';

  @override
  String get authPrivacyPolicy => '隐私政策';

  @override
  String get authContinueWithGoogle => '使用 Google 继续';

  @override
  String get authVerifyEmail => '验证您的电子邮件';

  @override
  String authVerifyEmailDesc(String email) {
    return '输入发送到 $email 的 6 位数字代码';
  }

  @override
  String get authResendCode => '重新发送代码';

  @override
  String authResendCodeIn(int seconds) {
    return '$seconds秒后重新发送代码';
  }

  @override
  String get authVerifyButton => '验证';

  @override
  String get authResetPassword => '重置密码';

  @override
  String get authResetPasswordDesc => '输入您的电子邮件以接收重置代码';

  @override
  String get authSendResetCode => '发送重置代码';

  @override
  String get authEnterResetCode => '输入重置代码';

  @override
  String get authEnterResetCodeDesc => '输入发送到您电子邮件的 6 位数字代码';

  @override
  String get authEnterNewPassword => '输入新密码';

  @override
  String get authEnterNewPasswordDesc => '为您的账户选择新密码';

  @override
  String get authNewPassword => '新密码';

  @override
  String get authResetPasswordSuccess => '密码重置成功';

  @override
  String get authSigningIn => '正在登录...';

  @override
  String get authSigningUp => '正在创建账户...';

  @override
  String get authVerifying => '正在验证...';

  @override
  String get authResetting => '正在重置密码...';

  @override
  String get authLoginSuccess => '登录成功';

  @override
  String get authSignupSuccess => '账户创建成功';

  @override
  String get authVerificationSuccess => '电子邮件验证成功';

  @override
  String get authPasswordResetSuccess => '密码重置成功';

  @override
  String get authCodeSent => '验证码已发送到您的电子邮件';

  @override
  String get sessionExpired => '您的会话已过期。请重新登录。';

  @override
  String get sessionExpiredTitle => '会话已过期';

  @override
  String get sessionRestoring => '正在恢复您的会话...';

  @override
  String get sessionCheckingAuth => '正在检查身份验证...';

  @override
  String get workspaceCreateTitle => '创建工作空间';

  @override
  String get workspaceCreateDescription => '为您的团队创建一个新的工作空间';

  @override
  String get workspaceCreateButton => '创建工作空间';

  @override
  String get workspaceName => '工作空间名称';

  @override
  String get workspaceNameHint => '例如，产品团队';

  @override
  String get workspaceDescription => '描述';

  @override
  String get workspaceDescriptionHint => '这个工作空间的用途是什么？';

  @override
  String get workspaceCreateSuccess => '工作空间创建成功';

  @override
  String get workspaceCreateError => '创建工作空间失败';

  @override
  String get workspaceJoinTitle => '加入工作空间';

  @override
  String get workspaceJoinDescription => '输入邀请码以加入工作空间';

  @override
  String get workspaceJoinButton => '加入工作空间';

  @override
  String get workspaceInviteCode => '邀请码';

  @override
  String get workspaceCodeHelper => '从团队成员处获取此代码';

  @override
  String get workspaceCodeLength => '代码必须为6个字符';

  @override
  String get workspaceCodeFormat => '代码只能包含字母和数字';

  @override
  String get workspaceCodeInvalid => '邀请码无效';

  @override
  String get workspaceCodeExpired => '此邀请码已过期';

  @override
  String get workspaceAlreadyMember => '您已经是此工作空间的成员';

  @override
  String get workspaceJoinSuccess => '成功加入工作空间';

  @override
  String get workspaceJoinError => '加入工作空间失败';

  @override
  String get workspaceCreateNew => '创建新工作空间';

  @override
  String get workspaceMembers => '成员';

  @override
  String get noMembersYet => '还没有成员';

  @override
  String get memberRoleChanged => '成员角色已更改';

  @override
  String get memberRoleChangeError => '更改成员角色失败';

  @override
  String get memberRemoveConfirmTitle => '移除成员';

  @override
  String memberRemoveConfirmMessage(String name) {
    return '您确定要从此工作空间中移除 $name 吗？';
  }

  @override
  String get memberRemoved => '成员已移除';

  @override
  String get memberRemoveError => '移除成员失败';

  @override
  String get workspaceLeaveConfirmTitle => '离开工作空间';

  @override
  String get workspaceLeaveConfirmMessage => '您确定要离开此工作空间吗？';

  @override
  String get workspaceLeft => '您已离开工作空间';

  @override
  String get workspaceLeaveError => '离开工作空间失败';

  @override
  String get workspaceLeave => '离开工作空间';

  @override
  String get changeRole => '更改角色';

  @override
  String get removeMember => '移除成员';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleAdminDescription => '可以管理工作空间和成员';

  @override
  String get roleMember => '成员';

  @override
  String get roleMemberDescription => '可以查看和创建内容';

  @override
  String get you => '您';

  @override
  String get errorLoadingMembers => '加载成员失败';

  @override
  String get inviteCodes => '邀请码';

  @override
  String get noInviteCodesYet => '还没有邀请码';

  @override
  String get createInviteCode => '创建邀请码';

  @override
  String get inviteCodeCreated => '邀请码创建成功';

  @override
  String get inviteCodeCreateError => '创建邀请码失败';

  @override
  String get inviteCodeRevokeConfirmTitle => '撤销邀请码';

  @override
  String get inviteCodeRevokeConfirmMessage => '您确定要撤销此邀请码吗？它将不再有效。';

  @override
  String get inviteCodeRevoked => '邀请码已撤销';

  @override
  String get inviteCodeRevokeError => '撤销邀请码失败';

  @override
  String get inviteCodeCopied => '邀请码已复制到剪贴板';

  @override
  String get copyCode => '复制代码';

  @override
  String get revokeCode => '撤销代码';

  @override
  String get statusActive => '活跃';

  @override
  String get statusRevoked => '已撤销';

  @override
  String get statusExpired => '已过期';

  @override
  String get statusMaxedOut => '已达到最大使用次数';

  @override
  String get uses => '使用次数';

  @override
  String get expires => '过期时间';

  @override
  String get inviteCodeMaxUses => '最大使用次数';

  @override
  String get inviteCodeExpiry => '过期时间';

  @override
  String get unlimited => '无限制';

  @override
  String get never => '永不';

  @override
  String daysCount(int count) {
    return '$count 天';
  }

  @override
  String get errorLoadingInviteCodes => '加载邀请码失败';

  @override
  String get workspaceSettings => '工作空间设置';

  @override
  String get workspaceUpdated => '工作空间已更新';

  @override
  String get workspaceUpdateError => '更新工作空间失败';

  @override
  String get workspaceNameTooShort => '名称必须至少3个字符';

  @override
  String get workspaceNameTooLong => '名称必须少于50个字符';

  @override
  String get workspaceType => '类型';

  @override
  String get workspaceTypePersonal => '个人';

  @override
  String get workspaceTypeTeam => '团队';

  @override
  String get createdAt => '创建时间';

  @override
  String get adminOnlySettings => '只有管理员可以编辑设置';

  @override
  String get dangerZone => '危险区域';

  @override
  String get deleteWorkspace => '删除工作空间';

  @override
  String get workspaceDeleteConfirmTitle => '删除工作空间？';

  @override
  String get workspaceDeleteConfirmMessage => '您确定要删除此工作空间吗？此操作无法撤消。';

  @override
  String get workspaceDeleteWarning => '此工作空间中的所有任务、项目和数据将被永久删除。';

  @override
  String get workspaceDeleted => '工作空间已删除';

  @override
  String get workspaceDeleteError => '删除工作空间失败';

  @override
  String get workspaceNotFound => '未找到工作空间';

  @override
  String get errorLoadingWorkspace => '加载工作空间失败';

  @override
  String get syncStatus => '同步状态';

  @override
  String get lastSync => '上次同步';

  @override
  String get pendingChanges => '待处理';

  @override
  String get failedChanges => '失败';

  @override
  String get failedItems => '失败的项目';

  @override
  String get retryAll => '全部重试';

  @override
  String get discardAll => '全部丢弃';

  @override
  String get discardChange => '丢弃更改？';

  @override
  String get discardAllChanges => '丢弃所有更改？';

  @override
  String get discardAllWarning => '这将永久丢弃所有失败的更改。此操作无法撤消。';

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
