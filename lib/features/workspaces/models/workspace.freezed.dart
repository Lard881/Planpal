// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) {
  return _Workspace.fromJson(json);
}

/// @nodoc
mixin _$Workspace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isPersonal => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError; // Related data
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int? get memberCount => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? get membershipId => throw _privateConstructorUsedError;

  /// Serializes this Workspace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceCopyWith<Workspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceCopyWith<$Res> {
  factory $WorkspaceCopyWith(Workspace value, $Res Function(Workspace) then) =
      _$WorkspaceCopyWithImpl<$Res, Workspace>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isPersonal,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) String? role,
      @JsonKey(includeFromJson: true, includeToJson: false) int? memberCount,
      @JsonKey(includeFromJson: true, includeToJson: false)
      String? membershipId});
}

/// @nodoc
class _$WorkspaceCopyWithImpl<$Res, $Val extends Workspace>
    implements $WorkspaceCopyWith<$Res> {
  _$WorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isPersonal = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? role = freezed,
    Object? memberCount = freezed,
    Object? membershipId = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPersonal: null == isPersonal
          ? _value.isPersonal
          : isPersonal // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: freezed == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int?,
      membershipId: freezed == membershipId
          ? _value.membershipId
          : membershipId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceImplCopyWith<$Res>
    implements $WorkspaceCopyWith<$Res> {
  factory _$$WorkspaceImplCopyWith(
          _$WorkspaceImpl value, $Res Function(_$WorkspaceImpl) then) =
      __$$WorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isPersonal,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) String? role,
      @JsonKey(includeFromJson: true, includeToJson: false) int? memberCount,
      @JsonKey(includeFromJson: true, includeToJson: false)
      String? membershipId});
}

/// @nodoc
class __$$WorkspaceImplCopyWithImpl<$Res>
    extends _$WorkspaceCopyWithImpl<$Res, _$WorkspaceImpl>
    implements _$$WorkspaceImplCopyWith<$Res> {
  __$$WorkspaceImplCopyWithImpl(
      _$WorkspaceImpl _value, $Res Function(_$WorkspaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isPersonal = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? role = freezed,
    Object? memberCount = freezed,
    Object? membershipId = freezed,
  }) {
    return _then(_$WorkspaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPersonal: null == isPersonal
          ? _value.isPersonal
          : isPersonal // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: freezed == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int?,
      membershipId: freezed == membershipId
          ? _value.membershipId
          : membershipId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceImpl implements _Workspace {
  const _$WorkspaceImpl(
      {required this.id,
      required this.name,
      this.description,
      this.isPersonal = false,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) this.role,
      @JsonKey(includeFromJson: true, includeToJson: false) this.memberCount,
      @JsonKey(includeFromJson: true, includeToJson: false) this.membershipId});

  factory _$WorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isPersonal;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Related data
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? role;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final int? memberCount;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? membershipId;

  @override
  String toString() {
    return 'Workspace(id: $id, name: $name, description: $description, isPersonal: $isPersonal, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, role: $role, memberCount: $memberCount, membershipId: $membershipId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isPersonal, isPersonal) ||
                other.isPersonal == isPersonal) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.membershipId, membershipId) ||
                other.membershipId == membershipId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      isPersonal,
      createdBy,
      createdAt,
      updatedAt,
      role,
      memberCount,
      membershipId);

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      __$$WorkspaceImplCopyWithImpl<_$WorkspaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceImplToJson(
      this,
    );
  }
}

abstract class _Workspace implements Workspace {
  const factory _Workspace(
      {required final String id,
      required final String name,
      final String? description,
      final bool isPersonal,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) final String? role,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final int? memberCount,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final String? membershipId}) = _$WorkspaceImpl;

  factory _Workspace.fromJson(Map<String, dynamic> json) =
      _$WorkspaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isPersonal;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Related data
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? get role;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  int? get memberCount;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? get membershipId;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceMember _$WorkspaceMemberFromJson(Map<String, dynamic> json) {
  return _WorkspaceMember.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceMember {
  String get id => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError; // User info
  @JsonKey(includeFromJson: true, includeToJson: false)
  WorkspaceMemberUser? get user => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceMemberCopyWith<WorkspaceMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceMemberCopyWith<$Res> {
  factory $WorkspaceMemberCopyWith(
          WorkspaceMember value, $Res Function(WorkspaceMember) then) =
      _$WorkspaceMemberCopyWithImpl<$Res, WorkspaceMember>;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String userId,
      String role,
      DateTime joinedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      WorkspaceMemberUser? user});

  $WorkspaceMemberUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$WorkspaceMemberCopyWithImpl<$Res, $Val extends WorkspaceMember>
    implements $WorkspaceMemberCopyWith<$Res> {
  _$WorkspaceMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? userId = null,
    Object? role = null,
    Object? joinedAt = null,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as WorkspaceMemberUser?,
    ) as $Val);
  }

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkspaceMemberUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $WorkspaceMemberUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkspaceMemberImplCopyWith<$Res>
    implements $WorkspaceMemberCopyWith<$Res> {
  factory _$$WorkspaceMemberImplCopyWith(_$WorkspaceMemberImpl value,
          $Res Function(_$WorkspaceMemberImpl) then) =
      __$$WorkspaceMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String userId,
      String role,
      DateTime joinedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      WorkspaceMemberUser? user});

  @override
  $WorkspaceMemberUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$WorkspaceMemberImplCopyWithImpl<$Res>
    extends _$WorkspaceMemberCopyWithImpl<$Res, _$WorkspaceMemberImpl>
    implements _$$WorkspaceMemberImplCopyWith<$Res> {
  __$$WorkspaceMemberImplCopyWithImpl(
      _$WorkspaceMemberImpl _value, $Res Function(_$WorkspaceMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? userId = null,
    Object? role = null,
    Object? joinedAt = null,
    Object? user = freezed,
  }) {
    return _then(_$WorkspaceMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as WorkspaceMemberUser?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceMemberImpl implements _WorkspaceMember {
  const _$WorkspaceMemberImpl(
      {required this.id,
      required this.workspaceId,
      required this.userId,
      required this.role,
      required this.joinedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) this.user});

  factory _$WorkspaceMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String workspaceId;
  @override
  final String userId;
  @override
  final String role;
  @override
  final DateTime joinedAt;
// User info
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final WorkspaceMemberUser? user;

  @override
  String toString() {
    return 'WorkspaceMember(id: $id, workspaceId: $workspaceId, userId: $userId, role: $role, joinedAt: $joinedAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, workspaceId, userId, role, joinedAt, user);

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceMemberImplCopyWith<_$WorkspaceMemberImpl> get copyWith =>
      __$$WorkspaceMemberImplCopyWithImpl<_$WorkspaceMemberImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceMemberImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceMember implements WorkspaceMember {
  const factory _WorkspaceMember(
      {required final String id,
      required final String workspaceId,
      required final String userId,
      required final String role,
      required final DateTime joinedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final WorkspaceMemberUser? user}) = _$WorkspaceMemberImpl;

  factory _WorkspaceMember.fromJson(Map<String, dynamic> json) =
      _$WorkspaceMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get workspaceId;
  @override
  String get userId;
  @override
  String get role;
  @override
  DateTime get joinedAt; // User info
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  WorkspaceMemberUser? get user;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceMemberImplCopyWith<_$WorkspaceMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceMemberUser _$WorkspaceMemberUserFromJson(Map<String, dynamic> json) {
  return _WorkspaceMemberUser.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceMemberUser {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceMemberUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceMemberUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceMemberUserCopyWith<WorkspaceMemberUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceMemberUserCopyWith<$Res> {
  factory $WorkspaceMemberUserCopyWith(
          WorkspaceMemberUser value, $Res Function(WorkspaceMemberUser) then) =
      _$WorkspaceMemberUserCopyWithImpl<$Res, WorkspaceMemberUser>;
  @useResult
  $Res call({String id, String name, String? email, String? avatarUrl});
}

/// @nodoc
class _$WorkspaceMemberUserCopyWithImpl<$Res, $Val extends WorkspaceMemberUser>
    implements $WorkspaceMemberUserCopyWith<$Res> {
  _$WorkspaceMemberUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceMemberUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
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
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceMemberUserImplCopyWith<$Res>
    implements $WorkspaceMemberUserCopyWith<$Res> {
  factory _$$WorkspaceMemberUserImplCopyWith(_$WorkspaceMemberUserImpl value,
          $Res Function(_$WorkspaceMemberUserImpl) then) =
      __$$WorkspaceMemberUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? email, String? avatarUrl});
}

/// @nodoc
class __$$WorkspaceMemberUserImplCopyWithImpl<$Res>
    extends _$WorkspaceMemberUserCopyWithImpl<$Res, _$WorkspaceMemberUserImpl>
    implements _$$WorkspaceMemberUserImplCopyWith<$Res> {
  __$$WorkspaceMemberUserImplCopyWithImpl(_$WorkspaceMemberUserImpl _value,
      $Res Function(_$WorkspaceMemberUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceMemberUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$WorkspaceMemberUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceMemberUserImpl implements _WorkspaceMemberUser {
  const _$WorkspaceMemberUserImpl(
      {required this.id, required this.name, this.email, this.avatarUrl});

  factory _$WorkspaceMemberUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceMemberUserImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'WorkspaceMemberUser(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceMemberUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, avatarUrl);

  /// Create a copy of WorkspaceMemberUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceMemberUserImplCopyWith<_$WorkspaceMemberUserImpl> get copyWith =>
      __$$WorkspaceMemberUserImplCopyWithImpl<_$WorkspaceMemberUserImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceMemberUserImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceMemberUser implements WorkspaceMemberUser {
  const factory _WorkspaceMemberUser(
      {required final String id,
      required final String name,
      final String? email,
      final String? avatarUrl}) = _$WorkspaceMemberUserImpl;

  factory _WorkspaceMemberUser.fromJson(Map<String, dynamic> json) =
      _$WorkspaceMemberUserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get avatarUrl;

  /// Create a copy of WorkspaceMemberUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceMemberUserImplCopyWith<_$WorkspaceMemberUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteCode _$InviteCodeFromJson(Map<String, dynamic> json) {
  return _InviteCode.fromJson(json);
}

/// @nodoc
mixin _$InviteCode {
  String get id => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  int get uses => throw _privateConstructorUsedError;
  int? get maxUses => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get revokedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError; // Creator info
  @JsonKey(includeFromJson: true, includeToJson: false)
  InviteCodeCreator? get createdByUser => throw _privateConstructorUsedError;

  /// Serializes this InviteCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteCodeCopyWith<InviteCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteCodeCopyWith<$Res> {
  factory $InviteCodeCopyWith(
          InviteCode value, $Res Function(InviteCode) then) =
      _$InviteCodeCopyWithImpl<$Res, InviteCode>;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String code,
      int uses,
      int? maxUses,
      DateTime? expiresAt,
      DateTime? revokedAt,
      String createdBy,
      DateTime createdAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      InviteCodeCreator? createdByUser});

  $InviteCodeCreatorCopyWith<$Res>? get createdByUser;
}

/// @nodoc
class _$InviteCodeCopyWithImpl<$Res, $Val extends InviteCode>
    implements $InviteCodeCopyWith<$Res> {
  _$InviteCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? code = null,
    Object? uses = null,
    Object? maxUses = freezed,
    Object? expiresAt = freezed,
    Object? revokedAt = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? createdByUser = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as int,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdByUser: freezed == createdByUser
          ? _value.createdByUser
          : createdByUser // ignore: cast_nullable_to_non_nullable
              as InviteCodeCreator?,
    ) as $Val);
  }

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InviteCodeCreatorCopyWith<$Res>? get createdByUser {
    if (_value.createdByUser == null) {
      return null;
    }

    return $InviteCodeCreatorCopyWith<$Res>(_value.createdByUser!, (value) {
      return _then(_value.copyWith(createdByUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InviteCodeImplCopyWith<$Res>
    implements $InviteCodeCopyWith<$Res> {
  factory _$$InviteCodeImplCopyWith(
          _$InviteCodeImpl value, $Res Function(_$InviteCodeImpl) then) =
      __$$InviteCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String code,
      int uses,
      int? maxUses,
      DateTime? expiresAt,
      DateTime? revokedAt,
      String createdBy,
      DateTime createdAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      InviteCodeCreator? createdByUser});

  @override
  $InviteCodeCreatorCopyWith<$Res>? get createdByUser;
}

/// @nodoc
class __$$InviteCodeImplCopyWithImpl<$Res>
    extends _$InviteCodeCopyWithImpl<$Res, _$InviteCodeImpl>
    implements _$$InviteCodeImplCopyWith<$Res> {
  __$$InviteCodeImplCopyWithImpl(
      _$InviteCodeImpl _value, $Res Function(_$InviteCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? code = null,
    Object? uses = null,
    Object? maxUses = freezed,
    Object? expiresAt = freezed,
    Object? revokedAt = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? createdByUser = freezed,
  }) {
    return _then(_$InviteCodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as int,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdByUser: freezed == createdByUser
          ? _value.createdByUser
          : createdByUser // ignore: cast_nullable_to_non_nullable
              as InviteCodeCreator?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteCodeImpl implements _InviteCode {
  const _$InviteCodeImpl(
      {required this.id,
      required this.workspaceId,
      required this.code,
      this.uses = 0,
      this.maxUses,
      this.expiresAt,
      this.revokedAt,
      required this.createdBy,
      required this.createdAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      this.createdByUser});

  factory _$InviteCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String workspaceId;
  @override
  final String code;
  @override
  @JsonKey()
  final int uses;
  @override
  final int? maxUses;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? revokedAt;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
// Creator info
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final InviteCodeCreator? createdByUser;

  @override
  String toString() {
    return 'InviteCode(id: $id, workspaceId: $workspaceId, code: $code, uses: $uses, maxUses: $maxUses, expiresAt: $expiresAt, revokedAt: $revokedAt, createdBy: $createdBy, createdAt: $createdAt, createdByUser: $createdByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.uses, uses) || other.uses == uses) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.revokedAt, revokedAt) ||
                other.revokedAt == revokedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdByUser, createdByUser) ||
                other.createdByUser == createdByUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, workspaceId, code, uses,
      maxUses, expiresAt, revokedAt, createdBy, createdAt, createdByUser);

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteCodeImplCopyWith<_$InviteCodeImpl> get copyWith =>
      __$$InviteCodeImplCopyWithImpl<_$InviteCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteCodeImplToJson(
      this,
    );
  }
}

abstract class _InviteCode implements InviteCode {
  const factory _InviteCode(
      {required final String id,
      required final String workspaceId,
      required final String code,
      final int uses,
      final int? maxUses,
      final DateTime? expiresAt,
      final DateTime? revokedAt,
      required final String createdBy,
      required final DateTime createdAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final InviteCodeCreator? createdByUser}) = _$InviteCodeImpl;

  factory _InviteCode.fromJson(Map<String, dynamic> json) =
      _$InviteCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get workspaceId;
  @override
  String get code;
  @override
  int get uses;
  @override
  int? get maxUses;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get revokedAt;
  @override
  String get createdBy;
  @override
  DateTime get createdAt; // Creator info
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  InviteCodeCreator? get createdByUser;

  /// Create a copy of InviteCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteCodeImplCopyWith<_$InviteCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteCodeCreator _$InviteCodeCreatorFromJson(Map<String, dynamic> json) {
  return _InviteCodeCreator.fromJson(json);
}

/// @nodoc
mixin _$InviteCodeCreator {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this InviteCodeCreator to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteCodeCreator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteCodeCreatorCopyWith<InviteCodeCreator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteCodeCreatorCopyWith<$Res> {
  factory $InviteCodeCreatorCopyWith(
          InviteCodeCreator value, $Res Function(InviteCodeCreator) then) =
      _$InviteCodeCreatorCopyWithImpl<$Res, InviteCodeCreator>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$InviteCodeCreatorCopyWithImpl<$Res, $Val extends InviteCodeCreator>
    implements $InviteCodeCreatorCopyWith<$Res> {
  _$InviteCodeCreatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteCodeCreator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteCodeCreatorImplCopyWith<$Res>
    implements $InviteCodeCreatorCopyWith<$Res> {
  factory _$$InviteCodeCreatorImplCopyWith(_$InviteCodeCreatorImpl value,
          $Res Function(_$InviteCodeCreatorImpl) then) =
      __$$InviteCodeCreatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$InviteCodeCreatorImplCopyWithImpl<$Res>
    extends _$InviteCodeCreatorCopyWithImpl<$Res, _$InviteCodeCreatorImpl>
    implements _$$InviteCodeCreatorImplCopyWith<$Res> {
  __$$InviteCodeCreatorImplCopyWithImpl(_$InviteCodeCreatorImpl _value,
      $Res Function(_$InviteCodeCreatorImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteCodeCreator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$InviteCodeCreatorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteCodeCreatorImpl implements _InviteCodeCreator {
  const _$InviteCodeCreatorImpl({required this.id, required this.name});

  factory _$InviteCodeCreatorImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteCodeCreatorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'InviteCodeCreator(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteCodeCreatorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of InviteCodeCreator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteCodeCreatorImplCopyWith<_$InviteCodeCreatorImpl> get copyWith =>
      __$$InviteCodeCreatorImplCopyWithImpl<_$InviteCodeCreatorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteCodeCreatorImplToJson(
      this,
    );
  }
}

abstract class _InviteCodeCreator implements InviteCodeCreator {
  const factory _InviteCodeCreator(
      {required final String id,
      required final String name}) = _$InviteCodeCreatorImpl;

  factory _InviteCodeCreator.fromJson(Map<String, dynamic> json) =
      _$InviteCodeCreatorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of InviteCodeCreator
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteCodeCreatorImplCopyWith<_$InviteCodeCreatorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
