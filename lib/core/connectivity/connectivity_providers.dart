import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'connectivity_service.dart';
import 'sync_trigger_service.dart';
import '../sync/sync_manager.dart';

/// Connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService(
    connectivity: Connectivity(),
    logger: Logger(),
  );

  // Initialize on first access
  service.initialize();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Connectivity state stream provider
final connectivityStateStreamProvider = StreamProvider<ConnectivityState>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.stateStream;
});

/// Current connectivity status provider
final connectivityStatusProvider = Provider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.currentState.status;
});

/// Is online provider
final isOnlineProvider = Provider<bool>((ref) {
  final stateAsync = ref.watch(connectivityStateStreamProvider);
  return stateAsync.when(
    data: (state) => state.status.isOnline,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Is offline provider
final isOfflineProvider = Provider<bool>((ref) {
  final stateAsync = ref.watch(connectivityStateStreamProvider);
  return stateAsync.when(
    data: (state) => state.status.isOffline,
    loading: () => true,
    error: (_, __) => true,
  );
});

/// Network type provider
final networkTypeProvider = Provider<NetworkType>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.currentState.networkType;
});

/// Is WiFi provider
final isWifiProvider = Provider<bool>((ref) {
  final networkType = ref.watch(networkTypeProvider);
  return networkType.isWifi;
});

/// Is mobile data provider
final isMobileProvider = Provider<bool>((ref) {
  final networkType = ref.watch(networkTypeProvider);
  return networkType.isMobile;
});

/// Sync trigger configuration provider
final syncTriggerConfigProvider = Provider<SyncTriggerConfig>((ref) {
  return const SyncTriggerConfig(
    syncOnReconnect: true,
    syncOnResume: true,
    minSyncInterval: Duration(minutes: 1),
    reconnectDelay: Duration(seconds: 2),
    wifiOnly: false, // TODO: Make this user-configurable via settings
  );
});

/// Sync trigger service provider
final syncTriggerServiceProvider = Provider<SyncTriggerService>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  final syncManager = ref.watch(syncManagerProvider);
  final config = ref.watch(syncTriggerConfigProvider);

  final service = SyncTriggerService(
    connectivityService: connectivityService,
    syncManager: syncManager,
    config: config,
    logger: Logger(),
  );

  // Start listening to triggers
  service.start();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Is sync allowed provider (considers WiFi-only setting)
final isSyncAllowedProvider = Provider<bool>((ref) {
  final service = ref.watch(syncTriggerServiceProvider);
  return service.isSyncAllowed;
});

/// Time since last sync provider
final timeSinceLastSyncProvider = Provider<Duration?>((ref) {
  final service = ref.watch(syncTriggerServiceProvider);
  return service.timeSinceLastSync;
});

/// Connectivity icon provider (for UI)
final connectivityIconProvider = Provider<ConnectivityIconData>((ref) {
  final stateAsync = ref.watch(connectivityStateStreamProvider);
  
  return stateAsync.when(
    data: (state) {
      if (state.status.isOnline) {
        switch (state.networkType) {
          case NetworkType.wifi:
            return ConnectivityIconData(
              icon: 'wifi',
              color: 'green',
              tooltip: 'Connected via WiFi',
            );
          case NetworkType.mobile:
            return ConnectivityIconData(
              icon: 'signal_cellular',
              color: 'green',
              tooltip: 'Connected via Mobile Data',
            );
          case NetworkType.ethernet:
            return ConnectivityIconData(
              icon: 'cable',
              color: 'green',
              tooltip: 'Connected via Ethernet',
            );
          default:
            return ConnectivityIconData(
              icon: 'cloud',
              color: 'green',
              tooltip: 'Online',
            );
        }
      } else if (state.status.isOffline) {
        return ConnectivityIconData(
          icon: 'cloud_off',
          color: 'red',
          tooltip: 'Offline',
        );
      } else {
        return ConnectivityIconData(
          icon: 'cloud_queue',
          color: 'grey',
          tooltip: 'Unknown',
        );
      }
    },
    loading: () => ConnectivityIconData(
      icon: 'cloud_queue',
      color: 'grey',
      tooltip: 'Checking...',
    ),
    error: (_, __) => ConnectivityIconData(
      icon: 'cloud_off',
      color: 'orange',
      tooltip: 'Connection Error',
    ),
  );
});

/// Connectivity icon data
class ConnectivityIconData {
  final String icon;
  final String color;
  final String tooltip;

  ConnectivityIconData({
    required this.icon,
    required this.color,
    required this.tooltip,
  });
}
