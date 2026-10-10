import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Network type enum
enum NetworkType {
  none,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
}

/// Connectivity state
class ConnectivityState {
  final ConnectivityStatus status;
  final NetworkType networkType;

  const ConnectivityState({
    required this.status,
    required this.networkType,
  });

  bool get isOnline => status == ConnectivityStatus.connected;
  bool get isOffline => status == ConnectivityStatus.disconnected;
}

/// Connectivity status enum
enum ConnectivityStatus {
  connected,
  disconnected,
  unknown,
}

/// Simple connectivity check provider
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  
  await for (final result in connectivity.onConnectivityChanged) {
    // Check if any connection is available
    final isConnected = result.any((r) =>
        r != ConnectivityResult.none);
    yield isConnected;
  }
});

/// Offline provider (inverse of online)
final isOfflineProvider = Provider<bool>((ref) {
  final onlineAsync = ref.watch(isOnlineProvider);
  return onlineAsync.when(
    data: (isOnline) => !isOnline,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Network type provider
final networkTypeProvider = Provider<NetworkType>((ref) {
  // Simplified - just return wifi for now
  return NetworkType.wifi;
});

/// Connectivity state stream provider
final connectivityStateStreamProvider = StreamProvider<ConnectivityState>((ref) async* {
  final connectivity = Connectivity();
  
  await for (final result in connectivity.onConnectivityChanged) {
    final isConnected = result.any((r) => r != ConnectivityResult.none);
    
    NetworkType type = NetworkType.none;
    if (result.contains(ConnectivityResult.wifi)) {
      type = NetworkType.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      type = NetworkType.mobile;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      type = NetworkType.ethernet;
    }
    
    yield ConnectivityState(
      status: isConnected ? ConnectivityStatus.connected : ConnectivityStatus.disconnected,
      networkType: type,
    );
  }
});
