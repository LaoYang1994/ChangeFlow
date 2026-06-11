---
description: Use when the user explicitly turns a frozen design into an implementation plan + task checklist (plan.md). Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-plan** workflow. Open with: "Running change-plan for …".

Target change-id (optional): $ARGUMENTS

Write the plan for a **zero-context engineer**: assume they don't know this repo. Every task names the exact file(s) and is one action they could do in a few minutes.

## Steps
1. Locate the active change. Id given → use it. Omitted → one active change → use it; multiple → list them and ask which.
2. Read `design.md`; read relevant project files and `docs/CONTRACTS.md` if applicable.
3. If other active changes exist, glance at their `plan.md` "Files to change" and **warn** on likely overlap.
4. Write/update `plan.md` using the template. Tasks live inside `plan.md` — there is no `tasks.md`.

## Rules (rule — why)
- `plan.md` is the source of truth for implementation — keep it accurate as work proceeds, not as an after-the-fact record.
- Each task has a stable ID (`T1`, `T2`, …) and a file path — IDs let `change-implement`/`change-review` reference tasks across edits without renumbering; the path makes the task executable.
- One action per task — a task that bundles several actions invites silent skipping.
- If planning reveals the design is wrong, update `design.md` first — don't plan around a broken design.
- Impact fields are one `none | <details>` line, never Yes/No.

**Next:** the **user** runs `/change-implement`. Stop here — don't start writing code on your own, even if the user approves the plan or asks for tweaks (revising the plan is fine; entering implementation is human-triggered).

## plan.md template
```markdown
# Plan

## Implementation steps
- [ ] T1 — <one concrete action> · `path/to/file`
- [ ] T2 — <one concrete action> · `path/to/other_file`

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
