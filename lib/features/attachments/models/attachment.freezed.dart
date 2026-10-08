// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return _Attachment.fromJson(json);
}

/// @nodoc
mixin _$Attachment {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get uploadedBy => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  String get storagePath => throw _privateConstructorUsedError;
  String? get thumbnailPath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachmentCopyWith<Attachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentCopyWith<$Res> {
  factory $AttachmentCopyWith(
          Attachment value, $Res Function(Attachment) then) =
      _$AttachmentCopyWithImpl<$Res, Attachment>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      String workspaceId,
      String uploadedBy,
      String fileName,
      int fileSize,
      String mimeType,
      String storagePath,
      String? thumbnailPath,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class _$AttachmentCopyWithImpl<$Res, $Val extends Attachment>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? workspaceId = null,
    Object? uploadedBy = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? storagePath = null,
    Object? thumbnailPath = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentImplCopyWith<$Res>
    implements $AttachmentCopyWith<$Res> {
  factory _$$AttachmentImplCopyWith(
          _$AttachmentImpl value, $Res Function(_$AttachmentImpl) then) =
      __$$AttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      String workspaceId,
      String uploadedBy,
      String fileName,
      int fileSize,
      String mimeType,
      String storagePath,
      String? thumbnailPath,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class __$$AttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$AttachmentImpl>
    implements _$$AttachmentImplCopyWith<$Res> {
  __$$AttachmentImplCopyWithImpl(
      _$AttachmentImpl _value, $Res Function(_$AttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? workspaceId = null,
    Object? uploadedBy = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? storagePath = null,
    Object? thumbnailPath = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$AttachmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentImpl implements _Attachment {
  const _$AttachmentImpl(
      {required this.id,
      required this.taskId,
      required this.workspaceId,
      required this.uploadedBy,
      required this.fileName,
      required this.fileSize,
      required this.mimeType,
      required this.storagePath,
      this.thumbnailPath,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  factory _$AttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final String workspaceId;
  @override
  final String uploadedBy;
  @override
  final String fileName;
  @override
  final int fileSize;
  @override
  final String mimeType;
  @override
  final String storagePath;
  @override
  final String? thumbnailPath;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Attachment(id: $id, taskId: $taskId, workspaceId: $workspaceId, uploadedBy: $uploadedBy, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, storagePath: $storagePath, thumbnailPath: $thumbnailPath, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      workspaceId,
      uploadedBy,
      fileName,
      fileSize,
      mimeType,
      storagePath,
      thumbnailPath,
      createdAt,
      updatedAt,
      deletedAt);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      __$$AttachmentImplCopyWithImpl<_$AttachmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentImplToJson(
      this,
    );
  }
}

abstract class _Attachment implements Attachment {
  const factory _Attachment(
      {required final String id,
      required final String taskId,
      required final String workspaceId,
      required final String uploadedBy,
      required final String fileName,
      required final int fileSize,
      required final String mimeType,
      required final String storagePath,
      final String? thumbnailPath,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt}) = _$AttachmentImpl;

  factory _Attachment.fromJson(Map<String, dynamic> json) =
      _$AttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  String get workspaceId;
  @override
  String get uploadedBy;
  @override
  String get fileName;
  @override
  int get fileSize;
  @override
  String get mimeType;
  @override
  String get storagePath;
  @override
  String? get thumbnailPath;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UploadProgress {
  String get fileName => throw _privateConstructorUsedError;
  int get totalBytes => throw _privateConstructorUsedError;
  int get uploadedBytes => throw _privateConstructorUsedError;
  UploadStatus get status => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of UploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadProgressCopyWith<UploadProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadProgressCopyWith<$Res> {
  factory $UploadProgressCopyWith(
          UploadProgress value, $Res Function(UploadProgress) then) =
      _$UploadProgressCopyWithImpl<$Res, UploadProgress>;
  @useResult
  $Res call(
      {String fileName,
      int totalBytes,
      int uploadedBytes,
      UploadStatus status,
      String? error});
}

/// @nodoc
class _$UploadProgressCopyWithImpl<$Res, $Val extends UploadProgress>
    implements $UploadProgressCopyWith<$Res> {
  _$UploadProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? totalBytes = null,
    Object? uploadedBytes = null,
    Object? status = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedBytes: null == uploadedBytes
          ? _value.uploadedBytes
          : uploadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadProgressImplCopyWith<$Res>
    implements $UploadProgressCopyWith<$Res> {
  factory _$$UploadProgressImplCopyWith(_$UploadProgressImpl value,
          $Res Function(_$UploadProgressImpl) then) =
      __$$UploadProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fileName,
      int totalBytes,
      int uploadedBytes,
      UploadStatus status,
      String? error});
}

/// @nodoc
class __$$UploadProgressImplCopyWithImpl<$Res>
    extends _$UploadProgressCopyWithImpl<$Res, _$UploadProgressImpl>
    implements _$$UploadProgressImplCopyWith<$Res> {
  __$$UploadProgressImplCopyWithImpl(
      _$UploadProgressImpl _value, $Res Function(_$UploadProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? totalBytes = null,
    Object? uploadedBytes = null,
    Object? status = null,
    Object? error = freezed,
  }) {
    return _then(_$UploadProgressImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedBytes: null == uploadedBytes
          ? _value.uploadedBytes
          : uploadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UploadProgressImpl extends _UploadProgress {
  const _$UploadProgressImpl(
      {required this.fileName,
      required this.totalBytes,
      required this.uploadedBytes,
      required this.status,
      this.error})
      : super._();

  @override
  final String fileName;
  @override
  final int totalBytes;
  @override
  final int uploadedBytes;
  @override
  final UploadStatus status;
  @override
  final String? error;

  @override
  String toString() {
    return 'UploadProgress(fileName: $fileName, totalBytes: $totalBytes, uploadedBytes: $uploadedBytes, status: $status, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadProgressImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.uploadedBytes, uploadedBytes) ||
                other.uploadedBytes == uploadedBytes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, fileName, totalBytes, uploadedBytes, status, error);

  /// Create a copy of UploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadProgressImplCopyWith<_$UploadProgressImpl> get copyWith =>
      __$$UploadProgressImplCopyWithImpl<_$UploadProgressImpl>(
          this, _$identity);
}

abstract class _UploadProgress extends UploadProgress {
  const factory _UploadProgress(
      {required final String fileName,
      required final int totalBytes,
      required final int uploadedBytes,
      required final UploadStatus status,
      final String? error}) = _$UploadProgressImpl;
  const _UploadProgress._() : super._();

  @override
  String get fileName;
  @override
  int get totalBytes;
  @override
  int get uploadedBytes;
  @override
  UploadStatus get status;
  @override
  String? get error;

  /// Create a copy of UploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadProgressImplCopyWith<_$UploadProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
