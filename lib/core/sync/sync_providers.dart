import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../providers/app_providers.dart';
import 'sync_service.dart';
import 'sync_engine.dart';

/// Device ID provider (persisted in SharedPreferences)
final deviceIdProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  String? deviceId = prefs.getString('device_id');
  
  if (deviceId == null) {
    deviceId = DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString('device_id', deviceId);
  }
  
  return deviceId;
});

/// Sync configuration class (minimal for compilation)
class SyncConfig {
  final String deviceId;
  final List<String> entityTypes;
  final ConflictResolutionStrategy strategy;
  final int batchSize;
  final Duration timeout;

  const SyncConfig({
    required this.deviceId,
    required this.entityTypes,
    required this.strategy,
    required this.batchSize,
    required this.timeout,
  });
}

/// Sync configuration provider
final syncConfigProvider = FutureProvider<SyncConfig>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  
  return SyncConfig(
    deviceId: deviceId,
    entityTypes: const ['task', 'project', 'label', 'comment', 'attachment', 'link'],
    strategy: ConflictResolutionStrategy.serverWins,
    batchSize: 100,
    timeout: const Duration(seconds: 30),
  );
});

/// Sync service provider
final syncServiceProvider = Provider<AsyncValue<SyncService>>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final configAsync = ref.watch(syncConfigProvider);
  
  return configAsync.when(
    data: (config) => AsyncValue.data(
      SyncService(
        database: database,
        dio: dio,
        config: config,
        logger: Logger(),
      ),
    ),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Dio provider for API requests
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseURL: 'https://your-api-url.com/api/v1', // TODO: Use environment config
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  // Add auth interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // TODO: Get auth token from auth provider
      // final token = await ref.read(authTokenProvider.future);
      // if (token != null) {
      //   options.headers['Authorization'] = 'Bearer $token';
      // }
      handler.next(options);
    },
    onError: (error, handler) {
      // Log errors
      final logger = Logger();
      logger.e('API Error: ${error.message}', error: error.error);
      handler.next(error);
    },
  ));
  
  return dio;
});

/// Sync status provider (checks if sync is needed)
final syncStatusProvider = StreamProvider<bool>((ref) async* {
  final serviceAsync = ref.watch(syncServiceProvider);
  
  if (serviceAsync is! AsyncData<SyncService>) {
    yield false;
    return;
  }
  
  final service = serviceAsync.value;
  
  // Check every 10 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 10))) {
    try {
      final needsSync = await service.needsSync();
      yield needsSync;
    } catch (e) {
      yield false;
    }
  }
});

/// Pending operations count provider
final pendingOperationsProvider = StreamProvider<int>((ref) async* {
  final serviceAsync = ref.watch(syncServiceProvider);
  
  if (serviceAsync is! AsyncData<SyncService>) {
    yield 0;
    return;
  }
  
  final service = serviceAsync.value;
  
  // Update every 5 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
    try {
      final count = await service.getPendingOperationsCount();
      yield count;
    } catch (e) {
      yield 0;
    }
  }
});

/// Last sync time provider for entity type
final lastSyncTimeProvider = FutureProvider.family<DateTime?, String>((ref, entityType) async {
  final serviceAsync = ref.watch(syncServiceProvider);
  
  if (serviceAsync is! AsyncData<SyncService>) {
    return null;
  }
  
  final service = serviceAsync.value;
  return await service.getLastSyncTime(entityType);
});

/// Sync result state notifier
class SyncResultNotifier extends StateNotifier<AsyncValue<SyncResult?>> {
  SyncResultNotifier() : super(const AsyncValue.data(null));

  void setResult(SyncResult result) {
    state = AsyncValue.data(result);
  }

  void setLoading() {
    state = const AsyncValue.loading();
  }

  void setError(Object error, StackTrace stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final syncResultProvider = StateNotifierProvider<SyncResultNotifier, AsyncValue<SyncResult?>>(
  (ref) => SyncResultNotifier(),
);
