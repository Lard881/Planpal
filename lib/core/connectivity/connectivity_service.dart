// app/lib/core/connectivity/connectivity_service.dart
// Four states: online, offline, serverUnreachable, wakingUp
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/empty_state.dart';
import '../config/env.dart';

ConnectivityState classifyReachability({
  required bool hasNetwork,
  required bool hasInternet,
  required bool backendReachable,
}) {
  if (!hasNetwork || !hasInternet) return ConnectivityState.offline;
  return backendReachable
      ? ConnectivityState.online
      : ConnectivityState.serverUnreachable;
}

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
      state = classifyReachability(
        hasNetwork: true,
        hasInternet: true,
        backendReachable: true,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        // Server responded (even with error) — it's up
        state = classifyReachability(
          hasNetwork: true,
          hasInternet: true,
          backendReachable: true,
        );
      } else {
        state = classifyReachability(
          hasNetwork: true,
          hasInternet: await _hasInternetConnection(),
          backendReachable: false,
        );
      }
    } catch (_) {
      state = classifyReachability(
        hasNetwork: true,
        hasInternet: await _hasInternetConnection(),
        backendReachable: false,
      );
    }
  }

  Future<bool> _hasInternetConnection() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    try {
      await dio.get(
        'https://www.google.com/generate_204',
        options: Options(validateStatus: (status) => status == 204),
      );
      return true;
    } on DioException catch (error) {
      return error.response?.statusCode == 204;
    } catch (_) {
      return false;
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
