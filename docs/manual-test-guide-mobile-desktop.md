# PlanPal Manual Test Guide — Android and Windows

Use this guide to test the installed app with real accounts and real backend data. Do
not mark a case passed until you have performed it on the stated platform. A result
on Android does not count as a Windows result, or vice versa.

## Test record

| Build/version | Platform/device | Account(s) used | Date | Tester |
|---|---|---|---|---|
|  |  |  |  |  |

For each case, mark **Pass**, **Fail**, or **Not tested**, and add a short note.
Do not put passwords, access tokens, Firebase keys, cron secrets, or private data
in this document.

## Before testing

- Install the current test build. Record its version above.
- Use a non-production test workspace where possible. Do not test destructive
  actions on records or accounts that must be kept.
- Have two real test accounts, **Account A** and **Account B**, in the same team
  workspace. Keep a separate Personal workspace available for workspace-isolation
  checks.
- Sign in to both accounts on separate devices/sessions. Use Android for Account A
  and Windows for Account B for cross-platform checks; two Android devices are also
  useful for push checks.
- Confirm both accounts are members of the intended team workspace. Use a guest
  account too if available for permission checks.
- For Android push testing, install the updated build, allow notification
  permission, sign in, and keep the device online. Push delivery can be delayed by
  the scheduled worker. Confirm the backend is live before diagnosing the app.
- For offline cases, first load the relevant real data while online. Then disable
  Wi-Fi and mobile data (Android) or disconnect the network (Windows). Restore the
  connection after making the offline change.
- Capture failures without including credentials, personal message contents, or
  secret values.

## Android phone checklist

### A. Launch, authentication, and navigation

- [ ] A1. Launch the app online. It opens without a crash and reaches the sign-in
  or signed-in screen appropriate to the account.
- [ ] A2. Sign in with a test account. The correct user and workspace are shown;
  signing out and back in works.
- [ ] A3. Move between Home, Tasks, Chat, Profile, and Settings using the mobile
  navigation. Each destination loads and the selected tab is correct.
- [ ] A4. Switch between Personal and team workspaces. Team-only destinations do
  not expose team data while Personal is selected.
- [ ] A5. Rotate the phone and check portrait and landscape layouts for clipped
  controls, unusable dialogs, and horizontal overflow.

### B. Home and tasks

- [ ] B1. Home shows real workspace data, or a clear empty state when the account
  has no corresponding data. Refresh and confirm the screen recovers.
- [ ] B2. Create a task with a title, priority, due date, and Account B as assignee.
  Confirm it appears in the task list and detail view.
- [ ] B3. On Account B, confirm the assigned task appears and can be opened. Record
  whether an assignment notification appears; the current backend targets the
  assignee, not every workspace member.
- [ ] B4. Edit task title/status, add and reorder subtasks, and add a comment.
  Confirm the saved values remain after leaving and reopening the task.
- [ ] B5. Complete a task, then verify the resulting status in the task list and
  Home summary.
- [ ] B6. With network access disabled, create or edit a task if the UI permits it.
  Confirm it shows a waiting/offline state; reconnect and verify it syncs once,
  without duplicate tasks.
- [ ] B7. Confirm destructive task actions require the intended confirmation and
  that cancellation leaves the task unchanged.

### C. Calendar

- [ ] C1. Open Calendar and inspect month/day views. Dates and weekday labels are
  localized for the selected app language.
- [ ] C2. Create a real test event with a start/end time, reminder, and Account B as
  attendee. Confirm invalid end-before-start times are rejected.
- [ ] C3. Confirm the event appears in the calendar and for the attendee. Open a
  due task from the calendar and verify it navigates to that task.
- [ ] C4. Edit and delete the test event. Confirm the updated/deleted state after
  refresh.
- [ ] C5. Change the profile timezone, then verify event times display consistently
  before and after restarting the app.

### D. Chat

- [ ] D1. In a team workspace, open a group channel shared with Account B.
- [ ] D2. Send a message from Account A. Confirm it appears once on Account B
  without manually refreshing.
- [ ] D3. Reply from Account B and confirm it appears on Account A. Verify unread
  state clears when the conversation is opened.
- [ ] D4. Send an `@mention` to the other test account and verify the mentioned
  account receives an in-app notification.
- [ ] D5. If attachments are enabled, send an image and a file. Verify progress,
  message display, preview/open, and failure/retry behavior where applicable.
- [ ] D6. Mute the test channel on Account B, send a new message from Account A,
  and confirm the muted account does not receive that chat notification.
- [ ] D7. In a direct conversation, send a message each way and verify only the
  other participant is notified.
- [ ] D8. In Personal workspace, confirm team chat is unavailable with a clear
  explanation.
- [ ] D9. Disconnect Account B, send a message from Account A, reconnect B, and
  check that history catches up without duplicate messages.

### E. Notifications and Android push

- [ ] E1. Open Notifications. Check All, Unread, Tasks, and Mentions; counts and
  rows correspond to real test actions.
- [ ] E2. Mark one notification read, mark it unread again, use Mark all as read,
  and dismiss one. Confirm the list and unread count update.
- [ ] E3. Tap task, chat, and event notifications where available. Confirm each
  opens the correct destination.
- [ ] E4. With the updated Android app installed and permission allowed, receive a
  task-assignment notification for Account B. Test once with the app foregrounded
  and once with it backgrounded/closed.
- [ ] E5. Tap the push notification and confirm it opens the relevant task.
- [ ] E6. Change the notification preference switches. Confirm disabled categories
  are not shown as local notifications and enabled categories still are.
- [ ] E7. Record delivery delay. Scheduled push processing can take up to about
  five minutes; distinguish a delay from a missing in-app notification.

**Expected current scope:** task assignment notifications target the assignee;
chat notifications target other unmuted channel members; mentions notify the
mentioned member. Creating a generic unassigned task or a document does not
currently notify every workspace member. The current notification text may not
identify the person who created/sent the item. Record these as known product gaps,
not as failed tests of an implemented behavior.

### F. Documents, search, and analytics

- [ ] F1. Open Documents. Browse folders and recent documents. Confirm only real
  workspace documents are shown.
- [ ] F2. Create or edit a written document, leave the screen, and reopen it.
  Confirm saved content persists.
- [ ] F3. Upload a small test file if the control is available. Confirm it appears
  and can be opened/downloaded. Do not use sensitive files.
- [ ] F4. Search for a known task title, document title, and workspace member.
  Check result category counts and tap each result.
- [ ] F5. With a previously loaded task/document available, search while offline.
  Confirm the offline notice appears and cached task/document results are shown.
  Offline people search is not currently supported.
- [ ] F6. Open Analytics and switch 7/30/90-day ranges. Compare visible values
  against real test activity where possible.
- [ ] F7. Export CSV and confirm the saved/shared file opens and contains the
  selected range without unrelated workspace data.
- [ ] F8. Disconnect and reopen Analytics after data was loaded. Confirm cached
  results and last-updated time are shown when available.

### G. Profile, settings, and sync

- [ ] G1. Change theme between Light, Dark, and System. Confirm it applies and
  persists after restart.
- [ ] G2. Change language among English, Spanish, French, Chinese, and Korean.
  Check navigation, buttons, empty states, and notification labels for missing or
  untranslated strings.
- [ ] G3. Change the profile name and timezone, save, restart, and verify persisted
  values.
- [ ] G4. Check notification preferences and Security settings. Verify password
  change and global sign-out only with test accounts and known test credentials.
- [ ] G5. Open Sync Status. Check connection state and pending/failed items. Retry
  a queued item after reconnecting and verify it resolves.
- [ ] G6. Sign out. Confirm private workspace data is no longer visible to the
  signed-out session.

## Windows desktop checklist

Run the applicable cases above on Windows as well as these desktop-specific cases.

- [ ] W1. Launch, sign in, and navigate using the sidebar. Confirm Home, Tasks,
  Calendar, Chat, Documents, Analytics, Team, and Settings open at desktop width.
- [ ] W2. Resize the window across wide desktop, narrow desktop, and tablet-like
  widths. Check layout transitions, panels, tables, dialogs, and horizontal
  overflow.
- [ ] W3. Press Ctrl+K to open Search and Escape to close it. Confirm keyboard
  focus and navigation work.
- [ ] W4. Use task table sorting, filters, selection, bulk actions, and confirmation
  dialogs. Verify cancelled actions do not alter data.
- [ ] W5. Check Calendar month, week, and day views; create and edit an event with
  an attendee.
- [ ] W6. Use the chat split view, send and receive messages across the Android and
  Windows sessions, and verify unread/mention behavior.
- [ ] W7. Test document upload controls. Drag-and-drop and upload cancel/retry
  controls are known outstanding Windows items; record any missing or unusable
  control rather than assuming the feature passed.
- [ ] W8. Export Analytics CSV using the Windows save dialog and open the result.
- [ ] W9. With Windows PlanPal running and online, receive a Realtime notification
  and confirm a local Windows notification appears. Windows does not use Android
  FCM push and does not receive push while the app is closed.
- [ ] W10. Check Team Directory filters, member profiles, role restrictions, and
  Latest Updates with real workspace activity.
- [ ] W11. Check theme, language, profile, timezone, notification preferences,
  Security actions, and Sync Status; restart and confirm persisted settings.
- [ ] W12. Disconnect and reconnect the network. Check connectivity state, cached
  data, queued writes, and recovery without duplicate records.

## Cross-account privacy and permissions

Perform using only test accounts/workspaces and non-sensitive data.

- [ ] P1. Account A cannot see Account B's Personal workspace tasks, documents,
  notifications, or private chats.
- [ ] P2. A team member sees only channels and records available to that member.
- [ ] P3. A guest cannot perform admin-only actions (invite/manage members, delete
  another member's records, or access guest-restricted features).
- [ ] P4. A non-admin cannot change another member's role or remove them.
- [ ] P5. Sign out and sign in as the second account; verify local account data and
  unread notifications do not leak between users.

## Result summary

| Platform | Passed | Failed | Not tested | Blocking issues |
|---|---:|---:|---:|---|
| Android phone |  |  |  |  |
| Windows desktop |  |  |  |  |
| Cross-account |  |  |  |  |

## Known limitations to track separately

- Generic newly created tasks do not notify all workspace members; assignment
  notifications target the assignee.
- Document/file creation does not currently notify workspace members.
- Chat notification text does not reliably identify the sender.
- Offline search currently covers tasks and document titles, not people.
- Windows document drag-and-drop and upload cancel/retry controls remain
  outstanding.
- Manual notification delivery and real multi-device testing are not considered
  passed until performed on installed builds.
