# Fidelity Report — Stage 3: Flutter Foundation

## Shell

### Desktop (1440x900)
- Sidebar: 240px wide, white, 1px right border — **matches**
- Logo: indigo "P" square 36x36 + "PlanPal" Inter 20 bold — **matches**
- Workspace switcher card: white, 1px border, radius 16, ~56px high, initial avatar + name + subtitle + chevrons — **matches**
- Nav items: Home, Tasks, Calendar, Chat, Documents, Analytics, Team, Settings at 40px height, radius 12, active = primarySoft pill — **matches**
- Bottom user card: avatar 32 + name + workspace name (fix F1 applied) — **matches**
- Top bar: search field 448x40 + Ctrl K chip + bell + user chip with role badge — **matches**

### Mobile (375x844)
- Bottom bar: 5 tabs (Home, Tasks, Chat, Profile, Settings), icon 24 + label 12 — **matches**
- Active tab primary color, inactive muted — **matches**

### Tablet (derived)
- NavigationRail 72px wide replacing sidebar — **derived from tokens, consistent with desktop**

## Theme tokens
- All colors match 01-DESIGN-TOKENS.md (light and dark) — **matches**
- Typography: Inter for headings, Noto Sans for body via google_fonts — **matches**

## Localization
- 5 ARB files (EN, ES, FR, ZH, KO) — **complete**
- All navigation labels and common strings covered — **complete**

## Approved differences
- None — all matches spec.
