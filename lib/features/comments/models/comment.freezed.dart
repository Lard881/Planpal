// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  List<String> get mentions =>
      throw _privateConstructorUsedError; // Populated from joins
  CommentAuthor? get author => throw _privateConstructorUsedError;
  List<Comment> get replies => throw _privateConstructorUsedError;
  int? get replyCount => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      String authorId,
      String content,
      String? parentId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? editedAt,
      DateTime? deletedAt,
      List<String> mentions,
      CommentAuthor? author,
      List<Comment> replies,
      int? replyCount});

  $CommentAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? authorId = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? mentions = null,
    Object? author = freezed,
    Object? replies = null,
    Object? replyCount = freezed,
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
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as CommentAuthor?,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      replyCount: freezed == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentAuthorCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $CommentAuthorCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      String authorId,
      String content,
      String? parentId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? editedAt,
      DateTime? deletedAt,
      List<String> mentions,
      CommentAuthor? author,
      List<Comment> replies,
      int? replyCount});

  @override
  $CommentAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? authorId = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? mentions = null,
    Object? author = freezed,
    Object? replies = null,
    Object? replyCount = freezed,
  }) {
    return _then(_$CommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as CommentAuthor?,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      replyCount: freezed == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.id,
      required this.taskId,
      required this.authorId,
      required this.content,
      this.parentId,
      required this.createdAt,
      required this.updatedAt,
      this.editedAt,
      this.deletedAt,
      final List<String> mentions = const [],
      this.author,
      final List<Comment> replies = const [],
      this.replyCount})
      : _mentions = mentions,
        _replies = replies;

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final String authorId;
  @override
  final String content;
  @override
  final String? parentId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? editedAt;
  @override
  final DateTime? deletedAt;
  final List<String> _mentions;
  @override
  @JsonKey()
  List<String> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

// Populated from joins
  @override
  final CommentAuthor? author;
  final List<Comment> _replies;
  @override
  @JsonKey()
  List<Comment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  final int? replyCount;

  @override
  String toString() {
    return 'Comment(id: $id, taskId: $taskId, authorId: $authorId, content: $content, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt, editedAt: $editedAt, deletedAt: $deletedAt, mentions: $mentions, author: $author, replies: $replies, replyCount: $replyCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      authorId,
      content,
      parentId,
      createdAt,
      updatedAt,
      editedAt,
      deletedAt,
      const DeepCollectionEquality().hash(_mentions),
      author,
      const DeepCollectionEquality().hash(_replies),
      replyCount);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final String id,
      required final String taskId,
      required final String authorId,
      required final String content,
      final String? parentId,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? editedAt,
      final DateTime? deletedAt,
      final List<String> mentions,
      final CommentAuthor? author,
      final List<Comment> replies,
      final int? replyCount}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  String get authorId;
  @override
  String get content;
  @override
  String? get parentId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get editedAt;
  @override
  DateTime? get deletedAt;
  @override
  List<String> get mentions; // Populated from joins
  @override
  CommentAuthor? get author;
  @override
  List<Comment> get replies;
  @override
  int? get replyCount;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentAuthor _$CommentAuthorFromJson(Map<String, dynamic> json) {
  return _CommentAuthor.fromJson(json);
}

/// @nodoc
mixin _$CommentAuthor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this CommentAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentAuthorCopyWith<CommentAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentAuthorCopyWith<$Res> {
  factory $CommentAuthorCopyWith(
          CommentAuthor value, $Res Function(CommentAuthor) then) =
      _$CommentAuthorCopyWithImpl<$Res, CommentAuthor>;
  @useResult
  $Res call({String id, String name, String? avatarUrl, String? email});
}

/// @nodoc
class _$CommentAuthorCopyWithImpl<$Res, $Val extends CommentAuthor>
    implements $CommentAuthorCopyWith<$Res> {
  _$CommentAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentAuthorImplCopyWith<$Res>
    implements $CommentAuthorCopyWith<$Res> {
  factory _$$CommentAuthorImplCopyWith(
          _$CommentAuthorImpl value, $Res Function(_$CommentAuthorImpl) then) =
      __$$CommentAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? avatarUrl, String? email});
}

/// @nodoc
class __$$CommentAuthorImplCopyWithImpl<$Res>
    extends _$CommentAuthorCopyWithImpl<$Res, _$CommentAuthorImpl>
    implements _$$CommentAuthorImplCopyWith<$Res> {
  __$$CommentAuthorImplCopyWithImpl(
      _$CommentAuthorImpl _value, $Res Function(_$CommentAuthorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_$CommentAuthorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentAuthorImpl implements _CommentAuthor {
  const _$CommentAuthorImpl(
      {required this.id, required this.name, this.avatarUrl, this.email});

  factory _$CommentAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;
  @override
  final String? email;

  @override
  String toString() {
    return 'CommentAuthor(id: $id, name: $name, avatarUrl: $avatarUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl, email);

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentAuthorImplCopyWith<_$CommentAuthorImpl> get copyWith =>
      __$$CommentAuthorImplCopyWithImpl<_$CommentAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentAuthorImplToJson(
      this,
    );
  }
}

abstract class _CommentAuthor implements CommentAuthor {
  const factory _CommentAuthor(
      {required final String id,
      required final String name,
      final String? avatarUrl,
      final String? email}) = _$CommentAuthorImpl;

  factory _CommentAuthor.fromJson(Map<String, dynamic> json) =
      _$CommentAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  String? get email;

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentAuthorImplCopyWith<_$CommentAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCommentRequest _$CreateCommentRequestFromJson(Map<String, dynamic> json) {
  return _CreateCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCommentRequest {
  String? get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  List<String> get mentions => throw _privateConstructorUsedError;

  /// Serializes this CreateCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCommentRequestCopyWith<CreateCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCommentRequestCopyWith<$Res> {
  factory $CreateCommentRequestCopyWith(CreateCommentRequest value,
          $Res Function(CreateCommentRequest) then) =
      _$CreateCommentRequestCopyWithImpl<$Res, CreateCommentRequest>;
  @useResult
  $Res call(
      {String? id,
      String taskId,
      String content,
      String? parentId,
      List<String> mentions});
}

/// @nodoc
class _$CreateCommentRequestCopyWithImpl<$Res,
        $Val extends CreateCommentRequest>
    implements $CreateCommentRequestCopyWith<$Res> {
  _$CreateCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? mentions = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCommentRequestImplCopyWith<$Res>
    implements $CreateCommentRequestCopyWith<$Res> {
  factory _$$CreateCommentRequestImplCopyWith(_$CreateCommentRequestImpl value,
          $Res Function(_$CreateCommentRequestImpl) then) =
      __$$CreateCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String taskId,
      String content,
      String? parentId,
      List<String> mentions});
}

/// @nodoc
class __$$CreateCommentRequestImplCopyWithImpl<$Res>
    extends _$CreateCommentRequestCopyWithImpl<$Res, _$CreateCommentRequestImpl>
    implements _$$CreateCommentRequestImplCopyWith<$Res> {
  __$$CreateCommentRequestImplCopyWithImpl(_$CreateCommentRequestImpl _value,
      $Res Function(_$CreateCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? mentions = null,
  }) {
    return _then(_$CreateCommentRequestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCommentRequestImpl implements _CreateCommentRequest {
  const _$CreateCommentRequestImpl(
      {this.id,
      required this.taskId,
      required this.content,
      this.parentId,
      final List<String> mentions = const []})
      : _mentions = mentions;

  factory _$CreateCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCommentRequestImplFromJson(json);

  @override
  final String? id;
  @override
  final String taskId;
  @override
  final String content;
  @override
  final String? parentId;
  final List<String> _mentions;
  @override
  @JsonKey()
  List<String> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  @override
  String toString() {
    return 'CreateCommentRequest(id: $id, taskId: $taskId, content: $content, parentId: $parentId, mentions: $mentions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCommentRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, content, parentId,
      const DeepCollectionEquality().hash(_mentions));

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith =>
          __$$CreateCommentRequestImplCopyWithImpl<_$CreateCommentRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateCommentRequest implements CreateCommentRequest {
  const factory _CreateCommentRequest(
      {final String? id,
      required final String taskId,
      required final String content,
      final String? parentId,
      final List<String> mentions}) = _$CreateCommentRequestImpl;

  factory _CreateCommentRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCommentRequestImpl.fromJson;

  @override
  String? get id;
  @override
  String get taskId;
  @override
  String get content;
  @override
  String? get parentId;
  @override
  List<String> get mentions;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateCommentRequest _$UpdateCommentRequestFromJson(Map<String, dynamic> json) {
  return _UpdateCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateCommentRequest {
  String get content => throw _privateConstructorUsedError;

  /// Serializes this UpdateCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCommentRequestCopyWith<UpdateCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCommentRequestCopyWith<$Res> {
  factory $UpdateCommentRequestCopyWith(UpdateCommentRequest value,
          $Res Function(UpdateCommentRequest) then) =
      _$UpdateCommentRequestCopyWithImpl<$Res, UpdateCommentRequest>;
  @useResult
  $Res call({String content});
}

/// @nodoc
class _$UpdateCommentRequestCopyWithImpl<$Res,
        $Val extends UpdateCommentRequest>
    implements $UpdateCommentRequestCopyWith<$Res> {
  _$UpdateCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCommentRequestImplCopyWith<$Res>
    implements $UpdateCommentRequestCopyWith<$Res> {
  factory _$$UpdateCommentRequestImplCopyWith(_$UpdateCommentRequestImpl value,
          $Res Function(_$UpdateCommentRequestImpl) then) =
      __$$UpdateCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content});
}

/// @nodoc
class __$$UpdateCommentRequestImplCopyWithImpl<$Res>
    extends _$UpdateCommentRequestCopyWithImpl<$Res, _$UpdateCommentRequestImpl>
    implements _$$UpdateCommentRequestImplCopyWith<$Res> {
  __$$UpdateCommentRequestImplCopyWithImpl(_$UpdateCommentRequestImpl _value,
      $Res Function(_$UpdateCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
  }) {
    return _then(_$UpdateCommentRequestImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCommentRequestImpl implements _UpdateCommentRequest {
  const _$UpdateCommentRequestImpl({required this.content});

  factory _$UpdateCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCommentRequestImplFromJson(json);

  @override
  final String content;

  @override
  String toString() {
    return 'UpdateCommentRequest(content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCommentRequestImpl &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content);

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCommentRequestImplCopyWith<_$UpdateCommentRequestImpl>
      get copyWith =>
          __$$UpdateCommentRequestImplCopyWithImpl<_$UpdateCommentRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateCommentRequest implements UpdateCommentRequest {
  const factory _UpdateCommentRequest({required final String content}) =
      _$UpdateCommentRequestImpl;

  factory _UpdateCommentRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateCommentRequestImpl.fromJson;

  @override
  String get content;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCommentRequestImplCopyWith<_$UpdateCommentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CommentsResponse _$CommentsResponseFromJson(Map<String, dynamic> json) {
  return _CommentsResponse.fromJson(json);
}

/// @nodoc
mixin _$CommentsResponse {
  List<Comment> get comments => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  CommentsPagination? get pagination => throw _privateConstructorUsedError;

  /// Serializes this CommentsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentsResponseCopyWith<CommentsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentsResponseCopyWith<$Res> {
  factory $CommentsResponseCopyWith(
          CommentsResponse value, $Res Function(CommentsResponse) then) =
      _$CommentsResponseCopyWithImpl<$Res, CommentsResponse>;
  @useResult
  $Res call(
      {List<Comment> comments, int? total, CommentsPagination? pagination});

  $CommentsPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$CommentsResponseCopyWithImpl<$Res, $Val extends CommentsResponse>
    implements $CommentsResponseCopyWith<$Res> {
  _$CommentsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comments = null,
    Object? total = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as CommentsPagination?,
    ) as $Val);
  }

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentsPaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $CommentsPaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentsResponseImplCopyWith<$Res>
    implements $CommentsResponseCopyWith<$Res> {
  factory _$$CommentsResponseImplCopyWith(_$CommentsResponseImpl value,
          $Res Function(_$CommentsResponseImpl) then) =
      __$$CommentsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Comment> comments, int? total, CommentsPagination? pagination});

  @override
  $CommentsPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$CommentsResponseImplCopyWithImpl<$Res>
    extends _$CommentsResponseCopyWithImpl<$Res, _$CommentsResponseImpl>
    implements _$$CommentsResponseImplCopyWith<$Res> {
  __$$CommentsResponseImplCopyWithImpl(_$CommentsResponseImpl _value,
      $Res Function(_$CommentsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comments = null,
    Object? total = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$CommentsResponseImpl(
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as CommentsPagination?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentsResponseImpl implements _CommentsResponse {
  const _$CommentsResponseImpl(
      {required final List<Comment> comments, this.total, this.pagination})
      : _comments = comments;

  factory _$CommentsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentsResponseImplFromJson(json);

  final List<Comment> _comments;
  @override
  List<Comment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final int? total;
  @override
  final CommentsPagination? pagination;

  @override
  String toString() {
    return 'CommentsResponse(comments: $comments, total: $total, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentsResponseImpl &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_comments), total, pagination);

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentsResponseImplCopyWith<_$CommentsResponseImpl> get copyWith =>
      __$$CommentsResponseImplCopyWithImpl<_$CommentsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentsResponseImplToJson(
      this,
    );
  }
}

abstract class _CommentsResponse implements CommentsResponse {
  const factory _CommentsResponse(
      {required final List<Comment> comments,
      final int? total,
      final CommentsPagination? pagination}) = _$CommentsResponseImpl;

  factory _CommentsResponse.fromJson(Map<String, dynamic> json) =
      _$CommentsResponseImpl.fromJson;

  @override
  List<Comment> get comments;
  @override
  int? get total;
  @override
  CommentsPagination? get pagination;

  /// Create a copy of CommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentsResponseImplCopyWith<_$CommentsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentsPagination _$CommentsPaginationFromJson(Map<String, dynamic> json) {
  return _CommentsPagination.fromJson(json);
}

/// @nodoc
mixin _$CommentsPagination {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this CommentsPagination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentsPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentsPaginationCopyWith<CommentsPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentsPaginationCopyWith<$Res> {
  factory $CommentsPaginationCopyWith(
          CommentsPagination value, $Res Function(CommentsPagination) then) =
      _$CommentsPaginationCopyWithImpl<$Res, CommentsPagination>;
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class _$CommentsPaginationCopyWithImpl<$Res, $Val extends CommentsPagination>
    implements $CommentsPaginationCopyWith<$Res> {
  _$CommentsPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentsPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentsPaginationImplCopyWith<$Res>
    implements $CommentsPaginationCopyWith<$Res> {
  factory _$$CommentsPaginationImplCopyWith(_$CommentsPaginationImpl value,
          $Res Function(_$CommentsPaginationImpl) then) =
      __$$CommentsPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class __$$CommentsPaginationImplCopyWithImpl<$Res>
    extends _$CommentsPaginationCopyWithImpl<$Res, _$CommentsPaginationImpl>
    implements _$$CommentsPaginationImplCopyWith<$Res> {
  __$$CommentsPaginationImplCopyWithImpl(_$CommentsPaginationImpl _value,
      $Res Function(_$CommentsPaginationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentsPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
  }) {
    return _then(_$CommentsPaginationImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentsPaginationImpl implements _CommentsPagination {
  const _$CommentsPaginationImpl(
      {required this.page,
      required this.limit,
      required this.total,
      required this.totalPages});

  factory _$CommentsPaginationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentsPaginationImplFromJson(json);

  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'CommentsPagination(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentsPaginationImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, total, totalPages);

  /// Create a copy of CommentsPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentsPaginationImplCopyWith<_$CommentsPaginationImpl> get copyWith =>
      __$$CommentsPaginationImplCopyWithImpl<_$CommentsPaginationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentsPaginationImplToJson(
      this,
    );
  }
}

abstract class _CommentsPagination implements CommentsPagination {
  const factory _CommentsPagination(
      {required final int page,
      required final int limit,
      required final int total,
      required final int totalPages}) = _$CommentsPaginationImpl;

  factory _CommentsPagination.fromJson(Map<String, dynamic> json) =
      _$CommentsPaginationImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  int get totalPages;

  /// Create a copy of CommentsPagination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentsPaginationImplCopyWith<_$CommentsPaginationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
