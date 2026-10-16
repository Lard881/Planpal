// app/lib/core/providers/presence_provider.dart
// #3 — Real-time presence via Supabase Realtime Presence channel.
// Tracks which users are online/away/offline using heartbeat timestamps.
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/avatar.dart';

class PresenceNotifier extends StateNotifier<Map<String, PresenceStatus>> {
  RealtimeChannel? _channel;
  Timer? _heartbeat;
  final String workspaceId;

  PresenceNotifier(this.workspaceId) : super({}) {
    if (workspaceId.isNotEmpty) _subscribe();
  }

  void _subscribe() {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    _channel = client.channel(
      'presence:$workspaceId',
      opts: const RealtimeChannelConfig(self: true),
    );

    _channel!
        .onPresenceSync((RealtimePresenceSyncPayload payload) => _updateState())
        .onPresenceJoin((RealtimePresenceJoinPayload payload) => _updateState())
        .onPresenceLeave(
          (RealtimePresenceLeavePayload payload) => _updateState(),
        )
        .subscribe((RealtimeSubscribeStatus status, Object? error) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _channel!.track({
              'user_id': userId,
              'online_at': DateTime.now().millisecondsSinceEpoch,
            });
            _heartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
              _channel!.track({
                'user_id': userId,
                'online_at': DateTime.now().millisecondsSinceEpoch,
              });
            });
          }
        });
  }

  void _updateState() {
    final rawState = _channel?.presenceState();
    if (rawState == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final updated = <String, PresenceStatus>{};

    for (final presence in rawState) {
      for (final p in presence.presences) {
        final userId = p.payload['user_id'] as String?;
        final onlineAt = p.payload['online_at'] as int?;
        if (userId == null) continue;

        PresenceStatus status;
        if (onlineAt == null) {
          status = PresenceStatus.offline;
        } else {
          final diffSeconds = (now - onlineAt) ~/ 1000;
          if (diffSeconds < 60) {
            status = PresenceStatus.online;
          } else if (diffSeconds < 300) {
            status = PresenceStatus.away;
          } else {
            status = PresenceStatus.offline;
          }
        }
        updated[userId] = status;
      }
    }

    state = updated;
  }

  PresenceStatus statusFor(String userId) =>
      state[userId] ?? PresenceStatus.offline;

  @override
  void dispose() {
    _heartbeat?.cancel();
    _channel?.unsubscribe();
    super.dispose();
  }
}

final presenceProvider = StateNotifierProvider.family
    .autoDispose<PresenceNotifier, Map<String, PresenceStatus>, String>(
      (ref, workspaceId) => PresenceNotifier(workspaceId),
    );
