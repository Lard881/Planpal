// app/lib/features/tasks/presentation/task_detail_screen.dart
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
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/network/failure_localizer.dart';
import '../data/task_repository.dart';
import '../models/task_model.dart';
import '../models/task_permissions.dart';
import '../providers/task_providers.dart';
import '../../documents/data/documents_repository.dart';
import '../../workspaces/models/workspace_model.dart';
import '../../workspaces/providers/workspace_providers.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return taskAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: ErrorState(
          message: e is AppFailure
              ? e.localizedMessage(context)
              : l10n.errorGeneric,
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
      ),
      data: (task) {
        if (task == null) {
          return Scaffold(
            body: EmptyState(
              icon: LucideIcons.alertCircle,
              title: l10n.emptyStateTaskNotFound,
            ),
          );
        }
        return _TaskDetailContent(task: task);
      },
    );
  }
}

class _TaskDetailContent extends ConsumerStatefulWidget {
  final TaskModel task;
  const _TaskDetailContent({required this.task});
  @override
  ConsumerState<_TaskDetailContent> createState() => _TaskDetailContentState();
}

class _TaskDetailContentState extends ConsumerState<_TaskDetailContent> {
  late TextEditingController _commentCtrl;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Timer? _titleDebounce;
  Timer? _descriptionDebounce;
  final Map<String, String> _pendingTextUpdates = {};
  String? _inlineTextStatus;
  bool _uploadingAttachment = false;
  ({int start, int end, String query})? _activeMention;

  @override
  void initState() {
    super.initState();
    _commentCtrl = TextEditingController();
    _commentCtrl.addListener(_updateMentionQuery);
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
  }

  @override
  void dispose() {
    _commentCtrl.removeListener(_updateMentionQuery);
    _commentCtrl.dispose();
    _titleDebounce?.cancel();
    _descriptionDebounce?.cancel();
    for (final entry in _pendingTextUpdates.entries) {
      unawaited(_persistInlineText(entry.key, entry.value));
    }
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateMentionQuery() {
    final selection = _commentCtrl.selection;
    final text = _commentCtrl.text;
    if (!selection.isValid || !selection.isCollapsed) {
      _setActiveMention(null);
      return;
    }

    final cursor = selection.baseOffset;
    if (cursor < 0 || cursor > text.length) {
      _setActiveMention(null);
      return;
    }
    final start = text.lastIndexOf('@', cursor - 1);
    if (start < 0 || (start > 0 && !RegExp(r'\s').hasMatch(text[start - 1]))) {
      _setActiveMention(null);
      return;
    }

    final query = text.substring(start + 1, cursor);
    if (RegExp(r'\s').hasMatch(query)) {
      _setActiveMention(null);
      return;
    }
    _setActiveMention((start: start, end: cursor, query: query));
  }

  void _setActiveMention(({int start, int end, String query})? mention) {
    if (_activeMention?.start == mention?.start &&
        _activeMention?.end == mention?.end &&
        _activeMention?.query == mention?.query) {
      return;
    }
    if (mounted) setState(() => _activeMention = mention);
  }

  void _insertMention(MemberModel member) {
    final mention = _activeMention;
    if (mention == null) return;

    final displayName =
        (member.fullName.trim().isEmpty ? member.email : member.fullName)
            .replaceAll(']', '')
            .replaceAll(RegExp(r'[\r\n]'), ' ')
            .trim();
    final encodedMention = '@[$displayName](user:${member.userId}) ';
    final text = _commentCtrl.text.replaceRange(
      mention.start,
      mention.end,
      encodedMention,
    );
    final cursor = mention.start + encodedMention.length;
    _commentCtrl.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor),
    );
    _setActiveMention(null);
  }

  @override
  void didUpdateWidget(covariant _TaskDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.title != widget.task.title &&
        _titleController.text == oldWidget.task.title) {
      _titleController.text = widget.task.title;
    }
    if (oldWidget.task.description != widget.task.description &&
        _descriptionController.text == oldWidget.task.description) {
      _descriptionController.text = widget.task.description;
    }
  }

  Future<void> _sendComment() async {
    final body = _commentCtrl.text.trim();
    if (body.isEmpty) return;
    final failure = await ref
        .read(taskRepositoryProvider)
        .addComment(widget.task.id, body);
    if (!mounted) return;
    if (failure == null ||
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure) {
      _commentCtrl.clear();
      ref.invalidate(taskDetailProvider(widget.task.id));
    }
    _showTaskActionResult(failure);
  }

  Future<void> _toggleSubtask(SubtaskModel subtask) async {
    final failure = await ref
        .read(taskRepositoryProvider)
        .updateSubtask(subtask.id, isDone: !subtask.isDone);
    if (!mounted) return;
    ref.invalidate(taskDetailProvider(widget.task.id));
    _showTaskActionResult(failure);
  }

  Future<void> _reorderSubtasks(int oldIndex, int newIndex) async {
    final orderedSubtasks = reorderSubtaskList(
      widget.task.subtasks,
      oldIndex,
      newIndex,
    );

    final failure = await ref
        .read(taskRepositoryProvider)
        .reorderSubtasks(orderedSubtasks);
    if (!mounted) return;
    ref.invalidate(taskDetailProvider(widget.task.id));
    _showTaskActionResult(failure);
  }

  Future<void> _deleteSubtask(
    SubtaskModel subtask,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmDeleteSubtaskTitle),
        content: Text(l10n.confirmDeleteBody),
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
    if (confirmed != true || !mounted) return;

    final failure = await ref
        .read(taskRepositoryProvider)
        .deleteSubtask(subtask.id);
    if (!mounted) return;
    if (failure == null ||
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure) {
      ref.invalidate(taskDetailProvider(widget.task.id));
    }
    _showTaskActionResult(failure);
  }

  Future<void> _openAttachment(AttachmentModel attachment) async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(isOnlineProvider)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOffline)));
      return;
    }

    final (downloadUrl, failure) = await ref
        .read(documentsRepositoryProvider)
        .getDownloadUrl(attachment.fileId);
    if (!mounted) return;
    if (failure != null || downloadUrl == null) {
      final message = failure is NetworkFailure
          ? l10n.errorNetwork
          : failure is ServerUnreachableFailure || failure is TimeoutFailure
          ? l10n.errorServer
          : failure is ForbiddenFailure
          ? l10n.errorPermission
          : l10n.taskAttachmentOpenFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    try {
      final opened = await launchUrl(
        Uri.parse(downloadUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOpenFailed)));
      }
    } on FormatException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOpenFailed)));
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOpenFailed)));
    }
  }

  Future<void> _pickAndAttachFile() async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(isOnlineProvider)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOffline)));
      return;
    }

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'txt',
          'csv',
          'zip',
        ],
        allowMultiple: false,
      );
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentUploadFailed)));
      return;
    }
    if (!mounted || result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final path = file.path;
    if (path == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentUploadFailed)));
      return;
    }

    setState(() => _uploadingAttachment = true);
    final documents = ref.read(documentsRepositoryProvider);
    final (fileId, uploadFailure) = await documents.uploadFile(
      widget.task.workspaceId,
      File(path),
      mimeTypeForFileName(file.name),
    );
    if (!mounted) return;
    if (fileId == null || uploadFailure != null) {
      setState(() => _uploadingAttachment = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentUploadFailed)));
      return;
    }

    final attachFailure = await ref
        .read(taskRepositoryProvider)
        .attachFile(widget.task.id, fileId);
    if (!mounted) return;
    final isQueuedFailure =
        attachFailure is NetworkFailure ||
        attachFailure is ServerUnreachableFailure ||
        attachFailure is TimeoutFailure;
    if (attachFailure != null && !isQueuedFailure) {
      final cleanupFailure = await documents.deleteFile(fileId);
      if (!mounted) return;
      setState(() => _uploadingAttachment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cleanupFailure == null
                ? l10n.taskAttachmentUploadFailed
                : l10n.errorGeneric,
          ),
        ),
      );
      return;
    }

    setState(() => _uploadingAttachment = false);
    ref.invalidate(taskDetailProvider(widget.task.id));
    _showTaskActionResult(attachFailure);
  }

  Future<void> _showTaskMenu(
    TaskModel task,
    TaskPermissions permissions,
  ) async {
    final l10n = AppLocalizations.of(context);
    final workspacesAsync = ref.read(workspacesProvider);
    final workspaces = workspacesAsync.valueOrNull;
    if (workspaces == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      return;
    }

    final canMove =
        permissions.canEditFields &&
        workspaces.any(
          (workspace) =>
              workspace.id != task.workspaceId &&
              (workspace.isAdmin || workspace.isMember),
        );
    final canDelete = permissions.canDelete;
    final canEditReminder = permissions.canEditFields && task.dueAt != null;
    if (!canMove && !canDelete && !canEditReminder) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorPermission)));
      return;
    }

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEditReminder)
              ListTile(
                leading: const Icon(LucideIcons.bell),
                title: Text(l10n.fieldTaskReminder),
                onTap: () => Navigator.pop(sheetContext, 'reminder'),
              ),
            if (canMove)
              ListTile(
                leading: const Icon(LucideIcons.arrowRightLeft),
                title: Text(l10n.taskMoveToWorkspace),
                onTap: () => Navigator.pop(sheetContext, 'move'),
              ),
            if (canDelete)
              ListTile(
                leading: const Icon(LucideIcons.trash2),
                title: Text(l10n.btnDelete),
                onTap: () => Navigator.pop(sheetContext, 'delete'),
              ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;

    if (action == 'reminder') {
      await _editReminder();
      return;
    }

    if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.confirmDeleteTaskTitle),
          content: Text(l10n.confirmDeleteBody),
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
      if (confirmed != true || !mounted) return;

      final failure = await ref
          .read(taskRepositoryProvider)
          .deleteTask(task.id);
      if (!mounted) return;
      final queued =
          failure is NetworkFailure ||
          failure is ServerUnreachableFailure ||
          failure is TimeoutFailure;
      if (failure == null || queued) {
        ref.invalidate(taskListProvider(task.workspaceId));
        context.pop();
      }
      _showTaskActionResult(failure);
      return;
    }

    final targetWorkspace = await showDialog<WorkspaceModel>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.taskMoveToWorkspace),
        content: SizedBox(
          width: 360,
          height: 320,
          child: ListView(
            shrinkWrap: true,
            children: workspaces
                .where(
                  (workspace) =>
                      workspace.id != task.workspaceId &&
                      (workspace.isAdmin || workspace.isMember),
                )
                .map(
                  (workspace) => ListTile(
                    title: Text(workspace.name),
                    onTap: () => Navigator.pop(dialogContext, workspace),
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
    if (targetWorkspace == null || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.taskMoveToWorkspace),
        content: Text(l10n.taskMoveConfirmation(targetWorkspace.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.btnMove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final failure = await ref
        .read(taskRepositoryProvider)
        .moveTask(task.id, targetWorkspace.id);
    if (!mounted) return;
    if (failure == null) {
      ref
        ..invalidate(taskListProvider(task.workspaceId))
        ..invalidate(taskListProvider(targetWorkspace.id))
        ..invalidate(taskDetailProvider(task.id));
      context.pop();
    }
    if (failure != null) {
      final message = failure is NetworkFailure
          ? l10n.errorNetwork
          : failure is ServerUnreachableFailure || failure is TimeoutFailure
          ? l10n.errorServer
          : failure.localizedMessage(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showTaskActionResult(AppFailure? failure) {
    final l10n = AppLocalizations.of(context);
    final isQueuedFailure =
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure;
    final message = failure == null
        ? l10n.syncSaved
        : isQueuedFailure
        ? l10n.syncWaitingShort
        : failure.localizedMessage(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _commentRelativeTime(DateTime createdAt, AppLocalizations l10n) {
    final age = DateTime.now().difference(createdAt);
    if (age.isNegative || age.inMinutes < 1) return l10n.tasksCommentJustNow;
    if (age.inMinutes < 60) {
      return l10n.tasksCommentMinutesAgo(age.inMinutes);
    }
    if (age.inHours < 24) {
      return l10n.tasksCommentHoursAgo(age.inHours);
    }
    if (age.inDays == 1) return l10n.yesterday;
    return l10n.tasksCommentDaysAgo(age.inDays);
  }

  Future<void> _saveTaskUpdates(Map<String, dynamic> updates) async {
    final taskId = widget.task.id;
    final l10n = AppLocalizations.of(context);
    final failure = await ref
        .read(taskRepositoryProvider)
        .updateTask(taskId, updates);
    if (!mounted) return;

    final isQueuedFailure =
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure;
    if (failure == null || isQueuedFailure) {
      ref.invalidate(taskDetailProvider(taskId));
    }

    final message = failure == null
        ? l10n.syncSaved
        : isQueuedFailure
        ? l10n.syncWaitingShort
        : failure.localizedMessage(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _scheduleInlineTextSave(String field, String value) {
    _pendingTextUpdates[field] = value;
    if (mounted) {
      setState(() {
        _inlineTextStatus = AppLocalizations.of(context).syncSaving;
      });
    }
    final timer = Timer(const Duration(milliseconds: 800), () {
      final latestValue = _pendingTextUpdates.remove(field);
      if (latestValue == null) return;
      if (field == 'title' && latestValue.trim().isEmpty) {
        if (mounted) {
          setState(() {
            _inlineTextStatus = AppLocalizations.of(
              context,
            ).validationTaskNameRequired;
          });
        }
        return;
      }
      unawaited(_persistInlineText(field, latestValue.trim()));
    });
    if (field == 'title') {
      _titleDebounce?.cancel();
      _titleDebounce = timer;
    } else {
      _descriptionDebounce?.cancel();
      _descriptionDebounce = timer;
    }
  }

  Future<void> _persistInlineText(String field, String value) async {
    final failure = await ref.read(taskRepositoryProvider).updateTask(
      widget.task.id,
      {field: value},
    );
    final isQueuedFailure =
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure;
    if (mounted && (failure == null || isQueuedFailure)) {
      ref.invalidate(taskDetailProvider(widget.task.id));
    }
    if (!mounted) {
      if (failure != null && !isQueuedFailure) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: failure,
            library: 'inline task text update',
          ),
        );
      }
      return;
    }
    setState(() {
      _inlineTextStatus = failure == null
          ? AppLocalizations.of(context).syncSaved
          : isQueuedFailure
          ? AppLocalizations.of(context).syncWaitingShort
          : failure.localizedMessage(context);
    });
    if (failure != null && !isQueuedFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
    }
  }

  Future<void> _editDueDate() async {
    final currentDate = widget.task.dueAt;
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (!mounted || date == null) return;

    final currentTime = currentDate == null
        ? const TimeOfDay(hour: 10, minute: 0)
        : TimeOfDay.fromDateTime(currentDate);
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (!mounted || time == null) return;

    final dueAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    await _saveTaskUpdates({'dueAt': dueAt.toIso8601String()});
  }

  Future<void> _clearDueDate() async {
    await _saveTaskUpdates({'dueAt': null, 'reminderMinutesBefore': null});
  }

  Future<void> _editReminder() async {
    final task = widget.task;
    final l10n = AppLocalizations.of(context);
    if (task.dueAt == null) return;

    final controller = TextEditingController(
      text: task.reminderMinutesBefore?.toString() ?? '',
    );
    String? validationError;
    final result = await showDialog<({bool saved, int? minutes})>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.fieldTaskReminder),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.fieldTaskReminderHint,
                  errorText: validationError,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.fieldTaskReminderHint,
                style: AppText.body.copyWith(color: context.colors.textMuted),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.btnCancel),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                final minutes = text.isEmpty ? null : int.tryParse(text);
                if (text.isNotEmpty && (minutes == null || minutes < 5)) {
                  setDialogState(
                    () => validationError = l10n.validationTaskReminderMinimum,
                  );
                  return;
                }
                Navigator.pop(dialogContext, (saved: true, minutes: minutes));
              },
              child: Text(l10n.btnSave),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result == null || !result.saved || !mounted) return;

    final failure = await ref.read(taskRepositoryProvider).updateTask(task.id, {
      'reminderMinutesBefore': result.minutes,
    });
    if (!mounted) return;
    final isQueuedFailure =
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure;
    if (failure == null || isQueuedFailure) {
      ref.invalidate(taskDetailProvider(task.id));
    }
    final message = failure == null
        ? l10n.syncSaved
        : isQueuedFailure
        ? l10n.syncWaitingShort
        : failure.localizedMessage(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final mentionMembersAsync = ref.watch(
      workspaceMembersProvider(task.workspaceId),
    );
    final workspaces = ref.watch(workspacesProvider).valueOrNull ?? const [];
    String? taskWorkspaceRole;
    for (final workspace in workspaces) {
      if (workspace.id == task.workspaceId) {
        taskWorkspaceRole = workspace.role;
        break;
      }
    }
    final doneCount = task.subtasks.where((s) => s.isDone).length;
    final totalCount = task.subtasks.length;
    final isOverdue = task.isOverdue;
    final permissions = TaskPermissions.forTask(
      role: taskWorkspaceRole,
      userId: Supabase.instance.client.auth.currentUser?.id,
      task: task,
    );
    final screenSlivers = <SliverToBoxAdapter>[
      // Header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              if (!context.isDesktopLayout)
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      border: Border.all(color: c.border),
                    ),
                    child: Icon(
                      LucideIcons.arrowLeft,
                      size: 18,
                      color: c.textPrimary,
                    ),
                  ),
                )
              else
                const SizedBox(width: 36),
              Expanded(
                child: Center(
                  child: Text(
                    l10n.tasksDetailTitle,
                    style: AppText.cardTitle.copyWith(color: c.textPrimary),
                  ),
                ),
              ),
              if (!context.isDesktopLayout)
                IconButton(
                  tooltip: l10n.tasksDetailTitle,
                  onPressed: () => _showTaskMenu(task, permissions),
                  icon: Icon(LucideIcons.moreHorizontal, color: c.textMuted),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
      // Priority + Status chips
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              if (permissions.canEditFields)
                PopupMenuButton<String>(
                  tooltip: l10n.fieldPriority,
                  onSelected: (priority) =>
                      _saveTaskUpdates({'priority': priority}),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'high',
                      child: Text(l10n.priorityHigh),
                    ),
                    PopupMenuItem(
                      value: 'medium',
                      child: Text(l10n.priorityMedium),
                    ),
                    PopupMenuItem(value: 'low', child: Text(l10n.priorityLow)),
                  ],
                  child: PriorityChip(priority: task.priority),
                )
              else
                Tooltip(
                  message: l10n.errorPermission,
                  child: PriorityChip(priority: task.priority),
                ),
              const SizedBox(width: 8),
              if (permissions.canChangeStatus)
                PopupMenuButton<String>(
                  tooltip: l10n.fieldStatus,
                  onSelected: (status) => _saveTaskUpdates({'status': status}),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'todo', child: Text(l10n.statusTodo)),
                    PopupMenuItem(
                      value: 'in_progress',
                      child: Text(l10n.statusInProgress),
                    ),
                    PopupMenuItem(
                      value: 'completed',
                      child: Text(l10n.statusCompleted),
                    ),
                  ],
                  child: StatusChip(
                    status: isOverdue ? 'overdue' : task.status,
                  ),
                )
              else
                Tooltip(
                  message: l10n.errorPermission,
                  child: StatusChip(
                    status: isOverdue ? 'overdue' : task.status,
                  ),
                ),
            ],
          ),
        ),
      ),
      // Title
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            controller: _titleController,
            readOnly: !permissions.canEditFields,
            minLines: 1,
            maxLines: 3,
            onChanged: (value) => _scheduleInlineTextSave('title', value),
            style: AppText.pageTitle.copyWith(color: c.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.fieldTaskNameHint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Icon(LucideIcons.calendar, size: 16, color: c.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: permissions.canEditFields ? _editDueDate : null,
                  child: Text(
                    task.dueAt == null
                        ? l10n.taskNoDueDate
                        : '${l10n.fieldDueDate} · ${_formatDue(task.dueAt!)}',
                    style: AppText.body.copyWith(
                      color: isOverdue ? c.danger : c.textMuted,
                    ),
                  ),
                ),
              ),
              if (task.dueAt != null)
                IconButton(
                  onPressed: permissions.canEditFields ? _clearDueDate : null,
                  tooltip: permissions.canEditFields
                      ? l10n.taskClearDueDate
                      : l10n.errorPermission,
                  icon: Icon(LucideIcons.x, size: 18, color: c.textMuted),
                ),
            ],
          ),
        ),
      ),
      // Description card
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isDesktopLayout ? 0 : 16,
            0,
            context.isDesktopLayout ? 0 : 16,
            8,
          ),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tasksDescriptionLabel,
                  style: AppText.cardTitle.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  readOnly: !permissions.canEditFields,
                  minLines: 2,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) =>
                      _scheduleInlineTextSave('description', value),
                  style: AppText.body.copyWith(color: c.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.tasksNoDescription,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                if (_inlineTextStatus != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _inlineTextStatus!,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      // Subtasks card
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isDesktopLayout ? 0 : 16,
            0,
            context.isDesktopLayout ? 0 : 16,
            8,
          ),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      totalCount > 0
                          ? l10n.tasksSubtasksLabel(doneCount, totalCount)
                          : l10n.tasksSubtasksTitle,
                      style: AppText.cardTitle.copyWith(color: c.textPrimary),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: permissions.canEditFields
                          ? () => _showAddSubtask(context, l10n)
                          : null,
                      child: Text(
                        l10n.btnAdd,
                        style: AppText.bodyMedium.copyWith(color: c.primary),
                      ),
                    ),
                  ],
                ),
                if (totalCount > 0) ...[
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: totalCount > 0 ? doneCount / totalCount : 0,
                      minHeight: 6,
                      backgroundColor: c.surfaceAlt,
                      valueColor: AlwaysStoppedAnimation(c.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: task.subtasks.length,
                    onReorderItem: permissions.canEditFields
                        ? _reorderSubtasks
                        : (_, __) {},
                    itemBuilder: (context, index) {
                      final subtask = task.subtasks[index];
                      return Padding(
                        key: ValueKey(subtask.id),
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            if (permissions.canEditFields)
                              ReorderableDelayedDragStartListener(
                                index: index,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    LucideIcons.gripVertical,
                                    size: 18,
                                    color: c.textMuted,
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: permissions.canEditFields
                                  ? () => _toggleSubtask(subtask)
                                  : null,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: subtask.isDone
                                      ? c.primary
                                      : Colors.transparent,
                                  border: subtask.isDone
                                      ? null
                                      : Border.all(color: c.border, width: 1.5),
                                ),
                                child: subtask.isDone
                                    ? const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                subtask.title,
                                style: AppText.body.copyWith(
                                  color: subtask.isDone
                                      ? c.textMuted
                                      : c.textPrimary,
                                  decoration: subtask.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            if (permissions.canEditFields)
                              IconButton(
                                tooltip: l10n.btnDelete,
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _deleteSubtask(subtask, l10n),
                                icon: Icon(
                                  LucideIcons.trash2,
                                  size: 16,
                                  color: c.textMuted,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      // Assignee & Label card
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isDesktopLayout ? 0 : 16,
            0,
            context.isDesktopLayout ? 0 : 16,
            8,
          ),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tasksAssigneeLabel,
                  style: AppText.cardTitle.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 12),
                _TaskAssigneePicker(
                  workspaceId: task.workspaceId,
                  selectedId: task.assigneeId,
                  selectedName: task.assigneeName,
                  enabled: permissions.canEditFields,
                  onChanged: (assigneeId) =>
                      _saveTaskUpdates({'assigneeId': assigneeId}),
                ),
                const SizedBox(height: 12),
                _TaskLabelPicker(
                  workspaceId: task.workspaceId,
                  selectedId: task.labelId,
                  selectedName: task.labelName,
                  selectedColor: task.labelColor,
                  enabled: permissions.canEditFields,
                  onChanged: (labelId) =>
                      _saveTaskUpdates({'labelId': labelId}),
                ),
              ],
            ),
          ),
        ),
      ),
      // Attachments
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isDesktopLayout ? 0 : 16,
            0,
            context.isDesktopLayout ? 0 : 16,
            8,
          ),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.tasksAttachments,
                        style: AppText.cardTitle.copyWith(color: c.textPrimary),
                      ),
                    ),
                    if (permissions.canEditFields)
                      IconButton(
                        tooltip: l10n.taskAttachFile,
                        onPressed: isOnline && !_uploadingAttachment
                            ? _pickAndAttachFile
                            : null,
                        icon: _uploadingAttachment
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(LucideIcons.paperclip),
                      ),
                  ],
                ),
                if (!isOnline) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.taskAttachmentOffline,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ],
                const SizedBox(height: 8),
                if (task.attachments.isEmpty)
                  Text(
                    l10n.taskNoAttachments,
                    style: AppText.body.copyWith(color: c.textMuted),
                  )
                else
                  ...task.attachments.map(
                    (attachment) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(LucideIcons.file, color: c.primary),
                      title: Text(
                        attachment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyMedium.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        attachment.sizeLabel,
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                      trailing: Icon(
                        LucideIcons.download,
                        color: isOnline ? c.primary : c.textMuted,
                      ),
                      onTap: isOnline
                          ? () => _openAttachment(attachment)
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      // Comments card
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isDesktopLayout ? 0 : 16,
            0,
            context.isDesktopLayout ? 0 : 16,
            24,
          ),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tasksComments,
                  style: AppText.cardTitle.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 12),
                ...task.comments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(
                            userId: comment.authorId,
                            name: comment.authorName?.trim().isNotEmpty == true
                                ? comment.authorName!.trim()
                                : l10n.roleMember,
                            avatarUrl: comment.authorAvatarUrl,
                            size: 32,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        comment.authorName?.trim().isNotEmpty ==
                                                true
                                            ? comment.authorName!.trim()
                                            : l10n.roleMember,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.bodyMedium.copyWith(
                                          color: c.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _commentRelativeTime(
                                        comment.createdAt,
                                        l10n,
                                      ),
                                      style: AppText.caption.copyWith(
                                        color: c.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.body,
                                  style: AppText.body.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Comment composer
                if (permissions.canComment)
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _commentCtrl,
                            decoration: InputDecoration(
                              hintText: l10n.fieldWriteComment,
                              hintStyle: AppText.body.copyWith(
                                color: c.textMuted,
                              ),
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) => _sendComment(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            LucideIcons.sendHorizonal,
                            size: 18,
                            color: c.primary,
                          ),
                          onPressed: _sendComment,
                        ),
                      ],
                    ),
                  )
                else
                  Tooltip(
                    message: l10n.errorPermission,
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: l10n.errorPermission,
                      ),
                    ),
                  ),
                if (permissions.canComment && _activeMention != null)
                  mentionMembersAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, _) => TextButton.icon(
                      onPressed: () => ref.invalidate(
                        workspaceMembersProvider(task.workspaceId),
                      ),
                      icon: const Icon(LucideIcons.refreshCw, size: 16),
                      label: Text(l10n.errorGeneric),
                    ),
                    data: (members) {
                      final query = _activeMention!.query.toLowerCase();
                      final matches = members
                          .where((member) {
                            final name = member.fullName.toLowerCase();
                            final email = member.email.toLowerCase();
                            return name.contains(query) ||
                                email.contains(query);
                          })
                          .take(5);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: matches
                            .map(
                              (member) => ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                leading: Avatar(
                                  userId: member.userId,
                                  name: member.fullName.isNotEmpty
                                      ? member.fullName
                                      : member.email,
                                  avatarUrl: member.avatarUrl,
                                  size: 32,
                                ),
                                title: Text(
                                  member.fullName.isNotEmpty
                                      ? member.fullName
                                      : member.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: member.email.isNotEmpty
                                    ? Text(
                                        member.email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                onTap: () => _insertMention(member),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    ];
    final arrangedSlivers = context.isDesktopLayout
        ? <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(LucideIcons.arrowLeft, size: 18),
                    label: Text(l10n.tasksBackToTasks),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                child: AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (permissions.canEditFields)
                            PopupMenuButton<String>(
                              tooltip: l10n.fieldPriority,
                              onSelected: (priority) =>
                                  _saveTaskUpdates({'priority': priority}),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: 'high',
                                  child: Text(l10n.priorityHigh),
                                ),
                                PopupMenuItem(
                                  value: 'medium',
                                  child: Text(l10n.priorityMedium),
                                ),
                                PopupMenuItem(
                                  value: 'low',
                                  child: Text(l10n.priorityLow),
                                ),
                              ],
                              child: PriorityChip(priority: task.priority),
                            )
                          else
                            PriorityChip(priority: task.priority),
                          const SizedBox(width: 8),
                          if (permissions.canChangeStatus)
                            PopupMenuButton<String>(
                              tooltip: l10n.fieldStatus,
                              onSelected: (status) =>
                                  _saveTaskUpdates({'status': status}),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: 'todo',
                                  child: Text(l10n.statusTodo),
                                ),
                                PopupMenuItem(
                                  value: 'in_progress',
                                  child: Text(l10n.statusInProgress),
                                ),
                                PopupMenuItem(
                                  value: 'completed',
                                  child: Text(l10n.statusCompleted),
                                ),
                              ],
                              child: StatusChip(
                                status: isOverdue ? 'overdue' : task.status,
                              ),
                            )
                          else
                            StatusChip(
                              status: isOverdue ? 'overdue' : task.status,
                            ),
                          const Spacer(),
                          IconButton(
                            tooltip: l10n.tasksDetailTitle,
                            onPressed: () => _showTaskMenu(task, permissions),
                            icon: Icon(
                              LucideIcons.moreHorizontal,
                              color: c.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _titleController,
                        readOnly: !permissions.canEditFields,
                        minLines: 1,
                        maxLines: 2,
                        onChanged: (value) =>
                            _scheduleInlineTextSave('title', value),
                        style: AppText.pageTitle.copyWith(color: c.textPrimary),
                        decoration: InputDecoration(
                          hintText: l10n.fieldTaskNameHint,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            size: 16,
                            color: c.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: permissions.canEditFields
                                  ? _editDueDate
                                  : null,
                              child: Text(
                                task.dueAt == null
                                    ? l10n.taskNoDueDate
                                    : '${l10n.fieldDueDate} · ${_formatDue(task.dueAt!)}',
                                style: AppText.body.copyWith(
                                  color: isOverdue ? c.danger : c.textMuted,
                                ),
                              ),
                            ),
                          ),
                          if (task.dueAt != null)
                            IconButton(
                              onPressed: permissions.canEditFields
                                  ? _clearDueDate
                                  : null,
                              tooltip: permissions.canEditFields
                                  ? l10n.taskClearDueDate
                                  : l10n.errorPermission,
                              icon: Icon(
                                LucideIcons.x,
                                size: 18,
                                color: c.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          screenSlivers[4].child!,
                          screenSlivers[5].child!,
                          screenSlivers[7].child!,
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          screenSlivers[6].child!,
                          screenSlivers[8].child!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        : screenSlivers;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(child: CustomScrollView(slivers: arrangedSlivers)),
    );
  }

  void _showAddSubtask(BuildContext context, AppLocalizations l10n) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.tasksAddSubtask),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: l10n.fieldSubtaskHint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final failure = await ref
                    .read(taskRepositoryProvider)
                    .addSubtask(widget.task.id, ctrl.text.trim());
                if (!context.mounted) return;
                ref.invalidate(taskDetailProvider(widget.task.id));
                _showTaskActionResult(failure);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.btnAdd),
          ),
        ],
      ),
    );
  }

  String _formatDue(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day} · $hour:$min $ampm';
  }
}

class _TaskAssigneePicker extends ConsumerWidget {
  final String workspaceId;
  final String? selectedId;
  final String? selectedName;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _TaskAssigneePicker({
    required this.workspaceId,
    required this.selectedId,
    required this.selectedName,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final membersAsync = ref.watch(workspaceMembersProvider(workspaceId));

    return membersAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => isOnline
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    error is AppFailure
                        ? error.localizedMessage(context)
                        : l10n.errorGeneric,
                    style: AppText.body.copyWith(color: c.danger),
                  ),
                ),
                IconButton(
                  tooltip: l10n.btnRetry,
                  onPressed: () =>
                      ref.invalidate(workspaceMembersProvider(workspaceId)),
                  icon: Icon(LucideIcons.refreshCw, color: c.textMuted),
                ),
              ],
            )
          : Tooltip(
              message: l10n.bannerOffline,
              child: Text(
                selectedName ?? l10n.tasksUnassigned,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
            ),
      data: (members) {
        final validIds = members.map((member) => member.userId).toSet();
        final value = selectedId != null && validIds.contains(selectedId)
            ? selectedId
            : null;
        return Tooltip(
          message: enabled ? l10n.fieldAssignee : l10n.errorPermission,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: value,
              isExpanded: true,
              hint: Text(
                l10n.tasksUnassigned,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.tasksUnassigned),
                ),
                ...members.map(
                  (member) => DropdownMenuItem<String?>(
                    value: member.userId,
                    child: Text(
                      member.fullName.trim().isEmpty
                          ? member.email
                          : member.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: enabled ? onChanged : null,
            ),
          ),
        );
      },
    );
  }
}

class _TaskLabelPicker extends ConsumerWidget {
  final String workspaceId;
  final String? selectedId;
  final String? selectedName;
  final String? selectedColor;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _TaskLabelPicker({
    required this.workspaceId,
    required this.selectedId,
    required this.selectedName,
    required this.selectedColor,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final labelsAsync = ref.watch(labelsProvider(workspaceId));

    return labelsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => isOnline
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    error is AppFailure
                        ? error.localizedMessage(context)
                        : l10n.errorGeneric,
                    style: AppText.body.copyWith(color: c.danger),
                  ),
                ),
                IconButton(
                  tooltip: l10n.btnRetry,
                  onPressed: () => ref.invalidate(labelsProvider(workspaceId)),
                  icon: Icon(LucideIcons.refreshCw, color: c.textMuted),
                ),
              ],
            )
          : Tooltip(
              message: l10n.bannerOffline,
              child: Row(
                children: [
                  if (selectedColor != null) ...[
                    _LabelDot(
                      color: _taskLabelColor(selectedColor!, c.primary),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    selectedName ?? l10n.fieldLabelOptional,
                    style: AppText.body.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
      data: (labels) {
        final matchingLabels = labels.where((label) => label.id == selectedId);
        final selectedLabel = matchingLabels.isEmpty
            ? null
            : matchingLabels.first;
        final value = selectedLabel?.id;
        final displayName = selectedLabel?.name ?? selectedName;
        final displayColor = selectedLabel?.color ?? selectedColor;

        return Tooltip(
          message: enabled ? l10n.fieldLabel : l10n.errorPermission,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: value,
              isExpanded: true,
              hint: Row(
                children: [
                  if (displayColor != null) ...[
                    _LabelDot(color: _taskLabelColor(displayColor, c.primary)),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    displayName ?? l10n.fieldLabelOptional,
                    style: AppText.body.copyWith(
                      color: displayName == null ? c.textMuted : c.textPrimary,
                    ),
                  ),
                ],
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.fieldLabelOptional),
                ),
                ...labels.map(
                  (label) => DropdownMenuItem<String?>(
                    value: label.id,
                    child: Row(
                      children: [
                        _LabelDot(
                          color: _taskLabelColor(label.color, c.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(label.name),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: enabled ? onChanged : null,
            ),
          ),
        );
      },
    );
  }
}

class _LabelDot extends StatelessWidget {
  final Color color;
  const _LabelDot({required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

Color _taskLabelColor(String hex, Color fallback) {
  try {
    return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
  } on FormatException {
    return fallback;
  }
}
