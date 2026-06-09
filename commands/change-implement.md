---
description: Implement code strictly according to the change's plan.md, keeping the task checklist updated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-implement** workflow.

Target change-id (optional): $ARGUMENTS

## Steps
1. Locate the active change. If a change-id is given, use it. If omitted: one active change → use it; multiple → list them and ask which.
2. Read `design.md`.
3. Read `plan.md`.
4. Implement strictly according to the plan.
5. Keep task checkboxes in `plan.md` updated as you go.
6. Avoid scope creep.
7. If the plan is wrong, update `plan.md`.
8. If the design is wrong, pause and update `design.md` first.

## Rules
- Do not implement unplanned features.
- Do not silently change stable contracts.
- Do not skip required tests.
- Do not mark a task complete unless implemented and locally checked where possible.
