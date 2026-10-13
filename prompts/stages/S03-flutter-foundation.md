# S03: Flutter foundation (tasks S3.1 to S3.20)

**Before you start:** read `00-MASTER-RULES.md`, `01-DESIGN-TOKENS.md`, `03-DESIGN-FIXES.md`, `docs/03-frontend.md` (sections 2 to 8, 12 to 14, 17), `docs/00-overview.md`, and the Stage 3 list in `docs/04-task-stages.md`. The backend is frozen.

**Open these images first** (the shell, navigation and every shared component appear in them):
`design/desktop/DesktopHome.png`, `DesktopTasks.png`, `DesktopTeam.png`, `DesktopDocuments.png`, `DesktopAnalytics.png`, `DesktopWorkspaceswitcher.png` and `design/mobile/MobileHome.png`, `MobileTasks.png`, `MobileTeam.png`, `MobileProfile.png`, `MobileWorkspaceswitcher.png`.

## Goal
A running app skeleton with the **exact PlanPal look**: theme, fonts, adaptive shell (sidebar / rail / bottom bar), shared components, routing, localization, networking, error handling, connectivity banners, local database and outbox. No feature screens yet: placeholder pages show **real empty states** (never fake content).

## 1. Project and packages (S3.1)
- Create the Flutter project in `app/` (organization and package name as in `docs/00-overview.md` section 11; ask the owner if missing).
- Targets: Android and Windows now. Keep the code free of iOS/macOS blockers (one `platform_info.dart`).
- Packages: `flutter_riverpod`, `go_router`, `supabase_flutter`, `dio`, `drift` (+ `drift_dev`, `build_runner`, `sqlite3_flutter_libs`), `connectivity_plus`, `flutter_secure_storage`, `intl` + `flutter_localizations`, `fl_chart`, `file_picker`, `image_picker`, `cached_network_image`, `flutter_quill`, `url_launcher`, `window_manager`, `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, a **Lucide icon package** for Flutter, `table_calendar` (calendar stage), `mocktail` (dev). Add Firebase and Google sign-in packages in their own stages.
- `core/config/env.dart` reads `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `API_BASE_URL` from `--dart-define`. Never commit secrets.

## 2. Theme and fonts (S3.2, S3.3)
- Copy `code-seeds/app_colors.dart`, `app_text.dart`, `app_theme.dart`, `breakpoints.dart` into `app/lib/core/theme/` and `app/lib/core/layout/`. They hold the **measured** tokens. Fix compile errors for the installed Flutter version. Do not change values.
- Download and bundle fonts into `app/assets/fonts/`: **Inter** (400, 500, 600, 700) and **Noto Sans** (400, 500, 600, 700). Declare them in `pubspec.yaml` as families `Inter` and `NotoSans`.
- Theme mode provider: Light / Dark / System (default System), saved locally, applied live through `MaterialApp.router(themeMode: ...)`. Syncing to `profiles.theme` happens in Stage 15.
- Add a hidden developer-only **theme gallery page** (debug builds only) that shows every token and shared component in Light and Dark. Use it to compare against the images.

## 3. Localization (S3.4, S3.5)
- Flutter gen-l10n with `app_en.arb`, `app_es.arb`, `app_fr.arb`, `app_zh.arb`, `app_ko.arb`. English is the template.
- Start with strings for: app name, navigation labels (Home, Tasks, Calendar, Chat, Documents, Analytics, Team, Settings, Profile), common buttons, the search placeholder "Search tasks, docs, people...", error and banner messages (docs section 13.4), empty-state texts.
- Language provider (device language if supported, else English), switch applies live.
- Add a script or CI check (`tool/check_l10n.dart`) that fails if any key is missing from any of the five files.

## 4. Adaptive shell (S3.6): build it exactly like the images
`core/layout/adaptive_scaffold.dart` chooses by width (under 600 mobile, 600 to 899 tablet, 900+ desktop).

**Desktop (look at DesktopHome.png / DesktopTasks.png):**
- **Sidebar** 240 wide, white (`surface`), 1 px right border. Top: logo mark 36x36 (`design/logo/planpal-logo.png` is the app icon; the in-app mark is the rounded indigo square with a white "P") + "PlanPal" (Inter 20 bold). Below: the **WorkspaceSwitcher card** (white, 1 px border, radius 16, ~56 high: square initial avatar 28 radius 8, workspace name 14 semibold, subtitle 12 muted, chevrons-up-down icon). Then the nav list: Home, Tasks, Calendar, Chat, Documents, Analytics, Team, Settings, each 40 high, radius 12, icon 20 + label 14 medium. Active item = `primarySoft` pill with `primary` icon and text. Bottom: user card (avatar 32, name 14 semibold, **current workspace name** on the second line, see fix F1).
- In the **Personal** workspace hide Chat and Team.
- **Top bar** (not on Chat, Document editor): search field (about 448x40, white, border, radius 12, search icon, placeholder, "Ctrl K" chip), then at the right a 40x40 bell button (red dot when unread) and the user chip (avatar 36, name, real role badge). Content padding 32.
- Page transitions inside the shell must not rebuild the sidebar.

**Mobile (look at MobileHome.png / MobileTasks.png):**
- Bottom bar with 5 tabs: Home, Tasks, Chat, Profile, Settings (icon 24 + label 12). Pages that hide the bar are listed in `02-SCREEN-INDEX.md`; implement a route-level flag `showBottomBar`.
- No top app bar by default; each page draws its own header as in the images.

**Tablet (derived):** a 72 wide navigation rail (icon over label) instead of the sidebar, the same top bar, and right-side panels moved below the main content.

Also create `WorkspaceSwitcher` UI shell only (the data comes in Stage 5; show the current workspace from a provider that is empty until then, with a real loading state).

## 5. Routing (S3.7)
go_router with the full route table from `docs/03-frontend.md` section 7 plus the routes in `02-SCREEN-INDEX.md`. Guards: signed-out -> `/login`; signed-in on `/login` -> `/home`; remembered workspace; deep links. Each placeholder page shows a real empty state with the page title and the shell around it. No fake data.

## 6. Shared components (S3.8): build every one to match the images
Use the recipes in `01-DESIGN-TOKENS.md` section 6. Look at the real usage in the images:
- `PlanPalButton`: primary (Add Task, Log In), outline (Upload File, Copy), soft (Details), danger-outline (Delete Selected, Remove, Revoke), loading state. 44 high in forms, 40 in toolbars, radius 12.
- `PlanPalTextField`: filled `surfaceAlt`, 44 high, label above, error text, password eye toggle, optional leading/trailing icon.
- `OtpField`: 6 or 8 boxes (verify code / invite code).
- `PriorityChip`, `StatusChip`, `LabelChip`, `RoleBadge`, `FileTypeBadge`: colors from the token tables.
- `Avatar` (photo or initials, deterministic color, presence dot), `AppCard`, `SectionHeader`, `QuickActionTile`, `StatCard`, `SegmentedTabs`, `ProgressBar`, `CheckCircle`, `SearchField`.
- `EmptyState`, `ErrorState` (message + "Try again" + "Details" with code and request id and Copy, S3.14), `LoadingSkeleton`.
- `ConnectivityBanner` (S3.13): yellow offline ("You're offline. Your changes are saved on this device and will sync when you're back online."), red server unreachable, orange/indigo "waking up" ("Waking up the server, this can take up to a minute."), green back online ("Back online. Syncing..."). Mobile: below the header; desktop: above the content.
- `SyncStatusChip` ("Waiting to sync 3"), `AppSnackbar` (success, info, error, error with Retry), `ConfirmDialog`.
Each component gets a widget test and appears in the theme gallery.

## 7. Network, errors, connectivity (S3.9 to S3.14)
Follow `docs/03-frontend.md` sections 8.6, 9.2, 13 exactly: `api_client.dart` (dio, base path `/api/v1`, bearer token, long timeout on the first call, retry once on `AUTH_EXPIRED`), `ConnectivityService` (four states with real reachability checks against `GET /health`), `AppFailure` sealed types, `api_error_mapper.dart` for every backend code in `docs/02-backend.md` section 5, `failure_messages.dart` with all texts in five languages, the banner, and the Details link.

## 8. Local database and outbox (S3.15, S3.16)
Drift database on Android and Windows (`sqlite3_flutter_libs`), tables and DAOs as in `docs/03-frontend.md` section 8.2, migrations set up, an `outbox` table, and the base repository pattern (write locally and queue, read streams from Drift).

## 9. Platform setup (S3.17, S3.18)
Android: minSdk 23, permissions, app name "PlanPal", launcher icon from `design/logo/planpal-logo.png`. Windows: `window_manager`, minimum size 900x600, remember size and position, app icon.

## 10. Tests (S3.19, S3.20)
Unit: failure mapper for every code and network case; connectivity state logic. Widget: the shell at widths 375, 700 and 1280 in Light and Dark.

## Acceptance checklist
- [ ] Theme gallery matches the token tables (colors, chips, avatars, buttons, fields).
- [ ] Desktop shell at 1440x900 matches `DesktopHome.png` (sidebar, switcher card, nav, user card, top bar) with an empty page body.
- [ ] Mobile shell at 375x844 matches the bottom bar and header of `MobileHome.png`.
- [ ] Light and Dark both work; tablet rail works at 700.
- [ ] Language switch works live for all five languages; l10n check passes.
- [ ] `flutter analyze` clean; tests pass.
- [ ] `docs/fidelity-report-S3.md` written.
