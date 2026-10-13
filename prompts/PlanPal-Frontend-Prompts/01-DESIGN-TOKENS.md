# PlanPal Design Tokens (measured from the approved design)

These values were **sampled from the design images**, not guessed. They replace section 4 of `docs/03-frontend.md` (the old palette and the old "dark sidebar" are gone). Ready-to-use Dart is in `code-seeds/`.

Where a number says "about", measure it on the image in `design/original-3x/` (divide by 3) and use the image.

---

## 1. Colors, Light theme (from the images)

| Token | Hex | Used for |
|---|---|---|
| `primary` | `#4F46E5` | Buttons, active icons, links, selected chips, today marker, chart line, progress |
| `primarySoft` | `#EEF0FF` | Active sidebar item, "Details" button, In Progress chip, Admin badge, selected soft backgrounds |
| `violet` | `#8B5CF6` | Member badge text, Calendar quick tile icon, accent |
| `violetSoft` | `#EDE9FE` | Member badge bg, Calendar quick tile, Marketing gradient end |
| `sky` | `#0EA5E9` | Analytics quick tile icon, DOC badge, some avatars |
| `skySoft` | `#E0F2FE` | Analytics quick tile |
| `success` | `#16A34A` | Completed, Low, presence online, Documents tile icon |
| `successSoft` | `#DCFCE7` | Completed chip, Low chip, Documents quick tile |
| `warning` | `#F59E0B` | Presence away, event color amber |
| `warningText` | `#D97706` | Medium chip text, amber text |
| `warningSoft` | `#FEF3C7` | Medium chip bg |
| `danger` | `#EF4444` | High and Overdue chip text, delete, unread badge (channels), notification dot |
| `dangerSoft` | `#FEE2E2` | High chip bg, Overdue chip bg |
| `background` | `#F7F7FB` | Page background (also the Login left half) |
| `surface` | `#FFFFFF` | Cards, sidebar, top bar controls, bottom nav |
| `surfaceAlt` | `#EEF0F6` | Text field fill, Todo chip, segmented track, key-hint chip, file tiles |
| `border` | `#E4E7EF` | 1 px card/field outline, dividers (verify on the image) |
| `textPrimary` | `#12141F` | Titles and body |
| `textMuted` | `#6B7185` | Secondary text, placeholders, inactive nav |
| `presenceOffline` | `#C4C7D1` | Offline presence dot |
| Auth showcase gradient (Login right) | `#EEEFFF` -> `#EDE9FE` | Login right half |
| Auth marketing gradient (Signup right) | `#5A4AE8` -> `#7554EF` (top-left to bottom-right) | Signup right half |

### Chips and badges (background / text)

| Chip | Bg | Text |
|---|---|---|
| Priority High | `#FEE2E2` | `#EF4444` |
| Priority Medium | `#FEF3C7` | `#D97706` |
| Priority Low | `#DCFCE7` | `#16A34A` |
| Status Todo | `#EEF0F6` | `#6B7185` |
| Status In Progress | `#EEF0FF` | `#4F46E5` |
| Status Completed | `#DCFCE7` | `#16A34A` |
| Status Overdue | `#FEE2E2` | `#EF4444` |
| Role Admin | `#EEF0FF` | `#4F46E5` |
| Role Member | `#EDE9FE` | `#8B5CF6` |
| Role Guest | `#EEF0F6` | `#6B7185` |
| Invite status Active | `#DCFCE7` | `#16A34A` |
| Invite status Expired / Revoked | `#EEF0F6` | `#6B7185` |
| File type PDF | `#EF4444` solid, white text | |
| File type DOC | `#0EA5E9` solid, white text | |
| File type XLS / XLSX | `#16A34A` solid, white text | |
| File type IMG / other | `#6B7185` solid, white text | |

### Event / label color choices (the 6 dots in Schedule Event)
`#4F46E5` indigo, `#8B5CF6` violet, `#0EA5E9` sky, `#16A34A` green, `#F59E0B` amber, `#EF4444` red.
Calendar event chips use the soft version of the color as background and the strong color as text.

### Avatar colors
Avatars are circles with white bold initials. Pick the color from this list **deterministically from the user id** (hash modulo 7) so a person always has the same color: `#4F46E5`, `#8B5CF6`, `#0EA5E9`, `#16A34A`, `#D97706`, `#EF4444`, `#6B7185`. If the user has an avatar photo, show the photo instead. The current-user avatar in the sidebar bottom card and mobile header uses a violet gradient (`#4F46E5` to `#8B5CF6`).

---

## 2. Colors, Dark theme (derived, no image exists)

Keep the same structure and hue. Do not invent a new look.

| Token | Hex |
|---|---|
| `background` | `#0C0E16` |
| `surface` | `#151826` |
| `surfaceAlt` | `#1E2233` |
| `border` | `#262B40` |
| `textPrimary` | `#F2F3F8` |
| `textMuted` | `#9AA0B8` |
| `primary` (fills) | `#6366F1` |
| `link` (text links, active icons) | `#A5B4FC` |
| `primarySoft` | `#232754` |
| `violet` / `violetSoft` | `#A78BFA` / `#2A2250` |
| `sky` / `skySoft` | `#38BDF8` / `#12303F` |
| `success` / `successSoft` | `#4ADE80` / `#12301F` |
| `warning` / `warningText` / `warningSoft` | `#FBBF24` / `#FBBF24` / `#3A2E10` |
| `danger` / `dangerSoft` | `#F87171` / `#3F1D22` |
| `presenceOffline` | `#4B5168` |

In Dark: cards use a 1 px `border` and **no shadow**. Text contrast must be at least 4.5:1.

---

## 3. Typography

| Role | Font | Size / weight |
|---|---|---|
| Page title ("Tasks", "Analytics", "Home greeting") | **Inter** | 28 bold desktop, 24 bold mobile, tight line height (1.2) |
| Auth and onboarding title | Inter | 32 bold desktop, 24 mobile |
| Section title ("Your Tasks Today", "Overview") | Inter | 20 semibold |
| Card title ("Description", "Subtasks") | Inter | 16 semibold |
| Stat number | Inter | 24 bold (28 on Analytics cards) |
| Brand "PlanPal" | Inter | 20 bold |
| Body, labels, table text | **Noto Sans** | 14 regular / 500 for labels / 600 for emphasis |
| Caption, chips, helper text | Noto Sans | 12 to 13 |

Bundle **Inter** and **Noto Sans** (weights 400, 500, 600, 700) as asset fonts. For Chinese and Korean use platform fallback fonts (`Noto Sans SC`, `Noto Sans KR`, `Microsoft YaHei`, `Malgun Gothic`). Allow text to scale and never clip.

---

## 4. Shape, spacing, elevation

| Item | Value |
|---|---|
| Card radius | 20 (large panels 24) |
| Button, input, dropdown, segmented control | radius 12 |
| Chips, badges, switches, avatars | fully rounded |
| Modal dialog | radius 24, width 480 (Create workspace 400), scrim black ~35% |
| Bottom sheet | top radius 24, drag handle |
| Spacing scale | 4, 8, 12, 16, 24, 32 |
| Light card style | `surface` + 1 px `border` + very soft shadow (about `0 1 2 rgba(16,24,40,0.04)`) |
| Primary button | fill `primary`, white text 14 semibold, no shadow |
| FAB (mobile) | 56 circle, `primary`, white "+", soft shadow, bottom-right, 16 above the bottom bar |

---

## 5. Layout measurements (logical px, measured)

### Desktop (frame 1440 x 900)
- **Sidebar:** 240 wide, `surface`, 1 px right border. Inner padding 16 (nav pill is x=16, width 208, height 40, radius 12). Logo mark 36 x 36 at (20, 20) with "PlanPal" next to it.
- **Workspace switcher card** (below the logo): white, 1 px border, radius 16, about 56 high; left square avatar with the workspace initial (about 28, radius 8, colored), name 14 semibold, subtitle 12 muted (Personal / member count), chevrons-up-down icon on the right.
- **Nav items:** icon 20 + label 14 medium, muted; active = `primarySoft` pill with `primary` icon and text. Order: Home, Tasks, Calendar, Chat, Documents, Analytics, Team, Settings.
- **Sidebar bottom user card:** white, 1 px border, radius 16, avatar 32 + name (14 semibold) + second line 12 muted (**the current workspace name**, see FIXES).
- **Content area:** starts at x=240, page padding 32 left and right (title at x=272, right edge at x=1408), top padding 16 for the top bar.
- **Top bar (height about 40):** search field about 448 wide x 40 high (white, 1 px border, radius 12, search icon, placeholder, "Ctrl K" key-hint chip on the right); at the far right a 40 x 40 bell button (white, border, radius 12, red 8 px dot when unread) and the user chip (avatar 36, name 14 semibold, role badge below the name).
- **Buttons:** toolbar buttons 40 high (e.g. "+ Add Task" is 116 x 40); form buttons 44 high; radius 12.
- **Inputs:** 44 high, `surfaceAlt` fill, no border, radius 12, 16 horizontal padding. Label above (14 medium).
- **Chips:** 24 high, 12 px horizontal padding, 12 text.
- **Right panel (Home, Calendar, Team):** about 288 wide, 24 gap from the main column.
- **Detail pages (Task detail):** content max about 960 wide, two columns (left about 568, right about 372, gap about 19).
- **Quick action tiles (Home):** 4 in a row, each about 197 x 93, radius 20, soft color bg, 40 icon tile top-left, label bottom-left.

### Mobile (frame 375 x 844)
- Page padding 16. Cards radius 20, tiles radius 16 to 20.
- **Bottom bar:** 5 tabs (Home, Tasks, Chat, Profile, Settings), icon 24 + label 12, active `primary`, inactive muted, `surface` with a top hairline.
- **Mobile header (Home):** left workspace tile (initial avatar 32 + workspace name 14 semibold), right bell and avatar 32.
- **Back button:** 36 x 36 white square, 1 px border, radius 12, arrow-left icon.
- **Segmented control:** track `surfaceAlt`, selected segment white with a light shadow.
- **List tiles:** white, radius 20, 1 px border, 16 padding, 12 gap between tiles.

---

## 6. Component recipes (use these names for shared widgets)

`PlanPalButton` (primary / secondary-outline / soft / danger-outline / loading), `PlanPalTextField` (filled, label above, error text, password eye), `OtpField` (6 or 8 boxes, box 44 to 52 high, filled `surfaceAlt`, entered box has `primary` 1.5 px border and `primarySoft` fill), `PriorityChip`, `StatusChip`, `LabelChip` (colored dot + name), `RoleBadge`, `FileTypeBadge`, `Avatar` (+ presence dot 12 with 2 px white ring), `AppCard`, `SectionHeader` ("title" + optional "View All" link), `QuickActionTile`, `StatCard`, `EmptyState`, `ErrorState`, `LoadingSkeleton`, `ConnectivityBanner`, `SyncStatusChip`, `AppSnackbar`, `ConfirmDialog`, `WorkspaceSwitcher`, `SearchField`, `SegmentedTabs`, `ProgressBar` (6 high, `surfaceAlt` track, `primary` fill, rounded), `CheckCircle` (22 circle; outlined grey when off, filled `primary` with white check when on).
