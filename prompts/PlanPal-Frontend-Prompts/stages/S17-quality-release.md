# S17: Quality, hardening and release (tasks S17.1 to S17.17)

**Before you start:** read the master rules, `docs/00-overview.md` sections 6 and 7, `docs/03-frontend.md` sections 13, 16, 17, `BACKEND-KNOWN-ISSUES.md`, and Stage 17 in `docs/04-task-stages.md`. All earlier stages finished.

## Tasks (follow the stage file; extra detail for the design work)
- **Final visual audit (do this first):** for **every image in `design/`** (27 desktop, 26 mobile) run the app at 1440x900 or 375x844, take a screenshot and compare it with the image. Produce `docs/final-fidelity-audit.md`: one row per image with "matches", or the remaining difference and why (approved fix F1..F30, real-data difference, or open bug). Fix every unapproved difference. Then repeat for Dark and for widths 700 and 900.
- **S17.1 to S17.4 Backend review:** these are backend tasks. Run the existing backend test suite and report; the owner decides about the patch in `BACKEND-KNOWN-ISSUES.md`. Verify the service-role key is only on the server and that every admin-client use has a permission check before it.
- **S17.5 / S17.6** load test and Render cold-start behavior: confirm the app shows "Waking up the server..." and recovers by itself.
- **S17.7 Offline plan:** every row of the offline table in `docs/00-overview.md` section 6.
- **S17.8 Error message test:** create each failure on purpose (Wi-Fi off, server stopped, expired session, forbidden action, rate limit, file too large) and confirm the message names the right cause (internet vs server vs permission).
- **S17.9 Translations:** all five languages complete and reviewed; no English left in the other four; check long German-length words, French and Spanish text do not clip, Chinese and Korean use the right fallback fonts.
- **S17.10 Accessibility:** text scaling to 200%, contrast at least 4.5:1 in both themes (check the `warningText`, `textMuted` and chip colors), mobile tap targets at least 48x48 (the design's 36 px buttons need a larger hit area), semantic labels on icon buttons.
- **S17.11** performance on a low-end Android phone. **S17.12** privacy: Terms and Privacy URLs live (replace the placeholders), account deletion tested end to end. **S17.13** backups. **S17.14** signed Android release build and install test. **S17.15** Windows release build and clean-machine install. **S17.16** README for running, testing and deploying. **S17.17** tag `1.0.0` and write release notes.

## Acceptance checklist
- [ ] `docs/final-fidelity-audit.md` has no unexplained differences.
- [ ] Everything in `docs/04-task-stages.md` is ticked for stages 3 to 17.
- [ ] Both release builds installed and used for 10 minutes without a crash.
