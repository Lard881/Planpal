# S13: Analytics (Flutter tasks S13.5 to S13.10)

**Before you start:** read the master rules, tokens, fixes (**F23, F24, F28**), `docs/03-frontend.md` section 10.9, `docs/02-backend.md` section 6.12, **`BACKEND-KNOWN-ISSUES.md`**, Stage 13 in `docs/04-task-stages.md`. Stages 3 to 12 finished.
**Backend:** the analytics endpoints have a **known issue** (they call SQL functions that do not exist and hide the error). Build against the documented response shape in `BACKEND-KNOWN-ISSUES.md` and test end to end after the owner applies the patch. Guests get `403`.

**Open these images first:** `design/desktop/DesktopAnalytics.png`; `design/mobile/MobileAnalytics.png`.

## Layout specs
- **Desktop** (`/analytics`, inside the shell with the top bar): title **"Analytics"** (Inter 28 bold) at the left; at the right a white dropdown **"Last 30 days"** (options Last 7 days / Last 30 days / Last 90 days -> `range=7d|30d|90d`) and a primary **"Export CSV"** button with a download icon (40 high).
- **Four stat cards** in a row (white, radius 20, about 156 high): a 36 icon tile (radius 12) top-left, the big number (Inter 28 bold), the label (14), and a colored sub-line (12; see F23):
  1. icon check-circle on `successSoft` · **"128"** · "Tasks Completed" · sub-line `changeVsPrevious`
  2. icon timer on `primarySoft` · **"1.8 days"** (`avg_completion_days`) · "Avg. Completion Time"
  3. icon zap on `violetSoft` · **"86%"** (`on_time_rate`, F24) · "Team Velocity"
  4. icon flame on a soft amber · **"9 days"** (`streak`) · "Productive Streak"
- **Weekly Task Output** card (white, radius 24, about 60% width): title (Inter 20 semibold), bar chart Mon to Sun from `weekly[]` (`weekday` 1 = Mon .. 7 = Sun, `completed`), bars with large rounded tops; all bars `primary` at about 20% opacity (`#DDD9FA`-like, take it from the image) **except the tallest bar in solid `primary`**; weekday labels under the bars; tooltip with the value on hover/tap. Use `fl_chart`.
- **Category Mix** card (white, radius 24): title, then a **donut** with the **total in the center** ("96" + "tasks") from `categories[]` (`label`, `color`, `total`); under it a legend: dot + name + right-aligned percentage. Show the 3 largest labels plus **"Other"** (grey, everything else and "No label"). **The donut must have its own space and never overlap the card title** (docs bug fix).
- **Mobile** (no bottom bar): title **"Analytics"** (Inter 24 bold) with a download icon button at the right (Export CSV); a white **"Last 30 days"** dropdown under the title; **2x2 stat cards** with shorter labels (**Completed, Avg. Time, Velocity, Streak**); card **"Weekly Task Output"** with bars and only **Mon** and **Sun** labels; card **"Category Mix"** with the donut and the legend.
- **Offline (S13.8):** show the last cached numbers and a caption **"Last updated {time}"**; Export CSV is disabled offline with an explanation.
- **Guests (S13.9):** the localized permission screen ("You don't have access to this page"). Empty state when there is no data: "Complete some tasks to see your statistics".
- **Export CSV (S13.7):** `GET /workspaces/:id/analytics/export.csv?range=`; Windows: save to disk with a file picker; Android: share sheet.

## Flutter tasks
S13.5 screen with four stat cards and the range selector . S13.6 bar chart and donut (no overlap) . S13.7 Export CSV . S13.8 offline cache and "Last updated" . S13.9 guest message and empty state . S13.10 manual test: the numbers equal what the Tasks list shows for the same range (completed count, overdue, streak).

## Acceptance checklist
- [ ] Two images match at both sizes (except F23, F24, F28).
- [ ] Switching the range reloads all cards and charts.
- [ ] Donut and title never overlap at widths 375, 700, 1280.
- [ ] Light/Dark verified (chart colors from tokens). `docs/fidelity-report-S13.md` written.
