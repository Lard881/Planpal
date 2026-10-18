// app/lib/features/chat/presentation/chat_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/providers/presence_provider.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/failure_localizer.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../workspaces/data/workspace_repository.dart';
import '../models/chat_models.dart';
import '../providers/chat_providers.dart';
import '../data/chat_repository.dart';
import '../../documents/data/documents_repository.dart';

Future<void> _showNewChannelDialog(
  BuildContext context,
  WidgetRef ref,
  String workspaceId,
) async {
  final l10n = AppLocalizations.of(context);
  final (members, failure) = await ref
      .read(workspaceRepositoryProvider)
      .getMembers(workspaceId);
  if (!context.mounted) return;
  if (failure != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
    return;
  }

  final controller = TextEditingController();
  final selectedMembers = <String>{};
  var isPrivate = false;
  final shouldCreate = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(l10n.chatNewChannel),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: l10n.fieldChannelName),
                autofocus: true,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.chatPrivateChannel),
                value: isPrivate,
                onChanged: (value) => setDialogState(() => isPrivate = value),
              ),
              if (isPrivate)
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: members
                        .where(
                          (member) =>
                              member.userId !=
                              Supabase.instance.client.auth.currentUser?.id,
                        )
                        .map(
                          (member) => CheckboxListTile(
                            dense: true,
                            value: selectedMembers.contains(member.userId),
                            title: Text(
                              member.fullName.isEmpty
                                  ? member.email
                                  : member.fullName,
                            ),
                            onChanged: (selected) => setDialogState(() {
                              if (selected == true) {
                                selectedMembers.add(member.userId);
                              } else {
                                selectedMembers.remove(member.userId);
                              }
                            }),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim().isNotEmpty),
            child: Text(l10n.btnCreate),
          ),
        ],
      ),
    ),
  );
  final name = controller.text.trim();
  controller.dispose();
  if (shouldCreate != true || name.isEmpty || !context.mounted) return;

  final (channel, createFailure) = await ref
      .read(chatRepositoryProvider)
      .createChannel(
        workspaceId,
        name: name,
        isPrivate: isPrivate,
        memberIds: selectedMembers.toList(),
      );
  if (!context.mounted) return;
  if (createFailure != null || channel == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          createFailure?.localizedMessage(context) ?? l10n.errorGeneric,
        ),
      ),
    );
    return;
  }
  ref.invalidate(channelsProvider(workspaceId));
  context.go('/chat/${channel.id}');
}

Future<void> _showNewDmPicker(
  BuildContext context,
  WidgetRef ref,
  String workspaceId,
) async {
  final l10n = AppLocalizations.of(context);
  final (members, failure) = await ref
      .read(workspaceRepositoryProvider)
      .getMembers(workspaceId);
  if (!context.mounted) return;
  if (failure != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
    return;
  }
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  final otherMembers = members
      .where((member) => member.userId != currentUserId)
      .toList();
  if (otherMembers.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.emptyStateNoMembers)));
    return;
  }

  final userId = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.chatNewDm),
      content: SizedBox(
        width: 420,
        child: ListView(
          shrinkWrap: true,
          children: otherMembers
              .map(
                (member) => ListTile(
                  leading: Avatar(
                    userId: member.userId,
                    name: member.fullName,
                    avatarUrl: member.avatarUrl,
                    size: 36,
                  ),
                  title: Text(
                    member.fullName.isEmpty ? member.email : member.fullName,
                  ),
                  subtitle: Text(member.email),
                  onTap: () => Navigator.pop(dialogContext, member.userId),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.btnCancel),
        ),
      ],
    ),
  );
  if (userId == null || !context.mounted) return;
  final (channel, createFailure) = await ref
      .read(chatRepositoryProvider)
      .createDm(workspaceId, userId);
  if (!context.mounted) return;
  if (createFailure != null || channel == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          createFailure?.localizedMessage(context) ?? l10n.errorGeneric,
        ),
      ),
    );
    return;
  }
  ref.invalidate(channelsProvider(workspaceId));
  context.go('/chat/${channel.id}');
}

Future<void> _manageChannelMembers(
  BuildContext context,
  WidgetRef ref,
  String workspaceId,
  ChannelModel channel,
) async {
  final l10n = AppLocalizations.of(context);
  final (members, failure) = await ref
      .read(workspaceRepositoryProvider)
      .getMembers(workspaceId);
  if (!context.mounted) return;
  if (failure != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
    return;
  }
  final selected = Set<String>.from(channel.memberIds);
  final updatedMembers = await showDialog<Set<String>>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(l10n.chatManageMembers),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: members.map((member) {
              final memberName = member.fullName.isEmpty
                  ? member.email
                  : member.fullName;
              return CheckboxListTile(
                value: selected.contains(member.userId),
                title: Text(memberName),
                subtitle: Text(member.email),
                onChanged: (value) => setDialogState(() {
                  if (value == true) {
                    selected.add(member.userId);
                  } else {
                    selected.remove(member.userId);
                  }
                }),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, selected),
            child: Text(l10n.btnSave),
          ),
        ],
      ),
    ),
  );
  if (updatedMembers == null || !context.mounted) return;

  final chatRepository = ref.read(chatRepositoryProvider);
  for (final userId in updatedMembers.difference(channel.memberIds.toSet())) {
    final updateFailure = await chatRepository.addMember(channel.id, userId);
    if (updateFailure != null) {
      ref.invalidate(channelsProvider(workspaceId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(updateFailure.localizedMessage(context))),
        );
      }
      return;
    }
  }
  for (final userId in channel.memberIds.toSet().difference(updatedMembers)) {
    final updateFailure = await chatRepository.removeMember(channel.id, userId);
    if (updateFailure != null) {
      ref.invalidate(channelsProvider(workspaceId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(updateFailure.localizedMessage(context))),
        );
      }
      return;
    }
  }
  ref.invalidate(channelsProvider(workspaceId));
}

String? _presenceStatusText(AppLocalizations l10n, PresenceStatus? status) =>
    switch (status) {
      PresenceStatus.online => l10n.teamPresenceOnline,
      PresenceStatus.away => l10n.teamPresenceAway,
      PresenceStatus.offline => l10n.teamPresenceOffline,
      null => null,
    };

String _dmDisplayName(ChannelModel channel, AppLocalizations l10n) {
  for (final name in channel.memberNames) {
    if (name.isNotEmpty) return name;
  }
  return l10n.chatDirectMessageFallback;
}

class ChatScreen extends ConsumerWidget {
  final String? channelId;
  const ChatScreen({super.key, this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(currentWorkspaceProvider);

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: EmptyState(
        icon: LucideIcons.messageCircle,
        title: l10n.emptyStateChatTeamOnly,
        subtitle: l10n.emptyStateChatTeamOnlyDesc,
        actionLabel: l10n.createOrJoinTeam,
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
    final l10n = AppLocalizations.of(context);
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final channelsAsync = ref.watch(channelsProvider(wsId));
    final presenceByUser = ref.watch(presenceProvider(wsId));
    ChannelModel? activeChannel;
    for (final channel in channelsAsync.valueOrNull ?? const <ChannelModel>[]) {
      if (channel.id == activeChannelId) {
        activeChannel = channel;
        break;
      }
    }
    final activeDmPresence =
        activeChannel?.isDm == true && activeChannel!.memberIds.isNotEmpty
        ? presenceByUser[activeChannel.memberIds.first]
        : null;

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
                  child: Text(
                    workspace?.name ?? l10n.navChat,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: channelsAsync.when(
                    loading: () => const ContentLoadingSkeleton(
                      kind: LoadingSkeletonKind.rows,
                      itemCount: 5,
                      padding: EdgeInsets.zero,
                    ),
                    error: (error, _) => ErrorState(
                      message: error.toString(),
                      retryLabel: l10n.btnRetry,
                      onRetry: () => ref.invalidate(channelsProvider(wsId)),
                    ),
                    data: (channels) {
                      final regularChannels = channels
                          .where((ch) => ch.isChannel)
                          .toList();
                      final dms = channels.where((ch) => ch.isDm).toList();

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Row(
                              children: [
                                Text(
                                  l10n.chatChannels,
                                  style: AppText.caption.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: l10n.chatNewChannel,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      _showNewChannelDialog(context, ref, wsId),
                                  icon: Icon(
                                    LucideIcons.plus,
                                    size: 14,
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (regularChannels.isNotEmpty)
                            ...regularChannels.map(
                              (ch) => _ChannelRow(
                                channel: ch,
                                isActive: ch.id == activeChannelId,
                                onTap: () => context.go('/chat/${ch.id}'),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 12, 0, 4),
                            child: Row(
                              children: [
                                Text(
                                  l10n.chatDirectMessages,
                                  style: AppText.caption.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: l10n.chatNewDm,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      _showNewDmPicker(context, ref, wsId),
                                  icon: Icon(
                                    LucideIcons.plus,
                                    size: 14,
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (dms.isNotEmpty)
                            ...dms.map(
                              (ch) => _DmRow(
                                channel: ch,
                                isActive: ch.id == activeChannelId,
                                onTap: () => context.go('/chat/${ch.id}'),
                              ),
                            ),
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
                    child: Column(
                      children: [
                        if (activeChannel != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                            child: Row(
                              children: [
                                if (activeChannel.isPrivate)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(LucideIcons.lock, size: 16),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activeChannel.isDm
                                            ? _dmDisplayName(
                                                activeChannel,
                                                l10n,
                                              )
                                            : '# ${activeChannel.name ?? ''}',
                                        style: AppText.bodyStrong.copyWith(
                                          color: c.textPrimary,
                                        ),
                                      ),
                                      if (activeDmPresence != null)
                                        Text(
                                          _presenceStatusText(
                                                l10n,
                                                activeDmPresence,
                                              ) ??
                                              '',
                                          style: AppText.caption.copyWith(
                                            color: c.textMuted,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (activeChannel.isChannel)
                                  IconButton(
                                    tooltip: l10n.chatManageMembers,
                                    onPressed: () => _manageChannelMembers(
                                      context,
                                      ref,
                                      wsId,
                                      activeChannel!,
                                    ),
                                    icon: const Icon(LucideIcons.users),
                                  ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: _ConversationPanel(
                            channelId: activeChannelId!,
                            workspaceId: wsId,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: EmptyState(
                      icon: LucideIcons.messageCircle,
                      title: l10n.emptyStateSelectChannel,
                      subtitle: l10n.emptyStateSelectChannelDesc,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChannelRow extends StatelessWidget {
  final ChannelModel channel;
  final bool isActive;
  final VoidCallback onTap;
  const _ChannelRow({
    required this.channel,
    required this.isActive,
    required this.onTap,
  });

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
            if (channel.isPrivate)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(LucideIcons.lock, size: 14, color: c.textMuted),
              ),
            Text('# ', style: AppText.body.copyWith(color: c.textMuted)),
            Expanded(
              child: Text(
                channel.name ?? AppLocalizations.of(context).chatUnnamedChannel,
                style: AppText.bodyMedium.copyWith(
                  color: isActive ? c.primary : c.textPrimary,
                ),
              ),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.danger,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: AppText.chip.copyWith(color: Colors.white),
                ),
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
  const _DmRow({
    required this.channel,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final name = _dmDisplayName(channel, l10n);
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: c.violet,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: AppText.chip.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: AppText.bodyMedium.copyWith(
                  color: isActive ? c.primary : c.textPrimary,
                ),
              ),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: AppText.chip.copyWith(color: Colors.white),
                ),
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
    required this.channelId,
    required this.workspaceId,
  });
  @override
  ConsumerState<_ConversationPanel> createState() => _ConversationPanelState();
}

class _ConversationPanelState extends ConsumerState<_ConversationPanel> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  RealtimeChannel? _membershipSubscription;
  RealtimeChannel? _typingChannel;
  Timer? _typingDebounce;
  final Map<String, Timer> _typingTimeouts = {};
  final Map<String, String> _typingUsers = {};
  bool _typingChannelReady = false;
  bool _loadingOlderMessages = false;
  bool _didInitialScroll = false;
  double? _uploadProgress;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_loadOlderMessages);
    _membershipSubscription = ref
        .read(chatRepositoryProvider)
        .subscribeToMembership(
          widget.channelId,
          _refreshChannelMembership,
          onReconnect: _refreshChannelMembership,
        );
    _typingChannel = Supabase.instance.client
        .channel(
          'typing:${widget.channelId}',
          opts: const RealtimeChannelConfig(self: false),
        )
        .onBroadcast(event: 'typing', callback: _handleRemoteTyping)
        .subscribe((status, _) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _typingChannelReady = true;
          }
        });
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_loadOlderMessages);
    _membershipSubscription?.unsubscribe();
    _typingChannel?.unsubscribe();
    _typingDebounce?.cancel();
    for (final timer in _typingTimeouts.values) {
      timer.cancel();
    }
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _handleRemoteTyping(Map<String, dynamic> payload) {
    final userId = payload['userId'] as String?;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (!mounted || userId == null || userId == currentUserId) return;
    final isTyping = payload['isTyping'] == true;
    _typingTimeouts.remove(userId)?.cancel();
    setState(() {
      if (isTyping) {
        _typingUsers[userId] =
            payload['name'] as String? ??
            AppLocalizations.of(context).chatUnknownSender;
      } else {
        _typingUsers.remove(userId);
      }
    });
    if (isTyping) {
      _typingTimeouts[userId] = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _typingUsers.remove(userId));
      });
    }
  }

  void _handleTyping(String text) {
    final channel = _typingChannel;
    final user = Supabase.instance.client.auth.currentUser;
    if (channel == null || user == null || !_typingChannelReady) return;
    _typingDebounce?.cancel();
    final isTyping = text.trim().isNotEmpty;
    _typingDebounce = Timer(
      isTyping ? const Duration(milliseconds: 300) : Duration.zero,
      () {
        unawaited(
          channel.sendBroadcastMessage(
            event: 'typing',
            payload: {
              'userId': user.id,
              'name': user.userMetadata?['full_name'] as String? ?? '',
              'isTyping': isTyping,
            },
          ),
        );
      },
    );
  }

  void _refreshChannelMembership() {
    if (!mounted) return;
    ref.invalidate(channelsProvider(widget.workspaceId));
  }

  Future<void> _loadOlderMessages() async {
    if (_loadingOlderMessages ||
        !_scrollCtrl.hasClients ||
        _scrollCtrl.position.pixels > 80) {
      return;
    }
    _loadingOlderMessages = true;
    final previousMaxExtent = _scrollCtrl.position.maxScrollExtent;
    final previousOffset = _scrollCtrl.position.pixels;
    await ref
        .read(
          messagesProvider((
            workspaceId: widget.workspaceId,
            channelId: widget.channelId,
          )).notifier,
        )
        .loadOlder();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) {
        _loadingOlderMessages = false;
        return;
      }
      final addedExtent =
          _scrollCtrl.position.maxScrollExtent - previousMaxExtent;
      _scrollCtrl.jumpTo(
        (previousOffset + addedExtent).clamp(
          0.0,
          _scrollCtrl.position.maxScrollExtent,
        ),
      );
      _loadingOlderMessages = false;
    });
  }

  void _send() {
    final body = _msgCtrl.text.trim();
    if (body.isEmpty) return;
    _msgCtrl.clear();
    _handleTyping('');
    ref
        .read(
          messagesProvider((
            workspaceId: widget.workspaceId,
            channelId: widget.channelId,
          )).notifier,
        )
        .send(body);
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

  Future<void> _pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final path = file.path;
    if (path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
        );
      }
      return;
    }
    setState(() => _uploadProgress = 0);
    final (fileId, failure) = await ref
        .read(documentsRepositoryProvider)
        .uploadFile(
          widget.workspaceId,
          File(path),
          mimeTypeForFileName(file.name),
          onProgress: (sent, total) {
            if (mounted && total > 0) {
              setState(() => _uploadProgress = sent / total);
            }
          },
        );
    if (!mounted) return;
    if (failure != null || fileId == null) {
      setState(() => _uploadProgress = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failure?.message ?? AppLocalizations.of(context).errorGeneric,
          ),
        ),
      );
      return;
    }
    setState(() => _uploadProgress = null);
    await ref
        .read(
          messagesProvider((
            workspaceId: widget.workspaceId,
            channelId: widget.channelId,
          )).notifier,
        )
        .send(
          '',
          fileId: fileId,
          fileName: file.name,
          fileMimeType: mimeTypeForFileName(file.name),
        );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final messageListProvider = messagesProvider((
      workspaceId: widget.workspaceId,
      channelId: widget.channelId,
    ));
    ref.listen<List<MessageModel>>(messageListProvider, (_, __) {
      final wasNearBottom =
          !_didInitialScroll ||
          (_scrollCtrl.hasClients &&
              _scrollCtrl.position.maxScrollExtent -
                      _scrollCtrl.position.pixels <
                  120);
      if (!wasNearBottom) return;
      _didInitialScroll = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
        }
      });
    });
    final messages = ref.watch(messageListProvider);
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    return Column(
      children: [
        // Messages
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Text(
                    l10n.emptyStateNoMessages,
                    style: AppText.body.copyWith(color: c.textMuted),
                  ),
                )
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageBubble(
                    message: messages[i],
                    workspaceId: widget.workspaceId,
                    channelId: widget.channelId,
                    isOwn: messages[i].senderId == currentUserId,
                    canDeleteAny: ref
                        .watch(currentRolePermissionsProvider)
                        .isAdmin,
                    onRetry: messages[i].status == MessageStatus.failed
                        ? () => ref
                              .read(
                                messagesProvider((
                                  workspaceId: widget.workspaceId,
                                  channelId: widget.channelId,
                                )).notifier,
                              )
                              .retry(messages[i].id)
                        : null,
                  ),
                ),
        ),
        const Divider(height: 1),
        if (_uploadProgress != null)
          LinearProgressIndicator(value: _uploadProgress),
        if (_typingUsers.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                l10n.chatTyping(_typingUsers.values.join(', ')),
                style: AppText.caption.copyWith(color: c.textMuted),
              ),
            ),
          ),
        // Composer
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              IconButton(
                tooltip: l10n.taskAttachFile,
                onPressed: _uploadProgress == null ? _pickAndSendFile : null,
                icon: Icon(LucideIcons.paperclip, size: 20, color: c.textMuted),
              ),
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
                      hintText: l10n.fieldMessageHint,
                      hintStyle: AppText.body.copyWith(color: c.textMuted),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                    onChanged: _handleTyping,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: const Icon(
                    LucideIcons.sendHorizonal,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final String workspaceId;
  final String channelId;
  final bool isOwn;
  final bool canDeleteAny;
  final VoidCallback? onRetry;
  const _MessageBubble({
    required this.message,
    required this.workspaceId,
    required this.channelId,
    required this.isOwn,
    required this.canDeleteAny,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isOwn
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatMessageHeader(
                    isOwn
                        ? l10n.chatYou
                        : message.senderName ?? l10n.chatUnknownSender,
                    message.formatTime(),
                  ),
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: message.status == MessageStatus.failed
                      ? onRetry
                      : null,
                  onLongPress: () => _showMessageActions(context, ref, l10n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isOwn ? c.primary : c.background,
                      borderRadius: BorderRadius.circular(16),
                      border: isOwn ? null : Border.all(color: c.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.body.isNotEmpty)
                          Text(
                            message.body,
                            style: AppText.body.copyWith(
                              color: isOwn ? Colors.white : c.textPrimary,
                            ),
                          ),
                        if (message.hasFile)
                          _MessageAttachment(message: message),
                        if (message.status == MessageStatus.failed) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.chatTapToRetry,
                            style: AppText.caption.copyWith(
                              color: isOwn ? Colors.white70 : c.danger,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (message.status == MessageStatus.sending)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      LucideIcons.clock,
                      size: 12,
                      color: c.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMessageActions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.copy),
              title: Text(l10n.btnCopy),
              onTap: () => Navigator.pop(sheetContext, 'copy'),
            ),
            if (isOwn)
              ListTile(
                leading: const Icon(LucideIcons.fileEdit),
                title: Text(l10n.btnEdit),
                onTap: () => Navigator.pop(sheetContext, 'edit'),
              ),
            if (isOwn || canDeleteAny)
              ListTile(
                leading: const Icon(LucideIcons.trash2),
                title: Text(l10n.btnDelete),
                onTap: () => Navigator.pop(sheetContext, 'delete'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (action == 'copy') {
      await Clipboard.setData(ClipboardData(text: message.body));
    } else if (action == 'edit') {
      final controller = TextEditingController(text: message.body);
      final body = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.btnEdit),
          content: TextField(controller: controller, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.btnCancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: Text(l10n.btnSave),
            ),
          ],
        ),
      );
      controller.dispose();
      if (body != null && body.isNotEmpty && context.mounted) {
        final failure = await ref
            .read(
              messagesProvider((
                workspaceId: workspaceId,
                channelId: channelId,
              )).notifier,
            )
            .edit(message.id, body);
        if (failure != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.localizedMessage(context))),
          );
        }
      }
    } else if (action == 'delete') {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.btnDelete),
          content: Text(l10n.chatConfirmDeleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.btnCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.btnDelete),
            ),
          ],
        ),
      );
      if (shouldDelete != true || !context.mounted) return;
      final failure = await ref
          .read(
            messagesProvider((
              workspaceId: workspaceId,
              channelId: channelId,
            )).notifier,
          )
          .delete(message.id);
      if (failure != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.localizedMessage(context))),
        );
      }
    }
  }
}

class _MessageAttachment extends ConsumerWidget {
  final MessageModel message;
  const _MessageAttachment({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return ref
        .watch(chatAttachmentUrlProvider(message.fileId!))
        .when(
          loading: () => Container(
            width: 150,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: const LoadingSkeleton(height: 46),
          ),
          error: (_, __) => Text(l10n.errorGeneric),
          data: (url) => InkWell(
            onTap: () async {
              final opened = await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
              if (!opened && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
              }
            },
            child: message.isImage
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 260,
                      maxHeight: 220,
                    ),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text(l10n.errorGeneric),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.file, color: colors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(message.fileName ?? l10n.taskAttachFile),
                      ),
                    ],
                  ),
          ),
        );
  }
}

// ── MOBILE Chat List ──────────────────────────────────────────────────────────
class _MobileChatList extends ConsumerWidget {
  const _MobileChatList();

  Future<void> _showNewChatMenu(
    BuildContext context,
    WidgetRef ref,
    String wsId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.hash),
              title: Text(l10n.chatNewChannel),
              onTap: () => Navigator.pop(sheetContext, 'channel'),
            ),
            ListTile(
              leading: const Icon(LucideIcons.messageCircle),
              title: Text(l10n.chatNewDm),
              onTap: () => Navigator.pop(sheetContext, 'dm'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (action == 'channel') {
      await _showNewChannelDialog(context, ref, wsId);
    } else if (action == 'dm') {
      await _showNewDmPicker(context, ref, wsId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final channelsAsync = ref.watch(channelsProvider(wsId));

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatMenu(context, ref, wsId),
        backgroundColor: c.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.chatTitle,
                  style: AppText.pageTitleMobile.copyWith(color: c.textPrimary),
                ),
              ),
            ),
            // Search bar — functional TextField
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
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
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.searchChats,
                            hintStyle: AppText.body.copyWith(
                              color: c.textMuted,
                            ),
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) {}, // search filtering is Part B
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            channelsAsync.when(
              loading: () => const SliverFillRemaining(
                child: ContentLoadingSkeleton(
                  kind: LoadingSkeletonKind.rows,
                  itemCount: 5,
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: ErrorState(
                  message: error.toString(),
                  retryLabel: l10n.btnRetry,
                  onRetry: () => ref.invalidate(channelsProvider(wsId)),
                ),
              ),
              data: (channels) => channels.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyState(
                        icon: LucideIcons.messageCircle,
                        title: l10n.emptyStateNoChannels,
                        subtitle: l10n.emptyStateNoChannelsDesc,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((_, i) {
                          final ch = channels[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () => context.push('/chat/${ch.id}'),
                              child: _MobileChannelCard(channel: ch),
                            ),
                          );
                        }, childCount: channels.length),
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
    final l10n = AppLocalizations.of(context);
    final colors = [c.primary, c.violet, c.sky, c.success];
    final color = colors[channel.name.hashCode.abs() % colors.length];
    final channelName = channel.name ?? l10n.chatUnnamedChannel;
    final displayedName = channel.isDm
        ? _dmDisplayName(channel, l10n)
        : channelName;

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                displayedName[0].toUpperCase(),
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
                  displayedName,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
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
              child: Text(
                '${channel.unreadCount}',
                style: AppText.chip.copyWith(color: Colors.white),
              ),
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
    final l10n = AppLocalizations.of(context);
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final channelsAsync = ref.watch(channelsProvider(wsId));
    final presenceByUser = ref.watch(presenceProvider(wsId));

    final channel = channelsAsync.valueOrNull?.firstWhere(
      (ch) => ch.id == channelId,
      orElse: () => ChannelModel(id: channelId, workspaceId: wsId),
    );
    final dmPresence = channel?.isDm == true && channel!.memberIds.isNotEmpty
        ? presenceByUser[channel.memberIds.first]
        : null;

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
            Text(
              channel?.isDm == true
                  ? _dmDisplayName(channel!, l10n)
                  : channel?.name != null
                  ? '# ${channel!.name}'
                  : l10n.navChat,
              style: AppText.bodyStrong.copyWith(color: c.textPrimary),
            ),
            if (dmPresence != null)
              Text(
                _presenceStatusText(l10n, dmPresence) ?? '',
                style: AppText.caption.copyWith(color: c.textMuted),
              ),
          ],
        ),
        actions: [
          if (channel?.isChannel == true)
            IconButton(
              tooltip: l10n.chatManageMembers,
              onPressed: () =>
                  _manageChannelMembers(context, ref, wsId, channel!),
              icon: const Icon(LucideIcons.users),
            ),
        ],
      ),
      body: _ConversationPanel(channelId: channelId, workspaceId: wsId),
    );
  }
}
