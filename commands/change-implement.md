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

## Where to work (ask once)
Before writing code, ask the user: **"Isolate this change in a git worktree, or work on the current branch?"** — unless a worktree for it already exists (then use it; don't re-ask; if the main tree also holds a copy of the change folder, the worktree's copy is the live one).
- **Current branch** (default if they decline): implement here. The change's docs stay where they are (the current tree).
- **New worktree:** `git worktree add .worktrees/<change-id> -b change/<change-id>` (omit `-b` if the branch exists); ensure `.worktrees/` is in `.gitignore`; then **move the change's docs into it** — docs live with the code once implementation starts, so they commit and merge together. If the change folder is untracked in the main tree (the default: ChangeFlow never commits; check with `git ls-files docs/changes/active/<change-id>`, which prints nothing), create `.worktrees/<change-id>/docs/changes/active/` and `mv docs/changes/active/<change-id> .worktrees/<change-id>/docs/changes/active/`. If it turns out to be committed already, the worktree has it from HEAD: copy over any uncommitted edits, treat the worktree copy as the only live one, and tell the user the main-tree copy is now stale (they can remove it). From here on read and write `design.md`/`plan.md` and tick `T#` boxes **only in the worktree**, and do the code work there too. A new worktree holds only tracked files — untracked/ignored things (venv, `.env`, datasets, build caches or compiled artifacts) are absent; tell the user, and set them up (or symlink them) before running anything.

ChangeFlow creates the worktree and moves the change's docs into it; it never commits, merges, or pushes. Removal is offered at `/change-archive`, and only after the branch is merged.

## Steps
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
   A change's docs live in its worktree once implementation has started (`.worktrees/<change-id>/docs/changes/active/<change-id>/`), otherwise in the current tree. Look in the current tree **and** in every worktree (`git worktree list`); if the same id exists in both, the worktree copy is the live one. Read and write the change's docs there.
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
