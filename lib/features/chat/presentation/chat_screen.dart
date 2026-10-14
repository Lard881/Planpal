// app/lib/features/chat/presentation/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../models/chat_models.dart';
import '../providers/chat_providers.dart';
import '../data/chat_repository.dart';

class ChatScreen extends ConsumerWidget {
  final String? channelId;
  const ChatScreen({super.key, this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(currentWorkspaceProvider);

    // Personal workspace — show explanation (fix F5)
    if (workspace?.isPersonal == true) {
      return _PersonalWorkspaceChat();
    }

    return context.isDesktopLayout
        ? _DesktopChat(activeChannelId: channelId)
        : channelId != null
            ? _ConversationScreen(channelId: channelId!)
            : const _MobileChatList();
  }
}

// ── Personal workspace placeholder ───────────────────────────────────────────
class _PersonalWorkspaceChat extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: EmptyState(
        icon: LucideIcons.messageCircle,
        title: 'Chat is for teams',
        subtitle: 'Chat is only available in team workspaces.',
        actionLabel: 'Create or join a team workspace',
        onAction: () => context.push('/workspace/create'),
      ),
    );
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopChat extends ConsumerWidget {
  final String? activeChannelId;
  const _DesktopChat({this.activeChannelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final channelsAsync = ref.watch(channelsProvider(wsId));

    return Scaffold(
      backgroundColor: c.background,
      body: Row(
        children: [
          // Left panel
          Container(
            width: 248,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
              border: Border.all(color: c.border),
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workspace name as title (fix F5)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(workspace?.name ?? 'Chat',
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                ),
                const Divider(),
                Expanded(
                  child: channelsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (channels) {
                      final regularChannels = channels.where((ch) => ch.isChannel).toList();
                      final dms = channels.where((ch) => ch.isDm).toList();

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          if (regularChannels.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              child: Row(
                                children: [
                                  Text('Channels',
                                    style: AppText.caption.copyWith(
                                      color: c.textMuted)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => _showNewChannel(context, ref, wsId),
                                    child: Icon(LucideIcons.plus,
                                      size: 14, color: c.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            ...regularChannels.map((ch) => _ChannelRow(
                              channel: ch,
                              isActive: ch.id == activeChannelId,
                              onTap: () => context.go('/chat/${ch.id}'),
                            )),
                          ],
                          if (dms.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                              child: Text('Direct Messages',
                                style: AppText.caption.copyWith(color: c.textMuted)),
                            ),
                            ...dms.map((ch) => _DmRow(
                              channel: ch,
                              isActive: ch.id == activeChannelId,
                              onTap: () => context.go('/chat/${ch.id}'),
                            )),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right panel — conversation or empty
          Expanded(
            child: activeChannelId != null
                ? Container(
                    margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.panel),
                      border: Border.all(color: c.border),
                    ),
                    child: _ConversationPanel(
                      channelId: activeChannelId!,
                      workspaceId: wsId,
                    ),
                  )
                : Center(
                    child: EmptyState(
                      icon: LucideIcons.messageCircle,
                      title: 'Select a channel',
                      subtitle: 'Choose a channel to start messaging.',
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showNewChannel(BuildContext context, WidgetRef ref, String wsId) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Channel'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Channel name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              await ref.read(chatRepositoryProvider)
                  .createChannel(wsId, name: ctrl.text.trim());
              ref.invalidate(channelsProvider(wsId));
            },
            child: const Text('Create')),
        ],
      ),
    );
  }
}

class _ChannelRow extends StatelessWidget {
  final ChannelModel channel;
  final bool isActive;
  final VoidCallback onTap;
  const _ChannelRow({required this.channel, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isActive ? c.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: Row(
          children: [
            Text('# ', style: AppText.body.copyWith(color: c.textMuted)),
            Expanded(
              child: Text(channel.name ?? 'channel',
                style: AppText.bodyMedium.copyWith(
                  color: isActive ? c.primary : c.textPrimary)),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.danger,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${channel.unreadCount}',
                  style: AppText.chip.copyWith(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

class _DmRow extends StatelessWidget {
  final ChannelModel channel;
  final bool isActive;
  final VoidCallback onTap;
  const _DmRow({required this.channel, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = channel.memberNames.isNotEmpty
        ? channel.memberNames.first : 'Direct Message';
    final initial = name[0].toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isActive ? c.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: c.violet, shape: BoxShape.circle),
              child: Center(
                child: Text(initial,
                  style: AppText.chip.copyWith(color: Colors.white))),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(name,
                style: AppText.bodyMedium.copyWith(
                  color: isActive ? c.primary : c.textPrimary)),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${channel.unreadCount}',
                  style: AppText.chip.copyWith(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Conversation Panel (shared desktop/mobile) ────────────────────────────────
class _ConversationPanel extends ConsumerStatefulWidget {
  final String channelId;
  final String workspaceId;
  const _ConversationPanel({
    required this.channelId, required this.workspaceId});
  @override
  ConsumerState<_ConversationPanel> createState() => _ConversationPanelState();
}

class _ConversationPanelState extends ConsumerState<_ConversationPanel> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final body = _msgCtrl.text.trim();
    if (body.isEmpty) return;
    _msgCtrl.clear();
    ref.read(messagesProvider((
      workspaceId: widget.workspaceId,
      channelId: widget.channelId,
    )).notifier).send(body);
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final messages = ref.watch(messagesProvider((
      workspaceId: widget.workspaceId,
      channelId: widget.channelId,
    )));
    final currentUserId =
        Supabase.instance.client.auth.currentUser?.id ?? '';

    return Column(
      children: [
        // Messages
        Expanded(
          child: messages.isEmpty
              ? Center(child: Text('No messages yet.',
                  style: AppText.body.copyWith(color: c.textMuted)))
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageBubble(
                    message: messages[i],
                    isOwn: messages[i].senderId == currentUserId,
                    onRetry: messages[i].status == MessageStatus.failed
                        ? () => ref.read(messagesProvider((
                              workspaceId: widget.workspaceId,
                              channelId: widget.channelId,
                            )).notifier)
                            .retry(messages[i].id, messages[i].body)
                        : null,
                  ),
                ),
        ),
        const Divider(height: 1),
        // Composer
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(LucideIcons.paperclip, size: 20, color: c.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: c.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: AppText.body.copyWith(color: c.textMuted),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: const Icon(LucideIcons.sendHorizonal,
                    size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isOwn;
  final VoidCallback? onRetry;
  const _MessageBubble({
    required this.message, required this.isOwn, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwn) ...[
            Avatar(
              userId: message.senderId,
              name: message.senderName ?? '',
              avatarUrl: message.senderAvatarUrl,
              size: 36,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isOwn
                  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  isOwn ? 'You · ${message.formatTime()}'
                      : '${message.senderName ?? 'Unknown'} · ${message.formatTime()}',
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: message.status == MessageStatus.failed
                      ? onRetry : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isOwn ? c.primary : c.background,
                      borderRadius: BorderRadius.circular(16),
                      border: isOwn ? null : Border.all(color: c.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.body,
                          style: AppText.body.copyWith(
                            color: isOwn ? Colors.white : c.textPrimary)),
                        if (message.status == MessageStatus.failed) ...[
                          const SizedBox(height: 4),
                          Text('Tap to retry',
                            style: AppText.caption.copyWith(
                              color: isOwn
                                  ? Colors.white70 : c.danger)),
                        ],
                      ],
                    ),
                  ),
                ),
                if (message.status == MessageStatus.sending)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(LucideIcons.clock,
                      size: 12, color: c.textMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── MOBILE Chat List ──────────────────────────────────────────────────────────
class _MobileChatList extends ConsumerWidget {
  const _MobileChatList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final channelsAsync = ref.watch(channelsProvider(wsId));

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: c.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Messages',
                  style: AppText.pageTitleMobile.copyWith(
                    color: c.textPrimary)),
              ),
            ),
            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: c.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(LucideIcons.search, size: 16, color: c.textMuted),
                      const SizedBox(width: 8),
                      Text('Search chats...',
                        style: AppText.body.copyWith(color: c.textMuted)),
                    ],
                  ),
                ),
              ),
            ),
            channelsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SliverFillRemaining(
                child: EmptyState(
                  icon: LucideIcons.messageCircle,
                  title: 'Could not load chats')),
              data: (channels) => channels.isEmpty
                  ? const SliverFillRemaining(
                      child: EmptyState(
                        icon: LucideIcons.messageCircle,
                        title: 'No channels yet',
                        subtitle: 'Create a channel to get started.'))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) {
                            final ch = channels[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    context.push('/chat/${ch.id}'),
                                child: _MobileChannelCard(channel: ch),
                              ),
                            );
                          },
                          childCount: channels.length,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileChannelCard extends StatelessWidget {
  final ChannelModel channel;
  const _MobileChannelCard({required this.channel});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final colors = [c.primary, c.violet, c.sky, c.success];
    final color = colors[channel.name.hashCode.abs() % colors.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                channel.isDm
                    ? (channel.memberNames.isNotEmpty
                        ? channel.memberNames.first[0].toUpperCase() : 'D')
                    : channel.initial,
                style: AppText.bodyStrong.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.isDm && channel.memberNames.isNotEmpty
                      ? channel.memberNames.first
                      : (channel.name ?? 'Channel'),
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                if (channel.lastMessageBody != null)
                  Text(
                    channel.isDm
                        ? (channel.lastMessageBody ?? '')
                        : '#${channel.name} · ${channel.lastMessageSenderName ?? ''}: ${channel.lastMessageBody ?? ''}',
                    style: AppText.caption.copyWith(color: c.textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (channel.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${channel.unreadCount}',
                style: AppText.chip.copyWith(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

// ── Mobile Conversation ───────────────────────────────────────────────────────
class _ConversationScreen extends ConsumerWidget {
  final String channelId;
  const _ConversationScreen({required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final channelsAsync = ref.watch(channelsProvider(wsId));

    final channel = channelsAsync.valueOrNull
        ?.firstWhere((ch) => ch.id == channelId,
            orElse: () => ChannelModel(
                id: channelId, workspaceId: wsId));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.control),
              border: Border.all(color: c.border),
            ),
            child: Icon(LucideIcons.arrowLeft, size: 18, color: c.textPrimary),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channel?.name != null ? '# ${channel!.name}' : 'Chat',
              style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
          ],
        ),
        actions: [
          Icon(LucideIcons.search, color: c.textMuted),
          const SizedBox(width: 8),
          Icon(LucideIcons.users, color: c.textMuted),
          const SizedBox(width: 16),
        ],
      ),
      body: _ConversationPanel(
        channelId: channelId,
        workspaceId: wsId,
      ),
    );
  }
}
