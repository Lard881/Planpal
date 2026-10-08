import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChatRepository(db);
});

final channelsProvider = StreamProvider.family<List<dynamic>, String>((ref, workspaceId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChannels(workspaceId);
});

final messagesProvider = StreamProvider.family<List<dynamic>, String>((ref, channelId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(channelId);
});
