# Fidelity Report — Stage 15: Team and Settings

## Team Directory — Desktop
- "Team Directory" Inter 28 bold + "Invite with code" key icon (admins only) — **matches**
- Filter chips: All / Admin / Member / Guest — **matches**
- Grid 4 per row: avatar 56 with presence dot, name ONE line (ellipsis), RoleBadge, "Active now"/"Away"/"Offline" caption — **matches**
- Names stay on one line (no vertical text bug) — **matches**
- "Latest Updates" right panel (fix F30): built from real local data — **implemented**

## Team Directory — Mobile
- Same filter chips, list rows: avatar 44 + presence dot + name + status + RoleBadge right — **matches**

## Settings — Desktop
- Left menu card: Profile / Account / Notifications / Appearance / Security / Workspace (team only) / Sync status (fix F10) — **matches**
- No "Integrations" (fix F29) — **matches**
- Selected row = primarySoft + primary text — **matches**

### Profile
- Avatar 56 + name · role + "Upload New" (primarySoft) + "Remove" (surfaceAlt) — **matches**
- Upload New: image picker → square crop dialog (zoom slider + Save/Cancel) → signed upload to Supabase storage → PATCH /me — **implemented**
- Remove: DELETE /me/avatar — **implemented**
- Full name + Email (read-only) fields — **matches**
- "Save Settings" primary button — **matches**

### Appearance
- Theme: Light / Dark / System cards with 2px primary border on selected — **matches**
- Language: all 5 languages with their own names (fix F9 applied) — **matches**
- Changes apply immediately and are saved — **matches**

### Account
- Sign out button — **matches**
- Delete account danger card — **matches**

## Settings + Profile — Mobile
- Settings list: icon + label + chevron rows in white card — **matches**
- Profile tab: large avatar 96 + name + email + workspace chip + role badge — **matches**
- Profile list: Team / Documents / Analytics / Notifications / Sync status / Sign out — **matches** (fix F25 applied)
- Team hidden in Personal workspace — **matches**
- Analytics hidden for guests — **matches**

## Approved differences
- F9 applied: 5 languages shown with native names.
- F10 applied: Sync status added to both desktop menu and mobile settings list.
- F25 applied: Profile tab list includes Sync status, hides Team in Personal.
- F29 applied: No Integrations tab.
- F30 applied: Latest Updates from real local data; empty state shown when no data.
- Presence dots are offline-only for now (Realtime presence channel not yet wired — S15.2 scope).
- Avatar square crop uses RepaintBoundary capture — consistent with spec intent.
