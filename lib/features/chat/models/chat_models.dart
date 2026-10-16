// app/lib/features/chat/models/chat_models.dart
class ChannelModel {
  final String id;
  final String workspaceId;
  final String kind; // 'channel' | 'dm'
  final String? name;
  final String? description;
  final bool isPrivate;
  final int unreadCount;
  final String? lastMessageBody;
  final String? lastMessageSenderName;
  final DateTime? lastMessageAt;
  final List<String> memberIds;
  final List<String> memberNames;

  const ChannelModel({
    required this.id,
    required this.workspaceId,
    this.kind = 'channel',
    this.name,
    this.description,
    this.isPrivate = false,
    this.unreadCount = 0,
    this.lastMessageBody,
    this.lastMessageSenderName,
    this.lastMessageAt,
    this.memberIds = const [],
    this.memberNames = const [],
  });

  bool get isDm => kind == 'dm';
  bool get isChannel => kind == 'channel';

  factory ChannelModel.fromJson(Map<String, dynamic> j) {
    final members = j['members'] as List? ?? [];
    final otherUser = j['otherUser'] as Map<String, dynamic>?;
    final List<String> memberNames;
    final List<String> memberIds;
    if (otherUser != null) {
      // DM — use otherUser directly (R2.4 backend fix)
      memberNames = [(otherUser['full_name'] as String? ?? '')];
      memberIds = [(otherUser['id'] as String? ?? '')];
    } else {
      memberIds = members
          .map((m) => (m['user_id'] ?? m['id']) as String)
          .toList();
      memberNames = members
          .map((m) {
            final p = m['profile'] as Map? ?? m;
            return (p['full_name'] ?? '') as String;
          })
          .where((n) => n.isNotEmpty)
          .toList();
    }
    return ChannelModel(
      id: j['id'] as String,
      workspaceId: j['workspace_id'] as String,
      kind: j['kind'] as String? ?? 'channel',
      name: j['name'] as String?,
      description: j['description'] as String?,
      isPrivate: j['is_private'] as bool? ?? false,
      unreadCount: j['unreadCount'] as int? ?? j['unread_count'] as int? ?? 0,
      lastMessageBody: j['lastMessage']?['body'] as String?,
      lastMessageSenderName: j['lastMessage']?['authorName'] as String?,
      lastMessageAt: j['lastMessage']?['createdAt'] != null
          ? DateTime.parse(j['lastMessage']['createdAt'] as String)
          : null,
      memberIds: memberIds,
      memberNames: memberNames,
    );
  }
}

class MessageModel {
  final String id;
  final String channelId;
  final String senderId;
  final String? senderName;
  final String? senderAvatarUrl;
  final String body;
  final String? fileId;
  final String? fileName;
  final String? fileMimeType;
  final DateTime createdAt;
  final DateTime? editedAt;
  final MessageStatus status;

  const MessageModel({
    required this.id,
    required this.channelId,
    required this.senderId,
    this.senderName,
    this.senderAvatarUrl,
    required this.body,
    this.fileId,
    this.fileName,
    this.fileMimeType,
    required this.createdAt,
    this.editedAt,
    this.status = MessageStatus.sent,
  });

  bool get hasFile => fileId != null;
  bool get isImage => fileMimeType?.startsWith('image/') ?? false;

  factory MessageModel.fromJson(Map<String, dynamic> j) {
    final sender = j['sender'] as Map<String, dynamic>?;
    final file = j['file'] as Map<String, dynamic>?;
    return MessageModel(
      id: j['id'] as String,
      channelId: j['channel_id'] as String,
      senderId: j['sender_id'] as String,
      senderName: sender?['full_name'] as String?,
      senderAvatarUrl: sender?['avatar_url'] as String?,
      body: j['body'] as String? ?? '',
      fileId: file?['id'] as String? ?? j['file_id'] as String?,
      fileName: file?['name'] as String?,
      fileMimeType: file?['mime_type'] as String?,
      createdAt: DateTime.parse(j['created_at'] as String),
      editedAt: j['edited_at'] != null
          ? DateTime.parse(j['edited_at'] as String)
          : null,
    );
  }

  String formatTime() {
    final h = createdAt.hour > 12
        ? createdAt.hour - 12
        : (createdAt.hour == 0 ? 12 : createdAt.hour);
    final m = createdAt.minute.toString().padLeft(2, '0');
    final ampm = createdAt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

enum MessageStatus { sending, sent, failed }
