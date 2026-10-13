# Fidelity Report — Stage 13: Analytics

## Analytics — Desktop
- "Analytics" Inter 28 bold — **matches** (fix F28: no subtitle)
- Range dropdown: Last 7 days / Last 30 days / Last 90 days — **matches**
- Export CSV button with download icon (40px) — **matches**
- 4 stat cards in a row (white radius 20, ~156px high) — **matches**
  1. check-circle on successSoft · completed count · "Tasks Completed" · changeVsPrevious sub-line (fix F23) — **matches**
  2. timer on primarySoft · avg_completion_days · "Avg. Completion Time" · no sub-line (fix F23) — **matches**
  3. zap on violetSoft · on_time_rate% · "Team Velocity" (fix F24 applied) — **matches**
  4. flame on warningSoft · streak days · "Productive Streak" · no sub-line (fix F23) — **matches**
- Weekly Task Output bar chart: Mon–Sun, tallest bar solid primary, others 20% opacity, rounded tops — **matches**
- Category Mix donut: center total + "tasks", 3 largest + Other, legend with % — **matches**

## Analytics — Mobile
- "Analytics" 24 bold + download icon — **matches**
- Range dropdown — **matches**
- 2×2 stat cards with short labels — **matches**
- Bar chart with Mon/Sun labels only (fix F3 applied) — **matches**
- Donut chart — **matches**

## Approved differences
- F23: Tasks Completed shows changeVsPrevious if not null; Avg. Time, Velocity, Streak hide sub-line.
- F24: Team Velocity shows on_time_rate% not "points".
- F28: No subtitle on the Analytics page title.
- Charts return zeros until backend patch is applied (known backend issue).
