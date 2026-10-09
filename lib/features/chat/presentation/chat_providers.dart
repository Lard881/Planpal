import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/core/services/supabase_service.dart';
import 'package:planpal/features/chat/data/chat_repository.dart';

/// Chat repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(apiClientProvider);
  final supabase = ref.watch(supabaseServiceProvider);

  final repo = ChatRepository(db: db, api: api, supabase: supabase);

  ref.onDispose(() {
    repo.dispose();
  });

  return repo;
});

/// Channels list for a workspace
final channelsProvider = StreamProvider.family<List<Channel>, String>((ref, workspaceId) {
  final repo = ref.watch(chatRepositoryProvider);
  
  // Trigger initial sync
  Future.microtask(() => repo.syncChannels(workspaceId));
  
  // Subscribe to realtime updates
  Future.microtask(() => repo.subscribeToChannels(workspaceId));

  return repo.watchChannels(workspaceId);
});

/// Messages for a channel
final messagesProvider = StreamProvider.family<List<Message>, String>((ref, channelId) {
  final repo = ref.watch(chatRepositoryProvider);

  // Trigger initial sync
  Future.microtask(() => repo.syncMessages(channelId));

  // Subscribe to realtime updates
  Future.microtask(() => repo.subscribeToChannel(channelId));

  return repo.watchMessages(channelId);
});

/// Unread count for a channel
final unreadCountProvider = StreamProvider.family<int, String>((ref, channelId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchUnreadCount(channelId);
});

/// Pending message count provider
final pendingMessageCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getPendingMessageCount();
});

/// Send message controller
final sendMessageProvider = Provider<SendMessageController>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return SendMessageController(repo);
});

/// Controller for sending messages
class SendMessageController {
  final ChatRepository _repo;

  SendMessageController(this._repo);

  Future<String> send({
    required String channelId,
    String? body,
    String? fileId,
  }) async {
    return await _repo.sendMessage(
      channelId: channelId,
      body: body,
      fileId: fileId,
    );
  }

  Future<void> edit(String messageId, String newBody) async {
    await _repo.editMessage(messageId, newBody);
  }

  Future<void> delete(String messageId) async {
    await _repo.deleteMessage(messageId);
  }

  Future<void> markAsRead(String channelId) async {
    await _repo.markChannelAsRead(channelId);
  }

  Future<void> retry(String messageId) async {
    await _repo.retryMessage(messageId);
  }

  Future<void> syncPending() async {
    await _repo.syncPendingMessages();
  }
}

/// API client provider (from core)
final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError('ApiClient provider must be overridden');
});

/// Supabase service provider (from core)
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});
