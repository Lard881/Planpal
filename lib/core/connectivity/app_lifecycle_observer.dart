import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'connectivity_providers.dart';

/// App lifecycle observer for sync triggers
class AppLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef _ref;
  final Logger _logger;

  AppLifecycleObserver({
    required WidgetRef ref,
    Logger? logger,
  })  : _ref = ref,
        _logger = logger ?? Logger();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.i('App lifecycle state changed: ${state.name}');

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state if needed
        break;
    }
  }

  /// Handle app resumed
  void _onAppResumed() {
    _logger.i('App resumed - triggering sync check');
    
    try {
      // Trigger sync via sync trigger service
      final syncTriggerService = _ref.read(syncTriggerServiceProvider);
      syncTriggerService.onAppResume();
    } catch (e) {
      _logger.e('Failed to trigger sync on resume', error: e);
    }
  }

  /// Handle app inactive
  void _onAppInactive() {
    _logger.d('App inactive');
  }

  /// Handle app paused
  void _onAppPaused() {
    _logger.i('App paused');
    // Could save any pending state here
  }

  /// Handle app detached
  void _onAppDetached() {
    _logger.i('App detached');
  }
}

/// Widget to register lifecycle observer
class AppLifecycleWidget extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleWidget({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<AppLifecycleWidget> createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends ConsumerState<AppLifecycleWidget> {
  late AppLifecycleObserver _observer;

  @override
  void initState() {
    super.initState();
    _observer = AppLifecycleObserver(ref: ref);
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
