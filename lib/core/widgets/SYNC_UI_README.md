# Sync UI Widgets

Reusable UI components for displaying sync status, connectivity, and offline mode indicators.

## Components

### SyncStatusIndicator

Compact sync status indicator with icon and optional text.

**Usage:**
```dart
// With text
SyncStatusIndicator()

// Icon only
SyncStatusIndicator(showText: false)

// Custom icon size
SyncStatusIndicator(iconSize: 24)

// Without pending count badge
SyncStatusIndicator(showPendingCount: false)
```

**States:**
- **Syncing**: Animated spinner with "Syncing..."
- **Online + Synced**: Green check icon with "Synced"
- **Offline**: Orange cloud_off icon with pending count
- **Conflicts**: Amber warning icon with "Sync conflicts"
- **Error**: Red error icon with "Sync failed"

**Example in AppBar:**
```dart
AppBar(
  title: Text('Tasks'),
  actions: [
    Padding(
      padding: EdgeInsets.only(right: 16),
      child: SyncStatusIndicator(showText: false),
    ),
  ],
)
```

---

### ConnectivityBadge

Network connection status badge.

**Usage:**
```dart
// Full badge with label
ConnectivityBadge()

// Compact icon only
ConnectivityBadge(compact: true)
```

**Network Types:**
- WiFi: Green WiFi icon
- Mobile: Green cellular icon
- Ethernet: Green ethernet icon
- Offline: Red cloud_off icon

**Example:**
```dart
Row(
  children: [
    Text('Status:'),
    SizedBox(width: 8),
    ConnectivityBadge(),
  ],
)
```

---

### OfflineBanner

Material banner shown at top when offline.

**Usage:**
```dart
Scaffold(
  body: Column(
    children: [
      OfflineBanner(), // Auto-hides when online
      Expanded(child: YourContent()),
    ],
  ),
)
```

**Features:**
- Auto-shows when offline
- Shows pending operations count
- Dismissible

---

### PendingOperationsBadge

Badge showing pending operations count.

**Usage:**
```dart
// Hide when zero
PendingOperationsBadge()

// Always show
PendingOperationsBadge(showZero: true)
```

**States:**
- **Pending > 0**: Orange badge with count
- **All synced**: Green badge with checkmark
- **Zero (hideZero: true)**: Hidden

---

### SyncButton

Button that triggers manual sync with status indication.

**Usage:**
```dart
SyncButton()

// With callback
SyncButton(
  onSyncComplete: () {
    print('Sync completed');
  },
)
```

**States:**
- **Can sync**: Enabled with "Sync Now"
- **Syncing**: Disabled with spinner and "Syncing..."
- **Offline**: Disabled with "Offline"

**Example in Drawer:**
```dart
Drawer(
  child: ListView(
    children: [
      // ... other items
      Padding(
        padding: EdgeInsets.all(16),
        child: SyncButton(),
      ),
    ],
  ),
)
```

---

### SyncStatusCard

Detailed card showing sync and queue status.

**Usage:**
```dart
// In settings or debug screen
SyncStatusCard()
```

**Shows:**
- Connectivity status with badge
- Current sync state
- Network type
- Pending operations count
- Failed operations count
- Manual sync button

**Example:**
```dart
// Settings screen
ListView(
  children: [
    // ... other settings
    SyncStatusCard(),
  ],
)
```

---

### SyncProgressOverlay

Full-screen overlay during sync operations.

**Usage:**
```dart
Stack(
  children: [
    YourMainContent(),
    SyncProgressOverlay(), // Auto-shows during sync
  ],
)
```

**Features:**
- Semi-transparent black background
- Centered loading card
- Auto-shows when syncing
- Blocks interaction during sync

---

### SyncDetailsBottomSheet

Bottom sheet with detailed sync information.

**Usage:**
```dart
// Show bottom sheet
SyncDetailsBottomSheet.show(context);

// Or manually
showModalBottomSheet(
  context: context,
  builder: (context) => SyncDetailsBottomSheet(),
);
```

**Sections:**
1. **Connectivity**: Status, network type, last changed
2. **Sync Status**: Current state, last sync time
3. **Queue Statistics**: Pending, failed, total operations
4. **Pending Operations**: List of queued operations (up to 10)

**Example with Icon Button:**
```dart
IconButton(
  icon: Icon(Icons.info_outline),
  tooltip: 'Sync Details',
  onPressed: () {
    SyncDetailsBottomSheet.show(context);
  },
)
```

---

## Integration Examples

### Complete AppBar with Sync Indicators

```dart
AppBar(
  title: Text('PlanPal'),
  actions: [
    // Connectivity badge
    Padding(
      padding: EdgeInsets.only(right: 8),
      child: ConnectivityBadge(compact: true),
    ),
    
    // Sync status
    Padding(
      padding: EdgeInsets.only(right: 8),
      child: SyncStatusIndicator(showText: false),
    ),
    
    // Sync details
    IconButton(
      icon: Icon(Icons.sync),
      onPressed: () {
        SyncDetailsBottomSheet.show(context);
      },
    ),
  ],
)
```

### Scaffold with Offline Banner

```dart
Scaffold(
  body: Column(
    children: [
      OfflineBanner(),
      Expanded(
        child: YourContent(),
      ),
    ],
  ),
)
```

### Settings Screen with Sync Card

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // App settings
          SettingsSection(
            title: 'General',
            tiles: [...],
          ),
          
          SizedBox(height: 24),
          
          // Sync status
          Text(
            'Sync & Offline',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12),
          SyncStatusCard(),
          
          SizedBox(height: 16),
          
          // Pending operations badge
          PendingOperationsBadge(showZero: true),
        ],
      ),
    );
  }
}
```

### Task List with Sync Feedback

```dart
class TaskListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Tasks'),
            SizedBox(width: 8),
            if (isOffline)
              Icon(Icons.cloud_off, size: 20, color: Colors.orange),
          ],
        ),
        actions: [
          SyncStatusIndicator(showText: false),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => SyncDetailsBottomSheet.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          OfflineBanner(),
          Expanded(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTask(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Pull to Refresh with Sync

```dart
RefreshIndicator(
  onRefresh: () async {
    final syncTrigger = ref.read(syncTriggerServiceProvider);
    final result = await syncTrigger.triggerManualSync();
    
    if (result?.success == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Synced ${result!.successful} changes'),
          backgroundColor: Colors.green,
        ),
      );
    }
  },
  child: ListView(...),
)
```

### Sync Progress Dialog

```dart
// Show during long sync operations
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Syncing...'),
        SizedBox(height: 8),
        SyncStatusIndicator(),
      ],
    ),
  ),
);
```

---

## Styling & Theming

All widgets respect Material Theme colors:

```dart
// Customize colors in theme
ThemeData(
  colorScheme: ColorScheme(
    primary: Colors.blue,    // Syncing state
    error: Colors.red,        // Error state
    // ...
  ),
)
```

### Custom Sync Indicator Colors

Modify colors in `SyncStatusIndicator._buildIndicator()`:

```dart
// Success
color = Colors.green;

// Syncing
color = theme.colorScheme.primary;

// Offline
color = Colors.orange;

// Error
color = Colors.red;

// Conflicts
color = Colors.amber;
```

---

## Best Practices

1. **Always show connectivity status**: Use `ConnectivityBadge` or `SyncStatusIndicator`
2. **Offline banner for critical workflows**: Use `OfflineBanner` on main screens
3. **Provide manual sync**: Add `SyncButton` to settings or drawer
4. **Detailed info for power users**: Use `SyncDetailsBottomSheet` for debugging
5. **Loading states**: Show `SyncProgressOverlay` for blocking operations
6. **Feedback on sync**: Show SnackBar with results after manual sync
7. **Pending count visibility**: Display `PendingOperationsBadge` when offline

---

## Accessibility

All widgets include:
- Semantic labels for screen readers
- Tooltips on interactive elements
- Color contrast for visibility
- Text alternatives for icons

### Example with Semantics:

```dart
Semantics(
  label: 'Sync status: Online and synced',
  child: SyncStatusIndicator(),
)
```

---

## Testing

### Widget Tests

```dart
testWidgets('shows sync status indicator', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SyncStatusIndicator(),
        ),
      ),
    ),
  );
  
  expect(find.byType(SyncStatusIndicator), findsOneWidget);
});
```

### Integration Tests

```dart
testWidgets('offline banner appears when offline', (tester) async {
  // Set offline state
  final container = ProviderContainer();
  
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: OfflineBanner(),
        ),
      ),
    ),
  );
  
  // Simulate offline
  // ... trigger offline state
  
  await tester.pump();
  
  expect(find.byType(MaterialBanner), findsOneWidget);
});
```

---

## Performance Tips

1. **Use compact indicators**: Set `showText: false` for AppBar
2. **Lazy load details**: Use bottom sheet instead of always-visible details
3. **Debounce updates**: Providers update on stream changes
4. **Cache icons**: Icons are cached by Flutter
5. **Minimize rebuilds**: Use `Consumer` for targeted rebuilds

---

## Troubleshooting

### Indicator not updating
- Check providers are watched, not just read
- Verify stream subscriptions active
- Check connectivity service initialized

### Wrong colors
- Verify theme configured correctly
- Check color mappings in widgets
- Test in both light and dark modes

### Bottom sheet not showing
- Ensure context is valid
- Check modal route stack
- Verify no navigation guards blocking

---

## Related Files

- `sync_status_indicator.dart`: Main indicator widgets
- `sync_details_bottom_sheet.dart`: Detailed info sheet
- `../connectivity/connectivity_providers.dart`: Data providers
- `../sync/sync_manager.dart`: Sync state management
- `../offline_queue/offline_queue_providers.dart`: Queue providers
