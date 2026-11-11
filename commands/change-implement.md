---
description: Use when the user explicitly implements a change's plan.md. Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-implement** workflow. Open with: "Running change-implement for …".

Target change-id (optional): $ARGUMENTS

> **IRON LAW: NO IMPLEMENTATION OUTSIDE THE FROZEN DESIGN + PLAN.**
> Improvising past the plan is how scope creep and unreviewable changes happen. If reality contradicts the plan, STOP and fix the plan (or design) first.

## Pre-gate
Locate the change first (Steps, 1). Confirm `design.md` and `plan.md` exist and **both** carry `Status: frozen (...)`. If either is missing, `draft` or `stale`, STOP and say which one needs (re)approval via `/change-design` or `/change-plan` — do not start coding, and never set `frozen` yourself (only the user's approval does). A legacy change with no `Status:` line: ask the user to confirm it is frozen, then add the line.

## Working tree checks (when the change lives in a worktree)
Where a change lives (`.worktrees/<change-id>/` vs. the current tree) was decided once at `/change-design` — do not ask again or move files between trees. If the change lives in `.worktrees/<change-id>/`:
- Do **all** code work, test writing, and `design.md`/`plan.md` (`T#` checkbox) updates inside `.worktrees/<change-id>/`.
- **Base-drift check:** if the default branch (`main`/`master`) has commits ahead of the worktree's `HEAD`, tell the user how many commits behind it is so they can rebase/merge before coding if they want — ChangeFlow never commits, rebases, merges, or pushes on its own.
- **Untracked runtime environment:** a git worktree holds only tracked files — untracked/ignored items (venv, `.env`, datasets, build caches, compiled artifacts) are absent unless already set up; tell the user, and set them up (or symlink them) before running anything.

## Steps
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
   A change's docs live in its worktree (`.worktrees/<change-id>/docs/changes/active/<change-id>/`) if one was created at `/change-design`, otherwise in the current tree (`docs/changes/active/<change-id>/`). Look in the current tree **and** in every worktree (`git worktree list`); read and write the change's docs there.
2. Read `design.md`, then `plan.md`.
3. Implement strictly per the plan, task by task. Tick each `T#` checkbox only when its concrete artifact exists.
4. If the plan is wrong, update `plan.md`. If the **design** is wrong, STOP, update `design.md` (it goes back to `draft`), and get the user's re-approval before continuing.

## Rules (rule — why)
- Do not implement unplanned features — if it's not in the plan, it's scope creep; add it to the plan (and design if needed) first.
- A task is DONE only when its actual artifact exists — code that *handles* a deliverable is not the deliverable; when unsure, leave it unchecked.
- Do not silently change a stable contract — if the work forces a `CONTRACTS.md` change, surface it; you're likely also editing the code that contract governs.
- Write the change's committed/automated tests here — they are part of the implementation. Don't skip required tests, and don't mark a task done on an unverified assumption. (Running them and recording the *evidence* is `/change-validate`.)
- **3-strike rule:** if the same task fails 3 times, or each fix breaks another task, STOP — the design or plan is probably wrong. Surface it; don't attempt fix #4.

**Next:** `/change-review` — nothing else.
