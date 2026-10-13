# Fidelity Report — Stage 4: Auth and Onboarding

## Login (`/login`)

### Mobile
- Logo centered, "Welcome back" Inter 24 bold, muted subtitle — **matches**
- Email + Password fields with eye toggle — **matches**
- Right-aligned "Forgot password?" link — **matches**
- Full-width primary "Log In" button — **matches**
- "or" divider + Google button with official G logo (fix F14 applied) — **matches**
- "New here? Create account" pinned bottom — **matches**

### Desktop
- Left half: form column 448px wide, vertically centered — **matches**
- Right half: EEEFFF→EDE9FE gradient, white decorative card with task list (fix F18) — **matches**
- "Calm days, done tasks." bold + muted subtitle — **matches**

## Signup (`/signup`)
- Mobile: logo, "Create your account", 4 fields + terms checkbox + buttons — **matches**
- Desktop: left form, right purple gradient (#5A4AE8→#7554EF) with white pills — **matches**
- Terms checkbox required validation — **matches**

## Verify Email (`/verify-email`)
- 6 OTP boxes: surfaceAlt empty, primarySoft filled with 1.5px primary border — **matches**
- 30s resend cooldown with countdown — **matches**
- Desktop: centered white card with logo above — **matches**

## Forgot Password (3 steps)
- Step indicator chips: current = primarySoft/primary, others = surfaceAlt/muted — **matches**
- Mobile shows only current step centered — **matches**
- Desktop: centered white card — **matches**

## Onboarding (`/onboarding/workspace`)
- Mobile: two stacked cards with icon + title + subtitle — **matches**
- Desktop: side-by-side cards 280px wide — **matches**
- "Skip for now" pinned bottom — **matches**

## Approved differences
- Google Sign-In button shows the icon but OAuth not wired (needs google-services.json from owner).
- Microsoft button does not exist anywhere — **correct per spec**.
