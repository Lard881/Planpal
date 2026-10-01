# Sync Engine Test Scenarios

This document outlines comprehensive test scenarios for the PlanPal sync engine. These should be performed manually on actual devices to ensure full functionality.

## 1. Basic Sync Operations

### 1.1 Create Task While Online
**Steps:**
1. Ensure device has internet connection
2. Create a new task
3. Observe sync status indicator
4. Check sync logs for push operation

**Expected:**
- Task syncs immediately to server
- Sync indicator shows "syncing" then "idle"
- Sync logs show successful push operation
- Task appears on other devices/web

### 1.2 Create Task While Offline
**Steps:**
1. Turn off internet connection
2. Create a new task
3. Observe sync queue (Settings > Sync > View Sync Queue)
4. Turn internet back on
5. Wait for automatic sync

**Expected:**
- Task saved locally
- Operation added to sync queue
- When online, task syncs automatically
- Sync logs show queued → pushed operation

### 1.3 Update Task While Online
**Steps:**
1. Ensure online connection
2. Update an existing task title
3. Check sync status

**Expected:**
- Update syncs immediately
- Changes reflected on server
- Sync logs show update operation

### 1.4 Update Task While Offline
**Steps:**
1. Go offline
2. Update task multiple times
3. Check sync queue
4. Go back online

**Expected:**
- All updates queued locally
- Queue deduplicates multiple updates to same task
- When online, latest version syncs
- Only one update operation in logs (deduplicated)

### 1.5 Delete Task While Online/Offline
**Steps:**
1. Delete task while online
2. Delete another task while offline
3. Go back online

**Expected:**
- Online deletion syncs immediately
- Offline deletion queued and syncs when online
- Both deletions reflected on server

---

## 2. Conflict Resolution

### 2.1 Last Write Wins Strategy
**Setup:**
- Set conflict strategy to "Last Write Wins" in Sync Settings

**Steps:**
1. Device A: Update task title to "Version A" at 10:00 AM
2. Device B (offline): Update same task to "Version B" at 10:01 AM
3. Device B goes online
4. Both devices sync

**Expected:**
- "Version B" wins (newer timestamp)
- Both devices show "Version B"
- Sync logs show conflict detected and auto-resolved

### 2.2 Server Wins Strategy
**Setup:**
- Set conflict strategy to "Server Wins"

**Steps:**
1. Device A: Update task, syncs to server
2. Device B (offline): Update same task differently
3. Device B goes online and syncs

**Expected:**
- Server version (Device A's changes) wins
- Device B's local changes discarded
- Sync logs show conflict resolved with server version

### 2.3 Client Wins Strategy
**Setup:**
- Set conflict strategy to "Client Wins"

**Steps:**
1. Device A: Update task, syncs to server
2. Device B (offline): Update same task differently
3. Device B goes online and syncs

**Expected:**
- Client version (Device B's changes) wins
- Device B's changes overwrite server
- Sync logs show conflict resolved with client version

### 2.4 Manual Resolution
**Setup:**
- Set conflict strategy to "Manual"

**Steps:**
1. Create conflict (as above scenarios)
2. Trigger sync
3. Conflict dialog should appear

**Expected:**
- Dialog shows local vs server versions side-by-side
- User can choose "Keep Local" or "Keep Server"
- Chosen version is applied
- Conflict marked as resolved in logs

### 2.5 View All Conflicts
**Steps:**
1. Create multiple conflicts with "Manual" strategy
2. Navigate to Settings > Sync > View Sync Conflicts

**Expected:**
- All pending conflicts listed
- Shows timestamps and which is newer
- Can resolve individual conflicts
- "Use Server for All" bulk action available

---

## 3. Queue Management

### 3.1 Queue Operations While Offline
**Steps:**
1. Go offline
2. Create 5 tasks
3. Update 3 existing tasks
4. Delete 2 tasks
5. Check sync queue

**Expected:**
- Queue shows 10 operations (5 creates, 3 updates, 2 deletes)
- Operations shown as "ready"
- Statistics accurate

### 3.2 Failed Operations and Retry
**Steps:**
1. Simulate server error (turn off backend server)
2. Go online but keep backend down
3. Create task (will fail to sync)
4. Observe retry behavior
5. Start backend server

**Expected:**
- Initial sync fails
- Operation marked for retry with exponential backoff
- Retries: 1s, 2s, 4s, 8s, 16s intervals
- After 5 retries, marked as failed
- When server back up, can manually retry from Sync Settings
- Sync logs show all retry attempts

### 3.3 Clear Sync Queue
**Steps:**
1. Create several operations offline
2. Go to Settings > Sync > Clear Sync Queue
3. Confirm action

**Expected:**
- All pending operations removed
- Warning about data loss shown
- Queue emptied
- Sync logs show queue cleared

### 3.4 View Sync Queue Details
**Steps:**
1. Create various operations offline
2. Tap "View Sync Queue" in Sync Settings
3. View sync status sheet

**Expected:**
- Shows current sync state
- Displays pending, ready, and failed operation counts
- Lists failed operations with errors
- "Retry Failed" and "Sync Now" buttons functional

---

## 4. Real-time Updates

### 4.1 Real-time Task Creation
**Setup:**
- Enable "Real-time Updates" in Sync Settings
- Have two devices logged into same workspace

**Steps:**
1. Device A: Create a new task
2. Observe Device B

**Expected:**
- Within 1-2 seconds, task appears on Device B
- Sync logs on Device B show realtime event received
- Sync triggered automatically
- No manual refresh needed

### 4.2 Real-time Task Update
**Steps:**
1. Device A: Update task title
2. Observe Device B

**Expected:**
- Update reflected on Device B almost instantly
- Smooth transition (no flicker)

### 4.3 Real-time Task Deletion
**Steps:**
1. Device A: Delete a task
2. Observe Device B

**Expected:**
- Task removed from Device B automatically
- UI updates smoothly

### 4.4 Disable Real-time Updates
**Steps:**
1. Turn off "Real-time Updates" in Sync Settings
2. Make changes on another device
3. Wait 30 seconds (periodic sync interval)

**Expected:**
- Changes not received immediately
- Changes appear after periodic sync (30s)
- Realtime WebSocket connection closed

### 4.5 Real-time with Multiple Rapid Changes
**Steps:**
1. Device A: Rapidly create 10 tasks in quick succession
2. Observe Device B

**Expected:**
- Debouncing prevents sync spam (500ms delay)
- All tasks appear on Device B
- Only 1-2 sync operations triggered (not 10)
- Sync logs show debounced sync

---

## 5. Background Sync

### 5.1 Background Sync Enabled
**Setup:**
- Enable "Background Sync" in Sync Settings

**Steps:**
1. Create tasks while online
2. Close app completely
3. Wait 15 minutes
4. Make changes on another device
5. Reopen app

**Expected:**
- App synced while closed (WorkManager executed)
- Changes from other device already present
- Sync logs show background sync execution

### 5.2 Background Sync Disabled
**Steps:**
1. Disable "Background Sync"
2. Close app
3. Wait 15 minutes
4. Make changes on another device
5. Reopen app

**Expected:**
- No background sync occurred
- Changes appear only after app opens and syncs

### 5.3 Background Sync with Network Constraint
**Steps:**
1. Enable background sync
2. Turn off WiFi (mobile data only)
3. Close app
4. Wait for background sync interval

**Expected:**
- If constraints require WiFi, no sync occurs
- Sync waits until WiFi available
- When WiFi restored, sync executes

---

## 6. Incremental Sync

### 6.1 Incremental Sync After Recent Sync
**Steps:**
1. Perform full sync
2. Make 1 small change on server
3. Trigger manual sync
4. Check sync logs

**Expected:**
- Sync logs show "incremental sync" type
- Request includes `updated_since` timestamp
- Only changed data fetched
- Faster than full sync

### 6.2 Full Sync After Long Time
**Steps:**
1. Don't sync for 8 days
2. Trigger sync
3. Check sync logs

**Expected:**
- Full sync performed (timestamp too old)
- No `updated_since` parameter
- All data fetched
- Sync logs indicate full sync

### 6.3 First Sync of New Workspace
**Steps:**
1. Join a new workspace
2. Automatic sync triggers
3. Check sync logs

**Expected:**
- Full sync performed
- No timestamp exists yet
- All workspace data fetched
- Timestamp saved for future incremental syncs

---

## 7. Workspace Switching

### 7.1 Switch Workspace While Online
**Steps:**
1. Switch from Workspace A to Workspace B
2. Observe sync behavior

**Expected:**
- Sync queue for Workspace A cleared
- Automatic sync triggered for Workspace B
- Real-time subscriptions updated to Workspace B
- Sync logs show workspace switch

### 7.2 Switch Workspace with Pending Operations
**Steps:**
1. Create tasks in Workspace A while offline
2. Switch to Workspace B (still offline)
3. Check sync queue

**Expected:**
- Workspace A operations cleared (to prevent cross-workspace sync)
- Queue emptied
- Warning dialog shown about unsaved changes

### 7.3 Real-time Updates Respect Workspace
**Steps:**
1. Device A in Workspace 1
2. Device B in Workspace 2
3. Device A creates task in Workspace 1

**Expected:**
- Device B does not receive update (different workspace)
- Real-time events filtered by workspace_id
- Sync logs show workspace filtering

---

## 8. Sync Logs and Monitoring

### 8.1 View Sync Logs
**Steps:**
1. Perform various sync operations
2. Go to Settings > Sync > View Sync Logs
3. Browse logs

**Expected:**
- All operations logged with timestamps
- Color-coded by level (debug, info, warning, error)
- Categorized by type
- Entity and workspace info included

### 8.2 Filter Logs
**Steps:**
1. Use filter menu in Sync Logs screen
2. Filter by level (errors only)
3. Filter by type (sync operations)

**Expected:**
- Logs filtered correctly
- Active filter shown as chip
- Can clear filter easily

### 8.3 View Log Details
**Steps:**
1. Tap on a log entry
2. View full details

**Expected:**
- Dialog shows complete log information
- Error stack traces viewable (if error)
- Metadata displayed
- Timestamps in full format

### 8.4 Error Logs Quick Filter
**Steps:**
1. Tap "Errors Only" button
2. View filtered results

**Expected:**
- Only errors and warnings shown
- Other logs hidden
- Can toggle off easily

### 8.5 Log Statistics
**Steps:**
1. View Sync Logs screen
2. Check statistics card

**Expected:**
- Total log count
- Count by level (debug, info, warning, error)
- Counts accurate and updated

### 8.6 Clear Logs
**Steps:**
1. Perform various operations
2. Clear all logs
3. Confirm action

**Expected:**
- All logs removed
- Empty state shown
- Confirmation required
- Statistics reset to zero

---

## 9. Error Handling

### 9.1 Network Error During Sync
**Steps:**
1. Start sync operation
2. Disconnect network mid-sync
3. Observe behavior

**Expected:**
- Sync fails gracefully
- Operation requeued for retry
- Error logged with network error type
- UI shows error state

### 9.2 Server Error Response
**Steps:**
1. Simulate 500 Internal Server Error
2. Attempt sync

**Expected:**
- Error captured and logged
- Operation retried with backoff
- Sync logs show server error details
- User notified

### 9.3 Invalid Data Handling
**Steps:**
1. Create task with invalid data (if possible)
2. Attempt sync

**Expected:**
- Validation error caught
- Operation moved to failed
- Error details in logs
- User can view and fix

### 9.4 Concurrent Sync Attempts
**Steps:**
1. Trigger manual sync
2. Immediately trigger another sync

**Expected:**
- Second sync ignored
- "Sync already in progress" logged
- No duplicate operations
- Single sync completes

---

## 10. Performance Testing

### 10.1 Large Queue Sync
**Steps:**
1. Create 100+ operations offline
2. Go online
3. Trigger sync
4. Monitor performance

**Expected:**
- Queue processed in batches (20 at a time)
- UI remains responsive
- Progress visible
- All operations eventually synced

### 10.2 Large Dataset Sync
**Steps:**
1. Join workspace with 1000+ tasks
2. Perform initial sync
3. Monitor time and memory

**Expected:**
- Sync completes successfully
- Reasonable performance (<30s for 1000 items)
- No memory issues
- App remains stable

### 10.3 Real-time Update Storm
**Steps:**
1. Simulate 50+ rapid changes from server
2. Observe real-time sync behavior

**Expected:**
- Debouncing limits sync frequency
- UI remains smooth
- All updates eventually reflected
- No performance degradation

---

## 11. Edge Cases

### 11.1 Clock Skew
**Steps:**
1. Set device time 1 hour ahead
2. Create tasks
3. Sync with server (normal time)
4. Reset device time to normal

**Expected:**
- Sync handles timestamp differences
- Data integrity maintained
- Conflicts resolved correctly

### 11.2 App Force Close During Sync
**Steps:**
1. Start sync operation
2. Force close app mid-sync
3. Reopen app

**Expected:**
- Sync resumes or restarts
- No data corruption
- Queue recovers correctly
- Incomplete operations reprocessed

### 11.3 Rapid Workspace Switching
**Steps:**
1. Switch workspaces rapidly 5 times
2. Observe sync behavior

**Expected:**
- Each workspace switch triggers sync
- No race conditions
- Correct workspace data shown
- Realtime subs updated correctly

### 11.4 Low Memory Conditions
**Steps:**
1. Open many apps to reduce available memory
2. Perform sync operations
3. Monitor stability

**Expected:**
- Sync continues functioning
- Log buffer limits prevent memory leaks
- App remains stable
- Graceful degradation if needed

---

## Test Summary Checklist

- [ ] All basic CRUD operations sync correctly
- [ ] Offline queue works as expected
- [ ] All conflict resolution strategies functional
- [ ] Retry logic with exponential backoff works
- [ ] Real-time updates instant and reliable
- [ ] Background sync executes correctly
- [ ] Incremental sync reduces bandwidth
- [ ] Workspace isolation maintained
- [ ] Sync logs comprehensive and accurate
- [ ] Error handling graceful
- [ ] Performance acceptable under load
- [ ] Edge cases handled correctly

---

## Automated Test Results

Run automated tests:
```bash
flutter test test/core/sync/
```

Expected: All tests pass ✅

## Notes for Testers

1. **Network Simulation:** Use device settings or Charles Proxy to simulate various network conditions
2. **Multiple Devices:** Testing real-time requires 2+ devices or web + mobile
3. **Backend Control:** Some tests require ability to start/stop backend server
4. **Supabase Dashboard:** Use Supabase dashboard to verify server-side data
5. **Log Everything:** Keep detailed notes of any failures or unexpected behavior
6. **Performance Metrics:** Record sync times for large operations
7. **Edge Cases:** Be creative - try to break it!
