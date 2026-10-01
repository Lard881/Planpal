# Workspace Scope Toggle - Stage 12 Task 6

## Overview
Implemented workspace scope switch allowing users to toggle between searching the current workspace only or all accessible workspaces.

## Features Implemented

### 1. Workspace Scope Toggle Widget
**File**: `app/lib/features/search/widgets/workspace_scope_toggle.dart`

A toggle control with two options:
- **This Workspace**: Search only in the current workspace
- **All Workspaces**: Search across all workspaces the user has access to

#### Visual Design
- **Container**: Rounded background with subtle color (`surfaceVariant` at 30% opacity)
- **Two equal-width buttons**: Side-by-side layout
- **Selected State**: Primary container color with bold text
- **Unselected State**: Transparent background with normal weight text
- **Icons**:
  - 📁 `Icons.folder` for "This Workspace"
  - 📂 `Icons.folder_open` for "All Workspaces"

#### Behavior
```dart
// When "This Workspace" is tapped
- Reads current workspace ID from currentWorkspaceIdProvider
- Updates searchFilterProvider with workspaceId set to current workspace
- Triggers new search with workspace filter

// When "All Workspaces" is tapped
- Updates searchFilterProvider with workspaceId set to null
- Triggers search across all accessible workspaces
```

### 2. Provider Integration

#### Updated `searchFilterProvider`
```dart
final searchFilterProvider = StateProvider<SearchFilter>((ref) {
  // Initialize with current workspace by default
  final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);
  return SearchFilter(workspaceId: currentWorkspaceId);
});
```

**Behavior**:
- **Default**: Initializes with current workspace (privacy-first approach)
- **Reactive**: Automatically updates when workspace changes
- **User Control**: Can be toggled to null for all-workspaces search

#### Reused Existing Provider
**`currentWorkspaceIdProvider`** from `app/lib/core/providers/app_providers.dart`
- Already defined as `StateProvider<String?>`
- Used throughout the app for workspace context
- No duplication needed

### 3. UI Integration

#### Updated `search_results_view.dart`
Added workspace scope toggle above filter chips in all states:
- **With Results**: Toggle → Filter chips → Count → Results list
- **No Results**: Toggle → Filter chips → Empty state message
- **Loading**: Toggle → Filter chips → Loading indicator
- **Error**: Toggle → Filter chips → Error message

**Layout**:
```
┌─────────────────────────────────────┐
│  [This Workspace] [All Workspaces]  │ ← Workspace Scope Toggle
├─────────────────────────────────────┤
│  [All] [Tasks] [Docs] [People]      │ ← Filter Chips
├─────────────────────────────────────┤
│  15 results                          │ ← Count
├─────────────────────────────────────┤
│  [Result 1]                          │
│  [Result 2]                          │ ← Results
│  ...                                 │
└─────────────────────────────────────┘
```

## Backend Support

The backend search endpoint (`/api/v1/search`) already supports workspace filtering:
- **Query Parameter**: `workspace_id` (optional)
- **When provided**: Filters results to specific workspace
- **When null/omitted**: Returns results from all accessible workspaces
- **RLS Enforcement**: Only returns results from workspaces where user has access

## User Experience

### Default Behavior
1. User opens search
2. Workspace scope defaults to "This Workspace" (current workspace)
3. Searches are scoped to current workspace by default
4. Privacy-first: Doesn't expose data from other workspaces without explicit user action

### Switching Scope
1. User taps "All Workspaces"
2. Toggle visually updates (primary container highlight)
3. Search automatically re-runs with new scope
4. Results now include matches from all accessible workspaces
5. Each result card shows workspace name for context

### Visual Feedback
- **Selected button**: Primary container background, bold text, colored icon
- **Unselected button**: Transparent background, normal text, muted icon
- **Smooth transitions**: InkWell ripple effects on tap
- **Clear affordance**: Button-like appearance invites interaction

## Testing Scenarios

When testing after all stages are complete:

### 1. Workspace Scope Functionality
- [ ] Default to current workspace on search screen open
- [ ] Toggle to "All Workspaces" → should re-run search
- [ ] Toggle back to "This Workspace" → should re-run search
- [ ] Verify workspace_id parameter sent correctly to backend
- [ ] Verify results are filtered appropriately

### 2. Multi-Workspace Results
- [ ] Create test data in multiple workspaces
- [ ] Search with "This Workspace" → only current workspace results
- [ ] Search with "All Workspaces" → results from all workspaces
- [ ] Verify workspace name badge shows on each result
- [ ] Verify no access to workspaces user doesn't belong to

### 3. Visual and Interaction
- [ ] Verify toggle rendering on different screen sizes
- [ ] Test tap targets are adequate (44x44 dp minimum)
- [ ] Verify selected state is visually clear
- [ ] Check color contrast meets WCAG standards
- [ ] Test with light and dark themes

### 4. Edge Cases
- [ ] User with only one workspace → toggle still works
- [ ] User with no workspaces → should handle gracefully
- [ ] Switching workspaces while on search screen
- [ ] Network error during scope switch → error handling
- [ ] Rapid toggling → debounce/cancellation works

## Accessibility

- **Semantic Labels**: Button labels are clear ("This Workspace", "All Workspaces")
- **Visual Indicators**: Icons + text + color provide multiple cues
- **Touch Targets**: Full button width for easy tapping
- **Screen Readers**: Text labels read by screen readers
- **Keyboard Navigation**: InkWell supports focus/tap

## Performance

- **Instant Toggle**: UI updates immediately on tap
- **Automatic Search**: Provider reactivity triggers new search
- **No Manual Refetch**: Riverpod's `autoDispose` handles cache invalidation
- **Network Efficiency**: Only sends workspace_id when needed

## Files Modified

1. **app/lib/features/search/providers/search_providers.dart**
   - Updated `searchFilterProvider` to initialize with current workspace
   - Added reactive dependency on `currentWorkspaceIdProvider`

2. **app/lib/features/search/widgets/search_results_view.dart**
   - Added `WorkspaceScopeToggle` import
   - Integrated toggle into all async states (data/loading/error)

## Files Created

1. **app/lib/features/search/widgets/workspace_scope_toggle.dart** - Toggle widget
2. **app/WORKSPACE_SCOPE_TOGGLE.md** - This documentation

## Future Enhancements

1. **Remember Preference**: Save last selected scope to shared preferences
2. **Workspace Picker**: Show dropdown of workspaces instead of just current/all
3. **Advanced Filters**: Add date range, creator, status filters
4. **Search within Project**: Add project-level scope option
5. **Visual Hierarchy**: Show workspace groupings in results

## Status
✅ **Task 6 Complete** - Workspace scope toggle implemented with current/all workspace switching
