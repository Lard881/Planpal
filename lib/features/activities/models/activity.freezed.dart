// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  String get id => throw _privateConstructorUsedError;
  ActivityEntityType get entityType => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  ActivityAction get action => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get changes => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata =>
      throw _privateConstructorUsedError; // Populated from joins
  ActivityUser? get user => throw _privateConstructorUsedError;
  ActivityTask? get task => throw _privateConstructorUsedError;
  ActivityProject? get project => throw _privateConstructorUsedError;
  ActivityWorkspace? get workspace => throw _privateConstructorUsedError;

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {String id,
      ActivityEntityType entityType,
      String entityId,
      ActivityAction action,
      String workspaceId,
      String userId,
      DateTime createdAt,
      Map<String, dynamic> changes,
      Map<String, dynamic> metadata,
      ActivityUser? user,
      ActivityTask? task,
      ActivityProject? project,
      ActivityWorkspace? workspace});

  $ActivityUserCopyWith<$Res>? get user;
  $ActivityTaskCopyWith<$Res>? get task;
  $ActivityProjectCopyWith<$Res>? get project;
  $ActivityWorkspaceCopyWith<$Res>? get workspace;
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? workspaceId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? changes = null,
    Object? metadata = null,
    Object? user = freezed,
    Object? task = freezed,
    Object? project = freezed,
    Object? workspace = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as ActivityEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ActivityAction,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ActivityUser?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as ActivityTask?,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ActivityProject?,
      workspace: freezed == workspace
          ? _value.workspace
          : workspace // ignore: cast_nullable_to_non_nullable
              as ActivityWorkspace?,
    ) as $Val);
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $ActivityUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityTaskCopyWith<$Res>? get task {
    if (_value.task == null) {
      return null;
    }

    return $ActivityTaskCopyWith<$Res>(_value.task!, (value) {
      return _then(_value.copyWith(task: value) as $Val);
    });
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityProjectCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $ActivityProjectCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityWorkspaceCopyWith<$Res>? get workspace {
    if (_value.workspace == null) {
      return null;
    }

    return $ActivityWorkspaceCopyWith<$Res>(_value.workspace!, (value) {
      return _then(_value.copyWith(workspace: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ActivityEntityType entityType,
      String entityId,
      ActivityAction action,
      String workspaceId,
      String userId,
      DateTime createdAt,
      Map<String, dynamic> changes,
      Map<String, dynamic> metadata,
      ActivityUser? user,
      ActivityTask? task,
      ActivityProject? project,
      ActivityWorkspace? workspace});

  @override
  $ActivityUserCopyWith<$Res>? get user;
  @override
  $ActivityTaskCopyWith<$Res>? get task;
  @override
  $ActivityProjectCopyWith<$Res>? get project;
  @override
  $ActivityWorkspaceCopyWith<$Res>? get workspace;
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? workspaceId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? changes = null,
    Object? metadata = null,
    Object? user = freezed,
    Object? task = freezed,
    Object? project = freezed,
    Object? workspace = freezed,
  }) {
    return _then(_$ActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as ActivityEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ActivityAction,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ActivityUser?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as ActivityTask?,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ActivityProject?,
      workspace: freezed == workspace
          ? _value.workspace
          : workspace // ignore: cast_nullable_to_non_nullable
              as ActivityWorkspace?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.workspaceId,
      required this.userId,
      required this.createdAt,
      final Map<String, dynamic> changes = const {},
      final Map<String, dynamic> metadata = const {},
      this.user,
      this.task,
      this.project,
      this.workspace})
      : _changes = changes,
        _metadata = metadata;

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  @override
  final String id;
  @override
  final ActivityEntityType entityType;
  @override
  final String entityId;
  @override
  final ActivityAction action;
  @override
  final String workspaceId;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  final Map<String, dynamic> _changes;
  @override
  @JsonKey()
  Map<String, dynamic> get changes {
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changes);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

// Populated from joins
  @override
  final ActivityUser? user;
  @override
  final ActivityTask? task;
  @override
  final ActivityProject? project;
  @override
  final ActivityWorkspace? workspace;

  @override
  String toString() {
    return 'Activity(id: $id, entityType: $entityType, entityId: $entityId, action: $action, workspaceId: $workspaceId, userId: $userId, createdAt: $createdAt, changes: $changes, metadata: $metadata, user: $user, task: $task, project: $project, workspace: $workspace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.workspace, workspace) ||
                other.workspace == workspace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      entityId,
      action,
      workspaceId,
      userId,
      createdAt,
      const DeepCollectionEquality().hash(_changes),
      const DeepCollectionEquality().hash(_metadata),
      user,
      task,
      project,
      workspace);

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImplToJson(
      this,
    );
  }
}

abstract class _Activity implements Activity {
  const factory _Activity(
      {required final String id,
      required final ActivityEntityType entityType,
      required final String entityId,
      required final ActivityAction action,
      required final String workspaceId,
      required final String userId,
      required final DateTime createdAt,
      final Map<String, dynamic> changes,
      final Map<String, dynamic> metadata,
      final ActivityUser? user,
      final ActivityTask? task,
      final ActivityProject? project,
      final ActivityWorkspace? workspace}) = _$ActivityImpl;

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override
  String get id;
  @override
  ActivityEntityType get entityType;
  @override
  String get entityId;
  @override
  ActivityAction get action;
  @override
  String get workspaceId;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic> get changes;
  @override
  Map<String, dynamic> get metadata; // Populated from joins
  @override
  ActivityUser? get user;
  @override
  ActivityTask? get task;
  @override
  ActivityProject? get project;
  @override
  ActivityWorkspace? get workspace;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityUser _$ActivityUserFromJson(Map<String, dynamic> json) {
  return _ActivityUser.fromJson(json);
}

/// @nodoc
mixin _$ActivityUser {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this ActivityUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityUserCopyWith<ActivityUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityUserCopyWith<$Res> {
  factory $ActivityUserCopyWith(
          ActivityUser value, $Res Function(ActivityUser) then) =
      _$ActivityUserCopyWithImpl<$Res, ActivityUser>;
  @useResult
  $Res call({String id, String name, String? avatarUrl, String? email});
}

/// @nodoc
class _$ActivityUserCopyWithImpl<$Res, $Val extends ActivityUser>
    implements $ActivityUserCopyWith<$Res> {
  _$ActivityUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityUser
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
abstract class _$$ActivityUserImplCopyWith<$Res>
    implements $ActivityUserCopyWith<$Res> {
  factory _$$ActivityUserImplCopyWith(
          _$ActivityUserImpl value, $Res Function(_$ActivityUserImpl) then) =
      __$$ActivityUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? avatarUrl, String? email});
}

/// @nodoc
class __$$ActivityUserImplCopyWithImpl<$Res>
    extends _$ActivityUserCopyWithImpl<$Res, _$ActivityUserImpl>
    implements _$$ActivityUserImplCopyWith<$Res> {
  __$$ActivityUserImplCopyWithImpl(
      _$ActivityUserImpl _value, $Res Function(_$ActivityUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_$ActivityUserImpl(
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
class _$ActivityUserImpl implements _ActivityUser {
  const _$ActivityUserImpl(
      {required this.id, required this.name, this.avatarUrl, this.email});

  factory _$ActivityUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityUserImplFromJson(json);

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
    return 'ActivityUser(id: $id, name: $name, avatarUrl: $avatarUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl, email);

  /// Create a copy of ActivityUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityUserImplCopyWith<_$ActivityUserImpl> get copyWith =>
      __$$ActivityUserImplCopyWithImpl<_$ActivityUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityUserImplToJson(
      this,
    );
  }
}

abstract class _ActivityUser implements ActivityUser {
  const factory _ActivityUser(
      {required final String id,
      required final String name,
      final String? avatarUrl,
      final String? email}) = _$ActivityUserImpl;

  factory _ActivityUser.fromJson(Map<String, dynamic> json) =
      _$ActivityUserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  String? get email;

  /// Create a copy of ActivityUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityUserImplCopyWith<_$ActivityUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityTask _$ActivityTaskFromJson(Map<String, dynamic> json) {
  return _ActivityTask.fromJson(json);
}

/// @nodoc
mixin _$ActivityTask {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this ActivityTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityTaskCopyWith<ActivityTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityTaskCopyWith<$Res> {
  factory $ActivityTaskCopyWith(
          ActivityTask value, $Res Function(ActivityTask) then) =
      _$ActivityTaskCopyWithImpl<$Res, ActivityTask>;
  @useResult
  $Res call({String id, String title, String? status});
}

/// @nodoc
class _$ActivityTaskCopyWithImpl<$Res, $Val extends ActivityTask>
    implements $ActivityTaskCopyWith<$Res> {
  _$ActivityTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityTaskImplCopyWith<$Res>
    implements $ActivityTaskCopyWith<$Res> {
  factory _$$ActivityTaskImplCopyWith(
          _$ActivityTaskImpl value, $Res Function(_$ActivityTaskImpl) then) =
      __$$ActivityTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String? status});
}

/// @nodoc
class __$$ActivityTaskImplCopyWithImpl<$Res>
    extends _$ActivityTaskCopyWithImpl<$Res, _$ActivityTaskImpl>
    implements _$$ActivityTaskImplCopyWith<$Res> {
  __$$ActivityTaskImplCopyWithImpl(
      _$ActivityTaskImpl _value, $Res Function(_$ActivityTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = freezed,
  }) {
    return _then(_$ActivityTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityTaskImpl implements _ActivityTask {
  const _$ActivityTaskImpl(
      {required this.id, required this.title, this.status});

  factory _$ActivityTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? status;

  @override
  String toString() {
    return 'ActivityTask(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, status);

  /// Create a copy of ActivityTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityTaskImplCopyWith<_$ActivityTaskImpl> get copyWith =>
      __$$ActivityTaskImplCopyWithImpl<_$ActivityTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityTaskImplToJson(
      this,
    );
  }
}

abstract class _ActivityTask implements ActivityTask {
  const factory _ActivityTask(
      {required final String id,
      required final String title,
      final String? status}) = _$ActivityTaskImpl;

  factory _ActivityTask.fromJson(Map<String, dynamic> json) =
      _$ActivityTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get status;

  /// Create a copy of ActivityTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityTaskImplCopyWith<_$ActivityTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityProject _$ActivityProjectFromJson(Map<String, dynamic> json) {
  return _ActivityProject.fromJson(json);
}

/// @nodoc
mixin _$ActivityProject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this ActivityProject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityProjectCopyWith<ActivityProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityProjectCopyWith<$Res> {
  factory $ActivityProjectCopyWith(
          ActivityProject value, $Res Function(ActivityProject) then) =
      _$ActivityProjectCopyWithImpl<$Res, ActivityProject>;
  @useResult
  $Res call({String id, String name, String? color});
}

/// @nodoc
class _$ActivityProjectCopyWithImpl<$Res, $Val extends ActivityProject>
    implements $ActivityProjectCopyWith<$Res> {
  _$ActivityProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = freezed,
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
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityProjectImplCopyWith<$Res>
    implements $ActivityProjectCopyWith<$Res> {
  factory _$$ActivityProjectImplCopyWith(_$ActivityProjectImpl value,
          $Res Function(_$ActivityProjectImpl) then) =
      __$$ActivityProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? color});
}

/// @nodoc
class __$$ActivityProjectImplCopyWithImpl<$Res>
    extends _$ActivityProjectCopyWithImpl<$Res, _$ActivityProjectImpl>
    implements _$$ActivityProjectImplCopyWith<$Res> {
  __$$ActivityProjectImplCopyWithImpl(
      _$ActivityProjectImpl _value, $Res Function(_$ActivityProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = freezed,
  }) {
    return _then(_$ActivityProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityProjectImpl implements _ActivityProject {
  const _$ActivityProjectImpl(
      {required this.id, required this.name, this.color});

  factory _$ActivityProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? color;

  @override
  String toString() {
    return 'ActivityProject(id: $id, name: $name, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color);

  /// Create a copy of ActivityProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityProjectImplCopyWith<_$ActivityProjectImpl> get copyWith =>
      __$$ActivityProjectImplCopyWithImpl<_$ActivityProjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityProjectImplToJson(
      this,
    );
  }
}

abstract class _ActivityProject implements ActivityProject {
  const factory _ActivityProject(
      {required final String id,
      required final String name,
      final String? color}) = _$ActivityProjectImpl;

  factory _ActivityProject.fromJson(Map<String, dynamic> json) =
      _$ActivityProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get color;

  /// Create a copy of ActivityProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityProjectImplCopyWith<_$ActivityProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityWorkspace _$ActivityWorkspaceFromJson(Map<String, dynamic> json) {
  return _ActivityWorkspace.fromJson(json);
}

/// @nodoc
mixin _$ActivityWorkspace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ActivityWorkspace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityWorkspaceCopyWith<ActivityWorkspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityWorkspaceCopyWith<$Res> {
  factory $ActivityWorkspaceCopyWith(
          ActivityWorkspace value, $Res Function(ActivityWorkspace) then) =
      _$ActivityWorkspaceCopyWithImpl<$Res, ActivityWorkspace>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$ActivityWorkspaceCopyWithImpl<$Res, $Val extends ActivityWorkspace>
    implements $ActivityWorkspaceCopyWith<$Res> {
  _$ActivityWorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityWorkspace
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
abstract class _$$ActivityWorkspaceImplCopyWith<$Res>
    implements $ActivityWorkspaceCopyWith<$Res> {
  factory _$$ActivityWorkspaceImplCopyWith(_$ActivityWorkspaceImpl value,
          $Res Function(_$ActivityWorkspaceImpl) then) =
      __$$ActivityWorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$ActivityWorkspaceImplCopyWithImpl<$Res>
    extends _$ActivityWorkspaceCopyWithImpl<$Res, _$ActivityWorkspaceImpl>
    implements _$$ActivityWorkspaceImplCopyWith<$Res> {
  __$$ActivityWorkspaceImplCopyWithImpl(_$ActivityWorkspaceImpl _value,
      $Res Function(_$ActivityWorkspaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$ActivityWorkspaceImpl(
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
class _$ActivityWorkspaceImpl implements _ActivityWorkspace {
  const _$ActivityWorkspaceImpl({required this.id, required this.name});

  factory _$ActivityWorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityWorkspaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'ActivityWorkspace(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityWorkspaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of ActivityWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityWorkspaceImplCopyWith<_$ActivityWorkspaceImpl> get copyWith =>
      __$$ActivityWorkspaceImplCopyWithImpl<_$ActivityWorkspaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityWorkspaceImplToJson(
      this,
    );
  }
}

abstract class _ActivityWorkspace implements ActivityWorkspace {
  const factory _ActivityWorkspace(
      {required final String id,
      required final String name}) = _$ActivityWorkspaceImpl;

  factory _ActivityWorkspace.fromJson(Map<String, dynamic> json) =
      _$ActivityWorkspaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of ActivityWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityWorkspaceImplCopyWith<_$ActivityWorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateActivityRequest _$CreateActivityRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateActivityRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateActivityRequest {
  String? get id => throw _privateConstructorUsedError;
  ActivityEntityType get entityType => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  ActivityAction get action => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  Map<String, dynamic> get changes => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this CreateActivityRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateActivityRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateActivityRequestCopyWith<CreateActivityRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateActivityRequestCopyWith<$Res> {
  factory $CreateActivityRequestCopyWith(CreateActivityRequest value,
          $Res Function(CreateActivityRequest) then) =
      _$CreateActivityRequestCopyWithImpl<$Res, CreateActivityRequest>;
  @useResult
  $Res call(
      {String? id,
      ActivityEntityType entityType,
      String entityId,
      ActivityAction action,
      String workspaceId,
      Map<String, dynamic> changes,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$CreateActivityRequestCopyWithImpl<$Res,
        $Val extends CreateActivityRequest>
    implements $CreateActivityRequestCopyWith<$Res> {
  _$CreateActivityRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateActivityRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? workspaceId = null,
    Object? changes = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as ActivityEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ActivityAction,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateActivityRequestImplCopyWith<$Res>
    implements $CreateActivityRequestCopyWith<$Res> {
  factory _$$CreateActivityRequestImplCopyWith(
          _$CreateActivityRequestImpl value,
          $Res Function(_$CreateActivityRequestImpl) then) =
      __$$CreateActivityRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      ActivityEntityType entityType,
      String entityId,
      ActivityAction action,
      String workspaceId,
      Map<String, dynamic> changes,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$CreateActivityRequestImplCopyWithImpl<$Res>
    extends _$CreateActivityRequestCopyWithImpl<$Res,
        _$CreateActivityRequestImpl>
    implements _$$CreateActivityRequestImplCopyWith<$Res> {
  __$$CreateActivityRequestImplCopyWithImpl(_$CreateActivityRequestImpl _value,
      $Res Function(_$CreateActivityRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateActivityRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? workspaceId = null,
    Object? changes = null,
    Object? metadata = null,
  }) {
    return _then(_$CreateActivityRequestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as ActivityEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ActivityAction,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateActivityRequestImpl implements _CreateActivityRequest {
  const _$CreateActivityRequestImpl(
      {this.id,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.workspaceId,
      final Map<String, dynamic> changes = const {},
      final Map<String, dynamic> metadata = const {}})
      : _changes = changes,
        _metadata = metadata;

  factory _$CreateActivityRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateActivityRequestImplFromJson(json);

  @override
  final String? id;
  @override
  final ActivityEntityType entityType;
  @override
  final String entityId;
  @override
  final ActivityAction action;
  @override
  final String workspaceId;
  final Map<String, dynamic> _changes;
  @override
  @JsonKey()
  Map<String, dynamic> get changes {
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changes);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'CreateActivityRequest(id: $id, entityType: $entityType, entityId: $entityId, action: $action, workspaceId: $workspaceId, changes: $changes, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateActivityRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      entityId,
      action,
      workspaceId,
      const DeepCollectionEquality().hash(_changes),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of CreateActivityRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateActivityRequestImplCopyWith<_$CreateActivityRequestImpl>
      get copyWith => __$$CreateActivityRequestImplCopyWithImpl<
          _$CreateActivityRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateActivityRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateActivityRequest implements CreateActivityRequest {
  const factory _CreateActivityRequest(
      {final String? id,
      required final ActivityEntityType entityType,
      required final String entityId,
      required final ActivityAction action,
      required final String workspaceId,
      final Map<String, dynamic> changes,
      final Map<String, dynamic> metadata}) = _$CreateActivityRequestImpl;

  factory _CreateActivityRequest.fromJson(Map<String, dynamic> json) =
      _$CreateActivityRequestImpl.fromJson;

  @override
  String? get id;
  @override
  ActivityEntityType get entityType;
  @override
  String get entityId;
  @override
  ActivityAction get action;
  @override
  String get workspaceId;
  @override
  Map<String, dynamic> get changes;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of CreateActivityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateActivityRequestImplCopyWith<_$CreateActivityRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActivitiesResponse _$ActivitiesResponseFromJson(Map<String, dynamic> json) {
  return _ActivitiesResponse.fromJson(json);
}

/// @nodoc
mixin _$ActivitiesResponse {
  List<Activity> get activities => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  ActivitiesPagination? get pagination => throw _privateConstructorUsedError;

  /// Serializes this ActivitiesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivitiesResponseCopyWith<ActivitiesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitiesResponseCopyWith<$Res> {
  factory $ActivitiesResponseCopyWith(
          ActivitiesResponse value, $Res Function(ActivitiesResponse) then) =
      _$ActivitiesResponseCopyWithImpl<$Res, ActivitiesResponse>;
  @useResult
  $Res call(
      {List<Activity> activities,
      int? total,
      ActivitiesPagination? pagination});

  $ActivitiesPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$ActivitiesResponseCopyWithImpl<$Res, $Val extends ActivitiesResponse>
    implements $ActivitiesResponseCopyWith<$Res> {
  _$ActivitiesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? total = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as ActivitiesPagination?,
    ) as $Val);
  }

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivitiesPaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $ActivitiesPaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivitiesResponseImplCopyWith<$Res>
    implements $ActivitiesResponseCopyWith<$Res> {
  factory _$$ActivitiesResponseImplCopyWith(_$ActivitiesResponseImpl value,
          $Res Function(_$ActivitiesResponseImpl) then) =
      __$$ActivitiesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Activity> activities,
      int? total,
      ActivitiesPagination? pagination});

  @override
  $ActivitiesPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$ActivitiesResponseImplCopyWithImpl<$Res>
    extends _$ActivitiesResponseCopyWithImpl<$Res, _$ActivitiesResponseImpl>
    implements _$$ActivitiesResponseImplCopyWith<$Res> {
  __$$ActivitiesResponseImplCopyWithImpl(_$ActivitiesResponseImpl _value,
      $Res Function(_$ActivitiesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? total = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$ActivitiesResponseImpl(
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as ActivitiesPagination?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivitiesResponseImpl implements _ActivitiesResponse {
  const _$ActivitiesResponseImpl(
      {required final List<Activity> activities, this.total, this.pagination})
      : _activities = activities;

  factory _$ActivitiesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivitiesResponseImplFromJson(json);

  final List<Activity> _activities;
  @override
  List<Activity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  final int? total;
  @override
  final ActivitiesPagination? pagination;

  @override
  String toString() {
    return 'ActivitiesResponse(activities: $activities, total: $total, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitiesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_activities), total, pagination);

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitiesResponseImplCopyWith<_$ActivitiesResponseImpl> get copyWith =>
      __$$ActivitiesResponseImplCopyWithImpl<_$ActivitiesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitiesResponseImplToJson(
      this,
    );
  }
}

abstract class _ActivitiesResponse implements ActivitiesResponse {
  const factory _ActivitiesResponse(
      {required final List<Activity> activities,
      final int? total,
      final ActivitiesPagination? pagination}) = _$ActivitiesResponseImpl;

  factory _ActivitiesResponse.fromJson(Map<String, dynamic> json) =
      _$ActivitiesResponseImpl.fromJson;

  @override
  List<Activity> get activities;
  @override
  int? get total;
  @override
  ActivitiesPagination? get pagination;

  /// Create a copy of ActivitiesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivitiesResponseImplCopyWith<_$ActivitiesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivitiesPagination _$ActivitiesPaginationFromJson(Map<String, dynamic> json) {
  return _ActivitiesPagination.fromJson(json);
}

/// @nodoc
mixin _$ActivitiesPagination {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this ActivitiesPagination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivitiesPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivitiesPaginationCopyWith<ActivitiesPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitiesPaginationCopyWith<$Res> {
  factory $ActivitiesPaginationCopyWith(ActivitiesPagination value,
          $Res Function(ActivitiesPagination) then) =
      _$ActivitiesPaginationCopyWithImpl<$Res, ActivitiesPagination>;
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class _$ActivitiesPaginationCopyWithImpl<$Res,
        $Val extends ActivitiesPagination>
    implements $ActivitiesPaginationCopyWith<$Res> {
  _$ActivitiesPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivitiesPagination
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
abstract class _$$ActivitiesPaginationImplCopyWith<$Res>
    implements $ActivitiesPaginationCopyWith<$Res> {
  factory _$$ActivitiesPaginationImplCopyWith(_$ActivitiesPaginationImpl value,
          $Res Function(_$ActivitiesPaginationImpl) then) =
      __$$ActivitiesPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class __$$ActivitiesPaginationImplCopyWithImpl<$Res>
    extends _$ActivitiesPaginationCopyWithImpl<$Res, _$ActivitiesPaginationImpl>
    implements _$$ActivitiesPaginationImplCopyWith<$Res> {
  __$$ActivitiesPaginationImplCopyWithImpl(_$ActivitiesPaginationImpl _value,
      $Res Function(_$ActivitiesPaginationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivitiesPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
  }) {
    return _then(_$ActivitiesPaginationImpl(
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
class _$ActivitiesPaginationImpl implements _ActivitiesPagination {
  const _$ActivitiesPaginationImpl(
      {required this.page,
      required this.limit,
      required this.total,
      required this.totalPages});

  factory _$ActivitiesPaginationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivitiesPaginationImplFromJson(json);

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
    return 'ActivitiesPagination(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitiesPaginationImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, total, totalPages);

  /// Create a copy of ActivitiesPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitiesPaginationImplCopyWith<_$ActivitiesPaginationImpl>
      get copyWith =>
          __$$ActivitiesPaginationImplCopyWithImpl<_$ActivitiesPaginationImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitiesPaginationImplToJson(
      this,
    );
  }
}

abstract class _ActivitiesPagination implements ActivitiesPagination {
  const factory _ActivitiesPagination(
      {required final int page,
      required final int limit,
      required final int total,
      required final int totalPages}) = _$ActivitiesPaginationImpl;

  factory _ActivitiesPagination.fromJson(Map<String, dynamic> json) =
      _$ActivitiesPaginationImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  int get totalPages;

  /// Create a copy of ActivitiesPagination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivitiesPaginationImplCopyWith<_$ActivitiesPaginationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
