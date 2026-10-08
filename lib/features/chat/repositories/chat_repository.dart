import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';

/// Stub Chat Repository - Chat feature not yet implemented in database
class ChatRepository {
  final AppDatabase _db;

  ChatRepository(this._db);

  // Chat feature is not implemented yet - these are stubs
  Stream<List<dynamic>> watchMessages(String channelId) {
    return Stream.value([]);
  }

  Future<dynamic> sendMessage(dynamic message) async {
    throw UnimplementedError('Chat feature not yet implemented');
  }

  Stream<List<dynamic>> watchChannels(String workspaceId) {
    return Stream.value([]);
  }

  Future<dynamic> createChannel(dynamic channel) async {
    throw UnimplementedError('Chat feature not yet implemented');
  }
}
