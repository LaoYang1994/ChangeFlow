---
description: Use when the user explicitly implements a change's plan.md. Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-implement** workflow. Open with: "Running change-implement for …".

Target change-id (optional): $ARGUMENTS

> **IRON LAW: NO IMPLEMENTATION OUTSIDE THE FROZEN DESIGN + PLAN.**
> Improvising past the plan is how scope creep and unreviewable changes happen. If reality contradicts the plan, STOP and fix the plan (or design) first.

## Pre-gate
Confirm `design.md` and `plan.md` exist for this change. If either is missing or the design clearly isn't frozen, STOP and suggest `/change-design` or `/change-plan` — do not start coding.

## Steps
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
2. Read `design.md`, then `plan.md`.
3. Implement strictly per the plan, task by task. Tick each `T#` checkbox only when its concrete artifact exists.
4. If the plan is wrong, update `plan.md`. If the **design** is wrong, STOP and update `design.md` first.

## Rules (rule — why)
- Do not implement unplanned features — if it's not in the plan, it's scope creep; add it to the plan (and design if needed) first.
- A task is DONE only when its actual artifact exists — code that *handles* a deliverable is not the deliverable; when unsure, leave it unchecked.
- Do not silently change a stable contract — if the work forces a `CONTRACTS.md` change, surface it; you're likely also editing the code that contract governs.
- Do not skip required tests, and do not mark a task done on an unverified assumption.
- **3-strike rule:** if the same task fails 3 times, or each fix breaks another task, STOP — the design or plan is probably wrong. Surface it; don't attempt fix #4.

**Next:** `/change-review` — nothing else.
