# S14: Home dashboard (Flutter tasks S14.1 to S14.9)

**Before you start:** read the master rules, tokens, fixes (**F1, F2, F3, F26, F27**), `docs/03-frontend.md` section 10.2, `docs/02-backend.md` sections 6.4, 6.6, 6.12, **`BACKEND-KNOWN-ISSUES.md`**, Stage 14 in `docs/04-task-stages.md`. Stages 3 to 13 finished. Tasks, events and workspace data already exist from earlier stages.
**Backend:** `GET /workspaces/:id/overview` has a **known issue** (it calls missing SQL functions). Build against the documented shape (`counts`, `productivityPercent`, `dailySeries`) and test after the owner applies the patch. Everything else on this page uses local Drift data.

**Open these images first:** `design/desktop/DesktopHome.png`; `design/mobile/MobileHome.png`.

## Layout specs

### Desktop (`/home`, 1440x900, content area x=240..1440)
- **Left/main column** (starts at x=272, ends about x=1095):
  - Greeting **"Good morning, Maya"** with the real first name (Inter 28 bold; Good morning / Good afternoon / Good evening by local time) and the muted line **"Let's make today productive."** (S14.1).
  - **"Your Tasks Today"** (Inter 20 semibold) with the primary link **"View All Tasks"** at the right (-> `/tasks` with the Today view). Up to **3 task cards** stacked (white, radius 20, about 64 high): circle check button (completes the task), title 14 medium, clock icon + time (12 muted), at the right a `PriorityChip` and a `primarySoft` **"Details"** button (-> task detail). Tasks due today and assigned to the user in the current workspace (S14.2).
  - **Quick Actions:** four tiles in a row (about 197 x 93, radius 20, gap 16): **New Task** (bg `primarySoft`, icon tile solid `primary` with a white "+"), **Calendar** (bg `violetSoft`, icon tile `violet`), **Analytics** (bg `skySoft`, icon tile `sky`), **Documents** (bg `successSoft`, icon tile `success`). Each icon tile 40, radius 12; label 14 medium at the bottom-left (S14.3, F26). Hide Analytics for guests.
  - **Overview** card (white, radius 24): title "Overview" (Inter 20 semibold) and a `surfaceAlt` dropdown **"Last 7 days"** at the right (options This Week, Last 7 days, Last 30 days -> `range=week|7d|30d`). Four stat tiles in a row (`background`-tinted, 1 px border, radius 16): **"24 / Tasks Completed"**, **"8 / In Progress"**, **"3 / Overdue"**, **"86% / Productivity"** from `counts` and `productivityPercent` (S14.4). Below, the **smooth line + soft area chart** (`fl_chart`, `primary` line about 2.5 px, area fading to transparent) from `dailySeries`, with a y-axis (0, 25, 50, 75, 100) and day labels on the x-axis. **Draw the full range** (fix F2).
- **Right panel** (about 288 wide, x=1121..1407), two white cards (radius 24):
  1. **Mini month calendar:** "October 2026" at the left, prev/next chevrons at the right, weekday letters **M T W T F S S**, day numbers; **today = filled `primary` circle with white number**. Tapping a day opens the Calendar on that day (S14.6).
  2. **"Upcoming":** the next events (real events from Drift) as rows with a 4 px colored left bar, title 14 semibold and time 12 muted ("11:00 AM"). Empty state "Nothing coming up".
- Top bar as in the shell (search, bell with red dot, user chip with the real role).

### Mobile (`/home`, bottom bar visible)
- Header row: left a tappable workspace tile (initial avatar 32 + workspace name 14 semibold; opens the switcher), right a bell (red dot when unread) and the user avatar (32).
- Greeting **"Good morning, Maya"** (Inter 24 bold) + "Let's make today productive.".
- **"Your Tasks Today"** with **"View All"** at the right: **vertical** cards (white, radius 20): check circle, title, time, priority chip (F27).
- **Quick actions:** a row of four small tiles (about 80 x 80, radius 20, the same soft colors as desktop) labeled **New Task, Calendar, Stats, Docs**; copy their exact size and spacing from the image.
- **Overview** card: title and a small **"7 days"** chip, 2x2 stat tiles (Completed, In Progress, Overdue, Productivity), then the line chart with **day labels** on the x-axis (F3).
- Floating **"+"** button (56) bottom-right above the bar -> New Task.

### States (S14.8)
Each block has its own loading skeleton, empty state ("Nothing due today"), error state and offline state; one failing block never breaks the others.

## Flutter tasks
S14.1 greeting . S14.2 Tasks Today (+ complete action, offline-capable) . S14.3 Quick Actions navigation . S14.4 Overview tiles + range dropdown . S14.5 smooth line/area chart (fixes the broken design) . S14.6 right panel (mini calendar + Upcoming) . S14.7 mobile header, floating add button . S14.8 states . S14.9 responsive check at widths 375, 700 and 1280 (tablet: right panel moves below the main column).

## Acceptance checklist
- [ ] Two images match at both sizes (except F1, F2, F3).
- [ ] Greeting changes with time of day and uses the real name.
- [ ] Completing a task from Home updates the Tasks list immediately, including offline.
- [ ] The chart spans the whole range with real data; changing the range reloads tiles and chart.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S14.md` written.
