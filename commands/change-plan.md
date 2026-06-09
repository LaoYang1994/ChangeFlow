---
description: Turn a frozen design into a concrete implementation plan and task checklist in plan.md.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-plan** workflow.

Target change-id (optional): $ARGUMENTS

## Steps
1. Locate the active change. If a change-id is given, use it. If omitted: one active change → use it; multiple → list them and ask which.
2. Read `design.md`.
3. Read relevant project files.
4. Read `docs/CONTRACTS.md` if applicable.
5. If other active changes exist, glance at their `plan.md` "Files to change" and **warn** if this plan is likely to overlap.
6. Produce a concrete implementation plan.
7. Write/update `plan.md` using the template below. There is no separate `tasks.md` — tasks live inside `plan.md`.

## Rules
- `plan.md` is the source of truth for implementation.
- Update task checkboxes as work progresses.
- If planning reveals a design change, update `design.md` first.
- Impact fields use a single `none | <details>` line, never Yes/No checkboxes.

## plan.md template
```markdown
# Plan

## Implementation steps
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Files to change
- `path/to/file`: planned change
- `path/to/other_file`: planned change

## Tests
- [ ] Unit tests
- [ ] Integration tests
- [ ] Benchmark or performance tests
- [ ] Manual validation

## Contract updates
none | which rule in docs/CONTRACTS.md needs updating, and how

## Project updates
none | what feature status in docs/PROJECT.md needs updating

## Experience updates
none | what reusable lesson may need capturing

## Risks
Known risks.

## Rollback plan
How to revert or mitigate if this change fails.
```
