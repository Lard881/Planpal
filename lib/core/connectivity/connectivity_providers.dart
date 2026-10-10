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
