import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/empty_state.dart';

class LabelsScreen extends ConsumerWidget {
  const LabelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.labels ?? 'Labels'),
      ),
      body: const EmptyState(
        icon: Icons.label_outline,
        title: 'No labels yet',
        message: 'Organize tasks with customizable colored labels.',
      ),
    );
  }
}
