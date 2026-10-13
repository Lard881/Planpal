# Fidelity Report — Stage 11: Notifications

## Notifications — Desktop
- "Notifications" Inter 28 bold + "Mark all as read" primary link — **matches**
- Filter chips: All / Unread / Tasks / Mentions — no counts (fix F16 applied) — **matches**
- White list card radius 20, rows ~56px, 1px dividers — **matches**
- Icon tile 36px radius 12, soft color by type: task_assigned=primarySoft, mention=violetSoft, comment=skySoft, deadline=dangerSoft, system=surfaceAlt — **matches**
- Unread rows: faint primarySoft tint + indigo dot right — **matches**
- "..." menu: Mark as read/unread + Delete — **matches**

## Notifications — Mobile
- "Notifications" 24 bold + "Mark all as read" — **matches**
- Same chips — **matches**
- Each notification = own white card radius 20 — **matches**

## Bell icon
- Red dot when unread count > 0 — **implemented**
- Realtime-driven via notificationsProvider — **implemented**

## Navigation on tap
- Marks read and opens: task → /tasks/:id, channel → /chat/:id, document → /documents/:id — **implemented**

## Approved differences
- F16 applied: no counts on filter chips, unread dot on rows and bell kept.
- FCM push (S11.9) not wired — needs google-services.json from owner.
- Windows local notifications (S11.10) — not implemented (S16 scope).
