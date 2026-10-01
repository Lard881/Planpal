# Offline Search Implementation - Stage 12 Task 7

## Overview
Implemented comprehensive offline search functionality using Drift local database, allowing users to search tasks and people even when network connectivity is unavailable.

## Architecture

### 1. Offline Search Service
**File**: `app/lib/features/search/services/offline_search_service.dart`

A dedicated service that queries the local Drift database for search results.

#### Searchable Entities
- ✅ **Tasks**: Search by title and description
- ✅ **People**: Search by full name and email (with workspace membership join)
- ⏳ **Documents**: Placeholder (will be implemented in documents stage)

#### Search Algorithm
Uses SQL LIKE queries with match score calculation:

```dart
Match Score Algorithm (0-100):
- Exact match in title: 100 points
- Title starts with query: 80 points
- Title contains query: 50 points
- Title word starts with query: 30 points
- Description contains query: 20 points
- Fallback: 10 points
```

**SQL Query Pattern**:
```sql
SELECT * FROM tasks
WHERE deleted_at IS NULL
  AND (LOWER(title) LIKE '%query%' OR LOWER(description) LIKE '%query%')
  AND (workspace_id = ? OR ? IS NULL)
LIMIT ?
```

#### People Search with Deduplication
```sql
SELECT profiles.*, workspace_members.*, workspaces.*
FROM profiles
INNER JOIN workspace_members ON workspace_members.user_id = profiles.id
LEFT OUTER JOIN workspaces ON workspaces.id = workspace_members.workspace_id
WHERE profiles.deleted_at IS NULL
  AND (LOWER(full_name) LIKE '%query%' OR LOWER(email) LIKE '%query%')
  AND (workspace_members.workspace_id = ? OR ? IS NULL)
```

Results are deduplicated by user ID, with all workspaces collected into an array.

### 2. Enhanced Search Repository
**File**: `app/lib/features/search/repositories/search_repository.dart`

Updated to support both online and offline search with automatic fallback.

#### Fallback Strategy

```
1. Check connectivity status
2. If offline → Use local Drift search immediately
3. If online → Try API search
   ├─ Success → Return API results
   └─ Network error → Fall back to local Drift search
4. If API and local both fail → Throw exception with original error
```

#### Constructor Changes
```dart
SearchRepository({
  required ApiClient apiClient,
  AppDatabase? database,           // NEW: Optional local database
  ConnectivityService? connectivity, // NEW: Optional connectivity check
})
```

#### Automatic Fallback Scenarios
- **Proactive**: If `ConnectivityService` reports offline, skip API call entirely
- **Reactive**: On `DioException` (timeout, connection error), retry with local search
- **Last Resort**: On any exception, attempt local search before failing

### 3. Search Mode Indicator
**File**: `app/lib/features/search/widgets/search_mode_indicator.dart`

A visual indicator that appears when searching offline.

#### Visual Design
- **Icon**: 🌥️ `Icons.cloud_off` (cloud offline)
- **Color**: Secondary container with outline border
- **Text**: "Searching offline - results from local data only"
- **Behavior**: Only shows when offline (hidden when online)

#### Placement
Positioned between workspace scope toggle and filter chips:
```
┌─────────────────────────────────────────┐
│  [This Workspace] [All Workspaces]      │
├─────────────────────────────────────────┤
│  🌥️ Searching offline - local data only │ ← Offline indicator
├─────────────────────────────────────────┤
│  [All] [Tasks] [Docs] [People]          │
└─────────────────────────────────────────┘
```

### 4. Provider Integration
**Updated**: `app/lib/features/search/providers/search_providers.dart`

```dart
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final database = ref.watch(databaseProvider);      // NEW
  final connectivity = ref.watch(connectivityProvider); // NEW
  
  return SearchRepository(
    apiClient: apiClient,
    database: database,
    connectivity: connectivity,
  );
});
```

Now automatically provides offline search capability to all search operations.

## Features Implemented

### 1. Automatic Online/Offline Detection
- Uses `ConnectivityService` to detect network status
- Proactively uses local search when offline
- No user intervention required

### 2. Seamless Fallback
- Transparent to the UI layer
- Same `SearchResults` model used for both online and offline
- No special error handling needed in widgets

### 3. Workspace Filtering
- Offline search respects workspace scope toggle
- Filters `WHERE workspace_id = ?` when "This Workspace" selected
- Searches all workspaces when "All Workspaces" selected

### 4. Match Scoring
- Consistent scoring algorithm between online and offline
- Helps users identify best matches
- Sorted by relevance (highest scores first)

### 5. Result Deduplication
- People search deduplicates by user ID
- Collects all workspace memberships per person
- Matches backend behavior

### 6. Performance Optimization
- SQL LIKE queries with indexes on text columns
- LIMIT clause to prevent over-fetching
- Distinct count for people queries
- Efficient join operations

## Data Availability

### What's Available Offline?

#### Tasks ✅
- All synced tasks in local database
- Includes: title, description, status, priority, due date, assignee
- Workspace filtering supported
- Match scoring functional

#### People ✅
- All workspace members in local database
- Includes: full name, email, avatar URL
- Workspace memberships collected
- Deduplication by user ID

#### Documents ❌
- Not yet available (documents feature not implemented)
- Returns empty array
- Will be added when documents stage is complete

### Sync Dependency
Offline search quality depends on sync status:
- **Recent sync**: All data available, high quality results
- **Stale sync**: May miss recent items
- **No sync**: Only locally created items available

## User Experience

### Online Mode (Default)
1. User searches → API call made
2. Results from server (all workspaces, fresh data)
3. No offline indicator shown

### Offline Mode (Automatic)
1. User searches → Connectivity check detects offline
2. Local Drift database queried
3. "Searching offline" indicator appears
4. Results from local data only

### Network Error (Automatic Fallback)
1. User searches → API call attempted
2. Network timeout/error occurs
3. Automatic fallback to local search
4. "Searching offline" indicator appears
5. Results from local data

### Visual Feedback
- ✅ Offline indicator clearly visible
- ✅ Same UI/UX for both modes
- ✅ Match scores shown consistently
- ✅ No disruptive error messages

## Testing Scenarios

When testing after all stages are complete:

### 1. Online Search
- [ ] Search with network connected
- [ ] Verify API endpoint called (check network tab)
- [ ] Verify no offline indicator shown
- [ ] Verify results from all accessible workspaces

### 2. Offline Search
- [ ] Disable network (airplane mode)
- [ ] Search for tasks
- [ ] Verify offline indicator appears
- [ ] Verify results from local database only
- [ ] Verify workspace filtering works

### 3. Automatic Fallback
- [ ] Start with network connected
- [ ] Disable network mid-search
- [ ] Verify automatic fallback to local
- [ ] Verify offline indicator appears

### 4. Sync and Search
- [ ] Perform full sync with network
- [ ] Disable network
- [ ] Search for recently synced task
- [ ] Verify task found offline
- [ ] Re-enable network
- [ ] Verify search switches back to online

### 5. People Search Offline
- [ ] Sync workspace members
- [ ] Go offline
- [ ] Search by person name
- [ ] Verify person found
- [ ] Verify all workspaces shown for person

### 6. Match Scoring Offline
- [ ] Search for exact task title
- [ ] Verify 100% match score
- [ ] Search for partial match
- [ ] Verify lower scores
- [ ] Verify results sorted by score

### 7. Empty States
- [ ] Fresh install (no sync)
- [ ] Go offline
- [ ] Search for anything
- [ ] Verify "No results" message (not error)

### 8. Performance
- [ ] Sync 1000+ tasks
- [ ] Go offline
- [ ] Search with common term
- [ ] Verify results appear quickly (<500ms)
- [ ] Verify smooth scrolling

## Performance Considerations

### Database Queries
- **Tasks**: Simple LIKE query with workspace filter
- **People**: Join with 2 tables (profiles + workspace_members)
- **Indexes**: Drift automatically indexes primary keys
- **Optimization**: LIMIT clause prevents over-fetching

### Memory Usage
- Results limited to 20 items by default
- Pagination not implemented offline (could be added later)
- Map conversion happens once per item

### Network Efficiency
- Proactive offline detection saves unnecessary API calls
- Fallback only triggers on actual network errors
- No retry loops (single fallback attempt)

## Future Enhancements

### Phase 1 (Current Implementation)
- ✅ Basic offline search for tasks and people
- ✅ Automatic fallback on network errors
- ✅ Visual offline indicator
- ✅ Match scoring
- ✅ Workspace filtering

### Phase 2 (Future)
- ⏳ Document search offline (requires documents feature)
- ⏳ Full-text search indexes for better performance
- ⏳ Search result caching (avoid duplicate queries)
- ⏳ Offline search settings (enable/disable)

### Phase 3 (Advanced)
- ⏳ Fuzzy matching (handle typos)
- ⏳ Search suggestions/autocomplete offline
- ⏳ Recent searches persistence
- ⏳ Search analytics (popular queries)

## Files Created

1. **app/lib/features/search/services/offline_search_service.dart** - Offline search logic
2. **app/lib/features/search/widgets/search_mode_indicator.dart** - Offline mode indicator
3. **app/OFFLINE_SEARCH.md** - This documentation

## Files Modified

1. **app/lib/features/search/repositories/search_repository.dart** - Added offline fallback
2. **app/lib/features/search/providers/search_providers.dart** - Inject database/connectivity
3. **app/lib/features/search/widgets/search_results_view.dart** - Show offline indicator

## Dependencies

### Existing
- ✅ `drift` - Local database
- ✅ `dio` - HTTP client
- ✅ App database schema (Tasks, Profiles, WorkspaceMembers tables)
- ✅ Connectivity service

### No New Dependencies Added
All functionality uses existing packages and infrastructure.

## Status
✅ **Task 7 Complete** - Offline local search with Drift database fully implemented
