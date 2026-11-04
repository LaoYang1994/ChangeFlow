---
description: Use when the user explicitly turns a frozen design into an implementation plan + task checklist (plan.md). Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-plan** workflow. Open with: "Running change-plan for …".

Target change-id (optional): $ARGUMENTS

Write the plan for a **zero-context engineer**: assume they don't know this repo. Every task names the exact file(s) and is one action they could do in a few minutes.

## Steps
1. Locate the active change. Id given → use it. Omitted → one active change → use it; multiple → list them and ask which.
   A change's docs live in its worktree once implementation has started (`.worktrees/<change-id>/docs/changes/active/<change-id>/`), otherwise in the current tree. Look in the current tree **and** in every worktree (`git worktree list`); if the same id exists in both, the worktree copy is the live one. Read and write the change's docs there.
2. Read `design.md` — if its `Status` isn't `frozen (...)`, STOP and ask the user to approve it first (don't plan against a draft). Then read relevant project files and `docs/CONTRACTS.md` if applicable.
3. If other active changes exist (in the current tree or any worktree), glance at their `plan.md` "Files to change" and **warn** on likely overlap.
4. Write/update `plan.md` using the template, with `Status: draft`. Tasks live inside `plan.md` — there is no `tasks.md`.
5. When the user approves the plan, set `Status: frozen (<today>)`. Approval only freezes the plan; it does not start implementation.

## Rules (rule — why)
- `plan.md` is the source of truth for implementation — keep it accurate as work proceeds, not as an after-the-fact record.
- Each task has a stable ID (`T1`, `T2`, …) and a file path — IDs let `change-implement`/`change-review` reference tasks across edits without renumbering; the path makes the task executable.
- One action per task — a task that bundles several actions invites silent skipping.
- If planning reveals the design is wrong, update `design.md` first (it goes back to `draft` until the user re-approves) — don't plan around a broken design.
- Impact fields are one `none | <details>` line, never Yes/No.
- Don't let an auto-formatter touch `plan.md` — its checkboxes are state, not prose; exclude `docs/changes/` from mdformat/prettier, and toggle a box by matching its stable `T#`, not by position.

**Next:** for a non-trivial change, the **user** may first run `/change-plan-review` (pre-build gate). Then the **user** runs `/change-implement`. Stop here — don't start writing code on your own, even if the user approves the plan or asks for tweaks (revising the plan is fine; entering implementation is human-triggered).

## plan.md template
```markdown
# Plan

Status: draft   <!-- draft | frozen (YYYY-MM-DD) | stale. Only the user's approval freezes it. -->

## Implementation steps
- [ ] T1 — <one concrete action> · `path/to/file`
- [ ] T2 — <one concrete action> · `path/to/other_file`

## Files to change
- `path/to/file`: planned change
- `path/to/other_file`: planned change

## Tests
Tests this change needs — one line each, or `none — <why>`. Anything that must be written or run is also a `T#` task above.
- Unit:
- Integration:
- Benchmark / performance:
- Manual:

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
