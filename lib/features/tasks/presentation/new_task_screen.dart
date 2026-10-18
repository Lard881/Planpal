// app/lib/features/tasks/presentation/new_task_screen.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/failure_localizer.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../documents/data/documents_repository.dart';
import '../data/task_repository.dart';
import '../providers/task_providers.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  const NewTaskScreen({super.key});
  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _subtaskCtrl = TextEditingController();
  String _priority = 'medium';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _assigneeId;
  String? _labelId;
  final List<String> _subtasks = [];
  final List<PlatformFile> _pendingAttachments = [];
  bool _loading = false;
  String? _titleError;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _subtaskCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _assigneeId = Supabase.instance.client.auth.currentUser?.id;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_pendingAttachments.isNotEmpty && !ref.read(isOnlineProvider)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOffline)));
      return;
    }
    if (!ref.read(currentRolePermissionsProvider).canCreateTask) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorPermission)));
      return;
    }
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _titleError = l10n.validationTaskNameRequired);
      return;
    }
    setState(() {
      _loading = true;
      _titleError = null;
    });
    final wsId = ref.read(currentWorkspaceIdProvider) ?? '';
    final documents = ref.read(documentsRepositoryProvider);
    final uploadedFileIds = <String>[];
    for (final attachment in _pendingAttachments) {
      final path = attachment.path;
      if (path == null) {
        await _removeUploadedFiles(documents, uploadedFileIds);
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.taskAttachmentUploadFailed)),
        );
        return;
      }
      final (fileId, uploadFailure) = await documents.uploadFile(
        wsId,
        File(path),
        mimeTypeForFileName(attachment.name),
      );
      if (fileId == null || uploadFailure != null) {
        final cleanupFailed = await _removeUploadedFiles(
          documents,
          uploadedFileIds,
        );
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              cleanupFailed
                  ? l10n.errorGeneric
                  : l10n.taskAttachmentUploadFailed,
            ),
          ),
        );
        return;
      }
      uploadedFileIds.add(fileId);
    }

    DateTime? dueAt;
    if (_dueDate != null) {
      final t = _dueTime ?? const TimeOfDay(hour: 10, minute: 0);
      dueAt = DateTime(
        _dueDate!.year,
        _dueDate!.month,
        _dueDate!.day,
        t.hour,
        t.minute,
      );
    }

    final (task, err) = await ref
        .read(taskRepositoryProvider)
        .createTask(
          wsId,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          priority: _priority,
          dueAt: dueAt,
          assigneeId: _assigneeId,
          labelId: _labelId,
          subtaskTitles: _subtasks,
          attachmentFileIds: uploadedFileIds,
        );

    if (!mounted) return;
    setState(() => _loading = false);
    final messenger = ScaffoldMessenger.of(context);
    if (task != null) {
      ref.invalidate(taskListProvider(wsId));
      ref.invalidate(currentWorkspaceTasksProvider);
      if (err != null) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.syncWaitingShort)));
      }
      context.go('/tasks');
    } else if (err != null) {
      final cleanupFailed = await _removeUploadedFiles(
        documents,
        uploadedFileIds,
      );
      if (!mounted) return;
      if (cleanupFailed) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.taskAttachmentUploadFailed)),
        );
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(err.localizedMessage(context))),
      );
    }
  }

  Future<bool> _removeUploadedFiles(
    DocumentsRepository documents,
    List<String> fileIds,
  ) async {
    var failed = false;
    for (final fileId in fileIds) {
      if (await documents.deleteFile(fileId) != null) failed = true;
    }
    return failed;
  }

  Future<void> _createLabel(String workspaceId) async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(isOnlineProvider)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorNetwork)));
      return;
    }

    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.taskCreateLabelTitle),
        content: TextField(
          controller: nameController,
          autofocus: true,
          maxLength: 40,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.taskLabelNameHint),
          onSubmitted: (value) {
            final trimmed = value.trim();
            if (trimmed.isNotEmpty) Navigator.pop(dialogContext, trimmed);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = nameController.text.trim();
              if (trimmed.isNotEmpty) {
                Navigator.pop(dialogContext, trimmed);
              }
            },
            child: Text(l10n.btnCreate),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (!mounted || name == null) return;

    try {
      final response = await ref
          .read(apiClientProvider)
          .dio
          .post(
            '/workspaces/$workspaceId/labels',
            data: {'name': name, 'color': '#3B82F6'},
          );
      final label = LabelModel.fromJson(
        response.data['label'] as Map<String, dynamic>,
      );
      final refreshedLabels = await ref.refresh(
        labelsProvider(workspaceId).future,
      );
      if (!refreshedLabels.any((entry) => entry.id == label.id)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
        }
        return;
      }
      if (mounted) setState(() => _labelId = label.id);
    } on DioException catch (error) {
      if (!mounted) return;
      final failure = mapDioError(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
    }
  }

  Future<void> _pickAttachments(AppLocalizations l10n) async {
    try {
      final files = await FilePicker.platform.pickFiles(
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
        allowMultiple: true,
      );
      if (!mounted || files == null) return;
      setState(() {
        for (final file in files.files) {
          if (!_pendingAttachments.any(
            (existing) => existing.path != null && existing.path == file.path,
          )) {
            _pendingAttachments.add(file);
          }
        }
      });
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentUploadFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktopLayout;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: c.scrim,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final dialogWidth = (constraints.maxWidth - 32)
                .clamp(0.0, 680.0)
                .toDouble();
            final dialogHeight = (constraints.maxHeight - 32)
                .clamp(0.0, 840.0)
                .toDouble();
            return Center(
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.panel),
                  border: Border.all(color: c.border),
                  boxShadow: AppShadows.card(Theme.of(context).brightness),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            l10n.tasksNewTitle,
                            style: AppText.pageTitle.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: l10n.btnCancel,
                            icon: Icon(LucideIcons.x, color: c.textMuted),
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        child: _buildForm(c, l10n, isDesktop: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: PlanPalButton(
                        label: l10n.btnCreateTask,
                        onPressed: _submit,
                        loading: _loading,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // Mobile full screen
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
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
                        LucideIcons.x,
                        size: 18,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.tasksNewTitle,
                        style: AppText.cardTitle.copyWith(color: c.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildForm(c, l10n, isDesktop: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: PlanPalButton(
                label: l10n.btnCreateTask,
                onPressed: _submit,
                loading: _loading,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
    PlanPalColors c,
    AppLocalizations l10n, {
    required bool isDesktop,
  }) {
    final workspaceId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final isPersonalWorkspace =
        workspace?.id == workspaceId && workspace?.isPersonal == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlanPalTextField(
          label: l10n.fieldTaskName,
          hint: l10n.fieldTaskNameHint,
          controller: _titleCtrl,
          errorText: _titleError,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _titleError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldDescription,
          hint: l10n.fieldDescriptionHint,
          controller: _descCtrl,
          maxLines: isDesktop ? 1 : 3,
          textInputAction: isDesktop
              ? TextInputAction.next
              : TextInputAction.newline,
        ),
        const SizedBox(height: 16),
        // Due Date + Time side by side
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fieldDueDate,
                    style: AppText.label.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _dueDate = d);
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dueDate != null
                              ? MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(_dueDate!)
                              : l10n.fieldDueDateOptional,
                          style: AppText.body.copyWith(
                            color: _dueDate != null
                                ? c.textPrimary
                                : c.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fieldTime,
                    style: AppText.label.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime:
                            _dueTime ?? const TimeOfDay(hour: 10, minute: 0),
                      );
                      if (t != null) setState(() => _dueTime = t);
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dueTime != null
                              ? _dueTime!.format(context)
                              : l10n.fieldTimeOptional,
                          style: AppText.body.copyWith(
                            color: _dueTime != null
                                ? c.textPrimary
                                : c.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Priority segmented control
        Text(
          l10n.fieldPriority,
          style: AppText.label.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 6),
        _PrioritySegmented(
          value: _priority,
          onChanged: (v) => setState(() => _priority = v),
        ),
        const SizedBox(height: 16),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAssigneeField(
                  c,
                  l10n,
                  workspaceId,
                  isPersonalWorkspace,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildLabelField(c, l10n, workspaceId)),
            ],
          )
        else ...[
          _buildAssigneeField(c, l10n, workspaceId, isPersonalWorkspace),
          const SizedBox(height: 16),
          _buildLabelField(c, l10n, workspaceId),
        ],
        const SizedBox(height: 16),
        // Subtasks
        ..._subtasks.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(LucideIcons.circle, size: 16, color: c.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s,
                    style: AppText.body.copyWith(color: c.textPrimary),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _subtasks.remove(s)),
                  child: Icon(LucideIcons.x, size: 16, color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isDesktop)
          Row(
            children: [
              Expanded(child: _buildAddSubtaskButton(c, l10n)),
              const SizedBox(width: 12),
              Expanded(child: _buildAttachmentButton(l10n, isOnline)),
            ],
          )
        else ...[
          _buildAddSubtaskButton(c, l10n),
          const SizedBox(height: 8),
          _buildAttachmentButton(l10n, isOnline),
        ],
        if (!isOnline) ...[
          const SizedBox(height: 4),
          Text(
            l10n.taskAttachmentOffline,
            style: AppText.caption.copyWith(color: c.textMuted),
          ),
        ],
        ..._pendingAttachments.map(
          (file) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(LucideIcons.file, color: c.primary),
            title: Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
            trailing: IconButton(
              tooltip: l10n.btnDelete,
              icon: const Icon(LucideIcons.x),
              onPressed: _loading
                  ? null
                  : () => setState(() => _pendingAttachments.remove(file)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssigneeField(
    PlanPalColors c,
    AppLocalizations l10n,
    String workspaceId,
    bool isPersonalWorkspace,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.fieldAssignee,
        style: AppText.label.copyWith(color: c.textPrimary),
      ),
      const SizedBox(height: 6),
      _AssigneePicker(
        workspaceId: workspaceId,
        selectedId: _assigneeId,
        enabled: !isPersonalWorkspace,
        onChanged: (id) => setState(() => _assigneeId = id),
      ),
    ],
  );

  Widget _buildLabelField(
    PlanPalColors c,
    AppLocalizations l10n,
    String workspaceId,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.fieldLabel,
        style: AppText.label.copyWith(color: c.textPrimary),
      ),
      const SizedBox(height: 6),
      _LabelPicker(
        workspaceId: workspaceId,
        selectedId: _labelId,
        onChanged: (id) => setState(() => _labelId = id),
        onCreateLabel: () => _createLabel(workspaceId),
      ),
    ],
  );

  Widget _buildAddSubtaskButton(PlanPalColors c, AppLocalizations l10n) =>
      GestureDetector(
        onTap: () => _showAddSubtaskDialog(l10n),
        child: CustomPaint(
          foregroundPainter: _DashedOutlinePainter(color: c.border),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, size: 16, color: c.textMuted),
                const SizedBox(width: 8),
                Text(
                  l10n.tasksAddSubtask.replaceFirst(RegExp(r'^\+\s*'), ''),
                  style: AppText.bodyMedium.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAttachmentButton(AppLocalizations l10n, bool isOnline) {
    final c = context.colors;
    return GestureDetector(
      onTap: isOnline && !_loading ? () => _pickAttachments(l10n) : null,
      child: CustomPaint(
        foregroundPainter: _DashedOutlinePainter(color: c.border),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.paperclip, size: 16, color: c.textMuted),
              const SizedBox(width: 8),
              Text(
                l10n.taskAttachFile,
                style: AppText.bodyMedium.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSubtaskDialog(AppLocalizations l10n) {
    _subtaskCtrl.clear();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.tasksAddSubtask),
        content: TextField(
          controller: _subtaskCtrl,
          decoration: InputDecoration(hintText: l10n.fieldSubtaskHint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () {
              if (_subtaskCtrl.text.trim().isNotEmpty) {
                setState(() => _subtasks.add(_subtaskCtrl.text.trim()));
              }
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.btnAdd),
          ),
        ],
      ),
    );
  }
}

class _DashedOutlinePainter extends CustomPainter {
  final Color color;

  const _DashedOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rect = Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(AppRadius.control)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 5).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + 3;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedOutlinePainter oldDelegate) =>
      color != oldDelegate.color;
}

class _AssigneePicker extends ConsumerWidget {
  final String workspaceId;
  final String? selectedId;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _AssigneePicker({
    required this.workspaceId,
    required this.selectedId,
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
      loading: () => Container(
        height: 44,
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => isOnline
          ? InkWell(
              onTap: () =>
                  ref.invalidate(workspaceMembersProvider(workspaceId)),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.errorGeneric,
                        style: AppText.body.copyWith(color: c.danger),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(LucideIcons.refreshCw, size: 16, color: c.textMuted),
                  ],
                ),
              ),
            )
          : Tooltip(
              message: l10n.bannerOffline,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Text(
                  Supabase.instance.client.auth.currentUser?.email ??
                      l10n.fieldAssigneeOptional,
                  style: AppText.body.copyWith(color: c.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
      data: (members) {
        final memberIds = members.map((member) => member.userId).toSet();
        final value = selectedId != null && memberIds.contains(selectedId)
            ? selectedId
            : null;
        return Tooltip(
          message: enabled ? l10n.fieldAssignee : l10n.errorPermission,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: value,
                hint: Text(
                  l10n.fieldAssigneeOptional,
                  style: AppText.body.copyWith(color: c.textMuted),
                ),
                icon: Icon(Icons.arrow_drop_down, color: c.textMuted),
                isExpanded: true,
                items: [
                  if (enabled)
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        l10n.fieldAssigneeOptional,
                        style: AppText.body.copyWith(color: c.textMuted),
                      ),
                    ),
                  ...members.map(
                    (member) => DropdownMenuItem<String?>(
                      value: member.userId,
                      child: Text(
                        member.fullName.isNotEmpty
                            ? member.fullName
                            : member.email,
                        style: AppText.body.copyWith(color: c.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PrioritySegmented extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _PrioritySegmented({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    const options = ['high', 'medium', 'low'];
    final labels = [l10n.priorityHigh, l10n.priorityMedium, l10n.priorityLow];

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final selected = value == options[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(options[i]),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: selected ? c.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.control - 3),
                  boxShadow: selected
                      ? AppShadows.card(Brightness.light)
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: AppText.bodyMedium.copyWith(
                      color: selected ? c.textPrimary : c.textMuted,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _LabelPicker extends ConsumerWidget {
  static const _createLabelValue = '__create_label__';

  final String workspaceId;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCreateLabel;
  const _LabelPicker({
    required this.workspaceId,
    required this.selectedId,
    required this.onChanged,
    required this.onCreateLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final canCreateLabel = ref
        .watch(currentRolePermissionsProvider)
        .canCreateTask;
    final labelsAsync = ref.watch(labelsProvider(workspaceId));

    return labelsAsync.when(
      loading: () => Container(
        height: 44,
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => isOnline
          ? InkWell(
              onTap: () => ref.invalidate(labelsProvider(workspaceId)),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.errorGeneric,
                        style: AppText.body.copyWith(color: c.danger),
                      ),
                    ),
                    Icon(LucideIcons.refreshCw, size: 16, color: c.textMuted),
                  ],
                ),
              ),
            )
          : Tooltip(
              message: l10n.bannerOffline,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Text(
                  l10n.fieldLabelOptional,
                  style: AppText.body.copyWith(color: c.textMuted),
                ),
              ),
            ),
      data: (labels) {
        return Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: selectedId,
              hint: Text(
                l10n.fieldLabelOptional,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
              icon: Icon(Icons.arrow_drop_down, color: c.textMuted),
              isExpanded: true,
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    l10n.fieldLabelOptional,
                    style: AppText.body.copyWith(color: c.textMuted),
                  ),
                ),
                ...labels.map((l) {
                  Color color;
                  try {
                    color = Color(
                      int.parse('FF${l.color.replaceAll('#', '')}', radix: 16),
                    );
                  } catch (_) {
                    color = c.primary;
                  }
                  return DropdownMenuItem<String?>(
                    value: l.id,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l.name,
                          style: AppText.body.copyWith(color: c.textPrimary),
                        ),
                      ],
                    ),
                  );
                }),
                if (isOnline && canCreateLabel)
                  DropdownMenuItem<String?>(
                    value: _createLabelValue,
                    child: Text(
                      l10n.taskCreateLabelTitle,
                      style: AppText.bodyMedium.copyWith(color: c.primary),
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value == _createLabelValue) {
                  onCreateLabel();
                } else {
                  onChanged(value);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
