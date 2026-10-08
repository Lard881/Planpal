import 'dart:async';
import 'package:drift/drift.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart' as Rx;

/// Repository for chat channels and messages
class ChatRepository {
  final AppDatabase _db;
  final ApiClient _api;
  final SupabaseService _supabase;
  final _uuid = const Uuid();

  StreamSubscription? _messagesSubscription;
  StreamSubscription? _channelsSubscription;

  ChatRepository({
    required AppDatabase db,
    required ApiClient api,
    required SupabaseService supabase,
  })  : _db = db,
        _api = api,
        _supabase = supabase;

  // ===== CHANNELS =====

  /// Get all channels for a workspace (local cache)
  Stream<List<Channel>> watchChannels(String workspaceId) {
    return (_db.select(_db.channels)
          ..where((c) => c.workspaceId.equals(workspaceId))
          ..where((c) => c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Get unread count for a channel
  Future<int> getUnreadCount(String channelId) async {
    final currentUserId = _supabase.currentUserId;
    if (currentUserId == null) return 0;

    // Get last read timestamp
    final member = await (_db.select(_db.channelMembers)
          ..where((cm) => cm.channelId.equals(channelId) & cm.userId.equals(currentUserId)))
        .getSingleOrNull();

    if (member == null) return 0;

    // Count messages after last read
    final count = await (_db.selectOnly(_db.messages)
          ..addColumns([_db.messages.id.count()])
          ..where(_db.messages.channelId.equals(channelId))
          ..where(_db.messages.deletedAt.isNull())
          ..where(_db.messages.createdAt.isBiggerThanValue(member.lastReadAt)))
        .getSingle();

    return count.read(_db.messages.id.count()) ?? 0;
  }

  /// Watch unread count for a channel
  Stream<int> watchUnreadCount(String channelId) {
    final currentUserId = _supabase.currentUserId;
    if (currentUserId == null) return Stream.value(0);

    // Combine member and messages streams
    return Rx.combineLatest2<ChannelMember?, List<Message>, int>(
      (_db.select(_db.channelMembers)
            ..where((cm) => cm.channelId.equals(channelId) & cm.userId.equals(currentUserId)))
          .watchSingleOrNull(),
      (_db.select(_db.messages)
            ..where((m) => m.channelId.equals(channelId))
            ..where((m) => m.deletedAt.isNull()))
          .watch(),
      (member, messages) {
        if (member == null) return 0;
        return messages.where((m) => m.createdAt.isAfter(member.lastReadAt)).length;
      },
    );
  }

  /// Sync channels from server
  Future<void> syncChannels(String workspaceId) async {
    try {
      final response = await _api.get('/workspaces/$workspaceId/channels');
      final channels = (response.data['channels'] as List)
          .map((json) => _channelFromJson(json))
          .toList();

      await _db.batch((batch) {
        batch.insertAll(
          _db.channels,
          channels,
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {
      // If sync fails, continue with local cache
      rethrow;
    }
  }

  /// Create a new channel
  Future<String> createChannel({
    required String workspaceId,
    required String name,
    String? description,
    bool isPrivate = false,
    List<String> memberIds = const [],
  }) async {
    final response = await _api.post(
      '/workspaces/$workspaceId/channels',
      data: {
        'name': name,
        'description': description,
        'isPrivate': isPrivate,
        'memberIds': memberIds,
      },
    );

    final channel = _channelFromJson(response.data['channel']);
    await _db.into(_db.channels).insert(channel, mode: InsertMode.insertOrReplace);

    return channel.id;
  }

  /// Get or create a DM channel with another user
  Future<String> getOrCreateDM({
    required String workspaceId,
    required String userId,
  }) async {
    final response = await _api.post(
      '/workspaces/$workspaceId/dms',
      data: {'userId': userId},
    );

    final channel = _channelFromJson(response.data['channel']);
    await _db.into(_db.channels).insert(channel, mode: InsertMode.insertOrReplace);

    return channel.id;
  }

  // ===== MESSAGES =====

  /// Watch messages for a channel (local cache, descending order)
  Stream<List<Message>> watchMessages(String channelId, {int limit = 50}) {
    return (_db.select(_db.messages)
          ..where((m) => m.channelId.equals(channelId))
          ..where((m) => m.deletedAt.isNull())
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  /// Sync message history from server
  Future<void> syncMessages(String channelId, {DateTime? before, int limit = 50}) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        if (before != null) 'before': before.toIso8601String(),
      };

      final response = await _api.get(
        '/channels/$channelId/messages',
        queryParameters: queryParams,
      );

      final messages = (response.data['messages'] as List)
          .map((json) => _messageFromJson(json))
          .toList();

      await _db.batch((batch) {
        batch.insertAll(
          _db.messages,
          messages,
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Send a message (with retry and offline support)
  Future<String> sendMessage({
    required String channelId,
    String? body,
    String? fileId,
  }) async {
    if (body == null && fileId == null) {
      throw ArgumentError('Message must have body or fileId');
    }

    final messageId = _uuid.v4();
    final now = DateTime.now();

    // Insert into local DB immediately (optimistic UI)
    final localMessage = MessagesCompanion.insert(
      id: messageId,
      channelId: channelId,
      senderId: _supabase.currentUserId!,
      body: Value(body ?? ''),
      fileId: Value(fileId),
      createdAt: now,
      updatedAt: now,
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.messages).insert(localMessage);

    // Try to send to server
    try {
      await _api.post(
        '/channels/$channelId/messages',
        data: {
          'id': messageId,
          'body': body,
          'fileId': fileId,
        },
      );

      // Mark as synced
      await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
          .write(const MessagesCompanion(syncStatus: Value('synced')));
    } catch (e) {
      // Mark as failed, will retry later
      await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
          .write(const MessagesCompanion(syncStatus: Value('failed')));
      rethrow;
    }

    return messageId;
  }

  /// Edit a message
  Future<void> editMessage(String messageId, String newBody) async {
    await _api.patch('/messages/$messageId', data: {'body': newBody});

    await (_db.update(_db.messages)..where((m) => m.id.equals(messageId))).write(
      MessagesCompanion(
        body: Value(newBody),
        editedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    await _api.delete('/messages/$messageId');

    await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
        .write(MessagesCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Mark channel as read
  Future<void> markChannelAsRead(String channelId) async {
    await _api.post('/channels/$channelId/read');

    // Update local last_read_at
    await (_db.update(_db.channelMembers)
          ..where((cm) => cm.channelId.equals(channelId) & cm.userId.equals(_supabase.currentUserId!)))
        .write(ChannelMembersCompanion(
      lastReadAt: Value(DateTime.now()),
    ));
  }

  /// Retry a failed message
  Future<void> retryMessage(String messageId) async {
    final message = await (_db.select(_db.messages)
          ..where((m) => m.id.equals(messageId)))
        .getSingleOrNull();

    if (message == null) return;

    // Mark as pending
    await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
        .write(const MessagesCompanion(syncStatus: Value('pending')));

    try {
      await _api.post(
        '/channels/${message.channelId}/messages',
        data: {
          'id': message.id,
          'body': message.body,
          'fileId': message.fileId,
        },
      );

      // Mark as synced
      await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
          .write(const MessagesCompanion(syncStatus: Value('synced')));
    } catch (e) {
      // Mark as failed again
      await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
          .write(const MessagesCompanion(syncStatus: Value('failed')));
      rethrow;
    }
  }

  /// Sync all pending messages
  Future<void> syncPendingMessages() async {
    final pending = await (_db.select(_db.messages)
          ..where((m) => m.syncStatus.equals('pending') | m.syncStatus.equals('failed')))
        .get();

    for (final message in pending) {
      try {
        await _api.post(
          '/channels/${message.channelId}/messages',
          data: {
            'id': message.id,
            'body': message.body,
            'fileId': message.fileId,
          },
        );

        await (_db.update(_db.messages)..where((m) => m.id.equals(message.id)))
            .write(const MessagesCompanion(syncStatus: Value('synced')));
      } catch (e) {
        // Keep as failed, will retry later
      }
    }
  }

  /// Get count of pending/failed messages
  Future<int> getPendingMessageCount() async {
    final count = await (_db.selectOnly(_db.messages)
          ..addColumns([_db.messages.id.count()])
          ..where(_db.messages.syncStatus.equals('pending') | _db.messages.syncStatus.equals('failed')))
        .getSingle();

    return count.read(_db.messages.id.count()) ?? 0;
  }

  // ===== REALTIME SUBSCRIPTIONS =====

  /// Subscribe to new messages in a channel
  void subscribeToChannel(String channelId) {
    _messagesSubscription?.cancel();

    _messagesSubscription = _supabase.client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('channel_id', channelId)
        .listen((data) {
          // Insert/update messages in local DB
          final messages = data.map((json) => _messageFromJson(json)).toList();
          _db.batch((batch) {
            batch.insertAll(
              _db.messages,
              messages,
              mode: InsertMode.insertOrReplace,
            );
          });
        });
  }

  /// Subscribe to channel list updates
  void subscribeToChannels(String workspaceId) {
    _channelsSubscription?.cancel();

    _channelsSubscription = _supabase.client
        .from('channels')
        .stream(primaryKey: ['id'])
        .eq('workspace_id', workspaceId)
        .listen((data) {
          final channels = data.map((json) => _channelFromJson(json)).toList();
          _db.batch((batch) {
            batch.insertAll(
              _db.channels,
              channels,
              mode: InsertMode.insertOrReplace,
            );
          });
        });
  }

  // ===== PRESENCE & TYPING =====

  /// Track online presence for current user
  final Map<String, sp.RealtimeChannel> _presenceChannels = {};

  /// Subscribe to presence in a channel
  Stream<Map<String, dynamic>> subscribeToPresence(String channelId) {
    final channel = _supabase.client.channel('presence:$channelId');
    
    channel.onPresenceSync((payload) {
      // Presence sync callback
    }).onPresenceJoin((payload) {
      // User joined
    }).onPresenceLeave((payload) {
      // User left
    });

    channel.subscribe((status, error) {
      if (status == sp.RealtimeSubscribeStatus.subscribed) {
        // Track presence
        channel.track({
          'user_id': _supabase.currentUserId,
          'online_at': DateTime.now().toIso8601String(),
        });
      }
    });

    _presenceChannels[channelId] = channel;

    // Return a stream of presence state
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return channel.presenceState();
    });
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(String channelId) async {
    final channel = _presenceChannels[channelId];
    if (channel != null) {
      await channel.track({
        'user_id': _supabase.currentUserId,
        'typing': true,
        'typing_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Clear typing indicator
  Future<void> clearTypingIndicator(String channelId) async {
    final channel = _presenceChannels[channelId];
    if (channel != null) {
      await channel.track({
        'user_id': _supabase.currentUserId,
        'typing': false,
      });
    }
  }

  /// Unsubscribe from realtime
  void dispose() {
    _messagesSubscription?.cancel();
    _channelsSubscription?.cancel();
    
    // Unsubscribe from all presence channels
    for (final channel in _presenceChannels.values) {
      channel.unsubscribe();
    }
    _presenceChannels.clear();
  }

  // ===== HELPER METHODS =====

  ChannelsCompanion _channelFromJson(Map<String, dynamic> json) {
    return ChannelsCompanion.insert(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      kind: json['kind'] as String? ?? 'channel',
      name: Value(json['name'] as String?),
      description: Value(json['description'] as String? ?? ''),
      isPrivate: Value(json['is_private'] as bool? ?? false),
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: Value(json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null),
      syncStatus: const Value('synced'),
    );
  }

  MessagesCompanion _messageFromJson(Map<String, dynamic> json) {
    return MessagesCompanion.insert(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      senderId: json['sender_id'] as String? ?? json['author_id'] as String,
      body: Value(json['body'] as String? ?? ''),
      fileId: Value(json['file_id'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: Value(json['edited_at'] != null ? DateTime.parse(json['edited_at'] as String) : null),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: Value(json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null),
      syncStatus: const Value('synced'),
    );
  }
}
