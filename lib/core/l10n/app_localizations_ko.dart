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
  String get searchCtrlK => 'Ctrl K';

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
  String get btnDetails => '세부 정보';

  @override
  String get btnCopy => '복사';

  @override
  String get btnCopied => '복사됨';

  @override
  String get btnAddTask => '+ 작업 추가';

  @override
  String get btnCreateTask => '작업 만들기';

  @override
  String get btnUpload => '파일 업로드';

  @override
  String get emptyStateNoTasks => '작업 없음';

  @override
  String get emptyStateNoTasksDesc => '첫 번째 작업을 만들어 시작하세요.';

  @override
  String get emptyStateNoEvents => '이번 주 이벤트 없음';

  @override
  String get emptyStateNoMessages => '메시지 없음';

  @override
  String get emptyStateNoDocuments => '문서 없음';

  @override
  String get emptyStateNoNotifications => '모두 확인했습니다';

  @override
  String get emptyStateNoResults => '결과 없음';

  @override
  String get errorGeneric => '문제가 발생했습니다. 다시 시도하세요.';

  @override
  String get errorNetwork => '인터넷 연결 없음. 네트워크를 확인하세요.';

  @override
  String get errorServer => '서버 오류. 잠시 후 다시 시도하세요.';

  @override
  String get errorPermission => '이 작업을 수행할 권한이 없습니다.';

  @override
  String get errorNotFound => '이 항목은 더 이상 존재하지 않습니다.';

  @override
  String get errorSessionExpired => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get bannerOffline => '오프라인 상태입니다. 변경사항이 기기에 저장되며 연결 시 동기화됩니다.';

  @override
  String get bannerServerUnreachable => '서버에 연결할 수 없습니다.';

  @override
  String get bannerWakingUp => '서버를 시작하는 중입니다. 최대 1분이 걸릴 수 있습니다.';

  @override
  String get bannerBackOnline => '다시 온라인 상태입니다. 동기화 중...';

  @override
  String syncWaiting(int count) {
    return '동기화 대기 중 $count';
  }

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
    return '멤버 $count명';
  }

  @override
  String get today => '오늘';

  @override
  String get thisWeek => '이번 주';

  @override
  String get overdue => '기한 초과';

  @override
  String get all => '전체';

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
  String get confirmDeleteTitle => '이 항목을 삭제하시겠습니까?';

  @override
  String get confirmDeleteBody => '이 작업은 취소할 수 없습니다.';

  @override
  String get logIn => '로그인';

  @override
  String get logOut => '로그아웃';

  @override
  String get signUp => '계정 만들기';

  @override
  String get forgotPassword => '비밀번호 찾기';

  @override
  String get goodMorning => '좋은 아침이에요';

  @override
  String get goodAfternoon => '좋은 오후예요';

  @override
  String get goodEvening => '좋은 저녁이에요';

  @override
  String get letsGetStarted => '오늘도 생산적인 하루 되세요.';
}
