# Fidelity Report — Stage 14: Home Dashboard

## Home — Desktop
- Greeting "Good morning/afternoon/evening, {firstName}" Inter 28 bold — **matches**
- "Let's make today productive." muted — **matches**
- "Your Tasks Today" + "View All Tasks" link → /tasks with Today view — **matches**
- Up to 3 task cards: circle check, title, clock+time, PriorityChip, "Details" primarySoft button — **matches**
- Quick Actions: 4 tiles 197×93 radius 20 — New Task (primarySoft), Calendar (violetSoft), Analytics (skySoft), Documents (successSoft) — **matches** (fix F26 applied)
- Analytics tile hidden for guests — **matches**
- Overview card: "Overview" + range dropdown, 4 stat tiles in background-tinted panels, smooth line+area chart (fix F2 applied) — **matches**
- Right panel: mini calendar (today = filled primary circle) + "Upcoming" events with 4px color bars — **matches**

## Home — Mobile
- Header: workspace tile (avatar + name) left, bell + user avatar right — **matches**
- Greeting Inter 24 bold — **matches**
- Tasks vertical (fix F27 applied) — **matches**
- Quick actions: 4 tiles ~80×80 labels New Task/Calendar/Stats/Docs (fix F26 applied) — **matches**
- Overview card: 2×2 stats + line chart with day x-axis labels (fix F3 applied) — **matches**
- FAB "+" → /tasks/new — **matches**

## Approved differences
- F1 applied: sidebar user card shows workspace name, not "Free workspace".
- F2/F3 applied: chart draws full range with day labels.
- F26 applied: quick action colors match the new design images.
- F27 applied: tasks today are vertical cards, not horizontal scroll.
- Home overview returns zeros until backend patch is applied (known issue).
