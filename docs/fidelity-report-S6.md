# Fidelity Report — Stage 6: Offline Sync

## No design images for this stage.

## What was built (derived from tokens and shared components)

### SyncStatusChip
- 24px pill, warningSoft bg / warningText fg, clock icon, "Waiting to sync n" text — **matches spec**
- Failed state: dangerSoft / danger, alertCircle icon, "Sync failed" text — **matches spec**
- Appears next to page titles; hidden when no pending items — **matches spec**

### Sync Status Screen (`/settings/sync`)
- Connection card: green/red dot, "Online"/"Offline"/"Server unreachable" — **derived from tokens**
- Last synced time — **derived**
- Pending changes list with clock icon and entry label — **derived**
- Failed changes list with alertCircle icon, "Could not be saved" message, Discard button with confirmation — **derived**
- "Retry all" outline button — **derived**
- All cards white radius 20, consistent with design language — **matches**

## Engine behavior
- Pull: fetches delta sync, merges to Drift, stores serverTime as next since — **implemented**
- Push: replays outbox in creation order, exponential backoff via 2-minute timer — **implemented**
- Permanent failures (400/403/404/409) stop retrying, mark retryCount=5 — **implemented**
- Triggers: app start, workspace switch, connectivity restored, every 2 minutes — **implemented**
