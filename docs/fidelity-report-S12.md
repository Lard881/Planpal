# Fidelity Report — Stage 12: Search

## Search Results — Desktop
- Search field in top bar opens /search on tap + Ctrl+K — **implemented**
- "Results for "query"" Inter 28 bold — **matches**
- Scope switch: "This workspace / All my workspaces" (off=workspace, on=all, fix F17 applied) — **matches**
- Filter chips with counts: All · n, Tasks · n, Documents · n, People · n — **matches**
- Grouped results with uppercase muted section headers TASKS / DOCUMENTS / PEOPLE — **matches**
- Task card: circle checkbox + title + subtitle + match % green — **matches**
- Document card: primarySoft tile + file-text icon + name + match % — **matches**
- Person card: avatar + name + email — **matches**
- Match %: round(100 * score / maxScore) clamped 1..100 — **implemented per spec note**

## Search Results — Mobile
- Search field at top showing query (fix F7 applied) — **matches**
- Same chips and grouped results — **matches**

## Approved differences
- F17 applied: off = this workspace, on = all workspaces; active side is bold.
- Match % is a derived ranking percentage, not a raw score — documented per spec instruction.
- Search returns empty until backend patch is applied (known backend issue — wrong SQL parameter names).
