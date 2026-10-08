import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/sync/sync_engine.dart' as sync;
import 'sync_conflict_dialog.dart';

/// Widget that listens for sync conflicts and shows resolution dialog
class SyncConflictListener extends ConsumerStatefulWidget {
  final Widget child;

  const SyncConflictListener({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<SyncConflictListener> createState() => _SyncConflictListenerState();
}

class _SyncConflictListenerState extends ConsumerState<SyncConflictListener> {
  final List<sync.SyncConflict> _pendingConflicts = [];
  bool _isShowingDialog = false;

  @override
  void initState() {
    super.initState();
    _listenToConflicts();
  }

  void _listenToConflicts() {
    final syncEngine = ref.read(syncEngineProvider);
    
    syncEngine.conflicts.listen((conflict) {
      if (mounted) {
        _handleConflict(conflict);
      }
    });
  }

  void _handleConflict(sync.SyncConflict conflict) {
    // Add to queue
    _pendingConflicts.add(conflict);
    
    // Show dialog if not already showing one
    if (!_isShowingDialog && mounted) {
      _showNextConflict();
    }
  }

  void _showNextConflict() {
    if (_pendingConflicts.isEmpty || !mounted) {
      _isShowingDialog = false;
      return;
    }

    _isShowingDialog = true;
    final conflict = _pendingConflicts.removeAt(0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SyncConflictDialog(conflict: conflict),
    ).then((_) {
      // Show next conflict after current one is resolved
      _isShowingDialog = false;
      if (_pendingConflicts.isNotEmpty && mounted) {
        // Small delay before showing next dialog
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _showNextConflict();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
