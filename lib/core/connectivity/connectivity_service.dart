import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Connectivity status
enum ConnectivityStatus {
  online,
  offline,
  unknown;

  bool get isOnline => this == ConnectivityStatus.online;
  bool get isOffline => this == ConnectivityStatus.offline;
  bool get isUnknown => this == ConnectivityStatus.unknown;
}

/// Network type
enum NetworkType {
  wifi,
  mobile,
  ethernet,
  vpn,
  bluetooth,
  other,
  none;

  bool get isWifi => this == NetworkType.wifi;
  bool get isMobile => this == NetworkType.mobile;
  bool get hasConnection => this != NetworkType.none;
}

/// Connectivity state
class ConnectivityState {
  final ConnectivityStatus status;
  final NetworkType networkType;
  final DateTime lastChanged;
  final bool wasOffline;

  ConnectivityState({
    required this.status,
    required this.networkType,
    required this.lastChanged,
    this.wasOffline = false,
  });

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    NetworkType? networkType,
    DateTime? lastChanged,
    bool? wasOffline,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      networkType: networkType ?? this.networkType,
      lastChanged: lastChanged ?? this.lastChanged,
      wasOffline: wasOffline ?? this.wasOffline,
    );
  }

  bool get justCameOnline => status.isOnline && wasOffline;
  bool get justWentOffline => status.isOffline && !wasOffline;
}

/// Connectivity service for monitoring network status
class ConnectivityService {
  final Connectivity _connectivity;
  final Logger _logger;

  final _stateController = StreamController<ConnectivityState>.broadcast();
  Stream<ConnectivityState> get stateStream => _stateController.stream;

  ConnectivityState _currentState = ConnectivityState(
    status: ConnectivityStatus.unknown,
    networkType: NetworkType.none,
    lastChanged: DateTime.now(),
  );

  ConnectivityState get currentState => _currentState;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _periodicCheckTimer;

  ConnectivityService({
    Connectivity? connectivity,
    Logger? logger,
  })  : _connectivity = connectivity ?? Connectivity(),
        _logger = logger ?? Logger();

  // ============================================================================
  // Initialization
  // ============================================================================

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    try {
      _logger.i('Initializing connectivity service');

      // Get initial status
      await _checkConnectivity();

      // Listen to connectivity changes
      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (error) {
          _logger.e('Connectivity stream error', error: error);
        },
      );

      // Periodic check as backup (every 30 seconds)
      _startPeriodicCheck();

      _logger.i('Connectivity service initialized');
    } catch (e, stack) {
      _logger.e('Failed to initialize connectivity service', error: e, stackTrace: stack);
    }
  }

  /// Start periodic connectivity check
  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkConnectivity(),
    );
  }

  // ============================================================================
  // Connectivity Monitoring
  // ============================================================================

  /// Handle connectivity change
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _updateState(
        ConnectivityStatus.offline,
        NetworkType.none,
      );
      return;
    }

    // Take the first result (most apps only have one connection at a time)
    final result = results.first;

    final networkType = _mapConnectivityResult(result);
    final status = networkType.hasConnection
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    _updateState(status, networkType);
  }

  /// Check current connectivity
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      _logger.e('Failed to check connectivity', error: e);
      _updateState(ConnectivityStatus.unknown, NetworkType.none);
    }
  }

  /// Map ConnectivityResult to NetworkType
  NetworkType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      case ConnectivityResult.vpn:
        return NetworkType.vpn;
      case ConnectivityResult.bluetooth:
        return NetworkType.bluetooth;
      case ConnectivityResult.other:
        return NetworkType.other;
      case ConnectivityResult.none:
        return NetworkType.none;
    }
  }

  /// Update connectivity state
  void _updateState(ConnectivityStatus status, NetworkType networkType) {
    final wasOffline = _currentState.status.isOffline;
    
    _currentState = ConnectivityState(
      status: status,
      networkType: networkType,
      lastChanged: DateTime.now(),
      wasOffline: wasOffline,
    );

    _stateController.add(_currentState);

    // Log status changes
    if (_currentState.justCameOnline) {
      _logger.i('Device came online (${networkType.name})');
    } else if (_currentState.justWentOffline) {
      _logger.w('Device went offline');
    }
  }

  // ============================================================================
  // Status Queries
  // ============================================================================

  /// Check if currently online
  bool get isOnline => _currentState.status.isOnline;

  /// Check if currently offline
  bool get isOffline => _currentState.status.isOffline;

  /// Get current network type
  NetworkType get networkType => _currentState.networkType;

  /// Check if on WiFi
  bool get isWifi => _currentState.networkType.isWifi;

  /// Check if on mobile data
  bool get isMobile => _currentState.networkType.isMobile;

  /// Get time since last status change
  Duration get timeSinceLastChange {
    return DateTime.now().difference(_currentState.lastChanged);
  }

  // ============================================================================
  // Lifecycle
  // ============================================================================

  /// Dispose service
  void dispose() {
    _subscription?.cancel();
    _periodicCheckTimer?.cancel();
    _stateController.close();
    _logger.i('Connectivity service disposed');
  }
}
