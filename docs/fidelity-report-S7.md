# Fidelity Report — Stage 7: Tasks

## Tasks List — Mobile
- "Tasks" 24 bold + filter icon button — **matches**
- Search field surfaceAlt — **matches**
- Filter chips: All/Today/This Week/Overdue — selected = filled primary — **matches**
- Task tiles: white radius 20 border, circle checkbox + title semibold + date/time muted + PriorityChip right — **matches**
- Completed: filled green check + strikethrough + "Done Oct 10" — **matches**
- Overdue: "Yesterday · Overdue" in danger color — **matches**
- FAB "+" primary bottom-right — **matches**

## Tasks Table — Desktop
- "Tasks" Inter 28 bold + "n tasks · m due today" muted — **matches**
- "+ Add Task" primary toolbar button — **matches**
- 4 filter dropdowns (Status, Priority, Assignee, Sort) — **matches**
- Bulk bar: white card 56px, check circle + "n tasks selected" + "Mark Complete" + "Delete Selected" — **matches**
- Table: header row 13px muted, rows 56px with 1px dividers — **matches**
- Columns: Task Name / Assignee (avatar + name) / Due Date / Priority / Status — **matches**
- Selected rows: #F4F3FF tint — **matches**

## New Task
- Mobile: X button + "New Task" centered, all fields, Priority segmented (High/Med/Low), "Create Task" pinned — **matches**
- Desktop: dialog 480px, same fields — **matches**
- Due Date + Time side by side — **matches**
- Dashed "+ Add Subtask" button — **matches**

## Task Detail — Mobile
- Back button + "Task details" + "..." menu — **matches**
- PriorityChip + StatusChip — **matches**
- Title Inter 24 bold + due date muted — **matches**
- Description card / Subtasks card (progress bar, circle checkboxes, strikethrough) — **matches**
- Attachments card (fix F19 applied) — **matches**
- Assignee & Label card — **matches**
- Comments card + composer — **matches**

## Approved differences
- Overdue display computed client-side from status + due_at — **correct per spec**
- priority values: high/medium/low only (urgent/backlog never sent) — **correct per spec**
