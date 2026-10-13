# S10: Chat, real-time (Flutter tasks S10.8 to S10.19)

**Before you start:** read the master rules, tokens, fixes (F5, F6, F22), `docs/03-frontend.md` sections 10.7 and 11, `docs/02-backend.md` section 6.7, Stage 10 in `docs/04-task-stages.md`. Stages 3 to 9 finished.
**Backend tasks S10.1 to S10.7 are already built:** verify `GET/POST /workspaces/:id/channels`, `/channels/:id/members`, `/channels/:id/messages`, `/messages/:id`, `/channels/:id/read`. **`POST /workspaces/:id/dms` is affected by a known backend issue** (`BACKEND-KNOWN-ISSUES.md`): build the UI now, test DMs after the owner applies the patch. Chat is **team workspaces only**; Personal returns `CHAT_NOT_AVAILABLE_IN_PERSONAL`.

**Open these images first:** `design/desktop/DesktopChat.png`; `design/mobile/MobileChatlist.png`, `MobileChatroom.png`.

## Layout specs

### Chat, desktop (`/chat`, `/chat/:channelId`)
No top bar: two white panels (radius 24) fill the content area with a small gap.
- **Left panel (about 248 wide):** title = the **team workspace name** (Inter 16 semibold, fix F5). Section label **"Channels"** (12 muted), rows **"# design"** etc. (40 high, radius 12; selected = `primarySoft`) with a **red** unread count badge (`danger`, white number, fully rounded) at the right. Section **"Direct Messages"**: rows with avatar 36 + presence dot + name 14, and an **indigo** unread badge (fix F22). A "+" action opens New channel / New DM.
- **Right panel:** header with **"# design"** (Inter 16 semibold) and **"8 members"** (caption), icons at the right: search and members (opens channel info: description, member list, Add members, Leave channel). Divider.
- **Messages:** others on the left: avatar 36, line **"Leo Park · 10:02 AM"** (caption), then a bubble (`background`-tinted with a 1 px border, radius 16). Your own messages on the right: **"You · 10:05 AM"** and an indigo bubble (`primary`, white text, radius 16). **Image message:** a card with a thumbnail and the file name (tap opens the full-screen image viewer). **File message:** `FileTypeBadge` + "release-notes.pdf · 840 KB" + download icon. **Typing indicator:** avatar + small bubble "... Sofia is typing...". Add date dividers (derived) and message states: **sending** (clock), **sent**, **failed** (red "Tap to retry").
- **Composer:** paperclip icon, filled text field **"Message #design..."** (radius 12), emoji icon, and a 40 primary square send button (radius 12). Enter sends, Shift+Enter new line.
- Message actions menu: **Copy, Edit, Delete** (own messages; admins can delete any).

### Messages, mobile (`/chat`, bottom bar visible, Chat tab)
- Title **"Messages"** (Inter 24 bold) with a bell at the right. Search field **"Search chats..."**. Conversation cards (white, radius 20): avatar 44 (channels: the first letter in a colored circle; DMs: initials), name 14 semibold, last message preview caption (**"#design · Leo: new flow is ready"** for channels), time at the right, and an **indigo** unread pill. Floating "+" button (new channel / new DM).
- **Conversation** (`/chat/:channelId`, no bottom bar): header with back arrow, avatar 36, name 14 semibold and **"3 online"** in `success` green; at the right **search and members icons** (**not** phone/video, fix F6). Messages as on desktop; composer pinned at the bottom: paperclip, field **"Message..."**, 40 round primary send button.

### Personal workspace
The Chat tab / sidebar item is hidden on desktop; on mobile the tab shows an explanation with a button **"Create or join a team workspace"** (docs section 5).

## Flutter tasks
S10.8 repository (Drift keeps the **last 200** messages per channel; outbox for sends) . S10.9 Supabase Realtime subscriptions for messages and channel membership with reconnect recovery (fetch missed messages) . S10.10 desktop split view . S10.11 mobile list + conversation . S10.12 composer states (client-generated message `id`; sending, sent, failed + retry) . S10.13 file and image sending with progress and inline preview (ask the backend for a download URL per image and cache it) . S10.14 new channel dialog (name, description, private switch, member picker) and new DM picker . S10.15 presence (online/away, Realtime presence) and typing indicator . S10.16 unread badges and mark-as-read (`POST /channels/:id/read`) when visible . S10.17 message actions and `@mentions` (`@[Full Name](user:<uuid>)`) . S10.18 offline reading and queued sending . S10.19 manual test with two real devices: live chat, airplane mode on one, send, reconnect, delivered.

## Acceptance checklist
- [ ] Three images match at both sizes (except F5, F6).
- [ ] Two devices exchange messages live; a failed send shows "Tap to retry" and retry does not duplicate (same `id`).
- [ ] Private channels and DMs are invisible to non-members (verify with a second account).
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S10.md` written.
