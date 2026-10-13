# S05: Workspaces, members and invite codes (Flutter tasks S5.7 to S5.17)

**Before you start:** read the master rules, tokens, fixes, `docs/03-frontend.md` sections 7 and 10.1, `docs/02-backend.md` section 6.2, the permission table in `docs/00-overview.md` section 5, and Stage 5 in `docs/04-task-stages.md`. Stages 3 and 4 must be finished.
**Backend tasks S5.1 to S5.6 are already built.** Verify these endpoints exist and answer as documented: `GET/POST /workspaces`, `GET /workspaces/:id`, `PATCH/DELETE /workspaces/:id`, `POST /workspaces/join`, `GET /workspaces/:id/members`, `PATCH/DELETE /workspaces/:id/members/:userId`, `GET/POST /workspaces/:id/invites`, `DELETE /workspaces/:id/invites/:inviteId`. Do not edit the backend.

**Open these images first:**
`design/desktop/DesktopWorkspaceswitcher.png`, `DesktopCreateworkspace.png`, `DesktopJoinwithcode.png`, `DesktopAdminMembers.png`, `DesktopAdminInvitecodes.png`; `design/mobile/MobileWorkspaceswitcher.png`, `MobileCreateworkspace.png`, `MobileJoinwithcode.png`.

## Layout specs

### Workspace switcher
- **Desktop popover:** opens from the sidebar switcher card, appearing to the right of the sidebar at the top of the content area, about 320 wide, white, 1 px border, radius 16, soft shadow. Heading **"Switch workspace"** (12 muted). Rows (about 56 high, radius 12): square initial avatar 36 (radius 10, colored), workspace name 14 semibold, subtitle 12 muted (fix F15), role badge on the right. The **current** workspace row has a `primarySoft` background. A divider, then rows **"+ Create workspace"** and **key icon "Join with code"**.
- **Mobile bottom sheet:** drag handle, title **"Switch workspace"** (Inter 20 semibold), the same rows as bordered cards (radius 16), then a full-width primary button **"+ Create workspace"** and below it a `surfaceAlt` button **"Join with code"**. Opened by tapping the workspace tile in the Home header.

### Create workspace (`/workspace/create`)
- **Desktop:** page inside the shell; a centered white card (about 400 wide, radius 24, soft shadow): title **"Create workspace"** (Inter 28 bold), text **"Give your new space a friendly name."**, label **"Workspace name"**, field, primary full-width **"Create"**, then a `surfaceAlt` tip box (radius 12): **"Tip: you can invite teammates right after creating it."**
- **Mobile:** back button (36x36 white square) top-left, large title "Create workspace", label, field, primary **"Create"**.

### Join with code (`/workspace/join`)
- **Desktop card:** title **"Join with code"** centered (Inter 28 bold), text **"Ask your teammate for the 8-character invite code."**, **8 boxes** (about 32 x 44, `surfaceAlt`, bold 18), primary **"Join"**.
- **Mobile:** back button, title, text "Enter the 8-character code from your teammate.", 8 boxes, **"Join"**.
- Behavior (fix F13): auto-uppercase, only characters `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`, paste fills all boxes, backspace moves back, Join enabled at 8 characters. Show a **specific inline message** for each backend code: `INVALID_CODE`, `CODE_EXPIRED`, `CODE_REVOKED`, `CODE_USED_UP`, `ALREADY_MEMBER`, `RATE_LIMITED` (10 attempts per hour; show the wait time from `Retry-After`).
- On success: switch to the new workspace, show a success snackbar, go to `/home`.

### Workspace Settings: Members and Invite codes (admin only)
- **Desktop** page (sidebar highlight = Team). Title **"Workspace Settings"** (Inter 28 bold), subtitle **"{workspace name} · Manage people and access"**. Right: primary **"+ New code"** (visible on both tabs). Under the subtitle: two pill tabs **"Members"** and **"Invite codes"** (selected = filled `primary` white text; other = `surfaceAlt`).
- **Members card** (white, radius 20, about 560 wide): rows 56 high with avatar 36, name 14 medium; at the right a **role dropdown** (`surfaceAlt`, radius 12, chevron: Admin / Member / Guest) and an outline red **"Remove"** button. Changing a role or removing asks for confirmation. The last-admin rule shows the localized `LAST_ADMIN` message. The current user's own row offers **"Leave workspace"** (not "Remove").
- **Invite codes card:** rows with the code in a bold letter-spaced monospace-style pill (`surfaceAlt`, radius 8, fix F12), then two lines: **"{Role} · {n} uses"** and **"Never expires"** / **"Expires {date}"** / **"Expired {date}"**; at the right a status chip (Active green / Expired grey / Revoked grey), an outline **"Copy"** button with a copy icon, and a red outline **"Revoke"** (hide it for already revoked codes). Copy shows the snackbar "Code copied".
- **"+ New code" dialog** (derived, same dialog style): Role (Member default / Guest / Admin), optional max uses, optional expiry date, **"Create code"**. After creation show the code large with a Copy button.
- **Mobile (derived, no image):** Settings -> Workspace -> Members / Invite codes as simple list pages with the same row styling.

## Flutter tasks
- **S5.7** workspace repository with Drift and `currentWorkspaceProvider` (remembered locally, default = personal workspace from `GET /me`).
- **S5.8** the switcher (desktop popover, mobile sheet). **S5.9** create. **S5.10** join. **S5.11** members screen. **S5.12** invite codes screen.
- **S5.13** Personal workspace rules: hide Chat, Team, Members, Invites, and the Workspace settings section.
- **S5.14** role-based UI everywhere (use one `RolePermissions` helper that mirrors the docs table; do not scatter role checks).
- **S5.15** the real role badge in the top bar and sidebar user card (replaces any fixed text).
- **S5.16** tests: switching workspace changes every data source; role-based visibility. **S5.17** manual test with two real accounts: create, invite, join, change role, remove.

## Acceptance checklist
- [ ] The 8 images match the running screens at both sizes.
- [ ] Switching workspace refreshes the sidebar, the top bar role, and (later) all data sources.
- [ ] Every join error code shows its own message; rate-limit shows a wait time.
- [ ] Guests and members cannot see admin pages (route guard + hidden entry points).
- [ ] `docs/fidelity-report-S5.md` written.
