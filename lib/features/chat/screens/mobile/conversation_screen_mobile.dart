import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:planpal/features/chat/widgets/message_composer.dart';
import 'package:planpal/features/chat/widgets/message_bubble.dart';
import 'package:planpal/core/services/supabase_service.dart';

/// Mobile conversation screen - shows messages in a channel
class ConversationScreenMobile extends ConsumerStatefulWidget {
  final String channelId;
  final String workspaceId;

  const ConversationScreenMobile({
    super.key,
    required this.channelId,
    required this.workspaceId,
  });

  @override
  ConsumerState<ConversationScreenMobile> createState() => _ConversationScreenMobileState();
}

class _ConversationScreenMobileState extends ConsumerState<ConversationScreenMobile> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    
    // Mark as read when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sendMessageProvider).markAsRead(widget.channelId);
    });

    // Listen to scroll position
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final isAtBottom = _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 100;

    if (isAtBottom != _isAtBottom) {
      setState(() => _isAtBottom = isAtBottom);
      
      // Mark as read when at bottom
      if (isAtBottom) {
        ref.read(sendMessageProvider).markAsRead(widget.channelId);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.channelId));
    final currentUserId = ref.watch(supabaseServiceProvider).currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'), // TODO: Show channel name
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show channel info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                // Messages are in descending order (newest first)
                // Reverse for display (oldest at top)
                final displayMessages = messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: false, // Scroll to bottom for new messages
                  padding: const EdgeInsets.all(16),
                  itemCount: displayMessages.length,
                  itemBuilder: (context, index) {
                    final message = displayMessages[index];
                    final isMe = message.senderId == currentUserId;
                    
                    // Check if we should show sender info (different sender than previous)
                    final showSender = index == 0 || 
                        displayMessages[index - 1].senderId != message.senderId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                      showSender: showSender,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading messages'),
                    TextButton(
                      onPressed: () => ref.invalidate(messagesProvider(widget.channelId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message composer
          MessageComposer(
            channelId: widget.channelId,
            workspaceId: widget.workspaceId,
            onMessageSent: () {
              // Scroll to bottom when a new message is sent
              Future.delayed(const Duration(milliseconds: 100), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
