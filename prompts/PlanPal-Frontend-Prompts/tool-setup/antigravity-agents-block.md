# Add this block to the repo's AGENTS.md (or save it as a workspace rule file for Antigravity)

## PlanPal Flutter app: design and build rules
Before any work read: `prompts/00-MASTER-RULES.md`, `prompts/01-DESIGN-TOKENS.md`, `prompts/03-DESIGN-FIXES.md`, `prompts/02-SCREEN-INDEX.md`, `prompts/BACKEND-KNOWN-ISSUES.md`. Project docs are in `docs/`. Design images are in `prompts/design/`.

- The app must look exactly like the design images. Open the image before coding each screen and write a layout inventory first.
- Only the deviations in `prompts/03-DESIGN-FIXES.md` are allowed.
- No mock data. Sample names and numbers in the images are never shipped.
- Colors and text styles only from theme tokens. No hard-coded hex values outside `core/theme/`.
- After each screen: run at 1440x900 and 375x844, take screenshots (use the browser/preview tooling to capture them), compare with the design image and fix differences.
- Work one stage at a time from `prompts/stages/`. The backend is frozen; report problems in `docs/backend-gaps.md`.
- If information is missing, ask the owner. Do not invent.
- At the end of each stage write `docs/fidelity-report-S{n}.md`.
