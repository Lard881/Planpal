# Design Fixes: the ONLY allowed differences from the images

Everything else must match the images exactly. Each item says what the image shows, and what to build instead.

| # | Where | The image shows | Build this instead | Why |
|---|---|---|---|---|
| F1 | Desktop sidebar, bottom user card (all desktop pages) | Second line says "Free workspace" | Show the **current workspace name** ("Personal" for the personal workspace) | No plans or pricing exist |
| F2 | Home chart (desktop) | The line and fill stop in the middle of the chart | Draw the **full range** (7 days: Mon to Sun, or the chosen range) from real data, connected, smooth, soft fill under the line, x-axis shows day names (Mon..Sun) or dates for 30 days | Image is a rendering bug |
| F3 | Home chart (mobile) | X-axis labels read 0 / 50 / 100 | Same as F2: y-axis 0 to 100 on the left, **days on the x-axis** | Image bug |
| F4 | Calendar (desktop) | Day 13 is highlighted but the right panel says "Events: Oct 12" | **Today** = number in `primary`, bold. **Selected day** = `primarySoft` fill + 1 px `primary` border; the right panel always matches the selected day (default: today). Week starts on Monday | Image is inconsistent |
| F5 | Chat (desktop) | Left panel title "Acme Studio" while the switcher says "Maya's Space / Personal" | The panel title is the **current team workspace name**. Chat only exists in team workspaces; in Personal show the explanation screen (docs 5 and 10.7) | Chat is team-only |
| F6 | Mobile conversation header | Phone and video icons | **Remove them** (no calls feature). Use **search** and **members** icons, like desktop | Feature does not exist |
| F7 | Mobile Documents and Mobile Search results | A tall grey block where the search field should be | A **normal search field**: 44 high, `surfaceAlt`, search icon, placeholder ("Search files..." / the current query) | Image rendering bug |
| F8 | Desktop Documents | Grid/list toggle is tiny and unclear | A proper **two-icon segmented toggle** (grid, list), 36 high, same style as the Calendar Week/Month/Day control | Usability |
| F9 | Settings > Appearance | Language list shows 3 languages | Show **five**: English, Espanol, Francais, Chinese (Simplified), Korean (use each language's own name: English, Español, Français, 简体中文, 한국어) | Product decision |
| F10 | Settings menu (desktop and mobile) | Profile, Account, Notifications, Appearance, Security, Workspace | **Add "Sync status"** as the last item (before it the mobile list keeps its "Language" row). Hide "Workspace" in the Personal workspace | Docs S6.9 / S15.11 |
| F11 | Document editor header | A "Share" button | **Do not build "Share"** (no sharing backend). Keep only the back arrow, breadcrumb and "Save" (plus the "Saved / Waiting to sync" indicator next to it). Ask the owner if Share is wanted later | No backend support |
| F12 | Invite codes | Codes like `ACME-2041` | Real codes are **8 characters** from `ABCDEFGHJKLMNPQRSTUVWXYZ23456789` (no I, O, 0, 1). Show them as 8 characters in a bold, letter-spaced, monospace-style pill | Backend format |
| F13 | Join with code | 8 boxes | Keep 8 boxes. Auto-uppercase; accept only the allowed characters; paste fills all boxes; backspace moves back | Backend format |
| F14 | Google button (login, signup) | A generic round icon | Use the **official Google "G" logo** asset, same position and size | Brand rules |
| F15 | Switcher subtitles | "Personal . 12 tasks", "Design team . 8 members" | Personal: "Personal". Team: "Team . {n} members" (real counts only; omit what the API does not return) | No such data |
| F16 | Notifications chips | "All, Unread, Tasks, Mentions" without counts | Keep **exactly as drawn (no counts)**. Do show the unread dot on rows and the red dot on the bell | Follow the image |
| F17 | Search scope control | A toggle that reads "This workspace / All my workspaces" | A switch where **off = This workspace**, **on = All my workspaces**. The active side is bold. Default off | Clarify behavior |
| F18 | Login right panel ("Maya's Tuesday" card) and Signup right panel | Decorative marketing art | Build as **static decorative widgets** with localized text (keep the wording). This is illustration, not user data | Allowed exception to "no sample data" |
| F19 | Mobile Task details | No Attachments card | **Add an Attachments card** after Subtasks, same style as desktop (file tiles, "Attach File") | Docs 10.4 |
| F20 | Role badge in the top bar | Fixed text "Admin" | The user's **real role in the current workspace** | Docs S5.15 |
| F21 | All pages | Sample names, numbers, dates | **Real data only** | Golden rule 1 |
| F22 | Chat unread badges | Channels red, Direct Messages indigo | Keep as drawn | Follow the image |

## Parts the images do not cover
Dark theme, tablet layout, banners, empty/loading/error states, dialogs and subpages listed in `02-SCREEN-INDEX.md`: derive them using only tokens and shared components. Document each choice in the stage fidelity report.

## Owner questions still open (ask, do not decide)
1. Is "Share" in the document editor wanted? (F11)
2. Should the "Maya's Tuesday" illustration on the Login screen keep a person's name? (F18)
3. Do guests see the Documents folder tree, or only files shared with them? (docs permission table)

## Additional fixes (data the backend does not have, and docs that disagree with the images)

| # | Where | The image shows | Build this instead | Why |
|---|---|---|---|---|
| F23 | Analytics, stat card sub-lines | "+12% this week", "-0.4 days faster", "+6 pts sprint", "Personal best!" | **Tasks Completed:** show `changeVsPrevious` as "+12% this week" (range 7d), "this month" (30d), "this quarter" (90d); green if positive, `danger` if negative; hide the line when `null`. **Avg. Completion Time, Team Velocity, Productive Streak:** **hide the sub-line** (the backend has no previous-period value, no sprint points and no personal best) | No such data |
| F24 | Analytics, "Team Velocity" | "34 pts" | Show the **on-time rate** as a percentage, e.g. "86%" (`summary.on_time_rate`), as decided in `docs/03-frontend.md` 10.9. Keep the lightning icon and the label "Team Velocity" | No "points" concept exists |
| F25 | Mobile Profile list | Team, Documents, Analytics, Notifications, Sign out | Add **"Sync status"** before "Sign out" (docs S6.9). In a Personal workspace hide **Team** | Docs |
| F26 | Home quick action colors | New Task indigo, Calendar violet, Analytics sky, Documents green | Keep **the image colors** (the older docs said blue/green/orange/purple: ignore them). Mobile labels stay **New Task, Calendar, Stats, Docs** | Follow the image |
| F27 | Home "Your Tasks Today" on mobile | Vertical stack of cards | Keep **vertical** (the old docs said horizontal scroll) | Follow the image |
| F28 | Analytics page header | No subtitle | No subtitle (the old docs listed one) | Follow the image |
| F29 | Settings left menu | No "Integrations" | Do not build it | Product decision |
| F30 | Team page "Latest Updates" | Three sample lines | Build from **real recent rows in the local database** (recently completed tasks, uploaded files, members who joined). The backend has no activity feed. Show an empty state "No recent activity" when there is nothing | No such endpoint |
