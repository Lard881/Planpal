# Connectivity & Sync Triggers

This directory contains connectivity monitoring and automatic sync trigger functionality.

## Overview

The connectivity layer provides:
- **Network monitoring**: Real-time connectivity status tracking
- **Automatic sync triggers**: Sync when connection restored
- **App lifecycle handling**: Sync on app resume
- **WiFi-only mode**: Save mobile data
- **Connection type detection**: WiFi, mobile, ethernet, etc.

## Architecture

```
┌─────────────────────────────────────────┐
│     Connectivity Service                 │
│  - Monitors network status               │
│  - Detects connection changes            │
│  - Broadcasts state updates              │
└─────────────────┬───────────────────────┘
                  │
                  ▼ Status change
┌─────────────────────────────────────────┐
│     Sync Trigger Service                 │
│  - Listens to connectivity               │
│  - Listens to app lifecycle              │
│  - Triggers sync automatically           │
└─────────────────┬───────────────────────┘
                  │
                  ▼ Trigger sync
┌─────────────────────────────────────────┐
│         Sync Manager                     │
│  - Executes sync operations              │
│  - Processes offline queue               │
└─────────────────────────────────────────┘
```

## Components

### ConnectivityService

Monitors network connectivity status.

**Properties:**
- `isOnline`: Boolean indicating online status
- `isOffline`: Boolean indicating offline status
- `networkType`: Current network type (wifi, mobile, etc.)
- `currentState`: Full connectivity state
- `stateStream`: Stream of state changes

**Methods:**
- `initialize()`: Start monitoring
- `dispose()`: Stop monitoring

### SyncTriggerService

Automatically triggers sync based on events.

**Configuration:**
```dart
SyncTriggerConfig(
  syncOnReconnect: true,      // Sync when coming online
  syncOnResume: true,          // Sync when app resumes
  minSyncInterval: Duration(minutes: 1),  // Min time between syncs
  reconnectDelay: Duration(seconds: 2),   // Delay after reconnect
  wifiOnly: false,             // Only sync on WiFi
)
```

**Methods:**
- `start()`: Begin listening to triggers
- `stop()`: Stop listening
- `triggerManualSync()`: Force immediate sync
- `triggerSyncIfNeeded()`: Sync if needed
- `onAppResume()`: Handle app resume

### ConnectivityStatus

Enum for connectivity status.

```dart
enum ConnectivityStatus {
  online,    // Connected to network
  offline,   // No connection
  unknown,   // Status unknown
}
```

### NetworkType

Enum for network type.

```dart
enum NetworkType {
  wifi,       // WiFi connection
  mobile,     // Mobile data
  ethernet,   // Ethernet cable
  vpn,        // VPN connection
  bluetooth,  // Bluetooth tethering
  other,      // Other connection
  none,       // No connection
}
```

### ConnectivityState

Full connectivity state.

```dart
ConnectivityState(
  status: ConnectivityStatus.online,
  networkType: NetworkType.wifi,
  lastChanged: DateTime.now(),
  wasOffline: false,
)
```

**Properties:**
- `justCameOnline`: True if just transitioned to online
- `justWentOffline`: True if just transitioned to offline

## Usage

### Basic Connectivity Check

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/connectivity/connectivity_providers.dart';

// Check if online
final isOnline = ref.watch(isOnlineProvider);

if (isOnline) {
  // Perform online operation
  await apiCall();
} else {
  // Queue for later
  await ref.enqueueOperation();
}
```

### Watch Connectivity State

```dart
// Watch connectivity state stream
final stateAsync = ref.watch(connectivityStateStreamProvider);

stateAsync.when(
  data: (state) {
    if (state.status.isOnline) {
      return Text('Online via ${state.networkType.name}');
    } else {
      return Text('Offline');
    }
  },
  loading: () => Text('Checking...'),
  error: (e, s) => Text('Error'),
);
```

### Check Network Type

```dart
// Get network type
final networkType = ref.watch(networkTypeProvider);

// Check specific types
final isWifi = ref.watch(isWifiProvider);
final isMobile = ref.watch(isMobileProvider);

if (isWifi) {
  // Safe to download large files
  await downloadLargeFile();
} else if (isMobile) {
  // Use mobile-friendly approach
  await downloadCompressed();
}
```

### Manual Sync Trigger

```dart
// Trigger manual sync
final syncTrigger = ref.read(syncTriggerServiceProvider);
final result = await syncTrigger.triggerManualSync();

if (result?.success == true) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Sync successful')),
  );
}
```

### Conditional Sync

```dart
// Sync only if needed
final syncTrigger = ref.read(syncTriggerServiceProvider);
await syncTrigger.triggerSyncIfNeeded();

// Check if sync is allowed (considers WiFi-only setting)
final isSyncAllowed = ref.watch(isSyncAllowedProvider);

if (isSyncAllowed) {
  await performSync();
}
```

## Automatic Sync Triggers

### On Reconnect

When device comes online, sync is automatically triggered after a short delay:

```
Offline → Online
    ↓
Wait 2 seconds (allows connection to stabilize)
    ↓
Check if sync needed
    ↓
Trigger sync
```

### On App Resume

When app returns from background:

```
Background → Foreground
    ↓
Check if online
    ↓
Check min sync interval
    ↓
Trigger sync if needed
```

### Configuration

```dart
// Configure sync triggers
final syncTriggerConfigProvider = Provider<SyncTriggerConfig>((ref) {
  return SyncTriggerConfig(
    syncOnReconnect: true,           // Auto-sync on reconnect
    syncOnResume: true,              // Auto-sync on app resume
    minSyncInterval: Duration(minutes: 1),  // Prevent too frequent syncs
    reconnectDelay: Duration(seconds: 2),   // Delay before sync
    wifiOnly: true,                  // Only sync on WiFi
  );
});
```

## App Lifecycle Integration

### Setup

Wrap your app with `AppLifecycleWidget`:

```dart
import 'package:planpal/core/connectivity/app_lifecycle_observer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLifecycleWidget(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
```

This automatically:
- Listens to app lifecycle events
- Triggers sync on app resume
- Handles background/foreground transitions

## UI Integration

### Connectivity Icon

Show connectivity status in UI:

```dart
final iconData = ref.watch(connectivityIconProvider);

Icon(
  _getIconFromName(iconData.icon),
  color: _getColorFromName(iconData.color),
  tooltip: iconData.tooltip,
)
```

### Status Banner

Show offline banner:

```dart
final isOffline = ref.watch(isOfflineProvider);

if (isOffline) {
  return Banner(
    message: 'You are offline. Changes will sync when connection is restored.',
    backgroundColor: Colors.orange,
  );
}
```

### Sync Button with Status

```dart
Consumer(
  builder: (context, ref, child) {
    final isOnline = ref.watch(isOnlineProvider);
    final isSyncing = ref.watch(isSyncingProvider);
    
    return ElevatedButton.icon(
      onPressed: isOnline && !isSyncing
          ? () async {
              final syncTrigger = ref.read(syncTriggerServiceProvider);
              await syncTrigger.triggerManualSync();
            }
          : null,
      icon: isSyncing
          ? CircularProgressIndicator()
          : Icon(isOnline ? Icons.sync : Icons.sync_disabled),
      label: Text(
        isSyncing ? 'Syncing...' : (isOnline ? 'Sync Now' : 'Offline'),
      ),
    );
  },
)
```

## Providers

### connectivityServiceProvider

Provides ConnectivityService instance.

```dart
final service = ref.read(connectivityServiceProvider);
```

### connectivityStateStreamProvider

Stream of connectivity state changes.

```dart
final stateAsync = ref.watch(connectivityStateStreamProvider);
```

### isOnlineProvider

Boolean indicating online status.

```dart
final isOnline = ref.watch(isOnlineProvider);
```

### isOfflineProvider

Boolean indicating offline status.

```dart
final isOffline = ref.watch(isOfflineProvider);
```

### networkTypeProvider

Current network type.

```dart
final networkType = ref.watch(networkTypeProvider);
```

### isWifiProvider

Boolean indicating WiFi connection.

```dart
final isWifi = ref.watch(isWifiProvider);
```

### isMobileProvider

Boolean indicating mobile data connection.

```dart
final isMobile = ref.watch(isMobileProvider);
```

### syncTriggerServiceProvider

Provides SyncTriggerService instance.

```dart
final service = ref.read(syncTriggerServiceProvider);
```

### isSyncAllowedProvider

Boolean considering WiFi-only setting.

```dart
final allowed = ref.watch(isSyncAllowedProvider);
```

## Configuration

### WiFi-Only Mode

```dart
// Enable WiFi-only mode in settings
final syncTriggerConfigProvider = Provider<SyncTriggerConfig>((ref) {
  final wifiOnly = ref.watch(settingsProvider).wifiOnlySync;
  
  return SyncTriggerConfig(
    wifiOnly: wifiOnly,
    // ... other config
  );
});
```

### Sync Intervals

```dart
SyncTriggerConfig(
  minSyncInterval: Duration(minutes: 5),  // Min 5 minutes between syncs
  reconnectDelay: Duration(seconds: 5),   // Wait 5 seconds after reconnect
)
```

## Testing

### Mock Connectivity

```dart
import 'package:mocktail/mocktail.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

test('should trigger sync on reconnect', () async {
  final mockConnectivity = MockConnectivityService();
  final mockSyncManager = MockSyncManager();
  
  when(() => mockConnectivity.isOnline).thenReturn(true);
  when(() => mockConnectivity.networkType).thenReturn(NetworkType.wifi);
  
  final syncTrigger = SyncTriggerService(
    connectivityService: mockConnectivity,
    syncManager: mockSyncManager,
  );
  
  // Simulate reconnect
  final controller = StreamController<ConnectivityState>();
  when(() => mockConnectivity.stateStream).thenAnswer((_) => controller.stream);
  
  syncTrigger.start();
  
  controller.add(ConnectivityState(
    status: ConnectivityStatus.online,
    networkType: NetworkType.wifi,
    lastChanged: DateTime.now(),
    wasOffline: true,
  ));
  
  await Future.delayed(Duration(seconds: 3));
  
  verify(() => mockSyncManager.sync()).called(1);
});
```

### Simulate Network Change

```dart
// In integration tests
final connectivityService = ref.read(connectivityServiceProvider);

// Force offline
connectivityService._updateState(ConnectivityStatus.offline, NetworkType.none);

// Perform offline actions
await createTask();

// Force online
connectivityService._updateState(ConnectivityStatus.online, NetworkType.wifi);

// Wait for auto-sync
await Future.delayed(Duration(seconds: 3));

// Verify sync occurred
expect(pendingOperations, isEmpty);
```

## Best Practices

1. **Always check connectivity**: Before API calls
2. **Queue when offline**: Don't fail user actions
3. **Show feedback**: Indicate online/offline status
4. **Handle transitions**: Gracefully handle status changes
5. **Respect WiFi-only**: Give users control over data usage
6. **Debounce syncs**: Use minSyncInterval
7. **Test offline**: Simulate no connection scenarios

## Troubleshooting

### Sync Not Triggering

1. Check connectivity service initialized
2. Verify sync trigger service started
3. Review min sync interval settings
4. Check WiFi-only restrictions
5. Review logs for errors

### False Offline Detection

1. Check connectivity_plus package version
2. Test on different networks
3. Review periodic check interval
4. Check device network permissions

### Too Frequent Syncs

1. Increase minSyncInterval
2. Reduce app resume sync frequency
3. Check for duplicate triggers
4. Review network status changes

## Performance

### Optimization Tips

1. **Debounce rapid changes**: Use minSyncInterval
2. **Delay after reconnect**: Allow connection to stabilize
3. **Background sync**: Don't block UI
4. **Efficient checks**: Periodic check every 30s
5. **Dispose properly**: Clean up subscriptions

### Monitoring

```dart
// Track sync triggers
final syncTrigger = ref.read(syncTriggerServiceProvider);

syncTrigger.stateStream.listen((state) {
  print('Connectivity: ${state.status.name}');
  print('Network: ${state.networkType.name}');
  print('Last changed: ${state.lastChanged}');
});
```

## Related Files

- `connectivity_service.dart`: Core connectivity monitoring
- `sync_trigger_service.dart`: Automatic sync triggers
- `connectivity_providers.dart`: Riverpod providers
- `app_lifecycle_observer.dart`: App lifecycle integration
- `../sync/`: Sync service
- `../offline_queue/`: Offline queue management
