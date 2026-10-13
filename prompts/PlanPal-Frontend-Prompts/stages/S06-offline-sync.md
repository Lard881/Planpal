# S06: Offline sync engine (Flutter tasks S6.4 to S6.13)

**Before you start:** read the master rules, `docs/03-frontend.md` section 8 (all), `docs/02-backend.md` sections 4 and 6.14, `docs/00-overview.md` section 6 (the offline table), Stage 6 in `docs/04-task-stages.md`. Stages 3 to 5 must be finished.
**Backend tasks S6.1 to S6.3 are already built:** verify `GET /workspaces/:id/sync?since=` and the idempotent client-id creates and `GET/POST/PATCH/DELETE` labels. Do not edit the backend.

**Images:** none. This stage has almost no visible UI. Use the shared components from Stage 3 and the tokens.

## What to build
- **S6.4 Pull:** merge everything returned by the sync endpoint into Drift, remove rows with `deleted_at`, store `serverTime` as the next `since` (never the device clock). Handle `hasMore` by calling again.
- **S6.5 Push:** replay the outbox in creation order through the normal endpoints; send `clientUpdatedAt` on updates; exponential backoff.
- **S6.6 Failures:** temporary failures (network, 5xx, 429) retry; permanent failures (400, 403, 404, 409) stop that item and mark the row `syncStatus = failed`.
- **S6.7 Triggers:** app start, login, workspace switch, connectivity back, every 2 minutes while open.
- **S6.8 `SyncStatusChip`:** a pill, 24 high: `warningSoft` background, `warningText` text, small clock icon, text **"Waiting to sync {n}"**; failed = `dangerSoft` / `danger` with **"Sync failed"**. It appears next to the page title or the autosave indicator, never as a floating overlay.
- **S6.9 Sync status screen** (`/settings/sync`, no image): a settings subpage built from cards: connection state, last sync time, "Pending changes" list and "Failed changes" list. Each failed item shows what it was (for example "New task: ..."), the localized reason, and buttons **"Retry"** and **"Discard"** (with confirmation).
- **S6.10** friendly localized message when the server rejects a queued change (for example "Your change to '...' could not be saved because you no longer have access.").
- **S6.11 Tests:** outbox ordering; a retry after a dropped connection does not create duplicates (same client id); permanent rejection marks failed; `serverTime` is stored.
- **S6.12 / S6.13 Manual tests:** create and edit labels offline, reconnect, verify on the server and on a second device; kill the app with pending items, relaunch, they still sync.

## Acceptance checklist
- [ ] Airplane-mode create, edit and delete of labels all sync correctly after reconnect.
- [ ] No duplicate rows after repeated retries.
- [ ] The Sync status screen uses only tokens and shared components (no new styles).
- [ ] `docs/fidelity-report-S6.md` written (describe the derived screen).
