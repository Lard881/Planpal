# S09: Files and Documents (Flutter tasks S9.8 to S9.17)

**Before you start:** read the master rules, tokens, fixes (F7, F8, F11), `docs/03-frontend.md` section 10.8, `docs/02-backend.md` sections 6.8 and 6.9, Stage 9 in `docs/04-task-stages.md`. Stages 3 to 8 finished.
**Backend tasks S9.1 to S9.7 are already built:** verify `POST /workspaces/:id/files/upload-url`, `GET /files/:id/download-url`, `DELETE /files/:id`, folders (`GET/POST /workspaces/:id/folders`, `PATCH/DELETE /folders/:id`), documents (`GET/POST /workspaces/:id/documents`, `GET/PATCH/DELETE /documents/:id`). Files never go through Express: upload straight to the signed URL.

**Open these images first:** `design/desktop/DesktopDocuments.png`, `DesktopDocumenteditor.png`; `design/mobile/MobileDocuments.png`, `MobileDocumenteditor.png`.

## Layout specs

### Documents, desktop (`/documents`, `/documents/folder/:id`)
- Breadcrumb (muted, 14): **"{workspace name} / Documents"** (inside a folder: "... / Documents / {folder}"); each part is clickable.
- Title **"Documents"** (Inter 28 bold). At the right: a **grid/list toggle** (fix F8, two-icon segmented control, 36 high), outline **"Upload File"** (upload icon) and primary **"+ New Document"**.
- **Folders row:** up to 4 cards per row (white, radius 20, about 64 high): a 40 icon tile with a folder icon (tile colors cycle: `primarySoft`, `violetSoft`, `skySoft`, a soft amber), the folder name 14 semibold and **"{n} files"** caption. "New folder" lives in the "+ New Document" menu (New document / New folder).
- **"Recent Documents"** (Inter 20 semibold): grid of 4 columns of cards (white, radius 20, about 108 high): top-left a `FileTypeBadge` pill (**PDF** red, **DOC** sky, **XLS** green, **IMG** grey, other **FILE** grey), top-right a "..." menu, the name 14 semibold, and **"Edited 2h ago"** caption (relative time, localized). Written documents show the **DOC** badge. Use `GET .../documents?recent=true` (latest 12).
- Item menu: **Open, Rename, Move, Download, Delete** (Delete asks for confirmation; permissions per role).
- **List view:** rows with badge, name, folder, updated, size, "..." (derived).
- Windows: **drag and drop** files onto the page: show a dashed highlighted drop area. Upload shows a progress card (name, progress bar, cancel, retry on failure).
- Empty state: "No documents yet" with "Upload File" and "New Document" buttons.

### Document editor, desktop (`/documents/:id` for written documents)
- No top bar. Own header row: back arrow, breadcrumb **"Documents / {title}"**, and at the right the primary **"Save"** button plus a small "Saved" / "Waiting to sync" indicator. **Do not build "Share"** (fix F11).
- A centered toolbar card (about 700 wide): **B, I, U | H1, H2 | bulleted list, numbered list | link** icons (active format = `primarySoft`).
- Below, a centered white card (about 700 wide, radius 20): the document **title** (Inter 28 bold, editable), a muted line **"Edited {relative time} by {author} · {workspace}"**, and the rich-text body (`flutter_quill`; links shown in `primary` with a link icon).
- Autosave 2 s after the last change to Drift + outbox; "Save" forces it. Last write wins.

### Documents, mobile (`/documents`, no bottom bar)
- Title **"Documents"** (24 bold) with a 36 round primary **"+"** at the right (menu: New document, Upload file, New folder). Search field **"Search files..."** (fix F7). Folder cards two per row (icon + name + "{n} files"). Heading **"Recent"** (Inter 20 semibold). Rows: white cards (radius 20) with badge, name and "..." menu.
- **Mobile editor:** header with back arrow, the document title (truncated) and a small primary **"Save"**; below it a toolbar row **B, I, U, H2, list, link**; then the title (Inter 24 bold) and the body.

### File preview (no image)
Images open in a full-screen viewer with zoom; PDFs open in an in-app viewer with page controls; other files open with the system app (`url_launcher`). Online only; offline shows the localized message.

## Flutter tasks
S9.8 upload service (progress, cancel, retry, **25 MB limit**, allowed types, clear messages for `FILE_TOO_LARGE` and `FILE_TYPE_NOT_ALLOWED`) . S9.9 Documents screen . S9.10 Upload File + Windows drag and drop . S9.11 create/rename/move/delete folders and documents (delete folder only when empty; show `FOLDER_NOT_EMPTY`) . S9.12 written editor with `flutter_quill` (store Quill delta JSON in `content` and plain text in `contentText`) . S9.13 file preview . S9.14 attach files to tasks using this service (hook into Stage 7) . S9.15 offline: cached lists, uploads disabled with explanation, written documents editable offline and queued . S9.16 empty/loading/error states and badges . S9.17 manual test: a 20 MB upload on mobile data succeeds; a 30 MB file is rejected with the right message.

## Acceptance checklist
- [ ] Four images match at both sizes (except F7, F8, F11).
- [ ] A written document edited offline syncs after reconnect with no lost text.
- [ ] Guests see only what the permission table allows.
- [ ] Light/Dark and tablet verified. `docs/fidelity-report-S9.md` written.
