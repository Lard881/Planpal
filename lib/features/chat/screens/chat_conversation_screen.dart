import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../repositories/chat_repository.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final int? channelId;
  final String? channelName;
  final int? userId;
  final String? userName;

  const ChatConversationScreen({
    super.key,
    this.channelId,
    this.channelName,
    this.userId,
    this.userName,
  });

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isChannel => widget.channelId != null;

  String get _title {
    if (_isChannel) {
      return '#${widget.channelName ?? 'Channel'}';
    }
    return widget.userName ?? 'Direct Message';
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = _isChannel
        ? ref.watch(channelMessagesProvider(widget.channelId!))
        : ref.watch(directMessagesListProvider(widget.userId!));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_title),
            if (!_isChannel)
              const Text(
                'Active',
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
          ],
        ),
        actions: [
          if (_isChannel)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showChannelInfo(context),
            )
          else
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () => _startVideoCall(context),
            ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 12),
                    Text('Search in conversation'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off),
                    SizedBox(width: 12),
                    Text('Mute notifications'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              // Handle menu actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading messages: $error'),
                  ],
                ),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final showAvatar = index == messages.length - 1 ||
                        messages[index + 1].senderId != message.senderId;
                    final showTimestamp = index == 0 ||
                        _shouldShowTimestamp(
                          message.createdAt,
                          messages[index - 1].createdAt,
                        );

                    return _MessageBubble(
                      message: message,
                      showAvatar: showAvatar,
                      showTimestamp: showTimestamp,
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () => _attachFile(context),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isSending
                        ? const SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _sendMessage,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(DateTime current, DateTime previous) {
    final diff = current.difference(previous);
    return diff.inMinutes > 5;
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      // Send message logic here
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network

      _messageController.clear();
      
      // Scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _attachFile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo & Video'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChannelInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.channelName}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.people),
                title: Text('Members'),
                trailing: Icon(Icons.chevron_right),
              ),
              const ListTile(
                leading: Icon(Icons.pin_drop),
                title: Text('Pinned Messages'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startVideoCall(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video call feature coming soon')),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool showTimestamp;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.showTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isCurrentUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: showAvatar ? 16 : 4,
        top: showTimestamp ? 16 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showTimestamp)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _formatTimestamp(message.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe && showAvatar)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _getAvatarColor(message.senderName),
                  child: Text(
                    _getInitials(message.senderName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (!isMe)
                const SizedBox(width: 32),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe && showAvatar)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            message.senderName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: _getAvatarColor(message.senderName),
                            ),
                          ),
                        ),
                      Text(
                        message.content,
                        style: TextStyle(
                          color: isMe
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMessageTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  String _formatMessageTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// Providers for messages
final channelMessagesProvider =
    StreamProvider.family<List<ChatMessage>, int>((ref, channelId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChannelMessages(channelId);
});

final directMessagesListProvider =
    StreamProvider.family<List<ChatMessage>, int>((ref, userId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchDirectMessages(userId);
});

// Placeholder model
class ChatMessage {
  final int id;
  final int senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;
  final bool isCurrentUser;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
    required this.isCurrentUser,
  });
}
