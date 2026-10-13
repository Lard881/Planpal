# Fidelity Report — Stage 10: Chat

## Chat — Desktop
- Two white panels (radius 24) with small gap filling content area — **matches**
- Left panel: team workspace name as title (fix F5 applied), "Channels" label + rows with # prefix — **matches**
- Channel rows: 40px, radius 12, selected = primarySoft, red unread badge — **matches**
- DM rows: avatar 24 + name, indigo unread badge (fix F22 applied) — **matches**
- Right panel: "# design" + "n members" caption, search + members icons — **matches**
- Messages: others left (avatar 36 + name/time caption + background-tinted bubble), own right (primary bubble) — **matches**
- Sending: clock icon indicator — **matches**
- Failed: "Tap to retry" text, retry on tap, same client ID — **implemented**
- Composer: paperclip + field "Message..." + send button (40px primary radius 12) — **matches**

## Chat — Mobile List
- "Messages" Inter 24 bold — **matches**
- Search field "Search chats..." — **matches**
- Conversation cards: avatar 44 circle, name 14 semibold, last message preview, indigo unread pill — **matches**
- FAB "+" for new channel/DM — **matches**

## Conversation — Mobile
- Back button + channel name + search/members icons (no phone/video, fix F6) — **matches**
- Messages same as desktop — **matches**
- Composer pinned bottom — **matches**

## Personal workspace
- Shows explanation screen with "Create or join a team workspace" button — **matches spec**

## Approved differences
- F5 applied: left panel title = team workspace name (not "Acme Studio" hardcoded).
- F6 applied: phone/video icons removed, search and members icons instead.
- F22 applied: channel unread = red, DM unread = indigo.
- DM creation will fail until backend patch is applied (known issue documented).
