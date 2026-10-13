# Backend Known Issues (found while preparing these prompts)

**Status: NOT fixed.** The owner said the backend stays unchanged for now. A tested patch is ready in `backend-fixes/backend-fixes.patch`. **Do not apply it unless the owner says so.**

## What is wrong

Several routes call database (SQL) functions with names or parameters that do not exist in the migrations. The calls fail, and some routes hide the failure, so the app would receive **empty data instead of an error**. The existing tests did not catch this because they only check permissions, and the database-backed tests are skipped when test credentials are missing.

| Feature | File | Problem | Effect for the app |
|---|---|---|---|
| Global search | `src/routes/search.js` | Calls `search_all` with `p_workspace_id` (SQL expects `p_workspace`). Also reads `entity_type` / `entity_id`, but the SQL returns `kind` / `id`, so every result would be dropped | Search always empty or error |
| Analytics page | `src/routes/analytics.js` | Calls `analytics_by_category`, `analytics_daily_completion`, `get_completion_streak` (SQL names are `analytics_categories`, `analytics_daily`, `analytics_streak`); passes `p_workspace_id` and `p_range` (SQL expects `p_workspace`, `p_from`, `p_to`); errors ignored | Empty charts and zero stats, no error |
| Export CSV | same | `requireRole('admin', 'full')`: "full" is not a role, so members get 403; also uses columns that do not exist | Export fails for members |
| Home overview | same | Same wrong function names; the "completed" count is all-time, not for the chosen range | Empty chart, wrong number |
| Start a Direct Message | `src/routes/channels.js` | Calls `get_or_create_dm` with `p_workspace_id` / `p_other_user_id` (SQL expects `p_workspace` / `p_other`); the function returns only an id but the route returns it as `channel` | DM creation fails |
| Move task to another workspace | `src/routes/tasks.js` | Calls `move_task_to_workspace` with `p_task_id` / `p_target_workspace_id` (SQL expects `p_task` / `p_target`); function returns nothing but the route returns `{ task }` | Move fails |
| Task priority and status values | `src/routes/tasks.js` | The API validation accepts priority `urgent` and status `backlog`, but the database only allows `high`, `medium`, `low` and `todo`, `in_progress`, `completed` | Sending those values fails with a database error. The Flutter app must only ever send the database values |

## What the patch does
Fixes the names and parameters, removes the two values the database does not accept from the task validation, converts the range (`7d`, `30d`, `90d`, `week`) to the `from`/`to` values the SQL needs, reads the first row of table results, throws real errors instead of hiding them, fixes the CSV role check, returns the real channel / task after DM and move, and adds `summary.changeVsPrevious` (percent change in completed tasks vs the previous period, or `null` when there was no previous data).

Verified so far: it applies cleanly to the current backend and every changed file passes a Node syntax check. **It has not been run against a live database** (no network in the environment where it was prepared), so run `npm test` with test database credentials after applying it.

To apply later (from the backend folder): `patch -p1 < ../backend-fixes/backend-fixes.patch`

## What the Flutter work must assume
Build the Flutter screens against the **documented response shapes below** (the shapes the patched backend returns). Until the patch is applied, Search, Analytics, Home overview, DM creation and Move task will not work end to end. Build the screens and their states anyway, and test them against the patched backend.

### Response shapes (after the patch)

`GET /search?q=&workspaceId=&type=` ->
`{ counts: { all, task, document, person }, results: [ { kind: 'task'|'document'|'person', id, workspace_id, title, subtitle, score, at } ] }`
(`subtitle` = priority for tasks, `kind` for documents, email for people; `at` = due date or updated time; `score` is a ranking number, **not** a percentage. Convert it for display, see S12.)

`GET /workspaces/:id/analytics?range=7d|30d|90d` ->
`{ summary: { completed, in_progress, overdue, avg_completion_days, completed_prev, on_time_rate, changeVsPrevious }, weekly: [ { weekday (1=Mon..7=Sun), completed } ], categories: [ { label, color, total } ], daily: [ { day, completed } ], streak }`

`GET /workspaces/:id/overview?range=week|7d|30d` ->
`{ counts: { completed, inProgress, overdue }, productivityPercent, dailySeries: [ { day, completed } ] }`

`POST /workspaces/:id/dms` -> `{ channel: { id, workspace_id, kind, ... } }`
`POST /tasks/:id/move` -> `{ task: { ... } }`
`GET /workspaces/:id/analytics/export.csv?range=` -> CSV text with header `Date,Completed Tasks`.
