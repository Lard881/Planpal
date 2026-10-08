import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// Application failure types
@freezed
class AppFailure with _$AppFailure {
  // Network & Connectivity
  const factory AppFailure.noNetwork() = NoNetworkFailure;
  const factory AppFailure.noInternet() = NoInternetFailure;
  const factory AppFailure.serverUnreachable() = ServerUnreachableFailure;
  const factory AppFailure.timeout() = TimeoutFailure;

  // Authentication
  const factory AppFailure.authRequired() = AuthRequiredFailure;
  const factory AppFailure.authExpired() = AuthExpiredFailure;
  const factory AppFailure.invalidCredentials() = InvalidCredentialsFailure;
  const factory AppFailure.emailNotConfirmed() = EmailNotConfirmedFailure;
  const factory AppFailure.userAlreadyExists() = UserAlreadyExistsFailure;
  const factory AppFailure.emailAlreadyInUse() = EmailAlreadyInUseFailure;
  const factory AppFailure.weakPassword() = WeakPasswordFailure;
  const factory AppFailure.authCancelled() = AuthCancelledFailure;

  // Authorization
  const factory AppFailure.notAMember() = NotAMemberFailure;
  const factory AppFailure.forbidden() = ForbiddenFailure;
  const factory AppFailure.lastAdmin() = LastAdminFailure;

  // Invite Codes
  const factory AppFailure.invalidCode() = InvalidCodeFailure;
  const factory AppFailure.codeExpired() = CodeExpiredFailure;
  const factory AppFailure.codeRevoked() = CodeRevokedFailure;
  const factory AppFailure.codeUsedUp() = CodeUsedUpFailure;
  const factory AppFailure.alreadyMember() = AlreadyMemberFailure;

  // Files
  const factory AppFailure.fileTooLarge() = FileTooLargeFailure;
  const factory AppFailure.fileTypeNotAllowed() = FileTypeNotAllowedFailure;

  // Resources
  const factory AppFailure.notFound({String? resource}) = NotFoundFailure;
  const factory AppFailure.taskNotFound() = TaskNotFoundFailure;
  const factory AppFailure.workspaceNotFound() = WorkspaceNotFoundFailure;

  // Validation
  const factory AppFailure.validationFailed({
    required Map<String, String> fields,
  }) = ValidationFailedFailure;

  // Conflicts
  const factory AppFailure.conflict({String? message}) = ConflictFailure;
  const factory AppFailure.folderNotEmpty() = FolderNotEmptyFailure;

  // System
  const factory AppFailure.payloadTooLarge() = PayloadTooLargeFailure;
  const factory AppFailure.rateLimited() = RateLimitedFailure;
  const factory AppFailure.internalError() = InternalErrorFailure;
  const factory AppFailure.upstreamError() = UpstreamErrorFailure;
  const factory AppFailure.serviceUnavailable() = ServiceUnavailableFailure;
  const factory AppFailure.networkError() = NetworkErrorFailure;
  const factory AppFailure.serverError({String? message}) = ServerErrorFailure;
  const factory AppFailure.validationError({String? message}) = ValidationErrorFailure;

  // Local/Sync
  const factory AppFailure.syncFailed({String? message}) = SyncFailedFailure;
  const factory AppFailure.localDatabaseError() = LocalDatabaseErrorFailure;

  // Unknown
  const factory AppFailure.unknown({String? message}) = UnknownFailure;
}
