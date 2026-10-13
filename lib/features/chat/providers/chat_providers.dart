// app/lib/features/chat/providers/chat_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/chat_repository.dart';
import '../models/chat_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

// Channels list
final channelsProvider =
    FutureProvider.autoDispose.family<List<ChannelModel>, String>(
  (ref, workspaceId) async {
    final (list, _) =
        await ref.watch(chatRepositoryProvider).getChannels(workspaceId);
    return list;
  },
);

// Current channel messages with realtime
class MessagesNotifier extends StateNotifier<List<MessageModel>> {
  final ChatRepository _repo;
  final String workspaceId;
  final String channelId;
  RealtimeChannel? _realtimeSub;

  MessagesNotifier(this._repo, this.workspaceId, this.channelId)
      : super([]) {
    _load();
    _subscribe();
  }

  Future<void> _load() async {
    final (msgs, _) = await _repo.getMessages(channelId);
    // Messages come newest-first from API, reverse for display
    state = msgs.reversed.toList();
  }

  void _subscribe() {
    _realtimeSub = _repo.subscribeToMessages(channelId, (msg) {
      // Append new message from realtime — avoid duplicates
      if (!state.any((m) => m.id == msg.id)) {
        state = [...state, msg];
      }
    });
  }

  Future<void> send(String body) async {
    // Optimistic: add sending message immediately
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final currentUser = Supabase.instance.client.auth.currentUser;
    final tempMsg = MessageModel(
      id: tempId,
      channelId: channelId,
      senderId: currentUser?.id ?? '',
      senderName: 'You',
      body: body,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    state = [...state, tempMsg];

    final (sent, err) = await _repo.sendMessage(workspaceId, channelId, body);
    if (sent != null) {
      // Replace temp with real message
      state = state.map((m) => m.id == tempId ? sent : m).toList();
    } else {
      // Mark as failed
      state = state.map((m) => m.id == tempId
          ? MessageModel(
              id: tempId, channelId: channelId,
              senderId: currentUser?.id ?? '',
              body: body, createdAt: DateTime.now(),
              status: MessageStatus.failed)
          : m).toList();
    }
  }

  Future<void> retry(String tempId, String body) async {
    state = state.map((m) => m.id == tempId
        ? MessageModel(
            id: tempId, channelId: channelId,
            senderId: m.senderId,
            body: body, createdAt: m.createdAt,
            status: MessageStatus.sending)
        : m).toList();

    final (sent, _) = await _repo.sendMessage(workspaceId, channelId, body);
    if (sent != null) {
      state = state.map((m) => m.id == tempId ? sent : m).toList();
    } else {
      state = state.map((m) => m.id == tempId
          ? MessageModel(
              id: tempId, channelId: channelId,
              senderId: m.senderId,
              body: body, createdAt: m.createdAt,
              status: MessageStatus.failed)
          : m).toList();
    }
  }

  @override
  void dispose() {
    _realtimeSub?.unsubscribe();
    super.dispose();
  }
}

final messagesProvider = StateNotifierProvider.autoDispose
    .family<MessagesNotifier, List<MessageModel>, ({String workspaceId, String channelId})>(
  (ref, args) => MessagesNotifier(
    ref.watch(chatRepositoryProvider),
    args.workspaceId,
    args.channelId,
  ),
);
