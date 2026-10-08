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
  String get signup => '회원가입';

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
  String get create => '생성';

  @override
  String get search => '검색';

  @override
  String get filter => '필터';

  @override
  String get sort => '정렬';

  @override
  String get loading => '로딩 중...';

  @override
  String get retry => '재시도';

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
  String get noData => '데이터 없음';

  @override
  String get noResults => '결과 없음';

  @override
  String get notificationTitleTaskAssigned => '작업 할당됨';

  @override
  String get notificationTitleTaskCompleted => '작업 완료됨';

  @override
  String get notificationTitleTaskOverdue => '작업 기한 초과';

  @override
  String get notificationTitleTaskDueSoon => '작업 마감 임박';

  @override
  String get notificationTitleTaskCommented => '새 댓글';

  @override
  String get notificationTitleTaskStatusChanged => '작업 상태 변경됨';

  @override
  String get notificationTitleProjectInvite => '프로젝트 초대';

  @override
  String get notificationTitleProjectUpdated => '프로젝트 업데이트됨';

  @override
  String get notificationTitleProjectDeadline => '프로젝트 마감일';

  @override
  String get notificationTitleEventReminder => '이벤트 알림';

  @override
  String get notificationTitleEventStartingSoon => '이벤트 곧 시작';

  @override
  String get notificationTitleEventUpdated => '이벤트 업데이트됨';

  @override
  String get notificationTitleEventCancelled => '이벤트 취소됨';

  @override
  String get notificationTitleChatMessage => '새 메시지';

  @override
  String get notificationTitleChatMention => '멘션됨';

  @override
  String get notificationTitleWorkspaceInvite => '워크스페이스 초대';

  @override
  String get notificationTitleWorkspaceRoleChanged => '역할 변경됨';

  @override
  String get notificationTitleSystem => '시스템 알림';

  @override
  String get notificationTitleDefault => '알림';

  @override
  String notificationBodyTaskAssigned(String actor, String task) {
    return '$actor님이 \"$task\"에 회원님을 할당했습니다';
  }

  @override
  String get notificationBodyTaskAssignedGeneric => '새 작업이 할당되었습니다';

  @override
  String notificationBodyTaskCompleted(String actor, String task) {
    return '$actor님이 \"$task\"를 완료했습니다';
  }

  @override
  String get notificationBodyTaskCompletedGeneric => '작업이 완료되었습니다';

  @override
  String notificationBodyTaskOverdue(String task) {
    return '\"$task\"의 기한이 지났습니다';
  }

  @override
  String get notificationBodyTaskOverdueGeneric => '기한이 지난 작업이 있습니다';

  @override
  String notificationBodyTaskDueSoon(String task, String time) {
    return '\"$task\"의 마감이 $time입니다';
  }

  @override
  String get notificationBodyTaskDueSoonGeneric => '곧 마감되는 작업이 있습니다';

  @override
  String notificationBodyTaskCommented(String actor, String task) {
    return '$actor님이 \"$task\"에 댓글을 달았습니다';
  }

  @override
  String get notificationBodyTaskCommentedGeneric => '작업에 새 댓글이 있습니다';

  @override
  String notificationBodyTaskStatusChanged(String task, String status) {
    return '\"$task\"의 상태가 $status(으)로 변경되었습니다';
  }

  @override
  String get notificationBodyTaskStatusChangedGeneric => '작업 상태가 변경되었습니다';

  @override
  String notificationBodyProjectInvite(String actor, String project) {
    return '$actor님이 \"$project\"에 회원님을 초대했습니다';
  }

  @override
  String get notificationBodyProjectInviteGeneric => '프로젝트에 초대되었습니다';

  @override
  String notificationBodyProjectUpdated(String project) {
    return '\"$project\"가 업데이트되었습니다';
  }

  @override
  String get notificationBodyProjectUpdatedGeneric => '프로젝트가 업데이트되었습니다';

  @override
  String notificationBodyProjectDeadline(String project, String time) {
    return '\"$project\"의 마감일은 $time입니다';
  }

  @override
  String get notificationBodyProjectDeadlineGeneric => '프로젝트 마감일이 다가옵니다';

  @override
  String notificationBodyEventReminder(String event, String time) {
    return '알림: \"$event\"가 $time에 시작됩니다';
  }

  @override
  String get notificationBodyEventReminderGeneric => '다가오는 이벤트가 있습니다';

  @override
  String notificationBodyEventStartingSoon(String event, String time) {
    return '\"$event\"가 $time에 시작됩니다';
  }

  @override
  String get notificationBodyEventStartingSoonGeneric => '이벤트가 곧 시작됩니다';

  @override
  String notificationBodyEventUpdated(String event) {
    return '\"$event\"가 업데이트되었습니다';
  }

  @override
  String get notificationBodyEventUpdatedGeneric => '이벤트가 업데이트되었습니다';

  @override
  String notificationBodyEventCancelled(String event) {
    return '\"$event\"가 취소되었습니다';
  }

  @override
  String get notificationBodyEventCancelledGeneric => '이벤트가 취소되었습니다';

  @override
  String notificationBodyChatMessage(String actor) {
    return '$actor님이 메시지를 보냈습니다';
  }

  @override
  String get notificationBodyChatMessageGeneric => '새 메시지가 있습니다';

  @override
  String notificationBodyChatMention(String actor) {
    return '$actor님이 채팅에서 회원님을 멘션했습니다';
  }

  @override
  String get notificationBodyChatMentionGeneric => '채팅에서 멘션되었습니다';

  @override
  String notificationBodyWorkspaceInvite(String actor, String workspace) {
    return '$actor님이 \"$workspace\"에 회원님을 초대했습니다';
  }

  @override
  String get notificationBodyWorkspaceInviteGeneric => '워크스페이스에 초대되었습니다';

  @override
  String notificationBodyWorkspaceRoleChanged(String workspace, String role) {
    return '\"$workspace\"에서의 역할이 $role(으)로 변경되었습니다';
  }

  @override
  String get notificationBodyWorkspaceRoleChangedGeneric =>
      '워크스페이스 역할이 변경되었습니다';

  @override
  String get notificationBodySystemGeneric => '시스템 알림';

  @override
  String get notificationBodyDefault => '새 알림이 있습니다';

  @override
  String timeRemainingDays(int days) {
    return '$days일 후';
  }

  @override
  String timeRemainingHours(int hours) {
    return '$hours시간 후';
  }

  @override
  String timeRemainingMinutes(int minutes) {
    return '$minutes분 후';
  }

  @override
  String timeOverdueDays(int days) {
    return '$days일 초과';
  }

  @override
  String timeOverdueHours(int hours) {
    return '$hours시간 초과';
  }

  @override
  String timeOverdueMinutes(int minutes) {
    return '$minutes분 초과';
  }

  @override
  String get errorNoNetwork => '네트워크 연결이 감지되지 않습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get errorNoInternet => '인터넷에 연결되어 있지 않습니다. 온라인 상태가 되면 변경 사항이 동기화됩니다.';

  @override
  String get errorServerUnreachable =>
      '서버에 연결할 수 없습니다. 나중에 다시 시도하거나 지원팀에 문의하세요.';

  @override
  String get errorTimeout => '요청 시간이 초과되었습니다. 인터넷 연결을 확인하고 다시 시도하세요.';

  @override
  String get errorAuthRequired => '이 작업을 수행하려면 로그인이 필요합니다.';

  @override
  String get errorAuthExpired => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get errorInvalidCredentials => '이메일 또는 비밀번호가 잘못되었습니다.';

  @override
  String get errorEmailNotConfirmed =>
      '이메일이 아직 확인되지 않았습니다. 받은편지함을 확인하고 확인 링크를 클릭하세요.';

  @override
  String get errorUserAlreadyExists => '이 이메일의 사용자가 이미 존재합니다.';

  @override
  String get errorEmailAlreadyInUse => '이 이메일 주소는 이미 사용 중입니다.';

  @override
  String get errorWeakPassword => '비밀번호가 너무 약합니다. 더 강력한 비밀번호를 사용하세요.';

  @override
  String get errorAuthCancelled => '인증이 취소되었습니다.';

  @override
  String get errorNotAMember => '이 워크스페이스의 멤버가 아닙니다.';

  @override
  String get errorForbidden => '이 작업을 수행할 권한이 없습니다.';

  @override
  String get errorLastAdmin => '워크스페이스에는 최소 한 명의 관리자가 있어야 합니다.';

  @override
  String get errorInvalidCode => '유효하지 않거나 만료된 초대 코드입니다.';

  @override
  String get errorCodeExpired => '이 초대 코드는 만료되었습니다.';

  @override
  String get errorCodeRevoked => '이 초대 코드는 취소되었습니다.';

  @override
  String get errorCodeUsedUp => '이 초대 코드는 최대 사용 횟수에 도달했습니다.';

  @override
  String get errorAlreadyMember => '이미 이 워크스페이스의 멤버입니다.';

  @override
  String get errorFileTooLarge => '파일이 너무 큽니다. 최대 크기: nullMB.';

  @override
  String get errorFileTypeNotAllowed => '이 파일 형식은 허용되지 않습니다. 허용되는 형식: null.';

  @override
  String get errorNotFound => '요청한 리소스를 찾을 수 없습니다.';

  @override
  String errorNotFoundWithResource(String resource) {
    return '$resource을(를) 찾을 수 없습니다.';
  }

  @override
  String get errorTaskNotFound => '작업을 찾을 수 없습니다. 삭제되었거나 액세스 권한이 없을 수 있습니다.';

  @override
  String get errorWorkspaceNotFound =>
      '워크스페이스를 찾을 수 없습니다. 삭제되었거나 액세스 권한이 없을 수 있습니다.';

  @override
  String get errorValidationFailed => '입력이 유효하지 않습니다. 데이터를 확인하고 다시 시도하세요.';

  @override
  String get errorSyncConflict =>
      '다른 기기에서 변경된 사항과 충돌합니다. 페이지를 새로 고치고 다시 시도하세요.';

  @override
  String get errorWorkspaceNameTaken => '이 이름의 워크스페이스가 이미 존재합니다.';

  @override
  String get errorChatNotAvailableInPersonal => '채팅은 개인 워크스페이스에서 사용할 수 없습니다.';

  @override
  String get chatNotAvailable => '채팅 사용 불가';

  @override
  String get errorChannelNotFound => '채널을 찾을 수 없습니다. 삭제되었거나 액세스 권한이 없을 수 있습니다.';

  @override
  String get errorMessageNotFound => '메시지를 찾을 수 없습니다. 삭제되었을 수 있습니다.';

  @override
  String get errorUnknown => '예기치 않은 오류가 발생했습니다. 다시 시도하세요.';

  @override
  String get errorServerError => '서버 오류가 발생했습니다. 나중에 다시 시도하세요.';

  @override
  String get errorTitleNetwork => 'Connection Error';

  @override
  String get errorTitleServer => 'Server Error';

  @override
  String get errorTitleTimeout => '시간 초과';

  @override
  String get errorTitleAuth => '인증 필요';

  @override
  String get errorTitlePermission => 'Permission Denied';

  @override
  String get errorTitleInviteCode => 'Invalid Invite Code';

  @override
  String get errorTitleFile => 'File Error';

  @override
  String get errorTitleNotFound => '찾을 수 없음';

  @override
  String get errorTitleValidation => '유효하지 않은 입력';

  @override
  String get errorTitleSync => 'Sync Error';

  @override
  String get errorTitleChat => 'Chat Error';

  @override
  String get errorDetails => '오류 세부정보';

  @override
  String get technicalDetails => '기술 세부정보';

  @override
  String get copyToClipboard => '클립보드에 복사';

  @override
  String get copiedToClipboard => '오류 세부정보가 클립보드에 복사되었습니다';

  @override
  String get validationEmailRequired => '이메일은 필수 항목입니다';

  @override
  String get validationEmailInvalid => '유효한 이메일 주소를 입력하세요';

  @override
  String get validationPasswordRequired => '비밀번호는 필수 항목입니다';

  @override
  String validationPasswordMinLength(int minLength) {
    return '비밀번호는 최소 $minLength자 이상이어야 합니다';
  }

  @override
  String get validationPasswordMatch => '비밀번호가 일치해야 합니다';

  @override
  String get validationNameRequired => '이름은 필수 항목입니다';

  @override
  String get validationTermsRequired => '서비스 약관 및 개인정보 보호정책에 동의해야 합니다';

  @override
  String get authWelcomeBack => '환영합니다';

  @override
  String get authSignInToContinue => 'PlanPal을 계속 사용하려면 로그인하세요';

  @override
  String get authCreateAccount => '계정 만들기';

  @override
  String get authSignUpToGetStarted => 'PlanPal을 시작하려면 가입하세요';

  @override
  String get authFullName => '전체 이름';

  @override
  String get authEnterYourName => '전체 이름을 입력하세요';

  @override
  String get authEnterYourEmail => '이메일을 입력하세요';

  @override
  String get authEnterYourPassword => '비밀번호를 입력하세요';

  @override
  String get authConfirmYourPassword => '비밀번호를 확인하세요';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return '$terms 및 $privacy에 동의합니다';
  }

  @override
  String get authTermsOfService => '서비스 약관';

  @override
  String get authPrivacyPolicy => '개인정보 보호정책';

  @override
  String get authContinueWithGoogle => 'Google로 계속하기';

  @override
  String get authVerifyEmail => '이메일 확인';

  @override
  String authVerifyEmailDesc(String email) {
    return '$email로 전송된 6자리 코드를 입력하세요';
  }

  @override
  String get authResendCode => '코드 재전송';

  @override
  String authResendCodeIn(int seconds) {
    return '$seconds초 후 코드 재전송';
  }

  @override
  String get authVerifyButton => '확인';

  @override
  String get authResetPassword => '비밀번호 재설정';

  @override
  String get authResetPasswordDesc => '재설정 코드를 받으려면 이메일을 입력하세요';

  @override
  String get authSendResetCode => '재설정 코드 보내기';

  @override
  String get authEnterResetCode => '재설정 코드 입력';

  @override
  String get authEnterResetCodeDesc => '이메일로 전송된 6자리 코드를 입력하세요';

  @override
  String get authEnterNewPassword => '새 비밀번호 입력';

  @override
  String get authEnterNewPasswordDesc => '계정의 새 비밀번호를 선택하세요';

  @override
  String get authNewPassword => '새 비밀번호';

  @override
  String get authResetPasswordSuccess => '비밀번호가 성공적으로 재설정되었습니다';

  @override
  String get authSigningIn => '로그인 중...';

  @override
  String get authSigningUp => '계정 생성 중...';

  @override
  String get authVerifying => '확인 중...';

  @override
  String get authResetting => '비밀번호 재설정 중...';

  @override
  String get authLoginSuccess => '로그인 성공';

  @override
  String get authSignupSuccess => '계정이 생성되었습니다';

  @override
  String get authVerificationSuccess => '이메일이 확인되었습니다';

  @override
  String get authPasswordResetSuccess => '비밀번호가 재설정되었습니다';

  @override
  String get authCodeSent => '인증 코드가 이메일로 전송되었습니다';

  @override
  String get sessionExpired => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get sessionExpiredTitle => '세션 만료';

  @override
  String get sessionRestoring => '세션 복원 중...';

  @override
  String get sessionCheckingAuth => '인증 확인 중...';

  @override
  String get workspaceCreateTitle => '워크스페이스 생성';

  @override
  String get workspaceCreateDescription => '팀을 위한 새 워크스페이스 만들기';

  @override
  String get workspaceCreateButton => '워크스페이스 생성';

  @override
  String get workspaceName => '워크스페이스 이름';

  @override
  String get workspaceNameHint => '예: 제품 팀';

  @override
  String get workspaceDescription => '설명';

  @override
  String get workspaceDescriptionHint => '이 워크스페이스의 용도는 무엇입니까?';

  @override
  String get workspaceCreateSuccess => '워크스페이스가 생성되었습니다';

  @override
  String get workspaceCreateError => '워크스페이스 생성 실패';

  @override
  String get workspaceJoinTitle => '워크스페이스 참여';

  @override
  String get workspaceJoinDescription => '초대 코드를 입력하여 워크스페이스에 참여하세요';

  @override
  String get workspaceJoinButton => '워크스페이스 참여';

  @override
  String get workspaceInviteCode => '초대 코드';

  @override
  String get workspaceCodeHelper => '팀 멤버에게서 이 코드를 받으세요';

  @override
  String get workspaceCodeLength => '코드는 6자여야 합니다';

  @override
  String get workspaceCodeFormat => '코드는 문자와 숫자만 포함해야 합니다';

  @override
  String get workspaceCodeInvalid => '유효하지 않은 초대 코드';

  @override
  String get workspaceCodeExpired => '이 초대 코드가 만료되었습니다';

  @override
  String get workspaceAlreadyMember => '이미 이 워크스페이스의 멤버입니다';

  @override
  String get workspaceJoinSuccess => '워크스페이스에 참여했습니다';

  @override
  String get workspaceJoinError => '워크스페이스 참여 실패';

  @override
  String get workspaceCreateNew => '새 워크스페이스 생성';

  @override
  String get workspaceMembers => '멤버';

  @override
  String get noMembersYet => '아직 멤버가 없습니다';

  @override
  String get memberRoleChanged => '멤버 역할이 변경되었습니다';

  @override
  String get memberRoleChangeError => '멤버 역할 변경 실패';

  @override
  String get memberRemoveConfirmTitle => '멤버 제거';

  @override
  String memberRemoveConfirmMessage(String name) {
    return '이 워크스페이스에서 $name을(를) 제거하시겠습니까?';
  }

  @override
  String get memberRemoved => '멤버가 제거되었습니다';

  @override
  String get memberRemoveError => '멤버 제거 실패';

  @override
  String get workspaceLeaveConfirmTitle => '워크스페이스 나가기';

  @override
  String get workspaceLeaveConfirmMessage => '이 워크스페이스를 나가시겠습니까?';

  @override
  String get workspaceLeft => '워크스페이스를 나갔습니다';

  @override
  String get workspaceLeaveError => '워크스페이스 나가기 실패';

  @override
  String get workspaceLeave => '워크스페이스 나가기';

  @override
  String get changeRole => '역할 변경';

  @override
  String get removeMember => '멤버 제거';

  @override
  String get roleAdmin => '관리자';

  @override
  String get roleAdminDescription => '워크스페이스 및 멤버 관리 가능';

  @override
  String get roleMember => '멤버';

  @override
  String get roleMemberDescription => '콘텐츠 보기 및 생성 가능';

  @override
  String get you => '본인';

  @override
  String get errorLoadingMembers => '멤버 로드 실패';

  @override
  String get inviteCodes => '초대 코드';

  @override
  String get noInviteCodesYet => '아직 초대 코드가 없습니다';

  @override
  String get createInviteCode => '초대 코드 생성';

  @override
  String get inviteCodeCreated => '초대 코드가 생성되었습니다';

  @override
  String get inviteCodeCreateError => '초대 코드 생성 실패';

  @override
  String get inviteCodeRevokeConfirmTitle => '초대 코드 취소';

  @override
  String get inviteCodeRevokeConfirmMessage =>
      '이 초대 코드를 취소하시겠습니까? 더 이상 작동하지 않습니다.';

  @override
  String get inviteCodeRevoked => '초대 코드가 취소되었습니다';

  @override
  String get inviteCodeRevokeError => '초대 코드 취소 실패';

  @override
  String get inviteCodeCopied => '초대 코드가 클립보드에 복사되었습니다';

  @override
  String get copyCode => '코드 복사';

  @override
  String get revokeCode => '코드 취소';

  @override
  String get statusActive => '활성';

  @override
  String get statusRevoked => '취소됨';

  @override
  String get statusExpired => '만료됨';

  @override
  String get statusMaxedOut => '최대 사용 횟수 도달';

  @override
  String get uses => '사용 횟수';

  @override
  String get expires => '만료';

  @override
  String get inviteCodeMaxUses => '최대 사용 횟수';

  @override
  String get inviteCodeExpiry => '만료 기간';

  @override
  String get unlimited => '무제한';

  @override
  String get never => '없음';

  @override
  String daysCount(int count) {
    return '$count일';
  }

  @override
  String get errorLoadingInviteCodes => '초대 코드 로드 실패';

  @override
  String get workspaceSettings => '워크스페이스 설정';

  @override
  String get workspaceUpdated => '워크스페이스가 업데이트되었습니다';

  @override
  String get workspaceUpdateError => '워크스페이스 업데이트 실패';

  @override
  String get workspaceNameTooShort => '이름은 최소 3자 이상이어야 합니다';

  @override
  String get workspaceNameTooLong => '이름은 50자 미만이어야 합니다';

  @override
  String get workspaceType => '유형';

  @override
  String get workspaceTypePersonal => '개인';

  @override
  String get workspaceTypeTeam => '팀';

  @override
  String get createdAt => '생성됨';

  @override
  String get adminOnlySettings => '관리자만 설정을 편집할 수 있습니다';

  @override
  String get dangerZone => '위험 구역';

  @override
  String get deleteWorkspace => '워크스페이스 삭제';

  @override
  String get workspaceDeleteConfirmTitle => '워크스페이스를 삭제하시겠습니까?';

  @override
  String get workspaceDeleteConfirmMessage =>
      '이 워크스페이스를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get workspaceDeleteWarning =>
      '이 워크스페이스의 모든 작업, 프로젝트 및 데이터가 영구적으로 삭제됩니다.';

  @override
  String get workspaceDeleted => '워크스페이스가 삭제되었습니다';

  @override
  String get workspaceDeleteError => '워크스페이스 삭제 실패';

  @override
  String get workspaceNotFound => '워크스페이스를 찾을 수 없습니다';

  @override
  String get errorLoadingWorkspace => '워크스페이스 로드 실패';

  @override
  String get syncStatus => '동기화 상태';

  @override
  String get lastSync => '마지막 동기화';

  @override
  String get pendingChanges => '대기 중';

  @override
  String get failedChanges => '실패';

  @override
  String get failedItems => '실패한 항목';

  @override
  String get retryAll => '모두 재시도';

  @override
  String get discardAll => '모두 삭제';

  @override
  String get discardChange => '변경사항을 삭제하시겠습니까?';

  @override
  String get discardAllChanges => '모든 변경사항을 삭제하시겠습니까?';

  @override
  String get discardAllWarning =>
      '이렇게 하면 실패한 모든 변경사항이 영구적으로 삭제됩니다. 이 작업은 취소할 수 없습니다.';

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
