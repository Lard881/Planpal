# S11: Notifications and push (Flutter tasks S11.6 to S11.14)

**Before you start:** read the master rules, tokens, fixes (F16), `docs/03-frontend.md` sections 10.11, 11, 15, `docs/02-backend.md` sections 6.10 and 6.15, Stage 11 in `docs/04-task-stages.md`. Stages 3 to 10 finished.
**Backend tasks S11.1 to S11.5 are already built:** verify `GET /notifications?filter=all|unread|tasks|mentions&cursor=`, `POST /notifications/:id/read`, `/unread`, `/read-all`, `DELETE /notifications/:id`, `POST /devices`, `DELETE /devices/:token`.

**Open these images first:** `design/desktop/DesktopNotifications.png`; `design/mobile/MobileNotifications.png`.

## Layout specs
- **Desktop** (`/notifications`, inside the shell with the top bar): title **"Notifications"** (Inter 28 bold) with a primary-colored link **"Mark all as read"** at the right. Chips **All, Unread, Tasks, Mentions** (selected = filled `primary`; others `surfaceAlt`; **no counts**, fix F16). A white list card (radius 20, about 704 wide) with rows about 56 high and 1 px dividers: a 36 icon tile (radius 12) with a soft color by type (task assigned = person-plus on `primarySoft`; mention = `@` on `violetSoft`; comment = message on `skySoft`; deadline = alarm on `dangerSoft`; system/info = info on `surfaceAlt`), a first line like **"Leo assigned you a task · 2 min ago"** (14, name emphasized) and a second line with the quoted detail in caption muted; **unread rows** have a faint tinted background and an indigo dot at the right; a "..." menu with **Mark as read/unread** and **Delete**.
- **Mobile** (no bottom bar): title **"Notifications"** (Inter 24 bold) with **"Mark all as read"** at the right; the same chips; each notification is its own white card (radius 20) with icon tile, title, time and an unread dot.
- Tap a row: mark read and open the target (task, event, channel, document) from `entity_type` / `entity_id`. Deep links from push use the notification `data`.
- The **bell** in the top bar and mobile header shows a red dot when unread exist (Realtime-driven).
- Empty state: "You're all caught up".

## Flutter tasks
S11.6 repository (Drift) + screen with tabs . S11.7 actions and navigation to the target . S11.8 live updates through Realtime inserts + unread dot . S11.9 **Android:** permission (Android 13+), FCM token registration and refresh (`POST /devices`, `DELETE /devices/:token` on logout), push tap handling. Ask the owner for `google-services.json`; do not invent it . S11.10 **Windows:** local notifications from Realtime while the app runs (`flutter_local_notifications`); no FCM on Windows . S11.11 **localized** notification text built from `type` and the entity (the server text is only a fallback) . S11.12 respect the Settings switches (Stage 15) . S11.13 empty/loading/error states . S11.14 manual test: assign a task from another account and receive a push with the app closed.

## Acceptance checklist
- [ ] Two images match at both sizes.
- [ ] Each of the five types has its own icon and localized text.
- [ ] A push opens the right screen; mark read/unread/all/delete work and persist.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S11.md` written.
