// app/lib/core/connectivity/connectivity_service.dart
// Four states: online, offline, serverUnreachable, wakingUp
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/empty_state.dart';
import '../config/env.dart';

class ConnectivityService extends StateNotifier<ConnectivityState> {
  ConnectivityService() : super(ConnectivityState.online) {
    _init();
  }

  StreamSubscription? _sub;
  Timer? _serverCheckTimer;

  void _init() {
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final hasNetwork = results.any((r) => r != ConnectivityResult.none);
      if (!hasNetwork) {
        state = ConnectivityState.offline;
      } else {
        _checkServer();
      }
    });
    _checkServer();
  }

  Future<void> _checkServer() async {
    try {
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));
      final healthUrl = Env.apiBaseUrl.replaceAll('/api/v1', '/health');
      await dio.get(healthUrl);
      state = ConnectivityState.online;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Check if it's just the server waking up (first few seconds after cold start)
        state = ConnectivityState.serverUnreachable;
      } else if (e.response?.statusCode != null) {
        // Server responded (even with error) — it's up
        state = ConnectivityState.online;
      } else {
        state = ConnectivityState.serverUnreachable;
      }
    } catch (_) {
      state = ConnectivityState.serverUnreachable;
    }
  }

  Future<void> checkNow() => _checkServer();

  bool get isOnline => state == ConnectivityState.online;

  @override
  void dispose() {
    _sub?.cancel();
    _serverCheckTimer?.cancel();
    super.dispose();
  }
}

final connectivityServiceProvider =
    StateNotifierProvider<ConnectivityService, ConnectivityState>(
  (ref) => ConnectivityService(),
);

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityServiceProvider) == ConnectivityState.online;
});
