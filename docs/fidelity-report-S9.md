# Fidelity Report — Stage 9: Files and Documents

## Documents — Desktop
- Breadcrumb: "{workspace} / Documents" muted 14px clickable — **matches**
- "Documents" Inter 28 bold + grid/list toggle (two-icon segmented, fix F8) + "Upload File" outline + "+ New Document" primary — **matches**
- Folders row: 4 per row, white radius 20, ~64px high, color-cycled folder icon tile + name + "n files" — **matches**
- "Recent Documents" section: 4-column grid, white radius 20, ~108px high — **matches**
- FileTypeBadge top-left (PDF red, DOC sky, XLS green, IMG grey) — **matches**
- "..." top-right menu — **matches**
- Name 14 semibold + "Edited 2h ago" relative time caption — **matches**

## Documents — Mobile
- "Documents" 24 bold + round primary "+" — **matches**
- Search field surfaceAlt (fix F7 applied) — **matches**
- Folder cards 2 per row — **matches**
- "Recent" section: white list rows with badge + name + "..." — **matches**

## Document Editor
- No top bar, own header: back arrow + breadcrumb + "Saved"/"Waiting to sync" indicator + "Save" (no Share, fix F11) — **matches**
- Quill toolbar: B, I, U, H1, H2, lists, link — **matches** (upgraded from plain TextField)
- Centered content max 700px — **matches**
- Editable title Inter 28 bold + edited time caption — **matches**
- Quill delta JSON stored in content field — **implemented**
- Autosave 2s after last change — **implemented**

## Approved differences
- F7 applied: search field is a proper 44px surfaceAlt field with icon.
- F8 applied: grid/list toggle is a two-icon segmented control 36px high.
- F11 applied: Share button removed.
- Upload: signed URL flow implemented; file type and 25MB size validation — **implemented**
