---
inclusion: always
---

# PlanPal design and build rules (always on)

Read these files at the start of every session. They are in the `prompts/` folder at the repo root:
`prompts/00-MASTER-RULES.md`, `prompts/01-DESIGN-TOKENS.md`, `prompts/03-DESIGN-FIXES.md`, `prompts/02-SCREEN-INDEX.md`, `prompts/BACKEND-KNOWN-ISSUES.md`. The project docs are in `docs/`.

The design images are in `prompts/design/`. The app must look exactly like them. The backend is frozen.

Summary of the most important rules (the full text is in `prompts/00-MASTER-RULES.md`):
1. Open the design image before coding any screen; write a layout inventory first.
2. Match layout, spacing, colors, fonts, radius, icons and copy text exactly. Only the differences listed in `prompts/03-DESIGN-FIXES.md` are allowed.
3. Never ship sample data from the images. No mock data anywhere.
4. Colors and text styles only from the theme tokens (`context.colors`, `AppText`). No hard-coded hex values.
5. After each screen, run the app at 1440x900 and 375x844, compare a screenshot with the image, and fix every visible difference.
6. Work one stage at a time from `prompts/stages/`. Do not change the backend. If something is missing, ask the owner; do not invent.
7. At the end of each stage write `docs/fidelity-report-S{n}.md` honestly.
