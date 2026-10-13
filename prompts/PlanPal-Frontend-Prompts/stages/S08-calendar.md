# S08: Calendar (Flutter tasks S8.5 to S8.12)

**Before you start:** read the master rules, tokens, fixes (especially F4), `docs/03-frontend.md` section 10.6, `docs/02-backend.md` section 6.6, Stage 8 in `docs/04-task-stages.md`. Stages 3 to 7 finished.
**Backend tasks S8.1 to S8.4 are already built:** verify `GET /workspaces/:id/events?from=&to=` (max span 62 days, returns `dueTasks[]`), `POST /workspaces/:id/events`, `PATCH/DELETE /events/:id`.

**Open these images first:** `design/desktop/DesktopCalendar.png`, `DesktopScheduleevent.png`; `design/mobile/MobileCalendar.png`, `MobileScheduleevent.png`.

## Layout specs

### Calendar, desktop (`/calendar`)
- Header row: month and year **"October 2026"** (Inter 28 bold, localized) with two round 36 buttons (white, border) for previous and next month; at the right a segmented control **Week | Month | Day** (track `surfaceAlt`, radius 12; selected white).
- **Month grid card** (white, radius 24): weekday header **Mon, Tue, Wed, Thu, Fri, Sat, Sun** (13 muted; **week starts on Monday**, localized names). 5 or 6 rows of cells, each cell about 72 high, white, 1 px border, radius 12, 8 gap. The day number sits at the top-left (14). Events appear as pills inside the cell (20 high, fully rounded, soft color background + strong color text, 12 text), at most 2, then a grey **"+N more"** pill. Days from the neighbouring months are drawn the same as in the image.
- **Today** and **selected** (fix F4): today = number in `primary` bold; selected day = `primarySoft` fill + 1 px `primary` border. Default selected day = today.
- Tasks with a due date appear in the grid with a different marker (a tiny check-square icon before the title) and open the task on click.
- **Right panel** (about 288 wide, white card): heading **"Events: Oct 12"** (matches the selected day), event rows with a 4 px colored left bar, title 14 semibold, and **"11:00 AM · Leo, Priya"** (time + attendee first names or "Team"); at the bottom a full-width primary **"+ Schedule Event"**.
- **Week** and **Day** views have no image: a time grid (7 or 1 columns, hour rows, current-time line, events as soft-colored blocks, all-day row on top), same card style and tokens.

### Calendar, mobile (`/calendar`, no bottom bar)
- Header: month name **"October"** (Inter 24 bold) and a small `primarySoft` **"Today"** chip at the right. Below: segmented **Month | Day**. Then a white card (radius 24) with a compact month grid: weekday letters **M T W T F S S**, day cells as round 40 targets; **today = filled `primary` circle with white number**; days that have events show the number in `primary` bold; tapping selects a day.
- Section **"Today's Schedule"** (Inter 20 semibold; for another day: "Schedule · Oct 14") with white cards (radius 20): colored soft icon tile (40, radius 12; video / coffee / users icon by event type or color) + title 14 semibold + **"11:00 AM · Acme room"** caption. **The list sits below the grid, never overlapping it.** Include tasks due that day.
- A "+" action opens Schedule Event.

### Schedule Event
- **Desktop dialog** (about 480 wide, radius 24): title **"Schedule Event"**, fields **Title**, **Description**, **Starts** and **Ends** side by side (date-time fields, e.g. "Oct 14 · 11:00 AM"), an **All-day** switch at the left and the **6 color dots** at the right (selected dot has a ring), **Attendees** (field showing "Leo, Priya +2"; opens a member picker with avatars; members of this workspace only), **Reminder** (dropdown: None, 5, 15 (default), 30, 60 minutes before), full-width primary **"Save Event"**.
- **Mobile:** page with back button + centered title, same fields stacked, **"Save Event"** pinned at the bottom.
- Edit and delete an event from an **Event detail** view (no image: a small dialog or page with title, time, color, attendees, reminder, **Edit** and **Delete** with confirmation).

## Flutter tasks
S8.5 repository (Drift, outbox, sync) . S8.6 desktop month, week, day, right panel . S8.7 mobile month/day + schedule list . S8.8 Schedule Event dialog/page . S8.9 due tasks on the calendar . S8.10 **timezone-correct** display using the profile timezone . S8.11 empty/loading/error/offline + localized names . S8.12 tests and a manual check with a real event with two attendees.

## Acceptance checklist
- [ ] Four images match at both sizes (except F4).
- [ ] Month grid starts on Monday and is correct for months of 4, 5 and 6 rows.
- [ ] Events created offline appear immediately and sync later.
- [ ] Times display in the user's timezone and in the chosen locale.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S8.md` written.
