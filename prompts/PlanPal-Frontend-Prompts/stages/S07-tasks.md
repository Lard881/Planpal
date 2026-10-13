# S07: Tasks (Flutter tasks S7.13 to S7.26)

**Before you start:** read the master rules, tokens, fixes, `docs/03-frontend.md` sections 10.3 to 10.5 and 8, `docs/02-backend.md` sections 6.3 to 6.5, and Stage 7 in `docs/04-task-stages.md`. Stages 3 to 6 finished.
**Backend tasks S7.1 to S7.12 are already built:** verify `GET/POST /workspaces/:id/tasks`, `GET/PATCH/DELETE /tasks/:id`, `POST /tasks/bulk`, subtasks, comments, attachments, labels. **`POST /tasks/:id/move` is affected by a known backend issue** (`BACKEND-KNOWN-ISSUES.md`): build the UI, and test it after the owner applies the patch.

**Open these images first:** `design/desktop/DesktopTasks.png`, `DesktopTaskdetail.png`, `DesktopNewtask.png`; `design/mobile/MobileTasks.png`, `MobileTaskdetail.png`, `MobileNewtask.png`.

**Allowed values (database):** priority `high | medium | low`; status `todo | in_progress | completed`. The API validation also lists `urgent` and `backlog`, but the database rejects them: **never send them**. "Overdue" is not stored: it is computed (`status != completed` and `due_at` in the past).

## Layout specs

### Tasks, desktop (`/tasks`)
- Header: title **"Tasks"** (Inter 28 bold), subtitle **"{n} tasks · {m} due today"** (muted), right-aligned primary **"+ Add Task"** (40 high). Under it a row of 4 filter dropdowns (white, 1 px border, radius 12, 40 high): **"Status: All"**, **"Priority: All"**, **"Assignee: All"**, **"Sort: Due date"** with a sort icon (options: Due date, Priority, Created, Title; toggles order).
- **Bulk bar** (white card, radius 20, 56 high, appears only when 1 or more rows are selected): a filled check circle + **"{n} tasks selected"**, and at the right two outline buttons **"Mark Complete"** (indigo text) and **"Delete Selected"** (red text). Delete asks for confirmation. Results use `POST /tasks/bulk`; show per-item failures from `failed[]`.
- **Table card** (white, radius 20): header row (13 muted): **Task Name | Assignee | Due Date | Priority | Status**. Rows are about 56 high with 1 px dividers: selection circle (22) + title 14 medium; assignee avatar 28 + name; due date like "Oct 14"; `PriorityChip`; `StatusChip`. **Selected rows** have a very light indigo background (about `#F4F3FF`). Overdue tasks show the Overdue status chip. Click a row to open its detail. Pagination: load more on scroll (cursor).
- Empty state when there are no tasks ("No tasks yet" + "Add Task"); another for "no results for these filters" with a "Clear filters" action.

### Tasks, mobile (`/tasks`)
- Title **"Tasks"** (24 bold) with a 40x40 filter icon button at the right (opens a bottom sheet with Status, Priority, Assignee, Sort; derived). Below: search field **"Search tasks..."** (`surfaceAlt`, radius 12). Chips row: **All, Today, This Week, Overdue** (selected = filled `primary` with white text; others `surfaceAlt`). These map to `view=all|today|week|overdue`.
- Task tiles (white, radius 20, border): left circle checkbox 24; title 14 semibold; second line 12 muted: **"Today · 9:30 AM"**, **"Tomorrow"**, **"Yesterday · Overdue"** (the word Overdue in `danger`), **"Done Oct 10"** for completed. Right: `PriorityChip`. Completed tiles: filled green check, strikethrough title, muted.
- **Swipe left** reveals **Edit** (primary) and **Delete** (danger) actions. Pull to refresh. Floating **"+"** button (56, `primary`) bottom-right above the bottom bar. A one-time dismissible hint explains the swipe.

### Task detail, desktop (`/tasks/:id`)
- Link **"<- Back to tasks"** (muted). Header card: `PriorityChip` and `StatusChip` (both tappable, open a menu to change), a "..." menu (Move to another workspace, Delete), the title (Inter 28 bold, **editable in place**), and a calendar icon with **"Due Oct 14 · 9:30 AM"** (tap to change).
- Two columns (left about 568, right about 372):
  - Left: **Description** card (title 16 semibold + editable text); **Subtasks** card: heading "Subtasks" + muted "2/5", a primary link **"Add subtask"** at the right, a 6 px progress bar, items with circle checkbox and text (done = strikethrough muted), and an inline filled field **"+ Add subtask..."**; **Attachments** card: heading, a primary link **"Attach File"** (paperclip), and file tiles (`surfaceAlt`, radius 12): type badge + name 14 semibold + "PDF · 2.4 MB" caption + download icon.
  - Right: card with **Assignee** (avatar + name + chevron dropdown of real workspace members) and **Label** (dropdown with colored dot + name, with "Create label" inside), and a muted line **"Move to another workspace · Delete"** (both are links); **Comments (n)** card: comment rows (avatar 32 + `surfaceAlt` bubble with the author name small and the text), then a composer **"Write a comment..."** with a primary send icon. Typing `@` opens a member picker (insert `@[Full Name](user:<uuid>)`).
- Autosave: edits save after 800 ms to Drift + outbox, with an indicator **"Saved"** / **"Waiting to sync"**.

### Task details, mobile
- Header: back button (36 white square), centered title **"Task details"**, "..." menu. Chips row, title (Inter 24 bold), muted **"Due Oct 14 · 9:30 AM"**. Stacked cards: **Description**; **Subtasks 2/5** with "Add", progress bar and items; **Attachments** (fix F19); **"Assignee & Label"** (avatar + name at the left, `LabelChip` at the right); **Comments** with a bubble and the composer. No bottom bar.

### New Task
- **Desktop dialog** (white, radius 24, about 480 wide, scrim): title **"New Task"** with an X. Fields: **Task Name** (placeholder "Plan team offsite"), **Description** (placeholder "Find a venue, set the date, share agenda..."), **Due Date** and **Time** side by side, **Priority** segmented control **High | Medium | Low** (default Medium), **Assignee** and **Label** side by side (dropdowns), two dashed-outline buttons **"+ Add Subtask"** and **"Attach File"**, and a full-width primary **"Create Task"**.
- **Mobile:** full-screen page: X at the top-left, centered title **"New Task"**, the same fields stacked (Due Date + Time side by side), **"+ Add Subtask"** dashed button, and **"Create Task"** pinned at the bottom.
- Offline: Attach File is disabled with the note "Attachments need an internet connection". The same form is reused for **editing** a task.

## Flutter tasks
S7.13 repository (Drift + outbox + sync, client-generated UUIDs) . S7.14 mobile list . S7.15 desktop table + bulk . S7.16 New Task . S7.17 detail with autosave . S7.18 subtasks (add, check, reorder, delete) . S7.19 comments + @mention picker . S7.20 attachments (open/download online only; clear offline message) . S7.21 assignee and label pickers from **real** members and labels . S7.22 move to another workspace (a dialog listing the user's workspaces with role badges; the assignee and label are cleared if missing there, say so) . S7.23 overdue display and empty/loading/error/offline states . S7.24 role rules (guests cannot create; members edit their own; admins everything, per the table) . S7.25 tests . S7.26 manual test with two accounts and offline create.

## Acceptance checklist
- [ ] Six images compared side by side at both sizes; selected-row tint, chip colors and spacing match.
- [ ] Creating, editing, completing and deleting work **offline** and sync after reconnect with no duplicates.
- [ ] Bulk bar reports partial failures clearly.
- [ ] Assignee list shows only members of the current workspace.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S7.md` written.
