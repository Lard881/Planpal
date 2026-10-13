# Fidelity Report — Stage 5: Workspaces

## Workspace Switcher

### Desktop popover
- 320px wide, white, 1px border, radius 16, soft shadow — **matches**
- Heading "Switch workspace" 12px muted — **matches**
- Rows: initial avatar 36 (radius 10), name 14 semibold, subtitle (fix F15: Personal / Team · n members), role badge right — **matches**
- Current workspace row = primarySoft background — **matches**
- Divider + "Create workspace" and "Join with code" rows — **matches**

### Mobile bottom sheet
- Drag handle, "Switch workspace" Inter 20 semibold — **matches**
- Workspace rows as bordered cards (radius 16) — **matches**
- Primary "+ Create workspace" button — **matches**
- surfaceAlt "Join with code" button — **matches**

## Create Workspace (`/workspace/create`)
- Mobile: back button (36x36 white square, radius 12, arrow-left) — **matches**
- "Create workspace" title, "Workspace name" label, surfaceAlt field, primary "Create" — **matches**
- Desktop: centered white card 400px, tip box in surfaceAlt — **matches**

## Join with Code (`/workspace/join`)
- 8 boxes (fix F13): allowed chars only, auto-uppercase, paste fills, backspace moves back — **matches**
- Desktop: centered card — **matches**
- All join error codes mapped to specific messages — **matches**

## Workspace Settings (Members + Invite codes)
- "Workspace Settings" title + subtitle + "+ New code" primary — **matches**
- Members/Invite codes pill tabs (filled primary selected) — **matches**
- Member rows: avatar + name + role dropdown (surfaceAlt) + red "Remove" — **matches**
- Invite code pill: monospace bold letter-spaced (fix F12) — **matches**
- Status chips: Active green / Expired grey / Revoked grey — **matches**

## Approved differences
- Fix F15 applied: subtitle shows "Personal" or "Team · n members" (no task counts — not returned by API).
