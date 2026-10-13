# PlanPal Frontend Prompt Pack (for Kiro and Antigravity)

This folder tells an AI coding tool how to build the **PlanPal Flutter app so it looks exactly like your new Banani design**. It contains the design images, the measured colors and sizes, the rules, and one detailed prompt per stage.

## 1. Put it in your project (once)

1. Copy this whole folder into the root of your repo and name it **`prompts`**. Your `docs/` folder (the 5 documentation files) stays where it is.
2. **Kiro:** copy `tool-setup/kiro-steering-planpal.md` to `.kiro/steering/planpal-design.md`. It keeps the main rules active in every chat.
3. **Antigravity:** add the text of `tool-setup/antigravity-agents-block.md` to the `AGENTS.md` in your repo root (you already have one).
4. If your tool version does not pick these files up automatically, paste `00-MASTER-RULES.md` as the first message of each session. That always works.

## 2. What is inside

```
prompts/
  README.md                  this file
  00-MASTER-RULES.md         the rulebook (design fidelity protocol, product rules)
  01-DESIGN-TOKENS.md        exact colors, fonts, sizes, dark theme (measured from your images)
  02-SCREEN-INDEX.md         every image -> screen -> route -> stage
  03-DESIGN-FIXES.md         the ONLY allowed differences from the images (30 items)
  BACKEND-KNOWN-ISSUES.md    problems found in the backend (not fixed)
  design/
    desktop/  (27 images, 1920 px wide)
    mobile/   (26 images, 750 px wide)
    original-3x/  (full-size originals, for measuring)
    logo/planpal-logo.png
  code-seeds/                Dart files: colors, text styles, theme, breakpoints
  stages/                    S03 ... S17, one prompt per stage
  backend-fixes/             a ready patch for the backend (do not apply yet)
  tool-setup/                Kiro and Antigravity rule files
```

## 3. How to run a stage

Do the stages **in order**: S03, S04, S05, S06, S07 ... S17. Start a **new chat/session for each stage** and paste this message (change the stage file):

```
Read prompts/00-MASTER-RULES.md, prompts/01-DESIGN-TOKENS.md, prompts/03-DESIGN-FIXES.md
and prompts/stages/S07-tasks.md. Then do Stage 7 exactly as written.

Rules for this session:
1. Open every image listed in the stage file before you write any code.
2. For each screen, first show me your layout inventory (regions, components, text, sizes).
3. Build one screen at a time. After each screen, run the app at 1440x900 (desktop) and
   375x844 (mobile), compare a screenshot with the design image, and fix every visible difference.
4. Do not change the backend. Do not use mock data. Do not invent anything: ask me.
5. When finished, run flutter analyze and the tests, tick the tasks in docs/04-task-stages.md,
   and write docs/fidelity-report-S7.md.
```

## 4. How YOU check each stage (5 minutes)

1. Run the app and open each screen listed in the stage's "Acceptance checklist".
2. Put the design image next to the app. Compare: spacing, colors, fonts, which item is highlighted, text.
3. If something is different, paste this (fill in the blanks) and do not move on until it is fixed:

```
The screen <name> does not match prompts/design/<image>.png.
Differences I see: <list, for example "title is smaller", "cards have no border", "chip colors are wrong">.
Open the image again, measure it (original-3x divided by 3), fix every difference, take a new screenshot,
and tell me what is still different. Only the deviations in prompts/03-DESIGN-FIXES.md are allowed.
```

## 5. Things you must know

- **Backend problems.** While preparing this pack I found that **search, analytics, the Home overview, starting a direct message and moving a task call database functions that do not exist** (details in `BACKEND-KNOWN-ISSUES.md`). I did **not** change your backend. A tested patch is in `backend-fixes/`. Until you apply it, those five features will not work end to end. The Flutter stages are written so you can build those screens anyway.
- **What the images do not show.** Dark theme, tablet layout, dialogs, banners, empty states, Settings subpages, Week and Day calendar, and the Sync status page were not designed. The prompts tell the AI to derive them from your tokens. Check these yourself; they are the most likely place for style drift.
- **Design bugs and wrong text** (for example "Free workspace", phone/video icons in chat, a broken chart) are listed in `03-DESIGN-FIXES.md` with what to build instead.
- **The code seeds** (`code-seeds/*.dart`) were written carefully but **not compiled** because Flutter is not installed in the environment where this pack was prepared. The AI tool will fix small errors for your Flutter version.
- **Nothing here can guarantee a pixel-perfect result by itself.** The pack lowers the risk with image-first work, measured tokens, a layout inventory, screenshot comparison and fidelity reports. Your own side-by-side check after each stage is the real safety net.
- **Open questions for you** (the AI will ask too): is "Share" in the document editor wanted, may the Login illustration keep a person's name, and what should guests see in Documents.

## 6. Stage list

| Stage | Prompt | Content |
|---|---|---|
| 3 | `S03-flutter-foundation.md` | Theme, fonts, shell, shared components, routing, errors, local database |
| 4 | `S04-auth-onboarding.md` | Login, sign up, verification, password reset, onboarding |
| 5 | `S05-workspaces.md` | Switcher, create, join, members, invite codes |
| 6 | `S06-offline-sync.md` | Sync engine and Sync status (almost no UI) |
| 7 | `S07-tasks.md` | Task list, detail, new task |
| 8 | `S08-calendar.md` | Calendar and events |
| 9 | `S09-files-documents.md` | Files, folders, documents, editor |
| 10 | `S10-chat.md` | Real-time chat |
| 11 | `S11-notifications.md` | Notifications and push |
| 12 | `S12-search.md` | Global search |
| 13 | `S13-analytics.md` | Analytics |
| 14 | `S14-home.md` | Home dashboard |
| 15 | `S15-team-settings.md` | Team, Settings, Profile |
| 16 | `S16-windows-polish.md` | Shortcuts, hover, drag and drop, installer |
| 17 | `S17-quality-release.md` | Final audit and release |
