# S04: Authentication and onboarding (tasks S4.1 to S4.14, S4.16; S4.15 is backend)

**Before you start:** read the master rules, tokens, fixes, `docs/03-frontend.md` section 9 and 13, `docs/02-backend.md` sections 6.1, 7, 6.16, and Stage 4 in `docs/04-task-stages.md`. Stage 3 must be finished.

**Open these images first:**
Desktop: `DesktopLogin.png`, `DesktopSignup.png`, `DesktopVerifyemail.png`, `DesktopForgotpassword1.png`, `DesktopForgotpassword2.png`, `DesktopForgotpassword3.png`, `DesktopOnboarding.png`.
Mobile: `MobileLogin.png`, `MobileSignup.png`, `MobileVerifyemail.png`, `MobileForgotpassword1.png`, `MobileForgotpassword2.png`, `MobileForgotpassword3.png`, `MobileOnboarding.png`.

## Layout specs (build exactly like the images)

### Login (`/login`)
- **Desktop:** two equal halves. **Left half** (`background` #F7F7FB): a 448 wide form column, vertically centered, left offset 136. From the top: logo mark 36 + "PlanPal"; title **"Welcome back"** (Inter 32 bold); subtitle **"Log in to pick up where you left off."** (muted); label "Email" + field; label "Password" + field with eye icon; right-aligned link **"Forgot password?"**; full-width primary button **"Log In"** (44); divider with the word **"or"**; outline button **"Continue with Google"** (official Google G, fix F14); centered text **"New here? Create account"** (link on "Create account"). **Right half:** soft gradient `#EEEFFF` to `#EDE9FE`, centered white card (radius 24, soft shadow, about 384 wide) containing an avatar, a headline line, a subline and three task pills (static decorative art, fix F18), and under the card the bold line **"Calm days, done tasks."** with the muted sentence **"PlanPal keeps tasks, calendar and chat in one friendly place."**
- **Mobile:** no card, single column on `background`: centered logo + "PlanPal", title "Welcome back" (24), subtitle "Log in to keep the day on track.", same fields and buttons, and the "New here? Create account" line pinned to the bottom. Page padding 16.

### Create account (`/signup`)
- **Desktop:** left half form (same column width), right half solid purple gradient `#5A4AE8` to `#7554EF` with white text **"Teamwork, minus the chaos."** (Inter bold ~36, two lines), subtitle **"Tasks, calendar, chat, docs and insights — designed to feel calm."** and three white pills with icons: Tasks, Calendar, Chat. Form: title **"Create your account"**, fields Full name, Email, Password, Confirm password (each with eye toggle where drawn), checkbox row **"I agree to the Terms and Privacy Policy"** (Terms and Privacy Policy are links to the Terms and Privacy placeholder pages), primary **"Create Account"**, divider "or", **"Continue with Google"**, **"Have an account? Log in"**.
- **Mobile:** single column, same content, title "Create your account", bottom line "Have an account? Log in".

### Check your inbox (`/verify-email`)
- **Desktop:** centered white card (radius 24, soft shadow, about 440 wide) on `background`, logo above the card. Title **"Check your inbox"**, text **"We sent a 6-digit code to {email}"** (the real email), 6 boxes, primary **"Verify"**, **"Didn't get it? Resend code"** (30 second cooldown with a countdown). Filled boxes: `primarySoft` fill with 1.5 px `primary` border; empty boxes `surfaceAlt`.
- **Mobile:** same without the card; text "Code sent to {email}".

### Reset password, 3 steps (`/forgot-password`, `/verify-code`, `/new-password`)
- A row of three small chips "Step 1 of 3", "Step 2 of 3", "Step 3 of 3": the current step is `primarySoft` with `primary` text, the others `surfaceAlt` muted (mobile shows just the current chip, centered).
- Step 1: title **"Reset password"**, text "Enter the email linked to your account.", field Email, primary **"Send Code"**, link **"Back to log in"**.
- Step 2: title **"Enter code"**, text "6-digit code sent to your email.", 6 boxes, primary **"Continue"**, "Didn't get it? Resend code".
- Step 3: title **"Set new password"**, fields "New password" and "Confirm new password", primary **"Save New Password"**.
- Desktop: centered card like Verify; mobile: plain page.

### Where do you want to start? (`/onboarding/workspace`)
- **Desktop:** no sidebar; centered logo + "PlanPal"; title **"Where do you want to start?"** (Inter 32 bold); subtitle **"You can always switch or create more later."**; two cards side by side (about 280 wide, white, radius 20): card 1 icon tile + **"Continue with my Personal workspace"** + "A calm private space for your own tasks and notes." + link **"Continue ->"**; card 2 violet icon tile + **"Create or join a team"** + "Invite teammates, share tasks and chat together." + link **"Get started ->"**. Under them a muted **"Skip for now"**. (The image shows card 1 slightly raised: treat that as the hover state.)
- **Mobile:** title on two lines, two stacked full-width cards (**"My Personal workspace"** / "Private tasks and notes."; **"Create or join a team"** / "Share work with others."), **"Skip for now"** pinned at the bottom.

## Behavior (from the docs)
- Validation with localized messages: email format, password 8+ characters, passwords match, Terms checkbox required. Show errors under the field, not as a dialog.
- Email + password sign-up and login through Supabase Auth; email confirmation with the 6-digit code; resend cooldown 30 s (S4.4, S4.5).
- Forgot password: request code -> verify code -> set new password (S4.6). Use Supabase OTP as in `docs/02-backend.md` section 7.
- Google: Android native token flow (S4.7); Windows browser flow with loopback redirect (S4.8). Ask the owner for the OAuth client IDs if they are missing; do not invent them.
- Map **every** Supabase auth error to an `AppFailure` and a localized message (S4.9): wrong credentials, unconfirmed email, user exists, weak password, rate limited, network. Never blame the user for server problems.
- Splash + session restore (`/splash`): works offline if a session exists (S4.10).
- After login: `GET /me`, apply the saved theme and language, set the current workspace (remembered or personal), start the first sync (S4.11). Show onboarding only on the **first** login (S4.12).
- Sign out: clear the local database and secure storage and remove the device token (S4.13). Session expired: refresh once, else sign out with the message "Your session has expired. Please log in again." on the login page (S4.14).
- **S4.15 (backend `DELETE /me`) is already built:** only verify that it exists. The UI for it comes in Stage 15.
- Terms and Privacy pages: simple placeholder pages with the text "These documents are coming soon." until the owner provides URLs.

## Acceptance checklist
- [ ] Each of the 14 images compared side by side with the running screen (desktop 1440x900, mobile 375x844).
- [ ] Microsoft button does not exist anywhere; Google button uses the official logo.
- [ ] All 6-box and 8-box inputs: paste works, backspace moves back, only digits (6-digit) accepted.
- [ ] Every auth error shows a specific localized message.
- [ ] Offline start with an existing session works; sign-out wipes local data.
- [ ] Light and Dark both verified; tablet width verified.
- [ ] Tests for each auth error mapping and the offline start (S4.16).
- [ ] `docs/fidelity-report-S4.md` written.
