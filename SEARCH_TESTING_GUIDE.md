# Search Testing Guide - Stage 12 Task 9

## Overview
Comprehensive manual testing guide for the global search feature. This testing should be performed after all 18 stages are complete and all skipped tasks are implemented.

## Prerequisites

### 1. Complete Implementation
- ✅ All 18 stages completed
- ✅ Skipped tasks implemented (ProfileScreen, SettingsScreen, MainShell, etc.)
- ✅ Auth system functional (login/signup)
- ✅ Supabase configured and connected
- ✅ Backend server running

### 2. Test Data Setup

#### Create Test Workspaces
```sql
-- Run in Supabase SQL editor or via backend
INSERT INTO workspaces (id, name, type, created_by) VALUES
  ('ws-1', 'Personal Tasks', 'personal', 'user-id'),
  ('ws-2', 'Work Projects', 'team', 'user-id'),
  ('ws-3', 'Home Improvement', 'team', 'user-id');
```

#### Create Test Tasks
```sql
INSERT INTO tasks (id, workspace_id, title, description, status, priority) VALUES
  -- Workspace 1
  ('task-1', 'ws-1', 'Buy groceries', 'Get milk, eggs, bread from supermarket', 'todo', 'high'),
  ('task-2', 'ws-1', 'Schedule dentist appointment', 'Annual checkup needed', 'todo', 'medium'),
  ('task-3', 'ws-1', 'Learn Flutter', 'Complete online course on Flutter development', 'in_progress', 'low'),
  
  -- Workspace 2
  ('task-4', 'ws-2', 'Project Alpha Planning', 'Define scope and requirements for Project Alpha', 'completed', 'high'),
  ('task-5', 'ws-2', 'Client Meeting Preparation', 'Prepare slides and demo for client presentation', 'in_progress', 'high'),
  ('task-6', 'ws-2', 'Code Review', 'Review pull requests from team members', 'todo', 'medium'),
  
  -- Workspace 3
  ('task-7', 'ws-3', 'Paint living room', 'Buy paint and supplies, paint walls', 'todo', 'medium'),
  ('task-8', 'ws-3', 'Fix leaky faucet', 'Kitchen sink needs washer replacement', 'in_progress', 'high'),
  ('task-9', 'ws-3', 'Garden maintenance', 'Mow lawn, trim hedges, water plants', 'todo', 'low');
```

#### Add Team Members
```sql
INSERT INTO workspace_members (workspace_id, user_id, role) VALUES
  ('ws-2', 'user-2', 'member'),
  ('ws-2', 'user-3', 'member'),
  ('ws-3', 'user-2', 'admin');
```

#### Create Test Profiles
```sql
INSERT INTO profiles (id, email, full_name, avatar_url) VALUES
  ('user-1', 'john@example.com', 'John Doe', 'https://i.pravatar.cc/150?u=user1'),
  ('user-2', 'jane@example.com', 'Jane Smith', 'https://i.pravatar.cc/150?u=user2'),
  ('user-3', 'bob@example.com', 'Bob Johnson', 'https://i.pravatar.cc/150?u=user3');
```

### 3. Environment Setup
- Backend server running on configured port
- Flutter app built and running (Windows or Android)
- Network connectivity enabled
- Supabase configured with correct credentials

## Test Scenarios

### Scenario 1: Basic Search Functionality

#### Test 1.1: Task Search - Exact Match
**Steps:**
1. Open app and navigate to search (Ctrl+K or search icon)
2. Type "groceries"
3. Wait for results (debounced 300ms)

**Expected Results:**
- ✅ "Buy groceries" task appears
- ✅ Match score: 50-100% (contains in title)
- ✅ Workspace name shown: "Personal Tasks"
- ✅ Status icon visible (todo = outline circle)
- ✅ Priority chip visible (high = red)

#### Test 1.2: Task Search - Partial Match
**Steps:**
1. Search for "proj"
2. Observe results

**Expected Results:**
- ✅ "Project Alpha Planning" appears
- ✅ Match score appropriate for partial match
- ✅ Results appear within 500ms after debounce

#### Test 1.3: Task Search - Description Match
**Steps:**
1. Search for "checkup"
2. Observe results

**Expected Results:**
- ✅ "Schedule dentist appointment" appears
- ✅ Lower match score (description match)
- ✅ Description text visible showing "Annual checkup needed"

#### Test 1.4: People Search
**Steps:**
1. Search for "Jane"
2. Observe results

**Expected Results:**
- ✅ "Jane Smith" appears in people section
- ✅ Email shown: "jane@example.com"
- ✅ Avatar displayed or fallback icon
- ✅ Workspace badges show "Work Projects", "Home Improvement"
- ✅ Match score visible

### Scenario 2: Filter Functionality

#### Test 2.1: Filter by Type - All
**Steps:**
1. Search for "project"
2. Observe "All" filter is selected by default
3. Verify all result types shown

**Expected Results:**
- ✅ Tasks section visible (if any task matches)
- ✅ Documents section visible (if any doc matches)
- ✅ People section visible (if any person matches)
- ✅ Section headers show counts

#### Test 2.2: Filter by Type - Tasks Only
**Steps:**
1. Search for "project"
2. Tap "Tasks" filter chip
3. Observe results

**Expected Results:**
- ✅ Only tasks shown
- ✅ No people or documents sections
- ✅ "Tasks" chip highlighted (primary container color)
- ✅ Count matches number of results
- ✅ Results update immediately (no re-search needed)

#### Test 2.3: Filter by Type - People Only
**Steps:**
1. Search for "john"
2. Tap "People" filter chip
3. Observe results

**Expected Results:**
- ✅ Only people shown
- ✅ "John Doe" appears if name matches
- ✅ Task "John's task" NOT shown (filtered out)
- ✅ People chip highlighted

### Scenario 3: Workspace Scope

#### Test 3.1: Search Current Workspace
**Steps:**
1. Navigate to workspace "Personal Tasks"
2. Open search (Ctrl+K)
3. Verify "This Workspace" is selected by default
4. Search for "Buy"

**Expected Results:**
- ✅ Only results from "Personal Tasks" workspace shown
- ✅ "Buy groceries" appears
- ✅ Tasks from other workspaces NOT shown
- ✅ "This Workspace" button highlighted

#### Test 3.2: Search All Workspaces
**Steps:**
1. With previous search active
2. Tap "All Workspaces" toggle
3. Observe results update

**Expected Results:**
- ✅ Results from all workspaces now shown
- ✅ More results appear
- ✅ Each result shows workspace name badge
- ✅ "All Workspaces" button highlighted
- ✅ Search automatically re-runs

#### Test 3.3: Switch Workspace Context
**Steps:**
1. Search in workspace "Personal Tasks"
2. Navigate to different workspace "Work Projects"
3. Open search again
4. Verify workspace scope updated

**Expected Results:**
- ✅ "This Workspace" now means "Work Projects"
- ✅ Results scoped to new workspace
- ✅ Previous results cleared

### Scenario 4: Offline Functionality

#### Test 4.1: Offline Search - Tasks
**Steps:**
1. Ensure data synced (online, perform full sync)
2. Enable airplane mode or disconnect network
3. Search for previously synced task "groceries"

**Expected Results:**
- ✅ Offline indicator appears ("Searching offline - local data only")
- ✅ "Buy groceries" task found from local DB
- ✅ All task details displayed correctly
- ✅ Match scoring works offline
- ✅ No error messages

#### Test 4.2: Offline Search - People
**Steps:**
1. While offline
2. Search for "Jane"

**Expected Results:**
- ✅ "Jane Smith" found in local DB
- ✅ All profile info displayed
- ✅ Workspace memberships shown
- ✅ Avatar loaded (if cached) or fallback shown

#### Test 4.3: Offline - Empty Results
**Steps:**
1. While offline
2. Search for term not in local DB: "asdfghjkl"

**Expected Results:**
- ✅ "No results found" message
- ✅ Search tips card shown
- ✅ NO error message (not a failure)
- ✅ Offline indicator still visible

#### Test 4.4: Online → Offline Transition
**Steps:**
1. Start online, search for "project"
2. Disable network mid-search
3. Try new search

**Expected Results:**
- ✅ First search completes or fails gracefully
- ✅ Second search automatically uses offline mode
- ✅ Offline indicator appears
- ✅ Local results shown

#### Test 4.5: Offline → Online Transition
**Steps:**
1. Start offline, search for task
2. Re-enable network
3. Perform new search

**Expected Results:**
- ✅ New search hits API
- ✅ Offline indicator disappears
- ✅ Results may be more complete (fresh data)
- ✅ Smooth transition, no errors

### Scenario 5: Debouncing

#### Test 5.1: Rapid Typing
**Steps:**
1. Type "project management" quickly (continuous keystrokes)
2. Observe network tab (if available) or loading indicators

**Expected Results:**
- ✅ Loading skeleton NOT shown until typing pauses
- ✅ Only 1 API call made (after 300ms pause)
- ✅ No flickering results
- ✅ Smooth user experience

#### Test 5.2: Slow Typing
**Steps:**
1. Type "p" ... wait 400ms ... "r" ... wait 400ms ... "o"
2. Observe behavior

**Expected Results:**
- ✅ Search triggered after each 300ms pause
- ✅ Multiple searches executed (one per pause)
- ✅ Results update after each character + pause

#### Test 5.3: Delete and Retype
**Steps:**
1. Type "project"
2. Backspace to "pro"
3. Add "gram" to make "program"
4. Observe debouncing

**Expected Results:**
- ✅ Each 300ms pause triggers search
- ✅ Deleting characters resets debounce timer
- ✅ Final search only for "program"

### Scenario 6: Loading States

#### Test 6.1: Skeleton Loader
**Steps:**
1. Throttle network to Slow 3G (Chrome DevTools)
2. Search for "project"
3. Observe loading state

**Expected Results:**
- ✅ "Searching..." text with spinner appears
- ✅ 5 skeleton cards displayed
- ✅ Skeleton cards have placeholder shapes (icon, title, description, chips)
- ✅ Skeleton uses muted colors
- ✅ Workspace toggle and filter chips remain visible

#### Test 6.2: Fast Network
**Steps:**
1. Normal network speed
2. Search for "task"
3. Observe loading state

**Expected Results:**
- ✅ Skeleton may be visible briefly (<200ms)
- ✅ Smooth transition from skeleton to results
- ✅ No jarring flash or flicker

### Scenario 7: Empty States

#### Test 7.1: No Results Found
**Steps:**
1. Search for nonsense: "xyzabc123"
2. Observe empty state

**Expected Results:**
- ✅ Large search-off icon (64px)
- ✅ "No results found" heading
- ✅ "Try different keywords or filters" subtitle
- ✅ Search tips card displayed with 4 tips
- ✅ Tips have lightbulb icons
- ✅ Tips are actionable and helpful

#### Test 7.2: Minimum Characters
**Steps:**
1. Clear search field
2. Type single character "a"
3. Observe message

**Expected Results:**
- ✅ "Start typing to search" message
- ✅ "Enter at least 2 characters" subtitle
- ✅ Large search icon (friendly, not error-like)
- ✅ No skeleton or loading state

### Scenario 8: Error Handling

#### Test 8.1: Network Error
**Steps:**
1. Configure backend to be unreachable (stop server or use invalid URL)
2. Go online in app
3. Search for "test"

**Expected Results:**
- ✅ Error icon displayed (64px, red)
- ✅ "Search failed" heading
- ✅ User-friendly message: "Could not connect to server. Check your internet connection."
- ✅ "Retry" button visible and functional
- ✅ "Show details" button visible

#### Test 8.2: Retry Functionality
**Steps:**
1. With network error state showing
2. Fix network/backend issue
3. Tap "Retry" button

**Expected Results:**
- ✅ Loading state appears
- ✅ New search attempt made
- ✅ If successful, results shown
- ✅ If still failing, error state returns
- ✅ Retry button remains available

#### Test 8.3: Error Details
**Steps:**
1. With error state showing
2. Tap "Show details" button

**Expected Results:**
- ✅ Dialog appears with title "Error Details"
- ✅ Technical error message shown
- ✅ Monospace font used for error
- ✅ Dialog is scrollable (if error is long)
- ✅ "Close" button dismisses dialog

#### Test 8.4: Timeout Error
**Steps:**
1. Configure very slow network (>30s delay)
2. Search for "test"
3. Wait for timeout

**Expected Results:**
- ✅ Error state appears after timeout
- ✅ User-friendly message: "Request timed out. Please try again."
- ✅ Retry button available

### Scenario 9: Navigation

#### Test 9.1: Navigate to Task
**Steps:**
1. Search for "groceries"
2. Tap on "Buy groceries" result card
3. Observe navigation

**Expected Results:**
- ✅ Navigates to TaskDetailScreen
- ✅ Correct task ID passed (task-1)
- ✅ Task details displayed
- ✅ Can navigate back to search

#### Test 9.2: Navigate to Document (Placeholder)
**Steps:**
1. Search for term that would match document
2. Tap on document result
3. Observe behavior

**Expected Results:**
- ✅ Snackbar appears
- ✅ Message: "Document viewer coming soon"
- ✅ Snackbar auto-dismisses after 2 seconds
- ✅ Stays on search screen

#### Test 9.3: Navigate to Person (Placeholder)
**Steps:**
1. Search for "Jane"
2. Tap on "Jane Smith" result
3. Observe behavior

**Expected Results:**
- ✅ Snackbar appears
- ✅ Message: "User profile coming soon"
- ✅ Snackbar auto-dismisses
- ✅ Stays on search screen

### Scenario 10: Match Scoring

#### Test 10.1: Exact Title Match
**Steps:**
1. Search for exact task title: "Buy groceries"
2. Observe match score

**Expected Results:**
- ✅ Match score: 100%
- ✅ Badge color: Primary container (best match)

#### Test 10.2: Partial Title Match
**Steps:**
1. Search for "groc"
2. Observe "Buy groceries" match score

**Expected Results:**
- ✅ Match score: 30-80% (word start or contains)
- ✅ Badge color: Primary or secondary container

#### Test 10.3: Description Match
**Steps:**
1. Search for "slides" (matches "Prepare slides..." in description)
2. Observe match score

**Expected Results:**
- ✅ Match score: 20-50%
- ✅ Badge color: Secondary container or surface variant

#### Test 10.4: Score Ordering
**Steps:**
1. Search for "project"
2. Observe result order

**Expected Results:**
- ✅ Exact or best matches appear first
- ✅ Results ordered by match score (descending)
- ✅ Lower score matches appear later

### Scenario 11: Keyboard Shortcuts

#### Test 11.1: Ctrl+K to Open Search
**Steps:**
1. From any screen in app
2. Press Ctrl+K (or Cmd+K on Mac)
3. Observe behavior

**Expected Results:**
- ✅ Search screen opens
- ✅ Search field auto-focused
- ✅ Cursor blinking in input
- ✅ Recent searches shown (if any)

#### Test 11.2: Escape to Close (if implemented)
**Steps:**
1. With search open
2. Press Escape key
3. Observe behavior

**Expected**: Should close search or clear input (depends on implementation)

#### Test 11.3: Enter to Submit
**Steps:**
1. Type search query
2. Press Enter
3. Observe behavior

**Expected Results:**
- ✅ Search executes immediately (skips debounce)
- ✅ Query added to recent searches

### Scenario 12: Visual Polish

#### Test 12.1: Light Theme
**Steps:**
1. Set app to light theme
2. Perform various searches
3. Check all states

**Expected Results:**
- ✅ All text readable (sufficient contrast)
- ✅ Icons visible
- ✅ Badges legible
- ✅ No color accessibility issues

#### Test 12.2: Dark Theme
**Steps:**
1. Set app to dark theme
2. Perform various searches
3. Check all states

**Expected Results:**
- ✅ All elements visible in dark mode
- ✅ Colors inverted appropriately
- ✅ No blinding whites
- ✅ Maintains visual hierarchy

#### Test 12.3: Animations
**Steps:**
1. Observe state transitions
2. Check filter chip selection
3. Watch result cards appear

**Expected Results:**
- ✅ Smooth transitions (no janky animations)
- ✅ 60fps scrolling
- ✅ InkWell ripples on taps
- ✅ Professional feel throughout

### Scenario 13: Edge Cases

#### Test 13.1: Very Long Query
**Steps:**
1. Type 100+ character search query
2. Observe behavior

**Expected Results:**
- ✅ Query accepted (no crash)
- ✅ Input field scrolls horizontally if needed
- ✅ Backend handles gracefully
- ✅ Results or "no results" shown

#### Test 13.2: Special Characters
**Steps:**
1. Search for: `!@#$%^&*()[]{}|`
2. Observe behavior

**Expected Results:**
- ✅ No crash
- ✅ Query sanitized by backend
- ✅ Likely "no results" but handled gracefully

#### Test 13.3: Unicode Characters
**Steps:**
1. Search for: "café résumé 日本語"
2. Observe behavior

**Expected Results:**
- ✅ Unicode handled correctly
- ✅ Matching works with accented characters
- ✅ No encoding issues

#### Test 13.4: Empty Result for All Filters
**Steps:**
1. Search for term with no matches in any category
2. Try switching between All/Tasks/Docs/People filters

**Expected Results:**
- ✅ Empty state shown for all filters
- ✅ No crashes or errors
- ✅ Filter counts all show 0

### Scenario 14: Performance

#### Test 14.1: Large Result Set
**Steps:**
1. Search for common term (e.g., "task")
2. Generate 100+ results if possible
3. Observe performance

**Expected Results:**
- ✅ Results appear within 1 second
- ✅ Smooth scrolling through results
- ✅ No memory issues
- ✅ Pagination works if implemented

#### Test 14.2: Rapid Filter Switching
**Steps:**
1. Search for term with multi-type results
2. Rapidly tap between All/Tasks/Docs/People filters
3. Observe performance

**Expected Results:**
- ✅ No lag or freeze
- ✅ Filters respond immediately
- ✅ No duplicate requests to backend
- ✅ Smooth user experience

#### Test 14.3: Memory Usage
**Steps:**
1. Perform 50+ searches in succession
2. Monitor app memory (if tools available)

**Expected Results:**
- ✅ No memory leaks
- ✅ Memory usage stable
- ✅ App remains responsive
- ✅ AutoDispose working correctly

## Bug Reporting Template

If issues found during testing:

```markdown
### Bug: [Short Description]

**Severity**: Critical | High | Medium | Low

**Steps to Reproduce**:
1. 
2. 
3. 

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happened]

**Screenshots**:
[If applicable]

**Environment**:
- OS: Windows 11 / Android 14
- App Version: [version]
- Backend: Running / Not Running
- Network: Online / Offline

**Logs**:
```
[Relevant logs]
```

**Workaround**:
[If any workaround exists]
```

## Success Criteria

Stage 12 (Global Search) is considered fully functional when:

- [✅] All test scenarios pass
- [✅] No critical or high severity bugs
- [✅] Performance acceptable (searches <1s on normal network)
- [✅] Offline mode works reliably
- [✅] UI polished and professional
- [✅] No crashes or errors in normal use
- [✅] Accessibility requirements met
- [✅] Documentation complete

## Notes

- **Deferred Testing**: As agreed, this testing will be performed after:
  1. All 18 stages complete
  2. Skipped tasks implemented
  3. Auth system functional
  4. All integrations complete

- **Integration Points**: Search depends on:
  - Auth (user sessions)
  - Workspaces (workspace context)
  - Tasks (data source)
  - Profiles (people search)
  - Sync (offline data availability)

- **Test Data**: Use realistic data that mimics production scenarios
- **Test Coverage**: Aim for 100% scenario coverage before production
- **Regression**: Re-test after any search-related changes

## Status
✅ **Task 9 Complete** - Comprehensive testing guide created (testing deferred until all stages complete as per user instruction)
