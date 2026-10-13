# PlanPal Flutter App: Master Rules (always apply, every stage)

You are building the **Flutter app** (Android + Windows first) for PlanPal. The backend and database already exist and must **not** be changed (see section 7). The owner has approved a new design. **The app must look exactly like the design images.** This file is the rulebook. Read it fully at the start of every session.

---

## 1. What wins when sources disagree

| Question | Source of truth (highest first) |
|---|---|
| How does it **look** (layout, spacing, colors, fonts, copy text)? | 1. Design images in `prompts/design/` 2. `01-DESIGN-TOKENS.md` 3. `03-DESIGN-FIXES.md` |
| How does it **behave** (data, permissions, offline, errors, security)? | 1. `docs/00-overview.md` and `docs/03-frontend.md` 2. `docs/02-backend.md` 3. the stage prompt |
| Old colors, "dark sidebar", "Free workspace", Microsoft login, pricing | **Ignore.** Old docs/designs are replaced by the new design. |

If the images contradict the docs about behavior, follow the docs and list the difference in your report.

---

## 2. Design fidelity protocol (the most important rule)

The owner lost two weeks to an app that did not match the design. **Do not repeat that.**

1. **Open the image before you code the screen.** Every stage prompt lists the exact images. Look at each one. Do not work from the description alone.
2. **Write a layout inventory first** (in your plan or notes, 10 to 25 lines): the regions, every component, every visible text string, the order, the alignment, the approximate sizes. Then build.
3. **Image scale.**
   - `design/original-3x/*.png` are 3x. Divide pixel values by 3 to get Flutter logical pixels. Desktop frame = **1440 x 900**. Mobile frame = **375 x 844**.
   - `design/desktop/*.png` are 1920 px wide (multiply by 0.75 to get logical px). `design/mobile/*.png` are 750 px wide (divide by 2).
   - Use the original-3x files when you need to zoom in and measure.
4. **Match exactly:** structure, order, spacing, corner radius, font, font size and weight, colors, icon style, label text, button text, empty areas, alignment, and which item is highlighted.
5. **Do not** add elements that are not in the image, remove elements that are, rename labels, "improve" the layout, swap components for different ones, or change the color palette. The only allowed differences are in `03-DESIGN-FIXES.md`.
6. **Copy text exactly** (English). Put every string in `app_en.arb` with a clear key. Never hard-code user-facing text in widgets.
7. **Sample data is not real data.** Names like "Maya Chen", "Acme Studio", "Finalize launch checklist", numbers like 24 / 8 / 3 / 86% exist only to show the layout. **Never put them in the app.** All content comes from the backend API, Supabase Realtime, or the local database.
8. **Colors only from tokens.** No hex values outside `core/theme/`. Use `context.colors.*` and `AppText.*`.
9. **Icons:** the design uses a Lucide-style outline icon set (stroke about 1.75, 20 px in lists and nav, 24 px in the mobile bottom bar). Use a Lucide package for Flutter and pick the icon that matches the image. Do not mix icon sets.
10. **Verify visually after each screen.** Run the app at **1440x900** (desktop) and **375x844** (mobile), take a screenshot, put it next to the design image, and list every difference you can see. Fix them. Repeat until nothing visible differs (except approved fixes and real data).
11. **Fidelity report.** At the end of each stage create `docs/fidelity-report-S{stage}.md`: for each screen, a line "matches", or the remaining difference with the reason. Be honest. Do not write "matches" unless you compared the screenshots.

---

## 3. Product rules (from the owner's decisions)

- **No mock data. Ever.** No fake lists, users, tasks or charts in the app. Real empty states instead (`docs/03-frontend.md` section 12).
- **No pricing, no plans, no "Upgrade", no "Free workspace" text.** **No Microsoft login.** Google only.
- **Two workspace types:** Personal (private, auto-created, owner is admin) and Team (invite code to join). Personal hides Chat, Team, Members and Invite codes.
- **Roles:** Admin, Member, Guest. Hide or disable actions a role cannot do (permission table in `docs/00-overview.md` section 5). Always show the user's **real** role.
- **Three themes:** Light, Dark, System (default System). Dark values are in `01-DESIGN-TOKENS.md`.
- **Five languages:** English, Spanish, French, Chinese (Simplified), Korean. All strings in ARB files, with plurals via ICU.
- **Clear errors:** every failure says what happened and whether it is internet, server, permission or something else (`docs/03-frontend.md` section 13).
- **Offline first:** screens read from the local Drift database; writes go to Drift and the outbox first (`docs/03-frontend.md` section 8).
- **Three layouts by width** (from `MediaQuery`, not platform): under 600 mobile (bottom tabs), 600 to 899 tablet (navigation rail), 900 and up desktop (sidebar). Designs exist for mobile and desktop. **Tablet is derived** from desktop (rail instead of sidebar, right-side panels move below or hide).
- **Dark mode and tablet have no images.** Derive them from the light designs and the tokens. Do not invent a different style.

---

## 4. Architecture rules

- Feature-first folders as in `docs/03-frontend.md` section 2. Riverpod for state, go_router for navigation, dio for HTTP, Drift for local data, freezed + json_serializable for models, supabase_flutter for auth and realtime.
- Screens never call dio or Supabase directly. Screen -> provider -> repository -> Drift / API.
- No business logic in widgets. Small files. Reuse the shared components (`core/widgets/`); if a second screen needs something, move it there.
- No secrets in the app. Config through `--dart-define`.
- Keep all platform checks inside one `platform_info.dart` so iOS and macOS can be added later.
- Use the latest stable Flutter and package versions at build time, and pin them.

---

## 5. How to work

1. Read `docs/04-task-stages.md`. Work **one stage at a time**, in order. Do not start a stage until the previous one is finished and tested.
2. Each stage prompt tells you which tasks (S3.1, S7.14 ...) are Flutter work. Tasks marked **Backend** are already built: **verify** that the endpoint exists and behaves as the docs say. Do not rebuild or edit it.
3. Tick the boxes in `docs/04-task-stages.md` and update the progress table when a task is truly finished and tested.
4. After each screen run `flutter analyze` and fix every warning. Add widget tests for new components. Run `flutter test`.
5. Commit often with clear messages. One feature or screen per commit.
6. **If information is missing, ask the owner. Do not invent** (API keys, copy for a new screen, a feature that is not in the docs). Add the question to "Owner inputs still needed" in `docs/04-task-stages.md`.
7. For screens that have **no image** (dialogs, banners, empty states, settings subpages, dark mode, tablet), build them from the same tokens and components so they look like they belong. Describe your choice in the fidelity report.

---

## 6. Definition of done for any screen

- [ ] Compared with the image at both sizes; no visible differences except approved ones.
- [ ] Works in Light and Dark.
- [ ] Works at widths 375, 700 and 1280.
- [ ] Loading, empty, error and offline states exist.
- [ ] Real data only; role-based visibility applied.
- [ ] All text from ARB files (at least English complete; other four languages filled, not left blank).
- [ ] `flutter analyze` clean; tests added and passing.
- [ ] Tasks ticked in `docs/04-task-stages.md`.

---

## 7. Backend: do not change it

The backend is frozen unless the owner says otherwise. If an endpoint is missing or broken:

1. Stop that part of the work.
2. Write what is wrong in `docs/backend-gaps.md` (endpoint, expected, actual).
3. Continue with other work that does not depend on it.

**Known problems are already documented in `BACKEND-KNOWN-ISSUES.md`.** They affect Search, Analytics, Home overview, starting a Direct Message and Moving a task. A tested patch exists in `backend-fixes/`. Do not apply it yourself; the owner decides.
