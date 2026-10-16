import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/sync/sync_engine.dart';
import '../models/chat_models.dart';

bool _isTemporaryFailure(AppFailure failure) =>
    failure is NetworkFailure ||
    failure is TimeoutFailure ||
    failure is ServerUnreachableFailure;

class ChatRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;
  ChatRepository(this._dio, this._db, this._sync);

  Future<void> _cacheChannels(List<ChannelModel> channels) async {
    await _db.transaction(() async {
      for (final channel in channels) {
        await _db
            .into(_db.chatChannels)
            .insertOnConflictUpdate(
              ChatChannelsCompanion(
                id: Value(channel.id),
                workspaceId: Value(channel.workspaceId),
                kind: Value(channel.kind),
                name: Value(channel.name),
                description: Value(channel.description),
                isPrivate: Value(channel.isPrivate),
                unreadCount: Value(channel.unreadCount),
                lastMessageBody: Value(channel.lastMessageBody),
                lastMessageSenderName: Value(channel.lastMessageSenderName),
                lastMessageAt: Value(channel.lastMessageAt),
                memberIds: Value(jsonEncode(channel.memberIds)),
                memberNames: Value(jsonEncode(channel.memberNames)),
              ),
            );
      }
    });
  }

  Future<List<ChannelModel>> _cachedChannels(String workspaceId) async {
    final rows =
        await (_db.select(_db.chatChannels)
              ..where((row) => row.workspaceId.equals(workspaceId))
              ..orderBy([
                (row) => OrderingTerm.desc(row.lastMessageAt),
                (row) => OrderingTerm.asc(row.name),
              ]))
            .get();
    return rows
        .map(
          (row) => ChannelModel(
            id: row.id,
            workspaceId: row.workspaceId,
            kind: row.kind,
            name: row.name,
            description: row.description,
            isPrivate: row.isPrivate,
            unreadCount: row.unreadCount,
            lastMessageBody: row.lastMessageBody,
            lastMessageSenderName: row.lastMessageSenderName,
            lastMessageAt: row.lastMessageAt,
            memberIds: (jsonDecode(row.memberIds) as List).cast<String>(),
            memberNames: (jsonDecode(row.memberNames) as List).cast<String>(),
          ),
        )
        .toList();
  }

  Future<void> _cacheMessage(MessageModel message, String workspaceId) async {
    await _db
        .into(_db.chatMessages)
        .insertOnConflictUpdate(
          ChatMessagesCompanion(
            id: Value(message.id),
            workspaceId: Value(workspaceId),
            channelId: Value(message.channelId),
            senderId: Value(message.senderId),
            senderName: Value(message.senderName),
            senderAvatarUrl: Value(message.senderAvatarUrl),
            body: Value(message.body),
            fileId: Value(message.fileId),
            fileName: Value(message.fileName),
            fileMimeType: Value(message.fileMimeType),
            createdAt: Value(message.createdAt),
            editedAt: Value(message.editedAt),
            status: Value(message.status.name),
          ),
        );
    final oldRows =
        await (_db.select(_db.chatMessages)
              ..where((row) => row.channelId.equals(message.channelId))
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
              ..limit(1000, offset: 200))
            .get();
    if (oldRows.isNotEmpty) {
      await (_db.delete(
        _db.chatMessages,
      )..where((row) => row.id.isIn(oldRows.map((row) => row.id)))).go();
    }
  }

  Future<void> saveMessage(MessageModel message, String workspaceId) =>
      _cacheMessage(message, workspaceId);

  Future<List<MessageModel>> _cachedMessages(
    String channelId, {
    DateTime? before,
  }) async {
    final query = _db.select(_db.chatMessages)
      ..where((row) => row.channelId.equals(channelId))
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    if (before != null) {
      query.where((row) => row.createdAt.isSmallerThanValue(before));
    }
    final rows = await query.get();
    return rows
        .map(
          (row) => MessageModel(
            id: row.id,
            channelId: row.channelId,
            senderId: row.senderId,
            senderName: row.senderName,
            senderAvatarUrl: row.senderAvatarUrl,
            body: row.body,
            fileId: row.fileId,
            fileName: row.fileName,
            fileMimeType: row.fileMimeType,
            createdAt: row.createdAt,
            editedAt: row.editedAt,
            status: MessageStatus.values.firstWhere(
              (status) => status.name == row.status,
              orElse: () => MessageStatus.sent,
            ),
          ),
        )
        .toList();
  }

  Future<(List<ChannelModel>, AppFailure?)> getChannels(
    String workspaceId,
  ) async {
    try {
      final res = await _dio.get('/workspaces/$workspaceId/channels');
      final list = (res.data['channels'] as List)
          .map((c) => ChannelModel.fromJson(c as Map<String, dynamic>))
          .toList();
      await _cacheChannels(list);
      return (list, null);
    } on DioException catch (e) {
      return (await _cachedChannels(workspaceId), mapDioError(e));
    }
  }

  Future<(List<MessageModel>, AppFailure?)> getMessages(
    String workspaceId,
    String channelId, {
    String? cursor,
  }) async {
    try {
      final params = <String, dynamic>{'limit': 50};
      if (cursor != null) params['before'] = cursor;
      final res = await _dio.get(
        '/channels/$channelId/messages',
        queryParameters: params,
      );
      final list = (res.data['messages'] as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
      for (final message in list) {
        await _cacheMessage(message, workspaceId);
      }
      final pending = (await _cachedMessages(channelId))
          .where(
            (message) =>
                message.status != MessageStatus.sent &&
                !list.any((remote) => remote.id == message.id),
          )
          .toList();
      return ([...list, ...pending], null);
    } on DioException catch (e) {
      return (
        await _cachedMessages(
          channelId,
          before: cursor == null ? null : DateTime.tryParse(cursor),
        ),
        mapDioError(e),
      );
    }
  }

  Future<(MessageModel?, AppFailure?)> sendMessage(
    String workspaceId,
    String channelId, {
    required String clientId,
    String body = '',
    String? fileId,
    String? fileName,
    String? fileMimeType,
    String? senderId,
    String? senderName,
  }) async {
    final optimistic = MessageModel(
      id: clientId,
      channelId: channelId,
      senderId: senderId ?? '',
      senderName: senderName,
      body: body,
      fileId: fileId,
      fileName: fileName,
      fileMimeType: fileMimeType,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    try {
      final response = await _dio.post(
        '/channels/$channelId/messages',
        data: {
          'id': clientId,
          'body': body,
          if (fileId != null) 'fileId': fileId,
        },
      );
      final sent = MessageModel.fromJson(
        response.data['message'] as Map<String, dynamic>,
      );
      await _cacheMessage(sent, workspaceId);
      return (sent, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (!_isTemporaryFailure(failure)) return (null, failure);
      await _cacheMessage(optimistic, workspaceId);
      await _sync.queueCreate('chat_messages', clientId, {
        'workspaceId': workspaceId,
        'channelId': channelId,
        'id': clientId,
        'body': body,
        if (fileId != null) 'fileId': fileId,
        if (fileName != null) 'fileName': fileName,
        if (fileMimeType != null) 'fileMimeType': fileMimeType,
        'senderId': senderId,
        'senderName': senderName,
      });
      return (optimistic, null);
    }
  }

  Future<AppFailure?> markRead(String channelId) async {
    try {
      await _dio.post('/channels/$channelId/read');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<(ChannelModel?, AppFailure?)> createChannel(
    String workspaceId, {
    required String name,
    String description = '',
    bool isPrivate = false,
    List<String> memberIds = const [],
  }) async {
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/channels',
        data: {
          'name': name,
          'description': description,
          'isPrivate': isPrivate,
          'memberIds': memberIds,
        },
      );
      return (
        ChannelModel.fromJson(res.data['channel'] as Map<String, dynamic>),
        null,
      );
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(ChannelModel?, AppFailure?)> createDm(
    String workspaceId,
    String userId,
  ) async {
    try {
      final response = await _dio.post(
        '/workspaces/$workspaceId/dms',
        data: {'userId': userId},
      );
      final channel = ChannelModel.fromJson(
        response.data['channel'] as Map<String, dynamic>,
      );
      await _cacheChannels([channel]);
      return (channel, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> addMember(String channelId, String userId) async {
    try {
      await _dio.post('/channels/$channelId/members', data: {'userId': userId});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> removeMember(String channelId, String userId) async {
    try {
      await _dio.delete('/channels/$channelId/members/$userId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<(String?, AppFailure?)> getDownloadUrl(String fileId) async {
    try {
      final response = await _dio.get('/files/$fileId/download-url');
      return (response.data['downloadUrl'] as String, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(MessageModel?, AppFailure?)> editMessage(
    String messageId,
    String body,
  ) async {
    try {
      final response = await _dio.patch(
        '/messages/$messageId',
        data: {'body': body},
      );
      return (
        MessageModel.fromJson(response.data['message'] as Map<String, dynamic>),
        null,
      );
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> deleteMessage(String messageId) async {
    try {
      await _dio.delete('/messages/$messageId');
      await (_db.delete(
        _db.chatMessages,
      )..where((row) => row.id.equals(messageId))).go();
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  RealtimeChannel subscribeToMessages(
    String channelId,
    void Function(MessageModel) onMessage, {
    void Function()? onReconnect,
  }) {
    return Supabase.instance.client
        .channel('messages:$channelId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'channel_id',
            value: channelId,
          ),
          callback: (payload) {
            final record = Map<String, dynamic>.from(payload.newRecord);
            unawaited(_hydrateRealtimeMessage(record, onMessage));
          },
        )
        .subscribe((status, _) {
          if (status == RealtimeSubscribeStatus.subscribed) onReconnect?.call();
        });
  }

  RealtimeChannel subscribeToMembership(
    String channelId,
    void Function() onChanged, {
    void Function()? onReconnect,
  }) {
    return Supabase.instance.client
        .channel('channel-members:$channelId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'channel_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'channel_id',
            value: channelId,
          ),
          callback: (_) => onChanged(),
        )
        .subscribe((status, _) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            onReconnect?.call();
          }
        });
  }

  Future<void> _hydrateRealtimeMessage(
    Map<String, dynamic> record,
    void Function(MessageModel) onMessage,
  ) async {
    final client = Supabase.instance.client;
    final senderId = record['sender_id'] as String?;
    if (senderId != null) {
      final profile = await client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', senderId)
          .maybeSingle();
      if (profile != null) {
        record['sender'] = profile;
      }
    }
    final fileId = record['file_id'] as String?;
    if (fileId != null) {
      final file = await client
          .from('files')
          .select('id, name, mime_type, size_bytes')
          .eq('id', fileId)
          .maybeSingle();
      if (file != null) record['file'] = file;
    }
    onMessage(MessageModel.fromJson(record));
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider.notifier),
  );
});
