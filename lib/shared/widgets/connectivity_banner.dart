import 'package:flutter/material.dart';
import '../../core/network/connectivity_service.dart';

/// Connectivity banner showing network status
/// Shows: offline, server unreachable, waking, back online
class ConnectivityBanner extends StatelessWidget {
  final ConnectivityState state;
  final VoidCallback? onDismiss;

  const ConnectivityBanner({
    super.key,
    required this.state,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show banner when online
    if (state == ConnectivityState.online) {
      return const SizedBox.shrink();
    }

    Color getColor() {
      switch (state) {
        case ConnectivityState.noNetwork:
        case ConnectivityState.noInternet:
          return const Color(0xFFF59E0B); // Orange
        case ConnectivityState.serverUnreachable:
          return const Color(0xFFEF4444); // Red
        case ConnectivityState.online:
          return const Color(0xFF10B981); // Green
      }
    }

    IconData getIcon() {
      switch (state) {
        case ConnectivityState.noNetwork:
        case ConnectivityState.noInternet:
          return Icons.wifi_off;
        case ConnectivityState.serverUnreachable:
          return Icons.cloud_off;
        case ConnectivityState.online:
          return Icons.cloud_done;
      }
    }

    String getMessage() {
      switch (state) {
        case ConnectivityState.noNetwork:
          return 'No network connection';
        case ConnectivityState.noInternet:
          return 'No internet connection';
        case ConnectivityState.serverUnreachable:
          return 'Server unreachable - waking up...';
        case ConnectivityState.online:
          return 'Back online';
      }
    }

    final color = getColor();
    final icon = getIcon();
    final message = getMessage();

    return Material(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
