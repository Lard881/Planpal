// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) {
  return _SearchResultItem.fromJson(json);
}

/// @nodoc
mixin _$SearchResultItem {
  String get id => throw _privateConstructorUsedError;
  SearchResultType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  String? get workspaceName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SearchResultItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResultItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultItemCopyWith<SearchResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultItemCopyWith<$Res> {
  factory $SearchResultItemCopyWith(
          SearchResultItem value, $Res Function(SearchResultItem) then) =
      _$SearchResultItemCopyWithImpl<$Res, SearchResultItem>;
  @useResult
  $Res call(
      {String id,
      SearchResultType type,
      String title,
      String? description,
      int matchScore,
      String? workspaceId,
      String? workspaceName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SearchResultItemCopyWithImpl<$Res, $Val extends SearchResultItem>
    implements $SearchResultItemCopyWith<$Res> {
  _$SearchResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResultItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? matchScore = null,
    Object? workspaceId = freezed,
    Object? workspaceName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SearchResultType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultItemImplCopyWith<$Res>
    implements $SearchResultItemCopyWith<$Res> {
  factory _$$SearchResultItemImplCopyWith(_$SearchResultItemImpl value,
          $Res Function(_$SearchResultItemImpl) then) =
      __$$SearchResultItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      SearchResultType type,
      String title,
      String? description,
      int matchScore,
      String? workspaceId,
      String? workspaceName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SearchResultItemImplCopyWithImpl<$Res>
    extends _$SearchResultItemCopyWithImpl<$Res, _$SearchResultItemImpl>
    implements _$$SearchResultItemImplCopyWith<$Res> {
  __$$SearchResultItemImplCopyWithImpl(_$SearchResultItemImpl _value,
      $Res Function(_$SearchResultItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResultItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? matchScore = null,
    Object? workspaceId = freezed,
    Object? workspaceName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SearchResultItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SearchResultType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultItemImpl implements _SearchResultItem {
  const _$SearchResultItemImpl(
      {required this.id,
      required this.type,
      required this.title,
      this.description,
      required this.matchScore,
      this.workspaceId,
      this.workspaceName,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$SearchResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultItemImplFromJson(json);

  @override
  final String id;
  @override
  final SearchResultType type;
  @override
  final String title;
  @override
  final String? description;
  @override
  final int matchScore;
  @override
  final String? workspaceId;
  @override
  final String? workspaceName;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SearchResultItem(id: $id, type: $type, title: $title, description: $description, matchScore: $matchScore, workspaceId: $workspaceId, workspaceName: $workspaceName, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.workspaceName, workspaceName) ||
                other.workspaceName == workspaceName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      description,
      matchScore,
      workspaceId,
      workspaceName,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SearchResultItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultItemImplCopyWith<_$SearchResultItemImpl> get copyWith =>
      __$$SearchResultItemImplCopyWithImpl<_$SearchResultItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultItemImplToJson(
      this,
    );
  }
}

abstract class _SearchResultItem implements SearchResultItem {
  const factory _SearchResultItem(
      {required final String id,
      required final SearchResultType type,
      required final String title,
      final String? description,
      required final int matchScore,
      final String? workspaceId,
      final String? workspaceName,
      final Map<String, dynamic>? metadata}) = _$SearchResultItemImpl;

  factory _SearchResultItem.fromJson(Map<String, dynamic> json) =
      _$SearchResultItemImpl.fromJson;

  @override
  String get id;
  @override
  SearchResultType get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  int get matchScore;
  @override
  String? get workspaceId;
  @override
  String? get workspaceName;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SearchResultItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultItemImplCopyWith<_$SearchResultItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskSearchResult _$TaskSearchResultFromJson(Map<String, dynamic> json) {
  return _TaskSearchResult.fromJson(json);
}

/// @nodoc
mixin _$TaskSearchResult {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String? get workspaceName => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;

  /// Serializes this TaskSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskSearchResultCopyWith<TaskSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskSearchResultCopyWith<$Res> {
  factory $TaskSearchResultCopyWith(
          TaskSearchResult value, $Res Function(TaskSearchResult) then) =
      _$TaskSearchResultCopyWithImpl<$Res, TaskSearchResult>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String status,
      String? priority,
      DateTime? dueDate,
      String workspaceId,
      String? workspaceName,
      String? projectId,
      String? assignedTo,
      DateTime createdAt,
      int matchScore});
}

/// @nodoc
class _$TaskSearchResultCopyWithImpl<$Res, $Val extends TaskSearchResult>
    implements $TaskSearchResultCopyWith<$Res> {
  _$TaskSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? workspaceId = null,
    Object? workspaceName = freezed,
    Object? projectId = freezed,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? matchScore = null,
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
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskSearchResultImplCopyWith<$Res>
    implements $TaskSearchResultCopyWith<$Res> {
  factory _$$TaskSearchResultImplCopyWith(_$TaskSearchResultImpl value,
          $Res Function(_$TaskSearchResultImpl) then) =
      __$$TaskSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String status,
      String? priority,
      DateTime? dueDate,
      String workspaceId,
      String? workspaceName,
      String? projectId,
      String? assignedTo,
      DateTime createdAt,
      int matchScore});
}

/// @nodoc
class __$$TaskSearchResultImplCopyWithImpl<$Res>
    extends _$TaskSearchResultCopyWithImpl<$Res, _$TaskSearchResultImpl>
    implements _$$TaskSearchResultImplCopyWith<$Res> {
  __$$TaskSearchResultImplCopyWithImpl(_$TaskSearchResultImpl _value,
      $Res Function(_$TaskSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? workspaceId = null,
    Object? workspaceName = freezed,
    Object? projectId = freezed,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? matchScore = null,
  }) {
    return _then(_$TaskSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskSearchResultImpl implements _TaskSearchResult {
  const _$TaskSearchResultImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.status,
      this.priority,
      this.dueDate,
      required this.workspaceId,
      this.workspaceName,
      this.projectId,
      this.assignedTo,
      required this.createdAt,
      required this.matchScore});

  factory _$TaskSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskSearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String status;
  @override
  final String? priority;
  @override
  final DateTime? dueDate;
  @override
  final String workspaceId;
  @override
  final String? workspaceName;
  @override
  final String? projectId;
  @override
  final String? assignedTo;
  @override
  final DateTime createdAt;
  @override
  final int matchScore;

  @override
  String toString() {
    return 'TaskSearchResult(id: $id, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, workspaceId: $workspaceId, workspaceName: $workspaceName, projectId: $projectId, assignedTo: $assignedTo, createdAt: $createdAt, matchScore: $matchScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.workspaceName, workspaceName) ||
                other.workspaceName == workspaceName) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      status,
      priority,
      dueDate,
      workspaceId,
      workspaceName,
      projectId,
      assignedTo,
      createdAt,
      matchScore);

  /// Create a copy of TaskSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskSearchResultImplCopyWith<_$TaskSearchResultImpl> get copyWith =>
      __$$TaskSearchResultImplCopyWithImpl<_$TaskSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskSearchResultImplToJson(
      this,
    );
  }
}

abstract class _TaskSearchResult implements TaskSearchResult {
  const factory _TaskSearchResult(
      {required final String id,
      required final String title,
      final String? description,
      required final String status,
      final String? priority,
      final DateTime? dueDate,
      required final String workspaceId,
      final String? workspaceName,
      final String? projectId,
      final String? assignedTo,
      required final DateTime createdAt,
      required final int matchScore}) = _$TaskSearchResultImpl;

  factory _TaskSearchResult.fromJson(Map<String, dynamic> json) =
      _$TaskSearchResultImpl.fromJson;

  @override
  String get id;
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
  String get workspaceId;
  @override
  String? get workspaceName;
  @override
  String? get projectId;
  @override
  String? get assignedTo;
  @override
  DateTime get createdAt;
  @override
  int get matchScore;

  /// Create a copy of TaskSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskSearchResultImplCopyWith<_$TaskSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentSearchResult _$DocumentSearchResultFromJson(Map<String, dynamic> json) {
  return _DocumentSearchResult.fromJson(json);
}

/// @nodoc
mixin _$DocumentSearchResult {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String? get workspaceName => throw _privateConstructorUsedError;
  String? get folderId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;

  /// Serializes this DocumentSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentSearchResultCopyWith<DocumentSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentSearchResultCopyWith<$Res> {
  factory $DocumentSearchResultCopyWith(DocumentSearchResult value,
          $Res Function(DocumentSearchResult) then) =
      _$DocumentSearchResultCopyWithImpl<$Res, DocumentSearchResult>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? content,
      String workspaceId,
      String? workspaceName,
      String? folderId,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      int matchScore});
}

/// @nodoc
class _$DocumentSearchResultCopyWithImpl<$Res,
        $Val extends DocumentSearchResult>
    implements $DocumentSearchResultCopyWith<$Res> {
  _$DocumentSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = freezed,
    Object? workspaceId = null,
    Object? workspaceName = freezed,
    Object? folderId = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? matchScore = null,
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
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentSearchResultImplCopyWith<$Res>
    implements $DocumentSearchResultCopyWith<$Res> {
  factory _$$DocumentSearchResultImplCopyWith(_$DocumentSearchResultImpl value,
          $Res Function(_$DocumentSearchResultImpl) then) =
      __$$DocumentSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? content,
      String workspaceId,
      String? workspaceName,
      String? folderId,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      int matchScore});
}

/// @nodoc
class __$$DocumentSearchResultImplCopyWithImpl<$Res>
    extends _$DocumentSearchResultCopyWithImpl<$Res, _$DocumentSearchResultImpl>
    implements _$$DocumentSearchResultImplCopyWith<$Res> {
  __$$DocumentSearchResultImplCopyWithImpl(_$DocumentSearchResultImpl _value,
      $Res Function(_$DocumentSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of DocumentSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = freezed,
    Object? workspaceId = null,
    Object? workspaceName = freezed,
    Object? folderId = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? matchScore = null,
  }) {
    return _then(_$DocumentSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      folderId: freezed == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentSearchResultImpl implements _DocumentSearchResult {
  const _$DocumentSearchResultImpl(
      {required this.id,
      required this.title,
      this.content,
      required this.workspaceId,
      this.workspaceName,
      this.folderId,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      required this.matchScore});

  factory _$DocumentSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentSearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? content;
  @override
  final String workspaceId;
  @override
  final String? workspaceName;
  @override
  final String? folderId;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int matchScore;

  @override
  String toString() {
    return 'DocumentSearchResult(id: $id, title: $title, content: $content, workspaceId: $workspaceId, workspaceName: $workspaceName, folderId: $folderId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, matchScore: $matchScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.workspaceName, workspaceName) ||
                other.workspaceName == workspaceName) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, content, workspaceId,
      workspaceName, folderId, createdBy, createdAt, updatedAt, matchScore);

  /// Create a copy of DocumentSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentSearchResultImplCopyWith<_$DocumentSearchResultImpl>
      get copyWith =>
          __$$DocumentSearchResultImplCopyWithImpl<_$DocumentSearchResultImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentSearchResultImplToJson(
      this,
    );
  }
}

abstract class _DocumentSearchResult implements DocumentSearchResult {
  const factory _DocumentSearchResult(
      {required final String id,
      required final String title,
      final String? content,
      required final String workspaceId,
      final String? workspaceName,
      final String? folderId,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final int matchScore}) = _$DocumentSearchResultImpl;

  factory _DocumentSearchResult.fromJson(Map<String, dynamic> json) =
      _$DocumentSearchResultImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get content;
  @override
  String get workspaceId;
  @override
  String? get workspaceName;
  @override
  String? get folderId;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get matchScore;

  /// Create a copy of DocumentSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentSearchResultImplCopyWith<_$DocumentSearchResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PersonWorkspace _$PersonWorkspaceFromJson(Map<String, dynamic> json) {
  return _PersonWorkspace.fromJson(json);
}

/// @nodoc
mixin _$PersonWorkspace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this PersonWorkspace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonWorkspaceCopyWith<PersonWorkspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonWorkspaceCopyWith<$Res> {
  factory $PersonWorkspaceCopyWith(
          PersonWorkspace value, $Res Function(PersonWorkspace) then) =
      _$PersonWorkspaceCopyWithImpl<$Res, PersonWorkspace>;
  @useResult
  $Res call({String id, String name, String role});
}

/// @nodoc
class _$PersonWorkspaceCopyWithImpl<$Res, $Val extends PersonWorkspace>
    implements $PersonWorkspaceCopyWith<$Res> {
  _$PersonWorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonWorkspaceImplCopyWith<$Res>
    implements $PersonWorkspaceCopyWith<$Res> {
  factory _$$PersonWorkspaceImplCopyWith(_$PersonWorkspaceImpl value,
          $Res Function(_$PersonWorkspaceImpl) then) =
      __$$PersonWorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String role});
}

/// @nodoc
class __$$PersonWorkspaceImplCopyWithImpl<$Res>
    extends _$PersonWorkspaceCopyWithImpl<$Res, _$PersonWorkspaceImpl>
    implements _$$PersonWorkspaceImplCopyWith<$Res> {
  __$$PersonWorkspaceImplCopyWithImpl(
      _$PersonWorkspaceImpl _value, $Res Function(_$PersonWorkspaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
  }) {
    return _then(_$PersonWorkspaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonWorkspaceImpl implements _PersonWorkspace {
  const _$PersonWorkspaceImpl(
      {required this.id, required this.name, required this.role});

  factory _$PersonWorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonWorkspaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String role;

  @override
  String toString() {
    return 'PersonWorkspace(id: $id, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonWorkspaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, role);

  /// Create a copy of PersonWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonWorkspaceImplCopyWith<_$PersonWorkspaceImpl> get copyWith =>
      __$$PersonWorkspaceImplCopyWithImpl<_$PersonWorkspaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonWorkspaceImplToJson(
      this,
    );
  }
}

abstract class _PersonWorkspace implements PersonWorkspace {
  const factory _PersonWorkspace(
      {required final String id,
      required final String name,
      required final String role}) = _$PersonWorkspaceImpl;

  factory _PersonWorkspace.fromJson(Map<String, dynamic> json) =
      _$PersonWorkspaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get role;

  /// Create a copy of PersonWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonWorkspaceImplCopyWith<_$PersonWorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonSearchResult _$PersonSearchResultFromJson(Map<String, dynamic> json) {
  return _PersonSearchResult.fromJson(json);
}

/// @nodoc
mixin _$PersonSearchResult {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  List<PersonWorkspace> get workspaces => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;

  /// Serializes this PersonSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonSearchResultCopyWith<PersonSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonSearchResultCopyWith<$Res> {
  factory $PersonSearchResultCopyWith(
          PersonSearchResult value, $Res Function(PersonSearchResult) then) =
      _$PersonSearchResultCopyWithImpl<$Res, PersonSearchResult>;
  @useResult
  $Res call(
      {String id,
      String fullName,
      String email,
      String? avatarUrl,
      List<PersonWorkspace> workspaces,
      int matchScore});
}

/// @nodoc
class _$PersonSearchResultCopyWithImpl<$Res, $Val extends PersonSearchResult>
    implements $PersonSearchResultCopyWith<$Res> {
  _$PersonSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? workspaces = null,
    Object? matchScore = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaces: null == workspaces
          ? _value.workspaces
          : workspaces // ignore: cast_nullable_to_non_nullable
              as List<PersonWorkspace>,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonSearchResultImplCopyWith<$Res>
    implements $PersonSearchResultCopyWith<$Res> {
  factory _$$PersonSearchResultImplCopyWith(_$PersonSearchResultImpl value,
          $Res Function(_$PersonSearchResultImpl) then) =
      __$$PersonSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fullName,
      String email,
      String? avatarUrl,
      List<PersonWorkspace> workspaces,
      int matchScore});
}

/// @nodoc
class __$$PersonSearchResultImplCopyWithImpl<$Res>
    extends _$PersonSearchResultCopyWithImpl<$Res, _$PersonSearchResultImpl>
    implements _$$PersonSearchResultImplCopyWith<$Res> {
  __$$PersonSearchResultImplCopyWithImpl(_$PersonSearchResultImpl _value,
      $Res Function(_$PersonSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? workspaces = null,
    Object? matchScore = null,
  }) {
    return _then(_$PersonSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaces: null == workspaces
          ? _value._workspaces
          : workspaces // ignore: cast_nullable_to_non_nullable
              as List<PersonWorkspace>,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonSearchResultImpl implements _PersonSearchResult {
  const _$PersonSearchResultImpl(
      {required this.id,
      required this.fullName,
      required this.email,
      this.avatarUrl,
      required final List<PersonWorkspace> workspaces,
      required this.matchScore})
      : _workspaces = workspaces;

  factory _$PersonSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonSearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String? avatarUrl;
  final List<PersonWorkspace> _workspaces;
  @override
  List<PersonWorkspace> get workspaces {
    if (_workspaces is EqualUnmodifiableListView) return _workspaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workspaces);
  }

  @override
  final int matchScore;

  @override
  String toString() {
    return 'PersonSearchResult(id: $id, fullName: $fullName, email: $email, avatarUrl: $avatarUrl, workspaces: $workspaces, matchScore: $matchScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality()
                .equals(other._workspaces, _workspaces) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, email, avatarUrl,
      const DeepCollectionEquality().hash(_workspaces), matchScore);

  /// Create a copy of PersonSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonSearchResultImplCopyWith<_$PersonSearchResultImpl> get copyWith =>
      __$$PersonSearchResultImplCopyWithImpl<_$PersonSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonSearchResultImplToJson(
      this,
    );
  }
}

abstract class _PersonSearchResult implements PersonSearchResult {
  const factory _PersonSearchResult(
      {required final String id,
      required final String fullName,
      required final String email,
      final String? avatarUrl,
      required final List<PersonWorkspace> workspaces,
      required final int matchScore}) = _$PersonSearchResultImpl;

  factory _PersonSearchResult.fromJson(Map<String, dynamic> json) =
      _$PersonSearchResultImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String get email;
  @override
  String? get avatarUrl;
  @override
  List<PersonWorkspace> get workspaces;
  @override
  int get matchScore;

  /// Create a copy of PersonSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonSearchResultImplCopyWith<_$PersonSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchResults _$SearchResultsFromJson(Map<String, dynamic> json) {
  return _SearchResults.fromJson(json);
}

/// @nodoc
mixin _$SearchResults {
  String get query => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  SearchResultsGroup get tasks => throw _privateConstructorUsedError;
  SearchResultsGroup get documents => throw _privateConstructorUsedError;
  SearchResultsGroup get people => throw _privateConstructorUsedError;

  /// Serializes this SearchResults to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultsCopyWith<SearchResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultsCopyWith<$Res> {
  factory $SearchResultsCopyWith(
          SearchResults value, $Res Function(SearchResults) then) =
      _$SearchResultsCopyWithImpl<$Res, SearchResults>;
  @useResult
  $Res call(
      {String query,
      String type,
      String? workspaceId,
      int totalCount,
      SearchResultsGroup tasks,
      SearchResultsGroup documents,
      SearchResultsGroup people});

  $SearchResultsGroupCopyWith<$Res> get tasks;
  $SearchResultsGroupCopyWith<$Res> get documents;
  $SearchResultsGroupCopyWith<$Res> get people;
}

/// @nodoc
class _$SearchResultsCopyWithImpl<$Res, $Val extends SearchResults>
    implements $SearchResultsCopyWith<$Res> {
  _$SearchResultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? type = null,
    Object? workspaceId = freezed,
    Object? totalCount = null,
    Object? tasks = null,
    Object? documents = null,
    Object? people = null,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
      people: null == people
          ? _value.people
          : people // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
    ) as $Val);
  }

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchResultsGroupCopyWith<$Res> get tasks {
    return $SearchResultsGroupCopyWith<$Res>(_value.tasks, (value) {
      return _then(_value.copyWith(tasks: value) as $Val);
    });
  }

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchResultsGroupCopyWith<$Res> get documents {
    return $SearchResultsGroupCopyWith<$Res>(_value.documents, (value) {
      return _then(_value.copyWith(documents: value) as $Val);
    });
  }

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchResultsGroupCopyWith<$Res> get people {
    return $SearchResultsGroupCopyWith<$Res>(_value.people, (value) {
      return _then(_value.copyWith(people: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchResultsImplCopyWith<$Res>
    implements $SearchResultsCopyWith<$Res> {
  factory _$$SearchResultsImplCopyWith(
          _$SearchResultsImpl value, $Res Function(_$SearchResultsImpl) then) =
      __$$SearchResultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      String type,
      String? workspaceId,
      int totalCount,
      SearchResultsGroup tasks,
      SearchResultsGroup documents,
      SearchResultsGroup people});

  @override
  $SearchResultsGroupCopyWith<$Res> get tasks;
  @override
  $SearchResultsGroupCopyWith<$Res> get documents;
  @override
  $SearchResultsGroupCopyWith<$Res> get people;
}

/// @nodoc
class __$$SearchResultsImplCopyWithImpl<$Res>
    extends _$SearchResultsCopyWithImpl<$Res, _$SearchResultsImpl>
    implements _$$SearchResultsImplCopyWith<$Res> {
  __$$SearchResultsImplCopyWithImpl(
      _$SearchResultsImpl _value, $Res Function(_$SearchResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? type = null,
    Object? workspaceId = freezed,
    Object? totalCount = null,
    Object? tasks = null,
    Object? documents = null,
    Object? people = null,
  }) {
    return _then(_$SearchResultsImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
      people: null == people
          ? _value.people
          : people // ignore: cast_nullable_to_non_nullable
              as SearchResultsGroup,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultsImpl implements _SearchResults {
  const _$SearchResultsImpl(
      {required this.query,
      required this.type,
      this.workspaceId,
      required this.totalCount,
      required this.tasks,
      required this.documents,
      required this.people});

  factory _$SearchResultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultsImplFromJson(json);

  @override
  final String query;
  @override
  final String type;
  @override
  final String? workspaceId;
  @override
  final int totalCount;
  @override
  final SearchResultsGroup tasks;
  @override
  final SearchResultsGroup documents;
  @override
  final SearchResultsGroup people;

  @override
  String toString() {
    return 'SearchResults(query: $query, type: $type, workspaceId: $workspaceId, totalCount: $totalCount, tasks: $tasks, documents: $documents, people: $people)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultsImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.documents, documents) ||
                other.documents == documents) &&
            (identical(other.people, people) || other.people == people));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, query, type, workspaceId,
      totalCount, tasks, documents, people);

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultsImplCopyWith<_$SearchResultsImpl> get copyWith =>
      __$$SearchResultsImplCopyWithImpl<_$SearchResultsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultsImplToJson(
      this,
    );
  }
}

abstract class _SearchResults implements SearchResults {
  const factory _SearchResults(
      {required final String query,
      required final String type,
      final String? workspaceId,
      required final int totalCount,
      required final SearchResultsGroup tasks,
      required final SearchResultsGroup documents,
      required final SearchResultsGroup people}) = _$SearchResultsImpl;

  factory _SearchResults.fromJson(Map<String, dynamic> json) =
      _$SearchResultsImpl.fromJson;

  @override
  String get query;
  @override
  String get type;
  @override
  String? get workspaceId;
  @override
  int get totalCount;
  @override
  SearchResultsGroup get tasks;
  @override
  SearchResultsGroup get documents;
  @override
  SearchResultsGroup get people;

  /// Create a copy of SearchResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultsImplCopyWith<_$SearchResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchResultsGroup _$SearchResultsGroupFromJson(Map<String, dynamic> json) {
  return _SearchResultsGroup.fromJson(json);
}

/// @nodoc
mixin _$SearchResultsGroup {
  List<dynamic> get items => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this SearchResultsGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResultsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultsGroupCopyWith<SearchResultsGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultsGroupCopyWith<$Res> {
  factory $SearchResultsGroupCopyWith(
          SearchResultsGroup value, $Res Function(SearchResultsGroup) then) =
      _$SearchResultsGroupCopyWithImpl<$Res, SearchResultsGroup>;
  @useResult
  $Res call({List<dynamic> items, int count});
}

/// @nodoc
class _$SearchResultsGroupCopyWithImpl<$Res, $Val extends SearchResultsGroup>
    implements $SearchResultsGroupCopyWith<$Res> {
  _$SearchResultsGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResultsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultsGroupImplCopyWith<$Res>
    implements $SearchResultsGroupCopyWith<$Res> {
  factory _$$SearchResultsGroupImplCopyWith(_$SearchResultsGroupImpl value,
          $Res Function(_$SearchResultsGroupImpl) then) =
      __$$SearchResultsGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<dynamic> items, int count});
}

/// @nodoc
class __$$SearchResultsGroupImplCopyWithImpl<$Res>
    extends _$SearchResultsGroupCopyWithImpl<$Res, _$SearchResultsGroupImpl>
    implements _$$SearchResultsGroupImplCopyWith<$Res> {
  __$$SearchResultsGroupImplCopyWithImpl(_$SearchResultsGroupImpl _value,
      $Res Function(_$SearchResultsGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResultsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? count = null,
  }) {
    return _then(_$SearchResultsGroupImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultsGroupImpl implements _SearchResultsGroup {
  const _$SearchResultsGroupImpl(
      {required final List<dynamic> items, required this.count})
      : _items = items;

  factory _$SearchResultsGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultsGroupImplFromJson(json);

  final List<dynamic> _items;
  @override
  List<dynamic> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'SearchResultsGroup(items: $items, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultsGroupImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), count);

  /// Create a copy of SearchResultsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultsGroupImplCopyWith<_$SearchResultsGroupImpl> get copyWith =>
      __$$SearchResultsGroupImplCopyWithImpl<_$SearchResultsGroupImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultsGroupImplToJson(
      this,
    );
  }
}

abstract class _SearchResultsGroup implements SearchResultsGroup {
  const factory _SearchResultsGroup(
      {required final List<dynamic> items,
      required final int count}) = _$SearchResultsGroupImpl;

  factory _SearchResultsGroup.fromJson(Map<String, dynamic> json) =
      _$SearchResultsGroupImpl.fromJson;

  @override
  List<dynamic> get items;
  @override
  int get count;

  /// Create a copy of SearchResultsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultsGroupImplCopyWith<_$SearchResultsGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) {
  return _SearchFilter.fromJson(json);
}

/// @nodoc
mixin _$SearchFilter {
  String get type => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterCopyWith<SearchFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterCopyWith<$Res> {
  factory $SearchFilterCopyWith(
          SearchFilter value, $Res Function(SearchFilter) then) =
      _$SearchFilterCopyWithImpl<$Res, SearchFilter>;
  @useResult
  $Res call({String type, String? workspaceId, int limit, int offset});
}

/// @nodoc
class _$SearchFilterCopyWithImpl<$Res, $Val extends SearchFilter>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? workspaceId = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchFilterImplCopyWith<$Res>
    implements $SearchFilterCopyWith<$Res> {
  factory _$$SearchFilterImplCopyWith(
          _$SearchFilterImpl value, $Res Function(_$SearchFilterImpl) then) =
      __$$SearchFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String? workspaceId, int limit, int offset});
}

/// @nodoc
class __$$SearchFilterImplCopyWithImpl<$Res>
    extends _$SearchFilterCopyWithImpl<$Res, _$SearchFilterImpl>
    implements _$$SearchFilterImplCopyWith<$Res> {
  __$$SearchFilterImplCopyWithImpl(
      _$SearchFilterImpl _value, $Res Function(_$SearchFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? workspaceId = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$SearchFilterImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterImpl implements _SearchFilter {
  const _$SearchFilterImpl(
      {this.type = 'all', this.workspaceId, this.limit = 20, this.offset = 0});

  factory _$SearchFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  final String? workspaceId;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int offset;

  @override
  String toString() {
    return 'SearchFilter(type: $type, workspaceId: $workspaceId, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, workspaceId, limit, offset);

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      __$$SearchFilterImplCopyWithImpl<_$SearchFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterImplToJson(
      this,
    );
  }
}

abstract class _SearchFilter implements SearchFilter {
  const factory _SearchFilter(
      {final String type,
      final String? workspaceId,
      final int limit,
      final int offset}) = _$SearchFilterImpl;

  factory _SearchFilter.fromJson(Map<String, dynamic> json) =
      _$SearchFilterImpl.fromJson;

  @override
  String get type;
  @override
  String? get workspaceId;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
