# S16: Windows desktop polish (tasks S16.1 to S16.9)

**Before you start:** read the master rules, `docs/03-frontend.md` sections 3, 5, 10.14, 17, and Stage 16 in `docs/04-task-stages.md`. Stages 3 to 15 finished.

**Images:** all `design/desktop/*.png` are the reference for how every page must look at 1440x900. Re-check the key pages after every change here.

## Tasks
- **S16.1 Keyboard shortcuts:** **Ctrl+K** search, **Ctrl+N** new task, **Ctrl+Enter** send message or save form, **Esc** close dialog or search, **Ctrl+1 to Ctrl+8** jump to the sidebar pages in order (Home, Tasks, Calendar, Chat, Documents, Analytics, Team, Settings). Add a small **"Keyboard shortcuts"** dialog (no image: dialog style from tokens, two-column list of key chips on `surfaceAlt` and descriptions) reachable from Settings and from `?`.
- **S16.2 Hover, tooltips, context menus:** every clickable element has a hover state (a slightly darker fill, same radius), every icon-only button has a localized tooltip, right-click menus on task rows and documents (the same actions as their "..." menus).
- **S16.3 Window:** minimum size 900x600, remember size, position and maximized state.
- **S16.4 Drag and drop** for uploads (Documents page and chat composer): dashed `primary` drop area with the text "Drop files to upload".
- **S16.5 Focus:** logical tab order, visible focus rings (2 px `primary`, radius matches the element) on all controls, Enter activates buttons, Esc closes overlays.
- **S16.6 High-DPI:** verify at 100%, 125% and 150% Windows scaling; no blurry icons, no clipped text.
- **S16.7 Installer:** MSIX or Inno Setup with the PlanPal icon (`design/logo/planpal-logo.png`).
- **S16.8 Sizes:** confirm every desktop screen at **1366x768** and **1920x1080** (content keeps its max widths, panels do not stretch ugly; sidebar stays 240).
- **S16.9** confirm no Windows-only call exists outside `platform_info.dart` so macOS can be added later.

## Acceptance checklist
- [ ] Every shortcut works and is listed in the shortcuts dialog.
- [ ] Tab through Login, Tasks and Settings using only the keyboard.
- [ ] 900x600 shows no overflow or clipped controls on any page.
- [ ] `docs/fidelity-report-S16.md` written.
