import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationPreferences {
  final bool push;
  final bool inApp;
  final bool assignments;
  final bool comments;
  final bool mentions;
  final bool deadlines;
  final bool chat;

  const NotificationPreferences({
    this.push = true,
    this.inApp = true,
    this.assignments = true,
    this.comments = true,
    this.mentions = true,
    this.deadlines = true,
    this.chat = true,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        push: json['push'] as bool? ?? true,
        inApp: json['inApp'] as bool? ?? true,
        assignments: json['assignments'] as bool? ?? true,
        comments: json['comments'] as bool? ?? true,
        mentions: json['mentions'] as bool? ?? true,
        deadlines: json['deadlines'] as bool? ?? true,
        chat: json['chat'] as bool? ?? true,
      );

  Map<String, bool> toJson() => {
    'push': push,
    'inApp': inApp,
    'assignments': assignments,
    'comments': comments,
    'mentions': mentions,
    'deadlines': deadlines,
    'chat': chat,
  };

  bool allowsType(String? type) {
    return switch (type) {
      'task_assigned' => assignments,
      'task_comment' => comments,
      'mention' => mentions,
      'deadline_approaching' || 'task_overdue' || 'event_reminder' => deadlines,
      'chat_message' => chat,
      _ => true,
    };
  }

  bool allowsInAppType(String? type) => inApp && allowsType(type);

  NotificationPreferences copyWith({
    bool? push,
    bool? inApp,
    bool? assignments,
    bool? comments,
    bool? mentions,
    bool? deadlines,
    bool? chat,
  }) => NotificationPreferences(
    push: push ?? this.push,
    inApp: inApp ?? this.inApp,
    assignments: assignments ?? this.assignments,
    comments: comments ?? this.comments,
    mentions: mentions ?? this.mentions,
    deadlines: deadlines ?? this.deadlines,
    chat: chat ?? this.chat,
  );
}

class NotificationPreferencesNotifier
    extends Notifier<NotificationPreferences> {
  static const _storageKey = 'planpal_notification_preferences';
  static const _storage = FlutterSecureStorage();
  Future<void>? _loadFuture;

  @override
  NotificationPreferences build() {
    unawaited(ensureLoaded());
    return const NotificationPreferences();
  }

  Future<void> ensureLoaded() => _loadFuture ??= _load();

  Future<void> update(NotificationPreferences next) async {
    await ensureLoaded();
    final previous = state;
    state = next;
    try {
      await _storage.write(key: _storageKey, value: jsonEncode(next.toJson()));
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  Future<void> _load() async {
    try {
      final value = await _storage.read(key: _storageKey);
      if (value != null) {
        state = NotificationPreferences.fromJson(
          jsonDecode(value) as Map<String, dynamic>,
        );
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'notification preferences',
        ),
      );
    }
  }
}

final notificationPreferencesProvider =
    NotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>(
      NotificationPreferencesNotifier.new,
    );
