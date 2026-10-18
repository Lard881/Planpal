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
  String get navHome => '홈';

  @override
  String get navTasks => '작업';

  @override
  String get navCalendar => '캘린더';

  @override
  String get navChat => '채팅';

  @override
  String get navDocuments => '문서';

  @override
  String get navAnalytics => '분석';

  @override
  String get navTeam => '팀';

  @override
  String get navSettings => '설정';

  @override
  String get navProfile => '프로필';

  @override
  String get searchPlaceholder => '작업, 문서, 사람 검색...';

  @override
  String get searchOfflineNotice => '오프라인: 이 기기의 검색 결과를 표시합니다.';

  @override
  String get searchCtrlK => 'Ctrl K';

  @override
  String get searchChats => '채팅 검색...';

  @override
  String get searchFiles => '파일 검색...';

  @override
  String get searchTasks => '작업 검색...';

  @override
  String get btnSave => '저장';

  @override
  String get btnCancel => '취소';

  @override
  String get btnDelete => '삭제';

  @override
  String get btnCreate => '만들기';

  @override
  String get btnConfirm => '확인';

  @override
  String get btnRetry => '다시 시도';

  @override
  String get btnViewAll => '전체 보기';

  @override
  String get btnViewAllTasks => '모든 작업 보기';

  @override
  String get btnDetails => '세부 정보';

  @override
  String get btnCopy => '복사';

  @override
  String get btnEdit => '수정';

  @override
  String get btnCopied => '복사됨';

  @override
  String get btnAddTask => '+ 작업 추가';

  @override
  String get btnCreateTask => '작업 만들기';

  @override
  String get btnUpload => '파일 업로드';

  @override
  String get btnNewDocument => '+ 새 문서';

  @override
  String get btnScheduleEvent => '+ 일정 추가';

  @override
  String get btnSaveEvent => '일정 저장';

  @override
  String get btnSaveSettings => '설정 저장';

  @override
  String get btnSignOut => '로그아웃';

  @override
  String get btnDeleteAccount => '계정 삭제';

  @override
  String get btnMarkAllRead => '모두 읽음으로 표시';

  @override
  String get btnMarkComplete => '완료로 표시';

  @override
  String get btnDeleteSelected => '선택 항목 삭제';

  @override
  String get btnInviteWithCode => '코드로 초대';

  @override
  String get btnNewCode => '+ 새 코드';

  @override
  String get btnJoin => '참여';

  @override
  String get btnCreateWorkspace => '+ 공간 만들기';

  @override
  String get btnJoinWithCode => '코드로 참여';

  @override
  String get btnUploadNew => '새로 업로드';

  @override
  String get btnRemove => '제거';

  @override
  String get btnRevoke => '취소';

  @override
  String get btnAdd => '추가';

  @override
  String get btnOpen => '열기';

  @override
  String get btnDownload => '다운로드';

  @override
  String get btnRename => '이름 변경';

  @override
  String get btnDiscard => '취소';

  @override
  String get btnSkipForNow => '지금은 건너뛰기';

  @override
  String get btnContinueWith => '계속 ->';

  @override
  String get btnGetStarted => '시작하기 ->';

  @override
  String get btnCreateCode => '코드 만들기';

  @override
  String get emptyStateNoTasks => '아직 작업이 없습니다';

  @override
  String get emptyStateNoTasksDesc => '첫 번째 작업을 만들어 시작하세요.';

  @override
  String get emptyStateNoTasksToday => '오늘 할 일이 없습니다.';

  @override
  String get emptyStateNoEvents => '이번 주 일정 없음';

  @override
  String get emptyStateNoEventsDay => '이날 일정 없음.';

  @override
  String get emptyStateNoMessages => '아직 메시지가 없습니다.';

  @override
  String get emptyStateNoDocuments => '아직 문서가 없습니다';

  @override
  String get emptyStateNoNotifications => '모두 확인했습니다';

  @override
  String get emptyStateNoResults => '결과를 찾을 수 없습니다';

  @override
  String emptyStateNoResultsFor(String query) {
    return '\"$query\"에 대한 결과 없음';
  }

  @override
  String get emptyStateNoInviteCodes => '초대 코드 없음';

  @override
  String get emptyStateNoInviteCodesDesc => '팀원을 초대하려면 코드를 만드세요.';

  @override
  String get emptyStateNoMembers => '멤버를 찾을 수 없습니다';

  @override
  String get emptyStateNoAnalytics => '아직 분석 데이터 없음';

  @override
  String get emptyStateNoAnalyticsDesc => '작업을 완료하여 통계를 확인하세요.';

  @override
  String get emptyStateNoChannels => '아직 채널 없음';

  @override
  String get emptyStateNoChannelsDesc => '채널을 만들어 시작하세요.';

  @override
  String get emptyStateSelectChannel => '채널 선택';

  @override
  String get emptyStateSelectChannelDesc => '메시지를 시작할 채널을 선택하세요.';

  @override
  String get emptyStateChatTeamOnly => '채팅은 팀 전용입니다';

  @override
  String get emptyStateChatTeamOnlyDesc => '채팅은 팀 공간에서만 사용할 수 있습니다.';

  @override
  String get emptyStateTeamOnly => '팀 기능은 팀 공간 전용입니다';

  @override
  String get emptyStateTeamOnlyDesc => '멤버를 보려면 팀 공간을 만들거나 참여하세요.';

  @override
  String get emptyStateTaskNotFound => '작업을 찾을 수 없습니다';

  @override
  String get emptyStateDocNotFound => '문서를 찾을 수 없습니다';

  @override
  String get emptyStateNothingUpcoming => '예정된 항목이 없습니다.';

  @override
  String get errorGeneric => '오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get errorNetwork => '인터넷 연결이 없습니다. 네트워크를 확인하고 다시 시도하세요.';

  @override
  String get errorServer => '서버 오류입니다. 잠시 후 다시 시도하세요.';

  @override
  String get errorPermission => '이 작업을 수행할 권한이 없습니다.';

  @override
  String get errorNotFound => '이 항목이 더 이상 존재하지 않습니다.';

  @override
  String get errorSessionExpired => '세션이 만료되었습니다. 다시 로그인해 주세요.';

  @override
  String get errorAuthRequired => '계속하려면 로그인하세요.';

  @override
  String get errorInvalidRequest => '정보를 확인한 후 다시 시도하세요.';

  @override
  String get errorConflict => '최신 변경 사항과 충돌합니다. 새로 고친 후 다시 시도하세요.';

  @override
  String get errorRateLimited => '요청이 너무 많습니다. 잠시 후 다시 시도하세요.';

  @override
  String get errorTimeout => '요청 시간이 초과되었습니다. 연결을 확인한 후 다시 시도하세요.';

  @override
  String get errorInvalidInviteCode => '초대 코드가 올바르지 않습니다.';

  @override
  String get errorInviteCodeExpired => '초대 코드가 만료되었습니다.';

  @override
  String get errorInviteCodeRevoked => '초대 코드가 취소되었습니다.';

  @override
  String get errorInviteCodeExhausted => '초대 코드의 사용 한도에 도달했습니다.';

  @override
  String get errorAlreadyMember => '이미 이 워크스페이스의 멤버입니다.';

  @override
  String get errorTransferAdminFirst => '계정을 삭제하기 전에 워크스페이스 소유권을 이전하세요.';

  @override
  String get errorChatPersonalOnly => '채팅은 팀 워크스페이스에서만 사용할 수 있습니다.';

  @override
  String get bannerOffline => '오프라인 상태입니다. 변경 사항이 기기에 저장되었으며 온라인 복구 시 동기화됩니다.';

  @override
  String get bannerServerUnreachable => '서버에 연결할 수 없습니다. 연결을 확인하세요.';

  @override
  String get bannerWakingUp => '서버를 깨우는 중입니다. 최대 1분이 걸릴 수 있습니다.';

  @override
  String get bannerBackOnline => '다시 온라인 상태입니다. 동기화 중...';

  @override
  String syncWaiting(int count) {
    return '동기화 대기 중 $count';
  }

  @override
  String get syncSaved => '저장됨';

  @override
  String get syncSaving => '저장 중...';

  @override
  String get syncWaitingShort => '동기화 대기 중';

  @override
  String get priorityHigh => '높음';

  @override
  String get priorityMedium => '보통';

  @override
  String get priorityLow => '낮음';

  @override
  String get statusTodo => '할 일';

  @override
  String get statusInProgress => '진행 중';

  @override
  String get statusCompleted => '완료';

  @override
  String get statusOverdue => '기한 초과';

  @override
  String get roleAdmin => '관리자';

  @override
  String get roleMember => '멤버';

  @override
  String get roleGuest => '게스트';

  @override
  String get workspacePersonal => '개인';

  @override
  String get workspaceTeam => '팀';

  @override
  String workspaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '멤버 $count명',
      one: '멤버 1명',
    );
    return '$_temp0';
  }

  @override
  String get workspaceNameLabel => '공간 이름';

  @override
  String get workspaceNameHint => '내 팀';

  @override
  String get workspaceSwitchTitle => '공간 전환';

  @override
  String get workspaceCreateTitle => '공간 만들기';

  @override
  String get workspaceCreateSubtitle => '새 공간에 친근한 이름을 지어주세요.';

  @override
  String get workspaceCreateTip => '팁: 만든 직후 팀원을 초대할 수 있습니다.';

  @override
  String get workspaceJoinTitle => '코드로 참여';

  @override
  String get workspaceJoinSubtitle => '팀원에게 8자리 초대 코드를 물어보세요.';

  @override
  String workspaceJoinedSuccess(String name) {
    return '$name에 참여했습니다!';
  }

  @override
  String get workspaceSettings => '공간 설정';

  @override
  String workspaceSettingsSubtitle(String name) {
    return '$name · 사람 및 접근 관리';
  }

  @override
  String get workspaceTeamOnlySettings => '사람 및 액세스 설정은 팀 공간에서만 사용할 수 있습니다.';

  @override
  String get authGoogleBrowserComplete => '로그인했습니다. 이 창을 닫고 PlanPal로 돌아가세요.';

  @override
  String get authGoogleBrowserFailure =>
      'Google 로그인을 완료하지 못했습니다. PlanPal로 돌아가 다시 시도하세요.';

  @override
  String get tabMembers => '멤버';

  @override
  String get tabInviteCodes => '초대 코드';

  @override
  String get today => '오늘';

  @override
  String get thisWeek => '이번 주';

  @override
  String get overdue => '기한 초과';

  @override
  String get all => '전체';

  @override
  String get yesterday => '어제';

  @override
  String get tomorrow => '내일';

  @override
  String get pageLoading => '로딩 중...';

  @override
  String errorCode(String code) {
    return '오류 코드: $code';
  }

  @override
  String requestId(String id) {
    return '요청 ID: $id';
  }

  @override
  String get confirmDeleteTitle => '이 항목을 삭제할까요?';

  @override
  String get confirmDeleteBody => '이 작업은 취소할 수 없습니다.';

  @override
  String get confirmDeleteTaskTitle => '이 작업을 삭제할까요?';

  @override
  String get confirmDeleteTasksTitle => '선택한 작업을 삭제할까요?';

  @override
  String get confirmRemoveMemberTitle => '멤버를 제거할까요?';

  @override
  String confirmRemoveMemberBody(String name) {
    return '이 공간에서 $name을(를) 제거할까요?';
  }

  @override
  String get confirmDiscardTitle => '변경 사항을 취소할까요?';

  @override
  String get confirmDiscardBody => '이 변경 사항은 영구적으로 삭제됩니다.';

  @override
  String get logIn => '로그인';

  @override
  String get logOut => '로그아웃';

  @override
  String get signUp => '계정 만들기';

  @override
  String get forgotPassword => '비밀번호 찾기';

  @override
  String get continueWithGoogle => 'Google로 계속';

  @override
  String get createOrJoinTeam => '팀 공간 만들기 또는 참여';

  @override
  String get loginTitle => '다시 오신 것을 환영합니다';

  @override
  String get authInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다. 다시 시도해 주세요.';

  @override
  String get authEmailNotConfirmed => '로그인하기 전에 이메일을 확인해 주세요.';

  @override
  String get authAccountAlreadyExists => '이 이메일로 만든 계정이 이미 있습니다.';

  @override
  String get authWeakPassword => '비밀번호가 충분히 안전하지 않습니다. 더 안전한 비밀번호를 선택해 주세요.';

  @override
  String get authTooManyAttempts => '시도 횟수가 너무 많습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get authInvalidCode => '인증 코드가 잘못되었거나 만료되었습니다. 다시 시도해 주세요.';

  @override
  String get loginSubtitleMobile => '로그인하여 오늘 하루를 이어가세요.';

  @override
  String get loginSubtitleDesktop => '로그인하여 중단한 곳에서 계속하세요.';

  @override
  String get loginForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginNewHere => '처음이신가요?';

  @override
  String get loginCreateAccount => '계정 만들기';

  @override
  String get loginCalm => '여유로운 하루, 완료된 작업.';

  @override
  String get loginCalmDesc => 'PlanPal은 작업, 캘린더, 채팅을 친근한 한 곳에 모았습니다.';

  @override
  String get signupTitle => '계정 만들기';

  @override
  String get signupTeamworkTitle => '팀워크, 혼돈 없이.';

  @override
  String get signupTeamworkDesc => '작업, 캘린더, 채팅, 문서, 인사이트 — 차분하게 설계되었습니다.';

  @override
  String get signupHaveAccount => '계정이 있으신가요?';

  @override
  String get signupTermsPrefix => '에 동의합니다';

  @override
  String get signupTerms => '이용약관';

  @override
  String get signupTermsAnd => '및';

  @override
  String get signupPrivacy => '개인정보 처리방침';

  @override
  String get fieldFullName => '이름';

  @override
  String get fieldFullNameHint => '홍길동';

  @override
  String get fieldEmail => '이메일';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => '비밀번호';

  @override
  String get fieldPasswordHint => '••••••••••';

  @override
  String get fieldConfirmPassword => '비밀번호 확인';

  @override
  String get fieldNewPassword => '새 비밀번호';

  @override
  String get fieldConfirmNewPassword => '새 비밀번호 확인';

  @override
  String get fieldTaskName => '작업 이름';

  @override
  String get fieldTaskNameHint => '팀 워크숍 계획';

  @override
  String get fieldDescription => '설명';

  @override
  String get fieldDescriptionHint => '장소, 날짜, 의제...';

  @override
  String get fieldDueDate => '마감일';

  @override
  String get fieldDueDateOptional => '마감일 선택';

  @override
  String get fieldTime => '시간';

  @override
  String get fieldTimeOptional => '선택 사항';

  @override
  String get fieldTaskReminder => '알림 (마감 전 분)';

  @override
  String get fieldTaskReminderHint => '분 단위로 입력하세요. 비워 두면 기본 24시간 전 알림을 사용합니다.';

  @override
  String get taskReminderDefault => '기본값 (24시간 전)';

  @override
  String taskReminderCustom(int minutes) {
    return '$minutes분 전';
  }

  @override
  String get taskNoDueDate => '마감일 없음';

  @override
  String get taskClearDueDate => '마감일 지우기';

  @override
  String get validationTaskReminderRequiresDueDate => '먼저 마감일을 선택해 주세요.';

  @override
  String get validationTaskReminderMinimum => '5분 이상의 정수를 입력해 주세요.';

  @override
  String get fieldPriority => '우선순위';

  @override
  String get fieldStatus => '상태';

  @override
  String get fieldAssignee => '담당자';

  @override
  String get fieldAssigneeOptional => '담당자 (선택)';

  @override
  String get fieldLabel => '레이블';

  @override
  String get fieldLabelOptional => '레이블 (선택)';

  @override
  String get taskCreateLabelTitle => '레이블 만들기';

  @override
  String get taskLabelNameHint => '레이블 이름';

  @override
  String get fieldTitle => '제목';

  @override
  String get fieldTitleHint => '디자인 검토';

  @override
  String get fieldStarts => '시작';

  @override
  String get fieldEnds => '종료';

  @override
  String get fieldAllDay => '하루 종일';

  @override
  String get fieldReminder => '알림';

  @override
  String get fieldChannelName => '채널 이름';

  @override
  String get fieldDocTitle => '문서 제목';

  @override
  String get fieldUntitled => '제목 없음';

  @override
  String get fieldStartWriting => '작성 시작...';

  @override
  String get fieldAddDetailsHint => '세부 정보 추가...';

  @override
  String get fieldWriteComment => '댓글 작성...';

  @override
  String get fieldMessageHint => '메시지...';

  @override
  String get fieldSubtaskHint => '하위 작업 제목';

  @override
  String fieldMessageChannelHint(String channel) {
    return '#$channel 메시지...';
  }

  @override
  String get validationEmailRequired => '이메일을 입력해 주세요.';

  @override
  String get validationEmailInvalid => '유효한 이메일을 입력해 주세요.';

  @override
  String get validationPasswordRequired => '비밀번호를 입력해 주세요.';

  @override
  String get validationPasswordTooShort => '비밀번호는 8자 이상이어야 합니다.';

  @override
  String get validationPasswordsNoMatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get validationNameRequired => '이름을 입력해 주세요.';

  @override
  String get validationTermsRequired => '이용약관 및 개인정보 처리방침에 동의해 주세요.';

  @override
  String get validationTaskNameRequired => '작업 이름을 입력해 주세요.';

  @override
  String get validationWorkspaceNameRequired => '공간 이름을 입력해 주세요.';

  @override
  String get forgotPasswordTitle => '비밀번호 재설정';

  @override
  String get forgotPasswordSubtitle => '계정에 연결된 이메일을 입력하세요.';

  @override
  String forgotPasswordStep(int current) {
    return '$current단계 / 3단계';
  }

  @override
  String get forgotPasswordSendCode => '코드 전송';

  @override
  String get forgotPasswordBackToLogin => '로그인으로 돌아가기';

  @override
  String get forgotPasswordEnterCode => '코드 입력';

  @override
  String get forgotPasswordCodeSent => '6자리 코드가 이메일로 전송되었습니다.';

  @override
  String get forgotPasswordContinue => '계속';

  @override
  String get forgotPasswordSetNew => '새 비밀번호 설정';

  @override
  String get forgotPasswordSaveNew => '새 비밀번호 저장';

  @override
  String get verifyEmailTitle => '받은 편지함 확인';

  @override
  String verifyEmailSentDesktop(String email) {
    return '$email로 6자리 코드를 전송했습니다';
  }

  @override
  String verifyEmailSentMobile(String email) {
    return '$email로 코드 전송';
  }

  @override
  String get verifyEmailVerify => '인증';

  @override
  String get verifyEmailResend => '받지 못하셨나요? 코드 재전송';

  @override
  String verifyEmailResendCooldown(int seconds) {
    return '받지 못하셨나요? $seconds초 후 재전송';
  }

  @override
  String get onboardingTitle => '어디서 시작하시겠어요?';

  @override
  String get onboardingSubtitle => '나중에 언제든지 전환하거나 더 만들 수 있습니다.';

  @override
  String get onboardingPersonalTitle => '내 개인 공간';

  @override
  String get onboardingPersonalSubtitle => '개인 작업과 메모.';

  @override
  String get onboardingPersonalTitleDesktop => '내 개인 공간으로 계속';

  @override
  String get onboardingPersonalSubtitleDesktop => '나만의 작업과 메모를 위한 조용한 개인 공간.';

  @override
  String get onboardingTeamTitle => '팀 만들기 또는 참여';

  @override
  String get onboardingTeamSubtitle => '다른 사람들과 작업 공유.';

  @override
  String get onboardingTeamSubtitleDesktop => '팀원 초대, 작업 공유, 함께 채팅.';

  @override
  String get tasksTitle => '작업';

  @override
  String get tasksBackToTasks => '작업으로 돌아가기';

  @override
  String tasksDueToday(int count, int dueToday) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '작업 $count개 · 오늘 $dueToday개 마감',
      one: '작업 1개 · 오늘 1개 마감',
    );
    return '$_temp0';
  }

  @override
  String tasksSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '작업 $count개 선택됨',
      one: '작업 1개 선택됨',
    );
    return '$_temp0';
  }

  @override
  String get tasksNoResultsFilters => '이 필터로 결과가 없습니다';

  @override
  String get tasksBulkPartialFailure => '선택한 작업 중 일부를 처리하지 못했습니다.';

  @override
  String get tasksBulkActionFailed => '선택한 작업을 처리하지 못했습니다.';

  @override
  String get tasksClearFilters => '필터 초기화';

  @override
  String get tasksSwipeHint => '작업을 왼쪽이나 오른쪽으로 밀어 편집하거나 삭제하세요.';

  @override
  String get tasksDismissSwipeHint => '스와이프 안내 닫기';

  @override
  String get tasksFilterTitle => '작업 필터';

  @override
  String get tasksFilterStatus => '상태';

  @override
  String get tasksFilterPriority => '우선순위';

  @override
  String get tasksFilterSort => '정렬';

  @override
  String get tasksFilterAll => '전체';

  @override
  String get tasksLoadMore => '더 불러오기';

  @override
  String get tasksSortBy => '정렬 기준';

  @override
  String get tasksSortDueDate => '마감일';

  @override
  String get tasksSortCreated => '생성일';

  @override
  String get tasksSortTitle => '제목';

  @override
  String get btnApply => '적용';

  @override
  String get tasksAddSubtask => '+ 하위 작업 추가';

  @override
  String get tasksAddSubtaskHint => '+ 하위 작업 추가...';

  @override
  String tasksSubtasksLabel(int done, int total) {
    return '하위 작업 $done/$total';
  }

  @override
  String get tasksSubtasksTitle => '하위 작업';

  @override
  String get tasksDetailTitle => '작업 세부 정보';

  @override
  String get tasksSwipeEdit => '편집';

  @override
  String get confirmDeleteSubtaskTitle => '이 하위 작업을 삭제할까요?';

  @override
  String get taskMoveToWorkspace => '다른 워크스페이스로 이동';

  @override
  String taskMoveConfirmation(Object workspace) {
    return '이 작업을 $workspace(으)로 이동할까요?';
  }

  @override
  String get btnMove => '이동';

  @override
  String get tasksNewTitle => '새 작업';

  @override
  String get tasksDescriptionLabel => '설명';

  @override
  String get tasksNoDescription => '설명 없음.';

  @override
  String get tasksComments => '댓글';

  @override
  String get tasksCommentJustNow => '방금';

  @override
  String tasksCommentMinutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String tasksCommentHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String tasksCommentDaysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get tasksAttachments => '첨부 파일';

  @override
  String get taskNoAttachments => '첨부 파일이 없습니다.';

  @override
  String get taskAttachmentOffline => '첨부 파일을 업로드하거나 열려면 인터넷 연결이 필요합니다.';

  @override
  String get taskAttachmentOpenFailed => '첨부 파일을 열 수 없습니다. 다시 시도해 주세요.';

  @override
  String get taskAttachFile => '파일 첨부';

  @override
  String get taskAttachmentUploadFailed => '파일을 업로드하거나 첨부할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get tasksAssigneeLabel => '담당자 및 레이블';

  @override
  String get tasksUnassigned => '미배정';

  @override
  String tasksDoneDate(String date) {
    return '$date 완료';
  }

  @override
  String get calendarTitle => '캘린더';

  @override
  String get calendarToday => '오늘';

  @override
  String get calendarTodaySchedule => '오늘의 일정';

  @override
  String calendarScheduleFor(String date) {
    return '일정 · $date';
  }

  @override
  String get calendarWeek => '주';

  @override
  String get calendarMonth => '월';

  @override
  String get calendarDay => '일';

  @override
  String calendarEventsFor(String date) {
    return '이벤트: $date';
  }

  @override
  String calendarMoreEvents(int count) {
    return '+$count개 더 보기';
  }

  @override
  String get calendarTeam => '팀';

  @override
  String get calendarDueTasks => '마감 예정 작업';

  @override
  String get calendarQueuedOffline => '이벤트가 기기에 저장되었으며 온라인 상태가 되면 동기화됩니다.';

  @override
  String get calendarAttendees => '참석자';

  @override
  String get calendarNoMembers => '이 워크스페이스에 사용 가능한 멤버가 없습니다.';

  @override
  String get calendarInvalidRange => '종료 시간은 시작 시간보다 늦어야 합니다.';

  @override
  String get scheduleEventTitle => '일정 추가';

  @override
  String get calendarEditEvent => '일정 수정';

  @override
  String get calendarDeleteEvent => '이 일정을 삭제할까요?';

  @override
  String get calendarDeleteQueuedOffline =>
      '일정이 이 기기에서 제거되었으며 온라인 상태가 되면 삭제됩니다.';

  @override
  String get reminderNone => '알림 없음';

  @override
  String get reminderFiveMin => '5분 전';

  @override
  String get reminderFifteenMin => '15분 전';

  @override
  String get reminderThirtyMin => '30분 전';

  @override
  String get reminderOneHour => '1시간 전';

  @override
  String get documentsTitle => '문서';

  @override
  String get documentSaving => '저장 중...';

  @override
  String get documentSaved => '저장됨';

  @override
  String get documentSavedLocally => '이 기기에 저장됨';

  @override
  String get documentWaitingToSync => '동기화 대기 중';

  @override
  String get documentsRecent => '최근';

  @override
  String get documentsRecentTitle => '최근 문서';

  @override
  String get documentEditorSave => '저장';

  @override
  String get documentEditorStartWriting => '작성 시작...';

  @override
  String get documentNewFolderTitle => '새 폴더';

  @override
  String get documentNewTitle => '새 문서';

  @override
  String get documentDownloadComplete => '다운로드 완료';

  @override
  String get errorFolderNotEmpty => '먼저 폴더 안의 파일과 폴더를 이동하거나 삭제하세요.';

  @override
  String get documentUploadFile => '파일 업로드';

  @override
  String get documentDropHint => '업로드할 파일을 여기에 놓으세요';

  @override
  String get documentDropFilesOnly => '폴더가 아닌 파일을 여기에 놓으세요.';

  @override
  String get documentNewFolder => '새 폴더';

  @override
  String get chatTitle => '메시지';

  @override
  String get chatNewChannel => '새 채널';

  @override
  String get chatChannels => '채널';

  @override
  String get chatDirectMessages => '다이렉트 메시지';

  @override
  String get chatNewDm => '새 다이렉트 메시지';

  @override
  String get chatPrivateChannel => '비공개 채널';

  @override
  String get chatManageMembers => '채널 멤버 관리';

  @override
  String get chatUnnamedChannel => '이름 없는 채널';

  @override
  String get chatDirectMessageFallback => '다이렉트 메시지';

  @override
  String get chatYou => '나';

  @override
  String get chatUnknownSender => '알 수 없는 발신자';

  @override
  String chatMessageHeader(String sender, String time) {
    return '$sender · $time';
  }

  @override
  String chatTyping(String names) {
    return '$names 입력 중...';
  }

  @override
  String get chatTapToRetry => '탭하여 다시 시도';

  @override
  String get chatConfirmDeleteMessage => '이 메시지를 삭제할까요?';

  @override
  String get notificationsTitle => '알림';

  @override
  String get notificationsAll => '전체';

  @override
  String get notificationsUnread => '읽지 않음';

  @override
  String get notificationsTasks => '작업';

  @override
  String get notificationsMentions => '멘션';

  @override
  String get notificationsMarkRead => '읽음으로 표시';

  @override
  String get notificationsMarkUnread => '읽지 않음으로 표시';

  @override
  String get notificationTaskAssigned => '작업이 할당됨';

  @override
  String get notificationTaskUpdated => '작업이 업데이트됨';

  @override
  String get notificationTaskComment => '새 작업 댓글';

  @override
  String get notificationMention => '멘션되었습니다';

  @override
  String get notificationDeadline => '마감일 임박';

  @override
  String get notificationOverdue => '작업 기한 초과';

  @override
  String get notificationEventReminder => '일정 알림';

  @override
  String get notificationChatMessage => '새 채팅 메시지';

  @override
  String get notificationMemberJoined => '새 멤버가 참여함';

  @override
  String get notificationJustNow => '방금';

  @override
  String notificationMinutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String notificationHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String notificationDaysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get analyticsTitle => '분석';

  @override
  String get analyticsExportCSV => 'CSV 내보내기';

  @override
  String get analyticsLastSevenDays => '최근 7일';

  @override
  String get analyticsLastThirtyDays => '최근 30일';

  @override
  String get analyticsLastNinetyDays => '최근 90일';

  @override
  String get analyticsTasksCompleted => '완료된 작업';

  @override
  String get analyticsAvgTime => '평균 완료 시간';

  @override
  String get analyticsVelocity => '팀 속도';

  @override
  String get analyticsStreak => '생산성 연속';

  @override
  String get analyticsWeeklyOutput => '주간 작업 생산량';

  @override
  String get analyticsCategoryMix => '카테고리 분포';

  @override
  String get homeYourTasksToday => '오늘의 작업';

  @override
  String get homeQuickActions => '빠른 작업';

  @override
  String get homeOverview => '개요';

  @override
  String get homeUpcoming => '예정';

  @override
  String get homeStats => '통계';

  @override
  String get homeDocs => '문서';

  @override
  String get homeSevenDays => '7일';

  @override
  String get homeThirtyDays => '30일';

  @override
  String get homeTasksCompleted => '완료된 작업';

  @override
  String get homeCompleted => '완료';

  @override
  String get homeInProgress => '진행 중';

  @override
  String get homeOverdue => '기한 초과';

  @override
  String get homeProductivity => '생산성';

  @override
  String get homeGreetingFallback => '안녕하세요';

  @override
  String get homeWorkspaceFallback => '워크스페이스';

  @override
  String get teamDirectoryTitle => '팀 디렉토리';

  @override
  String get teamLatestUpdates => '최근 업데이트';

  @override
  String get teamNoActivity => '최근 활동 없음';

  @override
  String get teamUpdatedTask => '작업 업데이트됨';

  @override
  String get teamUpdateTask => '작업 업데이트됨';

  @override
  String get teamUpdateDocument => '문서 업데이트됨';

  @override
  String get teamUpdateFile => '파일 업데이트됨';

  @override
  String get teamUpdateMemberJoined => '멤버가 참여함';

  @override
  String get teamMemberProfile => '멤버 프로필';

  @override
  String get teamMessageMember => '메시지';

  @override
  String get teamRemoveMember => '멤버 제거';

  @override
  String get teamChangeRole => '역할 변경';

  @override
  String get teamConfirmRemoveMember => '이 사용자를 워크스페이스에서 제거할까요?';

  @override
  String get teamPresenceOnline => '지금 활성';

  @override
  String get teamPresenceAway => '자리 비움';

  @override
  String get teamPresenceOffline => '오프라인';

  @override
  String get settingsProfile => '프로필';

  @override
  String get settingsAccount => '계정';

  @override
  String get settingsNotifications => '알림';

  @override
  String get settingsTimezone => '시간대';

  @override
  String get settingsPushNotifications => '푸시 알림';

  @override
  String get settingsInAppNotifications => '앱 내 알림';

  @override
  String get settingsNotifyAssignments => '작업 할당';

  @override
  String get settingsNotifyComments => '댓글';

  @override
  String get settingsNotifyMentions => '멘션';

  @override
  String get settingsNotifyDeadlines => '마감일 및 알림';

  @override
  String get settingsNotifyChat => '채팅 메시지';

  @override
  String get settingsChangePassword => '비밀번호 변경';

  @override
  String get settingsCurrentPassword => '현재 비밀번호';

  @override
  String get settingsPasswordChanged => '비밀번호가 변경되었습니다.';

  @override
  String get settingsSignOutEverywhere => '모든 기기에서 로그아웃';

  @override
  String get settingsAppearance => '외관';

  @override
  String get settingsAppearanceSaved => '외관 설정이 계정에 저장되었습니다.';

  @override
  String get settingsAppearanceQueued => '이 기기에 저장되었습니다. 서버에 연결되면 동기화됩니다.';

  @override
  String get settingsAppearanceSaveFailed => '이 기기에서 외관을 변경했지만 계정에 저장하지 못했습니다.';

  @override
  String get settingsSecurity => '보안';

  @override
  String get settingsWorkspace => '작업 공간';

  @override
  String get settingsSyncStatus => '동기화 상태';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeLight => '라이트';

  @override
  String get settingsThemeDark => '다크';

  @override
  String get settingsThemeSystem => '시스템';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsAvatarUpdated => '아바타가 업데이트되었습니다!';

  @override
  String get settingsDeleteAccountTitle => '계정 삭제';

  @override
  String get settingsDeleteAccountDesc => '계정과 모든 데이터를 영구적으로 삭제합니다.';

  @override
  String settingsComingSoon(String section) {
    return '$section 설정 출시 예정.';
  }

  @override
  String analyticsLastUpdated(String time) {
    return '마지막 업데이트: $time';
  }

  @override
  String get syncStatusTitle => '동기화 상태';

  @override
  String get syncConnection => '연결';

  @override
  String get syncOnline => '온라인';

  @override
  String get syncOffline => '오프라인';

  @override
  String get syncServerWaking => '서버 시작 중...';

  @override
  String get syncServerUnreachable => '서버에 연결할 수 없음';

  @override
  String syncLastSynced(String time) {
    return '마지막 동기화: $time';
  }

  @override
  String get syncPendingChanges => '대기 중인 변경 사항';

  @override
  String get syncNoPending => '대기 중인 변경 사항 없음.';

  @override
  String get syncFailedChanges => '실패한 변경 사항';

  @override
  String get syncNoFailed => '실패한 변경 사항 없음.';

  @override
  String get syncRetryAll => '모두 재시도';

  @override
  String get syncCouldNotSave => '저장할 수 없습니다. 더 이상 접근 권한이 없을 수 있습니다.';

  @override
  String get syncJustNow => '방금';

  @override
  String get avatarCropTitle => '사진 자르기';

  @override
  String get codeCopied => '코드 복사됨';

  @override
  String get goodMorning => '좋은 아침입니다';

  @override
  String get goodAfternoon => '안녕하세요';

  @override
  String get goodEvening => '좋은 저녁입니다';

  @override
  String get letsGetStarted => '오늘도 생산적인 하루 만들어요.';
}
