import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';
import '../db/app_database.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../sync/sync_engine.dart' as sync;
import '../sync/sync_timestamps.dart';
import '../sync/sync_logger.dart';
import '../sync/background_sync_service.dart';
import '../sync/realtime_service.dart';
import '../sync/realtime_sync_handler.dart';
import '../routing/app_router.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';
import '../../features/tasks/repositories/task_repository.dart';
import '../../features/projects/repositories/project_repository.dart';
import '../../features/labels/repositories/label_repository.dart';
import '../../features/workspaces/repositories/workspace_repository.dart';
import '../../features/comments/repositories/comment_repository.dart';
import '../../features/activities/repositories/activity_repository.dart';
import '../../features/notifications/repositories/notification_repository.dart';
import '../../features/reminders/services/reminder_scheduler_service.dart';
import '../services/local_notifications_service.dart';
import '../../features/attachments/services/file_upload_service.dart';
import '../../features/attachments/services/thumbnail_service.dart';
import '../../features/attachments/repositories/attachment_repository.dart';

/// Database provider - singleton instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ============================================================================
// Authentication providers
// ============================================================================

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return AuthService(supabase: supabase);
});

/// Current auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

/// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final user = ref.watch(currentUserProvider);
  final accessToken = user?.aud == 'authenticated' 
      ? SupabaseService.instance.currentSession?.accessToken 
      : null;
  
  return ApiClient(
    baseUrl: Env.apiBaseUrl,
    accessToken: accessToken,
    onUnauthorized: () {
      // Handle token expiration - will be implemented with refresh logic
      print('Unauthorized - token expired');
    },
  );
});

/// Connectivity service provider
final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Sync timestamps provider
final syncTimestampsProvider = FutureProvider<SyncTimestamps>((ref) async {
  return await SyncTimestamps.create();
});

/// Sync logger provider - singleton
final syncLoggerProvider = Provider<SyncLogger>((ref) {
  final logger = SyncLogger();
  ref.onDispose(() => logger.dispose());
  return logger;
});

/// Sync engine provider
final syncEngineProvider = Provider<sync.SyncEngine>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);
  final timestampsAsync = ref.watch(syncTimestampsProvider);
  final logger = ref.watch(syncLoggerProvider);
  
  // Get reminder scheduler for callback
  final reminderScheduler = ref.watch(reminderSchedulerServiceProvider);
  
  final syncEngine = sync.SyncEngine(
    database: db,
    apiClient: api,
    initialWorkspaceId: currentWorkspaceId,
    timestamps: timestampsAsync.value, // Use timestamps if available
    logger: logger,
    onTasksSynced: (taskIds) async {
      // Reschedule reminders for synced tasks
      await reminderScheduler.rescheduleTaskReminders(taskIds);
    },
  );
  
  // Listen to workspace changes and update sync engine
  ref.listen<String?>(currentWorkspaceIdProvider, (previous, next) {
    if (next != null && next != previous) {
      syncEngine.setWorkspace(next, syncImmediately: true);
    }
  });
  
  // Start periodic sync
  syncEngine.startPeriodicSync();
  
  ref.onDispose(() => syncEngine.dispose());
  
  return syncEngine;
});

/// Current workspace ID provider
final currentWorkspaceIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Router provider with auth state
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  
  return AppRouter.createRouter(
    isAuthenticated: isAuthenticated,
  );
});

/// Connectivity status stream provider
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.isConnectedStream;
});

/// Sync state stream provider
final syncStateProvider = StreamProvider<sync.SyncState>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return syncEngine.syncState;
});

/// Background sync service provider
final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) {
  return BackgroundSyncService();
});

/// Background sync enabled state provider
final backgroundSyncEnabledProvider = StateProvider<bool>((ref) {
  return true; // Default to enabled
});

/// Realtime service provider
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  final service = RealtimeService(supabaseService: supabase);
  
  ref.onDispose(() => service.dispose());
  
  return service;
});

/// Realtime sync handler provider
final realtimeSyncHandlerProvider = Provider<RealtimeSyncHandler>((ref) {
  final realtimeService = ref.watch(realtimeServiceProvider);
  final syncEngine = ref.watch(syncEngineProvider);
  
  final handler = RealtimeSyncHandler(
    realtimeService: realtimeService,
    syncEngine: syncEngine,
  );
  
  // Start listening to realtime changes
  handler.startListening();
  
  // Listen to workspace changes and subscribe to realtime updates
  ref.listen<String?>(currentWorkspaceIdProvider, (previous, next) {
    if (next != null && next != previous) {
      handler.subscribeToWorkspace(next);
    }
  });
  
  ref.onDispose(() => handler.dispose());
  
  return handler;
});

/// Realtime enabled state provider
final realtimeEnabledProvider = StateProvider<bool>((ref) {
  return true; // Default to enabled
});

// ============================================================================
// Repository providers
// ============================================================================

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  
  return TaskRepository(
    database: db,
    apiClient: api,
  );
});

/// Project repository provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  
  return ProjectRepository(
    database: db,
    apiClient: api,
  );
});

/// Label repository provider
final labelRepositoryProvider = Provider<LabelRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  
  return LabelRepository(db, api);
});

/// Workspace repository provider
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  
  return WorkspaceRepository(
    apiClient: api,
  );
});

/// Comment repository provider
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  
  return CommentRepository(
    apiClient: api,
  );
});

/// Activity repository provider
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  
  return ActivityRepository(
    apiClient: api,
  );
});

/// Notification repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  
  return NotificationRepository(
    apiClient: api,
  );
});

/// Attachment repository provider
final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  
  return AttachmentRepository(
    database: db,
    apiClient: api,
  );
});


// ============================================================================
// Reminder & Notifications providers
// ============================================================================

/// Local notifications service provider
final localNotificationsServiceProvider = Provider<LocalNotificationsService>((ref) {
  return LocalNotificationsService();
});

/// Reminder scheduler service provider
final reminderSchedulerServiceProvider = Provider<ReminderSchedulerService>((ref) {
  final db = ref.watch(databaseProvider);
  final notifications = ref.watch(localNotificationsServiceProvider);
  
  final scheduler = ReminderSchedulerService(
    database: db,
    notifications: notifications,
  );
  
  // Initialize on creation
  scheduler.initialize();
  
  return scheduler;
});

/// File upload service provider
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  
  return FileUploadService(
    apiClient: apiClient,
  );
});

/// Thumbnail generation service provider
final thumbnailServiceProvider = Provider<ThumbnailService>((ref) {
  return ThumbnailService();
});
