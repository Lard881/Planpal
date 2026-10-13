# Screen Index: every image, its route, and the prompt that builds it

Image folders: `design/desktop/` (1920 px wide), `design/mobile/` (750 px wide), 3x originals in `design/original-3x/`. Logo: `design/logo/planpal-logo.png` (also the app icon source).

## Desktop (1440 x 900)

| Image | Screen | Route | Prompt |
|---|---|---|---|
| DesktopLogin.png | Login | `/login` | S04 |
| DesktopSignup.png | Create account | `/signup` | S04 |
| DesktopVerifyemail.png | Check your inbox (6-digit code) | `/verify-email` | S04 |
| DesktopForgotpassword1.png | Reset password, step 1 | `/forgot-password` | S04 |
| DesktopForgotpassword2.png | Reset password, step 2 (enter code) | `/verify-code` | S04 |
| DesktopForgotpassword3.png | Reset password, step 3 (new password) | `/new-password` | S04 |
| DesktopOnboarding.png | Where do you want to start? | `/onboarding/workspace` | S04 |
| DesktopWorkspaceswitcher.png | Workspace switcher popover | (overlay) | S05 |
| DesktopCreateworkspace.png | Create workspace | `/workspace/create` | S05 |
| DesktopJoinwithcode.png | Join with code | `/workspace/join` | S05 |
| DesktopAdminMembers.png | Workspace Settings: Members | `/workspace/:id/members` | S05 |
| DesktopAdminInvitecodes.png | Workspace Settings: Invite codes | `/workspace/:id/invites` | S05 |
| DesktopTasks.png | Tasks table (with bulk bar) | `/tasks` | S07 |
| DesktopTaskdetail.png | Task detail | `/tasks/:id` | S07 |
| DesktopNewtask.png | New Task dialog | `/tasks/new` | S07 |
| DesktopCalendar.png | Calendar (Month) | `/calendar` | S08 |
| DesktopScheduleevent.png | Schedule Event dialog | (dialog) | S08 |
| DesktopDocuments.png | Documents | `/documents` | S09 |
| DesktopDocumenteditor.png | Document editor | `/documents/:id` | S09 |
| DesktopChat.png | Chat (channels, DMs, conversation) | `/chat/:channelId` | S10 |
| DesktopNotifications.png | Notifications | `/notifications` | S11 |
| DesktopSearchresults.png | Search results | `/search?q=` | S12 |
| DesktopAnalytics.png | Analytics | `/analytics` | S13 |
| DesktopHome.png | Home | `/home` | S14 |
| DesktopTeam.png | Team Directory | `/team` | S15 |
| DesktopSettingsProfile.png | Settings: Profile | `/settings/profile` | S15 |
| DesktopSettingsAppearance.png | Settings: Appearance | `/settings/appearance` | S15 |

## Mobile (375 x 844)

| Image | Screen | Route | Prompt |
|---|---|---|---|
| MobileLogin.png | Login | `/login` | S04 |
| MobileSignup.png | Create account | `/signup` | S04 |
| MobileVerifyemail.png | Check your inbox | `/verify-email` | S04 |
| MobileForgotpassword1.png / 2 / 3 | Reset password steps | `/forgot-password` ... | S04 |
| MobileOnboarding.png | Where do you want to start? | `/onboarding/workspace` | S04 |
| MobileWorkspaceswitcher.png | Switch workspace (bottom sheet) | (sheet) | S05 |
| MobileCreateworkspace.png | Create workspace | `/workspace/create` | S05 |
| MobileJoinwithcode.png | Join with code | `/workspace/join` | S05 |
| MobileTasks.png | Tasks list | `/tasks` | S07 |
| MobileTaskdetail.png | Task details | `/tasks/:id` | S07 |
| MobileNewtask.png | New Task (full screen) | `/tasks/new` | S07 |
| MobileCalendar.png | Calendar (Month) | `/calendar` | S08 |
| MobileScheduleevent.png | Schedule Event | (page) | S08 |
| MobileDocuments.png | Documents | `/documents` | S09 |
| MobileDocumenteditor.png | Document editor | `/documents/:id` | S09 |
| MobileChatlist.png | Messages list | `/chat` | S10 |
| MobileChatroom.png | Conversation | `/chat/:channelId` | S10 |
| MobileNotifications.png | Notifications | `/notifications` | S11 |
| MobileSearchresults.png | Search results | `/search?q=` | S12 |
| MobileAnalytics.png | Analytics | `/analytics` | S13 |
| MobileHome.png | Home | `/home` | S14 |
| MobileTeam.png | Team Directory | `/team` | S15 |
| MobileProfile.png | Profile tab | `/profile` | S15 |
| MobileSettings.png | Settings list | `/settings` | S15 |

## Which pages show the navigation (read from the images)

**Mobile bottom bar visible:** Home (Home), Tasks (Tasks), Messages list (Chat), Team (Profile highlighted), Profile (Profile), Settings (Settings), Workspace switcher sheet (over Home).
**Mobile bottom bar hidden (full-screen pages with a back button):** Login/auth, Task details, New Task, Calendar, Schedule Event, Conversation, Documents, Document editor, Analytics, Notifications, Search results, Create workspace, Join with code.

**Desktop sidebar highlight (as drawn):** Home -> Home; Tasks, Task detail, New Task -> Tasks; Calendar, Schedule Event -> Calendar; Chat -> Chat; Documents, Document editor -> Documents; Analytics -> Analytics; Team, Admin Members, Admin Invite codes -> Team; Settings pages -> Settings; Notifications, Search results, Create workspace, Join with code, Workspace switcher -> Home (keep as drawn).
**Desktop without the top bar:** Chat (three panels fill the content area) and Document editor (own header). Auth screens have no sidebar.

## Screens with NO image (build from tokens and components)

Splash, verify/forgot-password errors, Terms and Privacy placeholder, Week and Day calendar views, Event detail, Move-task dialog, label picker/creator, mobile task filter sheet, file preview, chat image viewer, new channel and new DM, channel info, member profile sheet, Settings subpages (Account, Notifications, Security, Workspace, Sync status), Sync status, all banners, all empty/loading/error states, confirm dialogs, Dark theme, tablet layout, context menus, tooltips, keyboard-shortcut overlay.
