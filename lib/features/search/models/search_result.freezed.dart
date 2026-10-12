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

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'workspace_id')
  String? get workspaceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'workspace_name')
  String? get workspaceName => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_rank')
  double? get matchRank => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) then) =
      _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_type') String entityType,
      String title,
      String? subtitle,
      @JsonKey(name: 'workspace_id') String? workspaceId,
      @JsonKey(name: 'workspace_name') String? workspaceName,
      @JsonKey(name: 'match_rank') double? matchRank,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityType = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? workspaceId = freezed,
    Object? workspaceName = freezed,
    Object? matchRank = freezed,
    Object? avatarUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      matchRank: freezed == matchRank
          ? _value.matchRank
          : matchRank // ignore: cast_nullable_to_non_nullable
              as double?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
          _$SearchResultImpl value, $Res Function(_$SearchResultImpl) then) =
      __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_type') String entityType,
      String title,
      String? subtitle,
      @JsonKey(name: 'workspace_id') String? workspaceId,
      @JsonKey(name: 'workspace_name') String? workspaceName,
      @JsonKey(name: 'match_rank') double? matchRank,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
      _$SearchResultImpl _value, $Res Function(_$SearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityType = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? workspaceId = freezed,
    Object? workspaceName = freezed,
    Object? matchRank = freezed,
    Object? avatarUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SearchResultImpl(
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceId: freezed == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      workspaceName: freezed == workspaceName
          ? _value.workspaceName
          : workspaceName // ignore: cast_nullable_to_non_nullable
              as String?,
      matchRank: freezed == matchRank
          ? _value.matchRank
          : matchRank // ignore: cast_nullable_to_non_nullable
              as double?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
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
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl(
      {@JsonKey(name: 'entity_id') required this.entityId,
      @JsonKey(name: 'entity_type') required this.entityType,
      required this.title,
      this.subtitle,
      @JsonKey(name: 'workspace_id') this.workspaceId,
      @JsonKey(name: 'workspace_name') this.workspaceName,
      @JsonKey(name: 'match_rank') this.matchRank,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  @JsonKey(name: 'workspace_id')
  final String? workspaceId;
  @override
  @JsonKey(name: 'workspace_name')
  final String? workspaceName;
  @override
  @JsonKey(name: 'match_rank')
  final double? matchRank;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
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
    return 'SearchResult(entityId: $entityId, entityType: $entityType, title: $title, subtitle: $subtitle, workspaceId: $workspaceId, workspaceName: $workspaceName, matchRank: $matchRank, avatarUrl: $avatarUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.workspaceName, workspaceName) ||
                other.workspaceName == workspaceName) &&
            (identical(other.matchRank, matchRank) ||
                other.matchRank == matchRank) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      entityId,
      entityType,
      title,
      subtitle,
      workspaceId,
      workspaceName,
      matchRank,
      avatarUrl,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(
      this,
    );
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult(
      {@JsonKey(name: 'entity_id') required final String entityId,
      @JsonKey(name: 'entity_type') required final String entityType,
      required final String title,
      final String? subtitle,
      @JsonKey(name: 'workspace_id') final String? workspaceId,
      @JsonKey(name: 'workspace_name') final String? workspaceName,
      @JsonKey(name: 'match_rank') final double? matchRank,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      final Map<String, dynamic>? metadata}) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  @JsonKey(name: 'workspace_id')
  String? get workspaceId;
  @override
  @JsonKey(name: 'workspace_name')
  String? get workspaceName;
  @override
  @JsonKey(name: 'match_rank')
  double? get matchRank;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
