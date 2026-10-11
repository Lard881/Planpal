import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/empty_state.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.reminders ?? 'Reminders'),
      ),
      body: const EmptyState(
        icon: Icons.notifications_none,
        title: 'No reminders set',
        message: 'Upcoming task and event reminders will appear here.',
      ),
    );
  }
}
