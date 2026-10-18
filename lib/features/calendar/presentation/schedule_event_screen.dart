// app/lib/features/calendar/presentation/schedule_event_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../auth/presentation/auth_failure_message.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../providers/calendar_providers.dart';

// The 6 event color choices
const _eventColors = [
  '#4F46E5',
  '#8B5CF6',
  '#0EA5E9',
  '#16A34A',
  '#F59E0B',
  '#EF4444',
];

void showScheduleEventSheet(BuildContext context, WidgetRef ref) {
  if (context.isDesktopLayout) {
    showDialog(
      context: context,
      builder: (_) => _ScheduleEventDialog(ref: ref),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScheduleEventPage(widgetRef: ref)),
    );
  }
}

// ── Desktop Dialog ────────────────────────────────────────────────────────────
class _ScheduleEventDialog extends StatefulWidget {
  final WidgetRef ref;
  const _ScheduleEventDialog({required this.ref});
  @override
  State<_ScheduleEventDialog> createState() => _ScheduleEventDialogState();
}

class _ScheduleEventDialogState extends State<_ScheduleEventDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  DateTime _endsAt = DateTime.now().add(const Duration(hours: 2));
  bool _allDay = false;
  String _color = '#4F46E5';
  int _reminderMinutes = 15;
  List<String> _attendeeIds = const [];
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    if (!_endsAt.isAfter(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).calendarInvalidRange),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    final failure = await widget.ref
        .read(calendarProvider.notifier)
        .createEvent(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          startsAt: _startsAt,
          endsAt: _endsAt,
          allDay: _allDay,
          color: _color,
          attendeeIds: _attendeeIds,
          reminderMinutesBefore: _reminderMinutes,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (failure != null) {
      final l10n = AppLocalizations.of(context);
      final queuedOffline =
          failure is NetworkFailure ||
          failure is ServerUnreachableFailure ||
          failure is TimeoutFailure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            queuedOffline
                ? l10n.calendarQueuedOffline
                : authFailureMessage(l10n, failure),
          ),
        ),
      );
      if (!queuedOffline) return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.panel),
      ),
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  Text(
                    l10n.scheduleEventTitle,
                    style: AppText.cardTitle.copyWith(color: c.textPrimary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(LucideIcons.x, color: c.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildFields(c),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PlanPalButton(
                label: l10n.btnSaveEvent,
                onPressed: _save,
                loading: _loading,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFields(PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlanPalTextField(
          label: l10n.fieldTitle,
          hint: l10n.fieldTitleHint,
          controller: _titleCtrl,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldDescription,
          hint: l10n.fieldDescriptionHint,
          controller: _descCtrl,
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DateTimeField(
                label: l10n.fieldStarts,
                value: _startsAt,
                onChanged: (dt) => setState(() => _startsAt = dt),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateTimeField(
                label: l10n.fieldEnds,
                value: _endsAt,
                onChanged: (dt) => setState(() => _endsAt = dt),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Switch(
              value: _allDay,
              onChanged: (v) => setState(() => _allDay = v),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.fieldAllDay,
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
            const Spacer(),
            // Color dots
            Row(
              children: _eventColors.map((col) {
                final selected = _color == col;
                return GestureDetector(
                  onTap: () => setState(() => _color = col),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _parseColor(col),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: c.textPrimary, width: 2)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.fieldReminder,
          style: AppText.label.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 6),
        _ReminderDropdown(
          value: _reminderMinutes,
          onChanged: (value) => setState(() => _reminderMinutes = value),
        ),
        const SizedBox(height: 16),
        _AttendeePicker(
          selectedIds: _attendeeIds,
          onChanged: (ids) => setState(() => _attendeeIds = ids),
        ),
      ],
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return PlanPalColors.light.primary;
    }
  }
}

// ── Mobile Page ───────────────────────────────────────────────────────────────
class ScheduleEventPage extends StatefulWidget {
  final WidgetRef widgetRef;
  const ScheduleEventPage({super.key, required this.widgetRef});
  @override
  State<ScheduleEventPage> createState() => _ScheduleEventPageState();
}

class _ScheduleEventPageState extends State<ScheduleEventPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  DateTime _endsAt = DateTime.now().add(const Duration(hours: 2));
  bool _allDay = false;
  String _color = '#4F46E5';
  int _reminderMinutes = 15;
  List<String> _attendeeIds = const [];
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    if (!_endsAt.isAfter(_startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).calendarInvalidRange),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    final failure = await widget.widgetRef
        .read(calendarProvider.notifier)
        .createEvent(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          startsAt: _startsAt,
          endsAt: _endsAt,
          allDay: _allDay,
          color: _color,
          attendeeIds: _attendeeIds,
          reminderMinutesBefore: _reminderMinutes,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (failure != null) {
      final l10n = AppLocalizations.of(context);
      final queuedOffline =
          failure is NetworkFailure ||
          failure is ServerUnreachableFailure ||
          failure is TimeoutFailure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            queuedOffline
                ? l10n.calendarQueuedOffline
                : authFailureMessage(l10n, failure),
          ),
        ),
      );
      if (!queuedOffline) return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.scheduleEventTitle,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    PlanPalTextField(
                      label: l10n.fieldTitle,
                      hint: l10n.fieldTitleHint,
                      controller: _titleCtrl,
                    ),
                    const SizedBox(height: 16),
                    PlanPalTextField(
                      label: l10n.fieldDescription,
                      hint: l10n.fieldDescriptionHint,
                      controller: _descCtrl,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTimeField(
                            label: l10n.fieldStarts,
                            value: _startsAt,
                            onChanged: (dt) => setState(() => _startsAt = dt),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateTimeField(
                            label: l10n.fieldEnds,
                            value: _endsAt,
                            onChanged: (dt) => setState(() => _endsAt = dt),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Switch(
                          value: _allDay,
                          onChanged: (v) => setState(() => _allDay = v),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.fieldAllDay,
                          style: AppText.body.copyWith(color: c.textPrimary),
                        ),
                        const Spacer(),
                        Row(
                          children: _eventColors.map((col) {
                            final selected = _color == col;
                            return GestureDetector(
                              onTap: () => setState(() => _color = col),
                              child: Container(
                                margin: const EdgeInsets.only(left: 6),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      'FF${col.replaceAll('#', '')}',
                                      radix: 16,
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                  border: selected
                                      ? Border.all(
                                          color: c.textPrimary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.fieldReminder,
                      style: AppText.label.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    _ReminderDropdown(
                      value: _reminderMinutes,
                      onChanged: (value) =>
                          setState(() => _reminderMinutes = value),
                    ),
                    const SizedBox(height: 16),
                    _AttendeePicker(
                      selectedIds: _attendeeIds,
                      onChanged: (ids) => setState(() => _attendeeIds = ids),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: PlanPalButton(
                label: l10n.btnSaveEvent,
                onPressed: _save,
                loading: _loading,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _ReminderDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          items: [
            DropdownMenuItem(value: 0, child: Text(l10n.reminderNone)),
            DropdownMenuItem(value: 5, child: Text(l10n.reminderFiveMin)),
            DropdownMenuItem(value: 15, child: Text(l10n.reminderFifteenMin)),
            DropdownMenuItem(value: 30, child: Text(l10n.reminderThirtyMin)),
            DropdownMenuItem(value: 60, child: Text(l10n.reminderOneHour)),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ),
    );
  }
}

class _AttendeePicker extends ConsumerWidget {
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;

  const _AttendeePicker({required this.selectedIds, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    if (workspaceId == null) {
      return Text(
        l10n.calendarNoMembers,
        style: AppText.caption.copyWith(color: c.textMuted),
      );
    }
    return ref
        .watch(workspaceMembersProvider(workspaceId))
        .when(
          loading: () => const ContentLoadingSkeleton(
            kind: LoadingSkeletonKind.rows,
            itemCount: 3,
            padding: EdgeInsets.zero,
          ),
          error: (_, _) => Text(
            l10n.errorGeneric,
            style: AppText.caption.copyWith(color: c.danger),
          ),
          data: (members) {
            if (members.isEmpty) {
              return Text(
                l10n.calendarNoMembers,
                style: AppText.caption.copyWith(color: c.textMuted),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.calendarAttendees,
                  style: AppText.label.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 4),
                ...members.map((member) {
                  final isSelected = selectedIds.contains(member.userId);
                  final displayName = member.fullName.isNotEmpty
                      ? member.fullName
                      : member.email;
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(displayName),
                    value: isSelected,
                    onChanged: (selected) {
                      final updated = {...selectedIds};
                      if (selected == true) {
                        updated.add(member.userId);
                      } else {
                        updated.remove(member.userId);
                      }
                      onChanged(updated.toList());
                    },
                  );
                }),
              ],
            );
          },
        );
  }
}

// ── Date Time Field ───────────────────────────────────────────────────────────
class _DateTimeField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final localizations = MaterialLocalizations.of(context);
    final formattedDate = localizations.formatShortDate(value);
    final formattedTime = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(value),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (d == null || !context.mounted) return;
            final t = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(value),
            );
            onChanged(
              DateTime(
                d.year,
                d.month,
                d.day,
                t?.hour ?? value.hour,
                t?.minute ?? value.minute,
              ),
            );
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
                '$formattedDate · $formattedTime',
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
