// app/lib/features/chat/data/chat_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/chat_models.dart';

const _uuid = Uuid();

class ChatRepository {
  final Dio _dio;
  ChatRepository(this._dio);

  Future<(List<ChannelModel>, AppFailure?)> getChannels(
      String workspaceId) async {
    try {
      final res = await _dio.get('/workspaces/$workspaceId/channels');
      final list = (res.data['channels'] as List)
          .map((c) => ChannelModel.fromJson(c as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<ChannelModel>[], mapDioError(e));
    }
  }

  Future<(List<MessageModel>, AppFailure?)> getMessages(
      String channelId, {String? cursor}) async {
    try {
      final params = <String, dynamic>{'limit': 50};
      if (cursor != null) params['cursor'] = cursor;
      final res = await _dio.get('/workspaces/0/channels/$channelId/messages',
          queryParameters: params);
      // The actual endpoint uses workspace-nested path
      final list = (res.data['messages'] as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<MessageModel>[], mapDioError(e));
    }
  }

  Future<(MessageModel?, AppFailure?)> sendMessage(
    String workspaceId,
    String channelId,
    String body,
  ) async {
    final clientId = _uuid.v4();
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/channels/$channelId/messages',
        data: {'id': clientId, 'body': body},
      );
      return (MessageModel.fromJson(
          res.data['message'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> markRead(
      String workspaceId, String channelId) async {
    try {
      await _dio.post(
          '/workspaces/$workspaceId/channels/$channelId/read');
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
  }) async {
    try {
      final res = await _dio.post('/workspaces/$workspaceId/channels', data: {
        'name': name,
        'description': description,
        'is_private': isPrivate,
      });
      return (ChannelModel.fromJson(
          res.data['channel'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  // Realtime subscription
  RealtimeChannel subscribeToMessages(
    String channelId,
    void Function(MessageModel) onMessage,
  ) {
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
            final msg = MessageModel.fromJson(
                payload.newRecord as Map<String, dynamic>);
            onMessage(msg);
          },
        )
        .subscribe();
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(apiClientProvider).dio);
});
