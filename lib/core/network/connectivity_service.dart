import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../config/env.dart';

/// Connectivity state
enum ConnectivityState {
  online, // Network and server reachable
  noNetwork, // Device has no network interface
  noInternet, // Interface up but nothing reachable
  serverUnreachable, // Internet works but API doesn't
}

/// Real connectivity service with server reachability checks
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  ConnectivityState _currentState = ConnectivityState.online;
  final _stateController = StreamController<ConnectivityState>.broadcast();

  Stream<ConnectivityState> get state => _stateController.stream;
  ConnectivityState get currentState => _currentState;

  ConnectivityService() {
    _init();
  }

  void _init() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      _checkConnectivity();
    });

    // Initial check
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResults = await _connectivity.checkConnectivity();

    // Check if device has network interface
    if (connectivityResults.contains(ConnectivityResult.none)) {
      _updateState(ConnectivityState.noNetwork);
      return;
    }

    // Check if internet is reachable (ping Supabase)
    final hasInternet = await _checkInternetAccess();
    if (!hasInternet) {
      _updateState(ConnectivityState.noInternet);
      return;
    }

    // Check if API server is reachable
    final serverReachable = await _checkServerAccess();
    if (!serverReachable) {
      _updateState(ConnectivityState.serverUnreachable);
      return;
    }

    _updateState(ConnectivityState.online);
  }

  Future<bool> _checkInternetAccess() async {
    try {
      // Ping Supabase URL (always available)
      final response = await _dio.get(
        '${Env.supabaseUrl}/rest/v1/',
        options: Options(
          headers: {'apikey': Env.supabaseAnonKey},
        ),
      );
      return response.statusCode == 200 || response.statusCode == 401;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _checkServerAccess() async {
    try {
      // Ping API health endpoint
      final response = await _dio.get('${Env.apiBaseUrl.replaceAll('/api/v1', '')}/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _updateState(ConnectivityState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _stateController.add(newState);
    }
  }

  /// Manual recheck (called after a failed request)
  Future<void> recheck() async {
    await _checkConnectivity();
  }

  void dispose() {
    _stateController.close();
  }
}
