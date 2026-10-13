# S12: Global search (Flutter tasks S12.3 to S12.9)

**Before you start:** read the master rules, tokens, fixes (F7, F17), `docs/03-frontend.md` section 10.12, `docs/02-backend.md` section 6.11, **`BACKEND-KNOWN-ISSUES.md`**, Stage 12 in `docs/04-task-stages.md`. Stages 3 to 11 finished.
**Backend:** `GET /search` has a **known issue** (wrong function parameter and result field names). Build against the response shape documented in `BACKEND-KNOWN-ISSUES.md` (`results[].kind|id|workspace_id|title|subtitle|score|at`, `counts`), and test end to end after the owner applies the patch.

**Open these images first:** `design/desktop/DesktopSearchresults.png`; `design/mobile/MobileSearchresults.png`.

## Layout specs
- **Search field (top bar, desktop):** the same 448 wide field; **Ctrl+K** focuses it from anywhere; Enter opens `/search?q=`. Minimum query length **2** (backend rule); debounce 300 ms.
- **Results page, desktop:** the top field shows the query. At the far right a **switch with the label "This workspace / All my workspaces"** (fix F17; off = `workspaceId` of the current workspace, on = omit `workspaceId`). Title **"Results for "launch""** (Inter 28 bold). Chips: **"All Results · 14"**, **"Tasks · 6"**, **"Documents · 5"**, **"People · 3"** (counts from `counts`; selected = filled `primary`). Groups with small uppercase muted headers **TASKS**, **DOCUMENTS**, **PEOPLE**; each result is a white card (radius 20, about 56 high):
  - Task: circle checkbox, title 14 semibold, **"Due Oct 14"** caption, `PriorityChip`, and a green bold match **"98%"** at the far right.
  - Document: file-text icon on a `primarySoft` tile, name, **"Edited 2h ago"**, match **"96%"**.
  - Person: avatar, name, email caption, `RoleBadge`.
- **Mobile (no bottom bar):** a normal search field at the top (fix F7) showing the query, chips **"All · 14"**, **"Tasks · 6"**, **"Docs · 5"**, **"People · 3"**, then the same groups (task cards show the priority chip; document cards show the match %; people cards show avatar, name and email).
- **Match %:** `score` is a ranking number, not a percentage. Display `round(100 * score / maxScoreOfTheCurrentResults)` clamped to 1..100 and say so in the fidelity report. Ask the owner if they prefer to hide it.
- Tap a result: open the task, document or person (people open the member profile sheet from Stage 15; until then open the Team page).
- Offline (S12.7): search the local Drift data (tasks, people, document titles) and show the note **"Offline: showing results from this device"**.
- Empty and error states: "No results for "{query}"", the standard `ErrorState`.

## Flutter tasks
S12.3 top-bar field + Ctrl+K + mobile search entry (the Home header search icon / quick access) . S12.4 results page with chips and counts . S12.5 grouped results and navigation . S12.6 scope switch . S12.7 offline local search . S12.8 debounce, empty, error states . S12.9 manual test with realistic data across two workspaces.

## Acceptance checklist
- [ ] Two images match at both sizes.
- [ ] Results respect permissions (a guest or non-member never sees other workspaces' data).
- [ ] Scope switch changes results; offline note appears offline.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S12.md` written.
