# PlanPal Desktop Manual Test Guide

This guide is for the installed Windows desktop app only. Test the screens in
order, with separate online and offline checks for each screen. It currently
covers Home and Tasks; the remaining screens will be added screen by screen.
Login, Create Account, Confirm Account, and Forgot Password are reserved for
the final group of screens.

## Test record

| App version | Windows version | Workspace | Account role | Date | Tester |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

For each case, record **Pass**, **Fail**, or **Not tested**, plus a short note.
Use a test account and a workspace whose data is safe to change. Do not include
passwords, access tokens, private messages, or other secrets in test notes.

### Prepare for Home testing

- Confirm the app is signed in and the intended workspace is selected.
- While online, open Home and allow its real tasks, overview, calendar, and
  upcoming events to load before starting offline checks.
- Have a disposable, incomplete task assigned to the signed-in account and due
  today for the offline completion check. Do not use a task that must remain
  incomplete.
- To test offline, leave the app open and disconnect Windows from the network
  (turn off Wi-Fi or disconnect Ethernet). Reconnect after the offline cases.

## 1. Home

### Online

- [pass] **H-ON-01 — Open Home.** The signed-in user's first name and time-appropriate
  greeting appear, and the data belongs to the selected workspace.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass ] **H-ON-02 — Tasks Today.** The section lists only incomplete tasks due today
  that are assigned to this account, up to three. Titles, due times, and priority
  labels correspond to the real tasks. If there are none, a clear empty state
  appears. **Result:** Pass / Fail / Not tested. **Notes:**
- [ Not tested ] **H-ON-03 — Task links.** Open a task using its card and return to Home.
  Use **View All Tasks** and confirm it opens the task list in today's view.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass] **H-ON-04 — Quick Actions.** The desktop tiles are visible and open the
  matching New Task, Calendar, Analytics, and Documents destinations. Analytics
  is hidden for a guest account. Return to Home after checking navigation; do not
  treat the destination screens as tested here.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass ] **H-ON-05 — Overview range and statistics.** Check the **This Week**,
  **Last 7 days**, and **Last 30 days** ranges. The four values (Tasks Completed,
  Tasks In Progress, Tasks Overdue, and Productivity) update for the selected
  range and reflect real workspace data.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass] **H-ON-06 — Overview chart.** The completed-tasks chart follows the selected
  range, has readable date labels and a 0–100 y-axis, and renders smoothly without
  broken segments, overlap, or clipping.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass ] **H-ON-07 — Mini calendar.** Today's date is highlighted. Previous/next
  month controls change the displayed month and dates correctly.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [pass] **H-ON-08 — Upcoming events.** The panel shows real upcoming events with
  their correct titles and times, or a clear empty state when there are none.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **H-ON-09 — Desktop layout.** Scroll through Home and check that its main
  content and right panel remain usable at the current window size. Resize the
  window and check for clipped content, unintended overlap, or horizontal
  scrolling.
  **Result:** Pass / Fail / Not tested. **Notes:**

### Offline

- [pass ] **H-OFF-01 — Offline status and cached Home.** After loading Home online,
  disconnect Windows from the network. The app stays open without crashing and
  clearly indicates that it is offline. Previously loaded Tasks Today, calendar,
  and Upcoming data remain available as cached data; do not treat it as fresh.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [not tested ] **H-OFF-02 — Cached Overview.** The last loaded Overview values remain
  visible with an offline/last-updated indication. Record the displayed
  last-updated time, if shown.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **H-OFF-03 — Queue a task completion.** Using the disposable task prepared
  above, mark it complete from its Home card while offline. The change appears
  locally and is identified as waiting to sync; no duplicate task appears.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **H-OFF-04 — Reconnect and sync.** Restore the network. The offline status
  clears, the queued completion syncs once, and the task is shown as completed
  when checked in the task list or from another signed-in session. No duplicate
  task or repeated completion appears.
  **Result:** Pass / Fail / Not tested. **Notes:**

## 2. Tasks

### Prepare for Tasks testing

- Stay signed in and keep the intended workspace selected.
- For online checks, use real workspace tasks with more than one status,
  priority, and assignee if available. If a needed combination is unavailable,
  mark that check **Not tested** rather than creating misleading test data.
- Have two disposable tasks in a workspace that is safe to change: one to
  complete and one to delete. Do not use tasks that must remain unchanged.
- For the offline-create check, use a unique title and do not attach a file;
  attachments require an online connection.
- Load the task list while online before disconnecting Windows from the network.

### Online

- [ ] **T-ON-01 — Open Tasks.** Select **Tasks** in the sidebar. Confirm the list
  belongs to the selected workspace, the task table shows real task names,
  assignees, due dates, priorities, and statuses, and the heading counts update
  to match the displayed tasks. If the workspace has no tasks, confirm the
  empty state appears and that **Add Task** is available to roles that can
  create tasks.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-02 — Create a task online.** Select **Add Task** and create one
  real task with a unique title, description, priority, due date/time, and
  assignee where available. Confirm submission succeeds, opens the created
  task, and returning to Tasks shows the task once with the entered values.
  If the workspace has more than one page, confirm the new task still appears
  immediately even when it is not in the first server page.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-03 — Filter and sort.** Try status, priority, and assignee filters
  separately, then try the available sort choices. Confirm the displayed rows
  match each selected filter and are ordered by the selected sort. Clear the
  filters and confirm the full task list returns. If a selected filter has no
  matching real tasks, confirm the no-results state and clear-filters action.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-04 — Open a task and load more.** Open a row and confirm its detail
  page is for that task; return to Tasks. If **Load More** appears, use it and
  confirm additional rows appear without duplicates.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-05 — Complete a task.** Select the disposable task prepared for
  completion, choose **Mark Complete**, and confirm the task is shown as
  completed and the selection clears. Confirm the change is visible after
  refreshing Tasks.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-06 — Delete confirmation.** Select the other disposable task and
  choose **Delete Selected**. Cancel once and confirm it remains. Repeat and
  confirm deletion; check that it no longer appears after refreshing.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-ON-07 — Desktop layout.** Resize the window and scroll the task table.
  Confirm the filter controls, table columns, row selection, bulk actions, and
  load-more control remain usable without unintended clipping or overlap.
  **Result:** Pass / Fail / Not tested. **Notes:**

### Offline

- [ ] **T-OFF-01 — Cached task list.** After loading Tasks online, disconnect
  Windows from the network. Confirm the offline banner appears, the app stays
  open, and cached task rows remain visible without a raw API error or retry
  banner. These rows are cached and may not reflect recent server changes.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-OFF-02 — Filter cached tasks.** While still offline, apply and clear
  status or priority filters. Confirm the cached list responds to the filters
  and can be restored without an error replacing the cached rows.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-OFF-03 — Create a task offline.** From Tasks choose **Add Task** and
  create a task with a unique title and no attachment. Confirm the task is
  saved locally, the app reports that it is waiting to sync, and it appears
  exactly once when you return to the task list. Confirm file attachment is
  disabled with an offline explanation.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-OFF-04 — Queue a completion offline.** Select the offline-created
  disposable task from T-OFF-03 and choose **Mark Complete**. Confirm its
  local status changes and the app reports that it is waiting to sync.
  **Result:** Pass / Fail / Not tested. **Notes:**
- [ ] **T-OFF-05 — Reconnect and sync.** Restore the network and wait for sync.
  Confirm the offline banner clears, the offline-created task appears on the
  server exactly once, and the queued completion is still completed. If
  possible, verify from a second signed-in session. Confirm no duplicate task
  appears.
  **Result:** Pass / Fail / Not tested. **Notes:**

If a case cannot be tested (for example, no real task or event is available),
mark **Not tested** and note why. Record unexpected behavior as a failure rather
than assuming the feature passed.



HOME TEST.
 AT THE SIDE BAR  THE WORKSPSACE SWITCHER WHEN YOU SWITCH IT WORKS BUT IT SHOWS ONLY PERSONAL WORKACE WHEN YOU CHANGE WORKSPACE IT SHOULD SWITCH TOO. AND THE SIDE BAR THE BUTTOM THE USER AND WORKSPACE CARD THERE WE HAVE TO REMOVE IT AND AT THE TOP RIGHT CONER AFTER THE NOTIFICATION BELL THE CARD THERE WHICH SHOWS USER AND MEMBER SHOULD BE REMOVE TOO. 
 THE OFFLINE
 first i see errors when i go offline the today task under the today task error shows "__PLANPAL_API_ERROR_:NETWORK   TRY AGAIN BUTTON" and  overview card show error "__PLANPAL_API_ERROR_:NETWORK       TRY AGAIN BUTTON" and the upcomimg under the mini calendar "__PLANPAL_API_ERROR_:NETWORK       TRY AGAIN BUTTON"   theses error message which should not show the app should look normal with the already sync data ryt tell me.

 THE ONCE YOU SEE EMPTY AND NOT TESTED YET, I HAVE NOT TESTED THEM. SIMPLY BECAUSE WHEN I ADD TASK AN ERROR MESSAGE SHOWS SOMETHING WENT WRONG PLS TRY AGAIN THAT FOR ONLINE BUT FOR OFFLINE ITS ADD BUT NOTHING SHOWS