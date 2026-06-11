# Agent Instructions

## Read order
Before starting work, read:
1. `docs/PROJECT.md`
2. `docs/CONCEPTS.md` if domain terms are unclear
3. `docs/CONTRACTS.md` before changing data formats, APIs, metric semantics,
   tensor layouts, alignment logic, or config schemas
4. `docs/experiences/` for relevant distilled lessons
5. `docs/workflows/` before a recurring multi-step task — if an established
   procedure matches, follow it instead of improvising

Do not blind-search `docs/changes/archive/`. Read an archived change only when a
durable doc links to it by ID, or when investigating a regression the durable
docs don't explain.

## Documentation system
Do not create random markdown files. Use only these locations:
- `docs/PROJECT.md`: project overview, repository layout, workflows, feature
  status
- `docs/CONCEPTS.md`: stable domain vocabulary
- `docs/CONTRACTS.md`: stable contracts and hard rules (a living document — add
  rules whenever you discover the need, no active change required)
- `docs/workflows/`: reusable step-by-step procedures for recurring tasks
  ("to do X, first A then B") — one file per procedure
- `docs/changes/active/<YYYY-MM-DD>-<slug>/`: active changes
- `docs/changes/archive/<YYYY-MM-DD>-<slug>/`: completed changes (immutable)
- `docs/experiences/`: reusable lessons, pitfalls, debugging notes

## When to open a change
- A change is human-initiated. Only open a change folder when a `/change-*`
  command is invoked. Never create one on your own.
- If a task would touch a contract, change observable behavior, or need
  validation, *suggest* opening a change before proceeding — but proceed
  without one if the user declines.

## Referencing changes
Refer to a change by its ID (`<YYYY-MM-DD>-<slug>`), never by path. The ID is
immutable. Link to the experience or contract distilled from a change for
long-term references, not to the change folder.

## Change workflow
For a tracked change:
1. `/change-design` — clarify requirements; create/update `design.md`.
2. `/change-plan` — create/update `plan.md` with steps and task checklist.
3. `/change-implement` — implement according to `plan.md`; keep checklist
   updated.
4. `/change-review` — review against `design.md`, `plan.md`, `CONTRACTS.md`;
   record findings in `review.md`.
5. `/change-validate` — required for correctness, performance, metric semantics,
   CUDA/TensorRT, data alignment, or benchmark changes; record commands,
   results, benchmark numbers, manual checks, and known gaps in `validation.md`.
6. `/change-archive` — move the active change folder to archive; update
   `PROJECT.md`, `CONTRACTS.md`, `CONCEPTS.md`, `experiences/`, and `workflows/`
   when needed.

Every `/change-*` command takes an optional change-id. If omitted: one active
change → use it; multiple → ask which.

## Durable knowledge rules
After tracked work, extract only durable learnings. Prefer this order:
1. Add or update a **test or hook** when the lesson can be enforced
   automatically.
2. Update `docs/CONTRACTS.md` when a stable hard rule changed.
3. Add or update `docs/experiences/` when a reusable debugging or implementation
   pattern was learned. Experiences are a holding pen: search before writing,
   update near-matches instead of duplicating, and graduate or prune over time.
4. Add or update `docs/workflows/` when a recurring multi-step procedure is
   worth following next time (a how-to, not a lesson).
5. Update `docs/CONCEPTS.md` only for stable project vocabulary.
6. Update this file only for short, stable, high-frequency rules.

Do not write task summaries, implementation diaries, chat logs, or unverified
ideas into long-term docs.

## Drift
Suggest `/docs-refresh` when you notice drift (random docs, conflicting
experiences or workflows, stale active changes, missing concepts). Run it at
milestones (before a release, after a batch of changes lands).

## Critical rules
<!-- Replace these examples with your project's hard rules, or move enforceable
     ones into tests/hooks. -->
- Missing metric values must not be treated as zero.
- Do not compare benchmark experiments with different `task_type` or
  `gt_version`.
- CUDA/TensorRT changes require correctness tests and benchmark comparison.
- TensorRT plugin `enqueue` must not introduce host-device synchronization.
- MCAP videoclip alignment must use frame-level timestamps when available.
