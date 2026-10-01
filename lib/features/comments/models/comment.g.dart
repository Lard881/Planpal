// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      parentId: json['parentId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      mentions: (json['mentions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      author: json['author'] == null
          ? null
          : CommentAuthor.fromJson(json['author'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      replyCount: (json['replyCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'authorId': instance.authorId,
      'content': instance.content,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'mentions': instance.mentions,
      'author': instance.author,
      'replies': instance.replies,
      'replyCount': instance.replyCount,
    };

_$CommentAuthorImpl _$$CommentAuthorImplFromJson(Map<String, dynamic> json) =>
    _$CommentAuthorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$CommentAuthorImplToJson(_$CommentAuthorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'email': instance.email,
    };

_$CreateCommentRequestImpl _$$CreateCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCommentRequestImpl(
      id: json['id'] as String?,
      taskId: json['taskId'] as String,
      content: json['content'] as String,
      parentId: json['parentId'] as String?,
      mentions: (json['mentions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CreateCommentRequestImplToJson(
        _$CreateCommentRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'content': instance.content,
      'parentId': instance.parentId,
      'mentions': instance.mentions,
    };

_$UpdateCommentRequestImpl _$$UpdateCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCommentRequestImpl(
      content: json['content'] as String,
    );

Map<String, dynamic> _$$UpdateCommentRequestImplToJson(
        _$UpdateCommentRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
    };

_$CommentsResponseImpl _$$CommentsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CommentsResponseImpl(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      pagination: json['pagination'] == null
          ? null
          : CommentsPagination.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentsResponseImplToJson(
        _$CommentsResponseImpl instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'total': instance.total,
      'pagination': instance.pagination,
    };

_$CommentsPaginationImpl _$$CommentsPaginationImplFromJson(
        Map<String, dynamic> json) =>
    _$CommentsPaginationImpl(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$CommentsPaginationImplToJson(
        _$CommentsPaginationImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };
