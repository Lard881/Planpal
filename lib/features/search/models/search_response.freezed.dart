// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) {
  return _SearchResponse.fromJson(json);
}

/// @nodoc
mixin _$SearchResponse {
  SearchCounts get counts => throw _privateConstructorUsedError;
  List<SearchResult> get results => throw _privateConstructorUsedError;

  /// Serializes this SearchResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResponseCopyWith<SearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResponseCopyWith<$Res> {
  factory $SearchResponseCopyWith(
          SearchResponse value, $Res Function(SearchResponse) then) =
      _$SearchResponseCopyWithImpl<$Res, SearchResponse>;
  @useResult
  $Res call({SearchCounts counts, List<SearchResult> results});

  $SearchCountsCopyWith<$Res> get counts;
}

/// @nodoc
class _$SearchResponseCopyWithImpl<$Res, $Val extends SearchResponse>
    implements $SearchResponseCopyWith<$Res> {
  _$SearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as SearchCounts,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SearchResult>,
    ) as $Val);
  }

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchCountsCopyWith<$Res> get counts {
    return $SearchCountsCopyWith<$Res>(_value.counts, (value) {
      return _then(_value.copyWith(counts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchResponseImplCopyWith<$Res>
    implements $SearchResponseCopyWith<$Res> {
  factory _$$SearchResponseImplCopyWith(_$SearchResponseImpl value,
          $Res Function(_$SearchResponseImpl) then) =
      __$$SearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SearchCounts counts, List<SearchResult> results});

  @override
  $SearchCountsCopyWith<$Res> get counts;
}

/// @nodoc
class __$$SearchResponseImplCopyWithImpl<$Res>
    extends _$SearchResponseCopyWithImpl<$Res, _$SearchResponseImpl>
    implements _$$SearchResponseImplCopyWith<$Res> {
  __$$SearchResponseImplCopyWithImpl(
      _$SearchResponseImpl _value, $Res Function(_$SearchResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? results = null,
  }) {
    return _then(_$SearchResponseImpl(
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as SearchCounts,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SearchResult>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResponseImpl implements _SearchResponse {
  const _$SearchResponseImpl(
      {required this.counts, required final List<SearchResult> results})
      : _results = results;

  factory _$SearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResponseImplFromJson(json);

  @override
  final SearchCounts counts;
  final List<SearchResult> _results;
  @override
  List<SearchResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'SearchResponse(counts: $counts, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResponseImpl &&
            (identical(other.counts, counts) || other.counts == counts) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, counts, const DeepCollectionEquality().hash(_results));

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResponseImplCopyWith<_$SearchResponseImpl> get copyWith =>
      __$$SearchResponseImplCopyWithImpl<_$SearchResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResponseImplToJson(
      this,
    );
  }
}

abstract class _SearchResponse implements SearchResponse {
  const factory _SearchResponse(
      {required final SearchCounts counts,
      required final List<SearchResult> results}) = _$SearchResponseImpl;

  factory _SearchResponse.fromJson(Map<String, dynamic> json) =
      _$SearchResponseImpl.fromJson;

  @override
  SearchCounts get counts;
  @override
  List<SearchResult> get results;

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResponseImplCopyWith<_$SearchResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchCounts _$SearchCountsFromJson(Map<String, dynamic> json) {
  return _SearchCounts.fromJson(json);
}

/// @nodoc
mixin _$SearchCounts {
  int get all => throw _privateConstructorUsedError;
  int get task => throw _privateConstructorUsedError;
  int get document => throw _privateConstructorUsedError;
  int get person => throw _privateConstructorUsedError;

  /// Serializes this SearchCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchCountsCopyWith<SearchCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchCountsCopyWith<$Res> {
  factory $SearchCountsCopyWith(
          SearchCounts value, $Res Function(SearchCounts) then) =
      _$SearchCountsCopyWithImpl<$Res, SearchCounts>;
  @useResult
  $Res call({int all, int task, int document, int person});
}

/// @nodoc
class _$SearchCountsCopyWithImpl<$Res, $Val extends SearchCounts>
    implements $SearchCountsCopyWith<$Res> {
  _$SearchCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? all = null,
    Object? task = null,
    Object? document = null,
    Object? person = null,
  }) {
    return _then(_value.copyWith(
      all: null == all
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as int,
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as int,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as int,
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchCountsImplCopyWith<$Res>
    implements $SearchCountsCopyWith<$Res> {
  factory _$$SearchCountsImplCopyWith(
          _$SearchCountsImpl value, $Res Function(_$SearchCountsImpl) then) =
      __$$SearchCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int all, int task, int document, int person});
}

/// @nodoc
class __$$SearchCountsImplCopyWithImpl<$Res>
    extends _$SearchCountsCopyWithImpl<$Res, _$SearchCountsImpl>
    implements _$$SearchCountsImplCopyWith<$Res> {
  __$$SearchCountsImplCopyWithImpl(
      _$SearchCountsImpl _value, $Res Function(_$SearchCountsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? all = null,
    Object? task = null,
    Object? document = null,
    Object? person = null,
  }) {
    return _then(_$SearchCountsImpl(
      all: null == all
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as int,
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as int,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as int,
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchCountsImpl implements _SearchCounts {
  const _$SearchCountsImpl(
      {required this.all,
      required this.task,
      required this.document,
      required this.person});

  factory _$SearchCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchCountsImplFromJson(json);

  @override
  final int all;
  @override
  final int task;
  @override
  final int document;
  @override
  final int person;

  @override
  String toString() {
    return 'SearchCounts(all: $all, task: $task, document: $document, person: $person)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchCountsImpl &&
            (identical(other.all, all) || other.all == all) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.document, document) ||
                other.document == document) &&
            (identical(other.person, person) || other.person == person));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, all, task, document, person);

  /// Create a copy of SearchCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchCountsImplCopyWith<_$SearchCountsImpl> get copyWith =>
      __$$SearchCountsImplCopyWithImpl<_$SearchCountsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchCountsImplToJson(
      this,
    );
  }
}

abstract class _SearchCounts implements SearchCounts {
  const factory _SearchCounts(
      {required final int all,
      required final int task,
      required final int document,
      required final int person}) = _$SearchCountsImpl;

  factory _SearchCounts.fromJson(Map<String, dynamic> json) =
      _$SearchCountsImpl.fromJson;

  @override
  int get all;
  @override
  int get task;
  @override
  int get document;
  @override
  int get person;

  /// Create a copy of SearchCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchCountsImplCopyWith<_$SearchCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
