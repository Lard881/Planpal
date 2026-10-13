# S15: Team and Settings (Flutter tasks S15.1 to S15.15)

**Before you start:** read the master rules, tokens, fixes (**F9, F10, F25, F29, F30**), `docs/03-frontend.md` sections 10.10, 10.13, 11, 13, `docs/02-backend.md` sections 6.1, 6.2, 6.16, 7, Stage 15 in `docs/04-task-stages.md`. Stages 3 to 14 finished.
**Backend (already built, verify):** `GET/PATCH /me`, `POST /me/avatar-upload-url`, `DELETE /me/avatar`, `DELETE /me` (needs password; `TRANSFER_ADMIN_FIRST` rule), members and invites endpoints (Stage 5).

**Open these images first:** `design/desktop/DesktopTeam.png`, `DesktopSettingsProfile.png`, `DesktopSettingsAppearance.png`; `design/mobile/MobileTeam.png`, `MobileProfile.png`, `MobileSettings.png`. (The admin Members and Invite codes pages were built in Stage 5; link to them from here.)

## Layout specs

### Team Directory, desktop (`/team`, team workspaces only; hidden in Personal)
- Title **"Team Directory"** (Inter 28 bold); at the right a primary **"Invite with code"** button with a key icon (admins only; opens the invite-codes page/dialog from Stage 5).
- Filter chips **All, Admin, Member, Guest** (selected = filled `primary`; others `surfaceAlt`).
- **Grid of member cards** (4 per row at 1440, responsive; white, radius 20, about 160 high, centered content): avatar **56** with a **presence dot** (12, white ring) at the bottom-right, the **full name on ONE line** (14 semibold, ellipsis if long), a `RoleBadge` pill, and a status line (12 muted): **Active now**, **Away**, **Offline**. Dots: online `success`, away `warning`, offline `presenceOffline`. No vertical text, no stretched cards (the old design had this bug).
- **Right panel "Latest Updates"** (about 288 wide, white, radius 24): rows with a 8 px colored dot, a text line ("Leo finished "Hero v3"") and a time line ("10 min ago"). Built from real local rows (F30), localized text templates.
- Tap a card -> **member profile sheet** (side panel on desktop, bottom sheet on mobile; no image): large avatar, name, email, role badge, presence; **"Message"** button (opens/creates a DM via `POST /workspaces/:id/dms`, see the known issue) and, for admins, a role dropdown and a red outline **"Remove from workspace"** with confirmation.
- **Presence** (S15.2): Supabase Realtime Presence on the workspace channel; away after 5 minutes of inactivity.

### Team Directory, mobile (`/team`, bottom bar visible with **Profile** highlighted)
- Title **"Team Directory"** (Inter 24 bold), the same filter chips, and a **list** of rows (white, radius 20): avatar 44 with presence dot, name 14 semibold, status caption ("Active now", "Away", "Offline"), the `RoleBadge` at the right.

### Settings, desktop (`/settings/:section`, sidebar highlight = Settings)
- A left **menu card** (white, radius 20, about 200 wide) with icon + label rows: **Profile, Account, Notifications, Appearance, Security, Workspace** and, at the end, **Sync status** (F10). Selected row = `primarySoft` with `primary` text. Hide **Workspace** in Personal. No Integrations (F29).
- A right **content card** (white, radius 24, about 620 wide).
  - **Profile:** title "Profile" (Inter 24 bold). Row: avatar 56 + **"Maya Chen · Admin"** (real name and role) + two small pills **"Upload New"** (`primarySoft`, `primary` text) and **"Remove"** (`surfaceAlt`). Two columns of filled fields: **Full name | Email** (read-only), **Timezone | Language** (dropdowns; timezone default from the device, shown like "GMT+1 · Berlin"). Primary **"Save Settings"**. Avatar upload: images up to 5 MB, **square crop dialog** (derived: zoom slider, Save, Cancel), request `POST /me/avatar-upload-url` with `{ mimeType }` (jpeg, png, gif or webp), upload the file to the returned `uploadUrl` (signed upload, `token` returned too), then save the returned `path` with `PATCH /me` as `{ avatarUrl: <path> }` (the field stores the storage path; show the image through a signed download URL). "Remove" calls `DELETE /me/avatar`.
  - **Appearance:** title "Appearance". Label **"Theme"**, three selectable cards **Light, Dark, System** (icon on a soft tile + label; the selected card has a 2 px `primary` border). Label **"Language"** and a list of the **five** languages with a check on the selected one (F9). Changes apply immediately and are saved to `profiles.theme` / `profiles.language` through `PATCH /me` (queued offline).
  - **Account** (derived): **Delete account** in a danger card -> a confirmation dialog asking for the password (send `DELETE /me` with `{ password, confirmDelete: true }`); show `TRANSFER_ADMIN_FIRST` as a clear message; **Sign out**.
  - **Notifications** (derived): switches for push (mobile), sound/flash, assignments, comments, mentions, deadlines, chat; stored locally and respected by local notifications.
  - **Security** (derived): change password (current + new + confirm), **"Sign out on all devices"** with confirmation.
  - **Workspace** (team only, derived): rename (admin), links to **Members** and **Invite codes** (Stage 5 pages), **Leave workspace**, **Delete workspace** (admin, typed confirmation).
  - **Sync status:** the page from Stage 6.

### Settings, mobile
- **Settings tab** (`/settings`, bottom bar visible): title **"Settings"** (Inter 24 bold), one white card (radius 20) with rows (icon, label, chevron): **Profile, Account, Notifications, Appearance, Security, Workspace, "Language — English"** and **Sync status**. Each opens its own page (same content as desktop, single column, back button).
- **Profile tab** (`/profile`, bottom bar visible): centered **large avatar (about 96)**, name (Inter 24 bold), email (muted), then two chips: the **workspace name** (`surfaceAlt`) and the **role badge**. A white list card (radius 20): **Team, Documents, Analytics, Notifications, Sync status, Sign out** (Sign out in `danger`), each with chevron (F25; hide Team in Personal, hide Analytics for guests).

## Flutter tasks
S15.1 Team page and grid . S15.2 presence dots . S15.3 Latest Updates . S15.4 member profile sheet . S15.5 Invite with code button . S15.6 Profile settings (avatar upload + crop, name, timezone, language, save) . S15.7 Account (delete account, sign out) . S15.8 Notification switches . S15.9 Appearance synced to the profile . S15.10 Security . S15.11 Workspace section + Sync status link . S15.12 no Integrations tab . S15.13 mobile Profile tab and Settings list . S15.14 empty/loading/error states . S15.15 tests: theme and language persist across devices (sign in on a second device).

## Acceptance checklist
- [ ] Six images match at both sizes (except F9, F10, F25, F29, F30).
- [ ] Team grid never shows stretched or vertical text at any width; names stay on one line.
- [ ] Theme and language changes apply instantly, persist, and follow the user to another device.
- [ ] Deleting an account works end to end and shows `TRANSFER_ADMIN_FIRST` correctly.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S15.md` written.
