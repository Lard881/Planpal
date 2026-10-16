import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/app_failure.dart';
import '../data/chat_repository.dart';
import '../models/chat_models.dart';

const _messageUuid = Uuid();

final channelsProvider = FutureProvider.autoDispose
    .family<List<ChannelModel>, String>((ref, workspaceId) async {
      if (workspaceId.isEmpty) return [];
      final (list, failure) = await ref
          .watch(chatRepositoryProvider)
          .getChannels(workspaceId);
      if (failure != null && list.isEmpty) throw failure;
      return list;
    });

class MessagesNotifier extends StateNotifier<List<MessageModel>> {
  final ChatRepository _repo;
  final String workspaceId;
  final String channelId;
  RealtimeChannel? _realtimeSub;
  bool hasMore = true;
  bool _loadingOlder = false;
  int _loadGeneration = 0;

  MessagesNotifier(this._repo, this.workspaceId, this.channelId) : super([]) {
    unawaited(_load());
    _subscribe();
  }

  Future<void> _load() async {
    final generation = ++_loadGeneration;
    final (messages, failure) = await _repo.getMessages(workspaceId, channelId);
    if (generation != _loadGeneration) return;
    hasMore = messages.length >= 50 && failure == null;
    _merge(messages);
    if (failure == null) unawaited(_repo.markRead(channelId));
  }

  void _subscribe() {
    _realtimeSub = _repo.subscribeToMessages(channelId, (message) {
      _merge([message]);
      unawaited(_repo.saveMessage(message, workspaceId));
    }, onReconnect: () => unawaited(_load()));
  }

  void _merge(Iterable<MessageModel> messages) {
    final merged = {for (final message in state) message.id: message};
    for (final message in messages) {
      merged[message.id] = message;
    }
    state = merged.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> loadOlder() async {
    if (_loadingOlder || !hasMore || state.isEmpty) return;
    _loadingOlder = true;
    try {
      final cursor = state.first.createdAt.toUtc().toIso8601String();
      final (messages, failure) = await _repo.getMessages(
        workspaceId,
        channelId,
        cursor: cursor,
      );
      hasMore = failure == null && messages.length >= 50;
      _merge(messages);
    } finally {
      _loadingOlder = false;
    }
  }

  Future<void> send(
    String body, {
    String? fileId,
    String? fileName,
    String? fileMimeType,
  }) async {
    final messageId = _messageUuid.v4();
    final user = Supabase.instance.client.auth.currentUser;
    final message = MessageModel(
      id: messageId,
      channelId: channelId,
      senderId: user?.id ?? '',
      senderName: user?.userMetadata?['full_name'] as String?,
      body: body,
      fileId: fileId,
      fileName: fileName,
      fileMimeType: fileMimeType,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    _merge([message]);
    final (sent, failure) = await _repo.sendMessage(
      workspaceId,
      channelId,
      clientId: messageId,
      body: body,
      fileId: fileId,
      fileName: fileName,
      fileMimeType: fileMimeType,
      senderId: user?.id,
      senderName: user?.userMetadata?['full_name'] as String?,
    );
    if (sent != null) {
      _merge([sent]);
    } else if (failure != null) {
      _merge([_copyWithStatus(message, MessageStatus.failed)]);
    }
  }

  Future<void> retry(String messageId) async {
    final index = state.indexWhere((message) => message.id == messageId);
    if (index < 0) return;
    final message = state[index];
    _merge([_copyWithStatus(message, MessageStatus.sending)]);
    final (sent, failure) = await _repo.sendMessage(
      workspaceId,
      channelId,
      clientId: message.id,
      body: message.body,
      fileId: message.fileId,
      fileName: message.fileName,
      fileMimeType: message.fileMimeType,
      senderId: message.senderId,
      senderName: message.senderName,
    );
    if (sent != null) {
      _merge([sent]);
    } else if (failure != null) {
      _merge([_copyWithStatus(message, MessageStatus.failed)]);
    }
  }

  Future<AppFailure?> edit(String messageId, String body) async {
    final (message, failure) = await _repo.editMessage(messageId, body);
    if (message != null) _merge([message]);
    return failure;
  }

  Future<AppFailure?> delete(String messageId) async {
    final failure = await _repo.deleteMessage(messageId);
    if (failure == null) {
      state = state.where((message) => message.id != messageId).toList();
    }
    return failure;
  }

  MessageModel _copyWithStatus(MessageModel message, MessageStatus status) =>
      MessageModel(
        id: message.id,
        channelId: message.channelId,
        senderId: message.senderId,
        senderName: message.senderName,
        senderAvatarUrl: message.senderAvatarUrl,
        body: message.body,
        fileId: message.fileId,
        fileName: message.fileName,
        fileMimeType: message.fileMimeType,
        createdAt: message.createdAt,
        editedAt: message.editedAt,
        status: status,
      );

  @override
  void dispose() {
    _realtimeSub?.unsubscribe();
    super.dispose();
  }
}

final messagesProvider = StateNotifierProvider.autoDispose
    .family<
      MessagesNotifier,
      List<MessageModel>,
      ({String workspaceId, String channelId})
    >(
      (ref, args) => MessagesNotifier(
        ref.watch(chatRepositoryProvider),
        args.workspaceId,
        args.channelId,
      ),
    );

final chatAttachmentUrlProvider = FutureProvider.autoDispose
    .family<String, String>((ref, fileId) async {
      final (url, failure) = await ref
          .watch(chatRepositoryProvider)
          .getDownloadUrl(fileId);
      if (failure != null) throw failure;
      if (url == null) throw const ServerFailure('File URL was not returned.');
      return url;
    });
