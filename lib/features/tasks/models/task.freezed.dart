// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get assigneeId => throw _privateConstructorUsedError;
  String? get parentTaskId => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  List<String> get labelIds => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt =>
      throw _privateConstructorUsedError; // Related data (from joins)
  @JsonKey(includeFromJson: true, includeToJson: false)
  TaskProject? get project => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: true, includeToJson: false)
  TaskAssignee? get assignee => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<TaskLabel>? get labels => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<Task>? get subtasks => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String? projectId,
      String title,
      String? description,
      String status,
      String? priority,
      DateTime? dueDate,
      String? assigneeId,
      String? parentTaskId,
      int? position,
      List<String> labelIds,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt,
      DateTime? deletedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      TaskProject? project,
      @JsonKey(includeFromJson: true, includeToJson: false)
      TaskAssignee? assignee,
      @JsonKey(includeFromJson: true, includeToJson: false)
      List<TaskLabel>? labels,
      @JsonKey(includeFromJson: true, includeToJson: false)
      List<Task>? subtasks});

  $TaskProjectCopyWith<$Res>? get project;
  $TaskAssigneeCopyWith<$Res>? get assignee;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? projectId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? assigneeId = freezed,
    Object? parentTaskId = freezed,
    Object? position = freezed,
    Object? labelIds = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? deletedAt = freezed,
    Object? project = freezed,
    Object? assignee = freezed,
    Object? labels = freezed,
    Object? subtasks = freezed,
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
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      labelIds: null == labelIds
          ? _value.labelIds
          : labelIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as TaskProject?,
      assignee: freezed == assignee
          ? _value.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as TaskAssignee?,
      labels: freezed == labels
          ? _value.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<TaskLabel>?,
      subtasks: freezed == subtasks
          ? _value.subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Task>?,
    ) as $Val);
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskProjectCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $TaskProjectCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskAssigneeCopyWith<$Res>? get assignee {
    if (_value.assignee == null) {
      return null;
    }

    return $TaskAssigneeCopyWith<$Res>(_value.assignee!, (value) {
      return _then(_value.copyWith(assignee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String? projectId,
      String title,
      String? description,
      String status,
      String? priority,
      DateTime? dueDate,
      String? assigneeId,
      String? parentTaskId,
      int? position,
      List<String> labelIds,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt,
      DateTime? deletedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      TaskProject? project,
      @JsonKey(includeFromJson: true, includeToJson: false)
      TaskAssignee? assignee,
      @JsonKey(includeFromJson: true, includeToJson: false)
      List<TaskLabel>? labels,
      @JsonKey(includeFromJson: true, includeToJson: false)
      List<Task>? subtasks});

  @override
  $TaskProjectCopyWith<$Res>? get project;
  @override
  $TaskAssigneeCopyWith<$Res>? get assignee;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? projectId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? assigneeId = freezed,
    Object? parentTaskId = freezed,
    Object? position = freezed,
    Object? labelIds = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? deletedAt = freezed,
    Object? project = freezed,
    Object? assignee = freezed,
    Object? labels = freezed,
    Object? subtasks = freezed,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentTaskId: freezed == parentTaskId
          ? _value.parentTaskId
          : parentTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      labelIds: null == labelIds
          ? _value._labelIds
          : labelIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as TaskProject?,
      assignee: freezed == assignee
          ? _value.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as TaskAssignee?,
      labels: freezed == labels
          ? _value._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<TaskLabel>?,
      subtasks: freezed == subtasks
          ? _value._subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Task>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.workspaceId,
      this.projectId,
      required this.title,
      this.description,
      this.status = 'todo',
      this.priority,
      this.dueDate,
      this.assigneeId,
      this.parentTaskId,
      this.position,
      final List<String> labelIds = const [],
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt,
      this.deletedAt,
      @JsonKey(includeFromJson: true, includeToJson: false) this.project,
      @JsonKey(includeFromJson: true, includeToJson: false) this.assignee,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final List<TaskLabel>? labels = const [],
      @JsonKey(includeFromJson: true, includeToJson: false)
      final List<Task>? subtasks = const []})
      : _labelIds = labelIds,
        _labels = labels,
        _subtasks = subtasks;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String workspaceId;
  @override
  final String? projectId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final String status;
  @override
  final String? priority;
  @override
  final DateTime? dueDate;
  @override
  final String? assigneeId;
  @override
  final String? parentTaskId;
  @override
  final int? position;
  final List<String> _labelIds;
  @override
  @JsonKey()
  List<String> get labelIds {
    if (_labelIds is EqualUnmodifiableListView) return _labelIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labelIds);
  }

  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? deletedAt;
// Related data (from joins)
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final TaskProject? project;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final TaskAssignee? assignee;
  final List<TaskLabel>? _labels;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<TaskLabel>? get labels {
    final value = _labels;
    if (value == null) return null;
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Task>? _subtasks;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<Task>? get subtasks {
    final value = _subtasks;
    if (value == null) return null;
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Task(id: $id, workspaceId: $workspaceId, projectId: $projectId, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, assigneeId: $assigneeId, parentTaskId: $parentTaskId, position: $position, labelIds: $labelIds, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, deletedAt: $deletedAt, project: $project, assignee: $assignee, labels: $labels, subtasks: $subtasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.assigneeId, assigneeId) ||
                other.assigneeId == assigneeId) &&
            (identical(other.parentTaskId, parentTaskId) ||
                other.parentTaskId == parentTaskId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            const DeepCollectionEquality().equals(other._labelIds, _labelIds) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        workspaceId,
        projectId,
        title,
        description,
        status,
        priority,
        dueDate,
        assigneeId,
        parentTaskId,
        position,
        const DeepCollectionEquality().hash(_labelIds),
        createdBy,
        createdAt,
        updatedAt,
        completedAt,
        deletedAt,
        project,
        assignee,
        const DeepCollectionEquality().hash(_labels),
        const DeepCollectionEquality().hash(_subtasks)
      ]);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String workspaceId,
      final String? projectId,
      required final String title,
      final String? description,
      final String status,
      final String? priority,
      final DateTime? dueDate,
      final String? assigneeId,
      final String? parentTaskId,
      final int? position,
      final List<String> labelIds,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? completedAt,
      final DateTime? deletedAt,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final TaskProject? project,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final TaskAssignee? assignee,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final List<TaskLabel>? labels,
      @JsonKey(includeFromJson: true, includeToJson: false)
      final List<Task>? subtasks}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get workspaceId;
  @override
  String? get projectId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get status;
  @override
  String? get priority;
  @override
  DateTime? get dueDate;
  @override
  String? get assigneeId;
  @override
  String? get parentTaskId;
  @override
  int? get position;
  @override
  List<String> get labelIds;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get deletedAt; // Related data (from joins)
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  TaskProject? get project;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  TaskAssignee? get assignee;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<TaskLabel>? get labels;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<Task>? get subtasks;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskProject _$TaskProjectFromJson(Map<String, dynamic> json) {
  return _TaskProject.fromJson(json);
}

/// @nodoc
mixin _$TaskProject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this TaskProject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskProjectCopyWith<TaskProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskProjectCopyWith<$Res> {
  factory $TaskProjectCopyWith(
          TaskProject value, $Res Function(TaskProject) then) =
      _$TaskProjectCopyWithImpl<$Res, TaskProject>;
  @useResult
  $Res call({String id, String name, String? color, String? icon});
}

/// @nodoc
class _$TaskProjectCopyWithImpl<$Res, $Val extends TaskProject>
    implements $TaskProjectCopyWith<$Res> {
  _$TaskProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = freezed,
    Object? icon = freezed,
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskProjectImplCopyWith<$Res>
    implements $TaskProjectCopyWith<$Res> {
  factory _$$TaskProjectImplCopyWith(
          _$TaskProjectImpl value, $Res Function(_$TaskProjectImpl) then) =
      __$$TaskProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? color, String? icon});
}

/// @nodoc
class __$$TaskProjectImplCopyWithImpl<$Res>
    extends _$TaskProjectCopyWithImpl<$Res, _$TaskProjectImpl>
    implements _$$TaskProjectImplCopyWith<$Res> {
  __$$TaskProjectImplCopyWithImpl(
      _$TaskProjectImpl _value, $Res Function(_$TaskProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$TaskProjectImpl(
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskProjectImpl implements _TaskProject {
  const _$TaskProjectImpl(
      {required this.id, required this.name, this.color, this.icon});

  factory _$TaskProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? color;
  @override
  final String? icon;

  @override
  String toString() {
    return 'TaskProject(id: $id, name: $name, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color, icon);

  /// Create a copy of TaskProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskProjectImplCopyWith<_$TaskProjectImpl> get copyWith =>
      __$$TaskProjectImplCopyWithImpl<_$TaskProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskProjectImplToJson(
      this,
    );
  }
}

abstract class _TaskProject implements TaskProject {
  const factory _TaskProject(
      {required final String id,
      required final String name,
      final String? color,
      final String? icon}) = _$TaskProjectImpl;

  factory _TaskProject.fromJson(Map<String, dynamic> json) =
      _$TaskProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get color;
  @override
  String? get icon;

  /// Create a copy of TaskProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskProjectImplCopyWith<_$TaskProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskAssignee _$TaskAssigneeFromJson(Map<String, dynamic> json) {
  return _TaskAssignee.fromJson(json);
}

/// @nodoc
mixin _$TaskAssignee {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this TaskAssignee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskAssignee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskAssigneeCopyWith<TaskAssignee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskAssigneeCopyWith<$Res> {
  factory $TaskAssigneeCopyWith(
          TaskAssignee value, $Res Function(TaskAssignee) then) =
      _$TaskAssigneeCopyWithImpl<$Res, TaskAssignee>;
  @useResult
  $Res call({String id, String name, String? avatarUrl});
}

/// @nodoc
class _$TaskAssigneeCopyWithImpl<$Res, $Val extends TaskAssignee>
    implements $TaskAssigneeCopyWith<$Res> {
  _$TaskAssigneeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskAssignee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskAssigneeImplCopyWith<$Res>
    implements $TaskAssigneeCopyWith<$Res> {
  factory _$$TaskAssigneeImplCopyWith(
          _$TaskAssigneeImpl value, $Res Function(_$TaskAssigneeImpl) then) =
      __$$TaskAssigneeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? avatarUrl});
}

/// @nodoc
class __$$TaskAssigneeImplCopyWithImpl<$Res>
    extends _$TaskAssigneeCopyWithImpl<$Res, _$TaskAssigneeImpl>
    implements _$$TaskAssigneeImplCopyWith<$Res> {
  __$$TaskAssigneeImplCopyWithImpl(
      _$TaskAssigneeImpl _value, $Res Function(_$TaskAssigneeImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskAssignee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$TaskAssigneeImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskAssigneeImpl implements _TaskAssignee {
  const _$TaskAssigneeImpl(
      {required this.id, required this.name, this.avatarUrl});

  factory _$TaskAssigneeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskAssigneeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'TaskAssignee(id: $id, name: $name, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskAssigneeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl);

  /// Create a copy of TaskAssignee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskAssigneeImplCopyWith<_$TaskAssigneeImpl> get copyWith =>
      __$$TaskAssigneeImplCopyWithImpl<_$TaskAssigneeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskAssigneeImplToJson(
      this,
    );
  }
}

abstract class _TaskAssignee implements TaskAssignee {
  const factory _TaskAssignee(
      {required final String id,
      required final String name,
      final String? avatarUrl}) = _$TaskAssigneeImpl;

  factory _TaskAssignee.fromJson(Map<String, dynamic> json) =
      _$TaskAssigneeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;

  /// Create a copy of TaskAssignee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskAssigneeImplCopyWith<_$TaskAssigneeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskLabel _$TaskLabelFromJson(Map<String, dynamic> json) {
  return _TaskLabel.fromJson(json);
}

/// @nodoc
mixin _$TaskLabel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  /// Serializes this TaskLabel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskLabelCopyWith<TaskLabel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskLabelCopyWith<$Res> {
  factory $TaskLabelCopyWith(TaskLabel value, $Res Function(TaskLabel) then) =
      _$TaskLabelCopyWithImpl<$Res, TaskLabel>;
  @useResult
  $Res call({String id, String name, String color});
}

/// @nodoc
class _$TaskLabelCopyWithImpl<$Res, $Val extends TaskLabel>
    implements $TaskLabelCopyWith<$Res> {
  _$TaskLabelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskLabelImplCopyWith<$Res>
    implements $TaskLabelCopyWith<$Res> {
  factory _$$TaskLabelImplCopyWith(
          _$TaskLabelImpl value, $Res Function(_$TaskLabelImpl) then) =
      __$$TaskLabelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String color});
}

/// @nodoc
class __$$TaskLabelImplCopyWithImpl<$Res>
    extends _$TaskLabelCopyWithImpl<$Res, _$TaskLabelImpl>
    implements _$$TaskLabelImplCopyWith<$Res> {
  __$$TaskLabelImplCopyWithImpl(
      _$TaskLabelImpl _value, $Res Function(_$TaskLabelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
  }) {
    return _then(_$TaskLabelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskLabelImpl implements _TaskLabel {
  const _$TaskLabelImpl(
      {required this.id, required this.name, required this.color});

  factory _$TaskLabelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskLabelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String color;

  @override
  String toString() {
    return 'TaskLabel(id: $id, name: $name, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskLabelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color);

  /// Create a copy of TaskLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskLabelImplCopyWith<_$TaskLabelImpl> get copyWith =>
      __$$TaskLabelImplCopyWithImpl<_$TaskLabelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskLabelImplToJson(
      this,
    );
  }
}

abstract class _TaskLabel implements TaskLabel {
  const factory _TaskLabel(
      {required final String id,
      required final String name,
      required final String color}) = _$TaskLabelImpl;

  factory _TaskLabel.fromJson(Map<String, dynamic> json) =
      _$TaskLabelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;

  /// Create a copy of TaskLabel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskLabelImplCopyWith<_$TaskLabelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
