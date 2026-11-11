---
description: Use when the user explicitly starts or revises a change's design (design.md). Human-initiated; never run on your own.
argument-hint: "[<change-id> | <short description>]"
---

Run the ChangeFlow **change-design** workflow. Open with: "Running change-design for …".

Argument (may be empty): $ARGUMENTS
- Matches an existing **active** change-id (`<YYYY-MM-DD>-<slug>`) → **revise** that change's `design.md`.
- Otherwise → treat it as a short description of a **new** change.

**Human-initiated.** Never open a change folder on your own — only on this command, or after the user accepts your suggestion to. A design is not frozen until the user approves it.

## Steps
1. **Target.** Existing change-id → revise it in place (no new folder, never re-ask about worktrees). Description/empty → new change; if active changes exist and intent is unclear, list them and ask first. Look for existing changes in the current tree **and** in every worktree (`git worktree list`).
2. Read `AGENTS.md` (+ `CLAUDE.md` under Claude Code), `docs/PROJECT.md`, and `docs/CONCEPTS.md` / `docs/CONTRACTS.md` if relevant. Search `docs/experiences/`; read an archived change only if a durable doc points to it by ID — do not blind-search the archive.
3. If other active changes exist (in the current tree or any worktree), glance at their `plan.md` "Files to change" and **warn** on likely overlap.
4. **Clarify — only when it changes the design.** Ask **one question at a time**, prefer multiple-choice, at most ~5, ordered by impact. Record each answer under `## Clarifications`; make informed guesses for everything else and list them under `## Assumptions`. Don't interrogate — defaulting the obvious is better than a wall of questions.
5. **Confirm scope before freezing.** State in 1–2 lines what this change will and won't cover; wait for the user's OK. **STOP here** — an "obvious" design still needs sign-off; freezing without it is the failure this gate prevents.
6. **New change only — choose where it lives (ask once) and create the folder:**
   - Derive `<change-id>` = `<YYYY-MM-DD>-<slug>` (`<YYYY-MM-DD>` = today's date from `date +%F` — don't guess it — fixed forever; `<slug>` = short kebab, e.g. `2026-06-09-multi-condition-benchmark`, not `fix-stuff`).
   - Check the current branch (`git branch --show-current`) and ask the user once: **"Isolate this change in a new git worktree (`.worktrees/<change-id>/`, branch `change/<change-id>`), or create it on the current branch (`<current-branch>`)?"** (Always ask, even if already on a feature branch — naming `<current-branch>` lets them decide clearly. Choosing a worktree keeps the main branch clean from day one.)
   - **New worktree:** ensure `.worktrees/` is in `.gitignore`; run `git worktree add .worktrees/<change-id> -b change/<change-id>` (omit `-b` if the branch already exists); create `.worktrees/<change-id>/docs/changes/active/<change-id>/`. ChangeFlow never commits, merges, or pushes; the change's docs and code live together in this worktree for its entire lifecycle (never moved later).
   - **Current branch:** create `docs/changes/active/<change-id>/` in the current tree.
7. Write/update `design.md` with `Status: draft`.
8. **Get the user's approval of the written design.** Only their explicit approval freezes it — then set `Status: frozen (<today>)`. Revising a frozen design sets it back to `draft` until re-approved; if `plan.md` exists, set its `Status:` to `stale` and tell the user to re-run `/change-plan`.

## Rules (rule — why)
- Do not start implementation here — the design must be frozen before code so review and validation have a stable target to check against.
- Do not create `requirements.md` / `brainstorm.md` or any file outside the change folder — scattered docs are exactly what ChangeFlow exists to prevent.
- Impact fields are one `none | <details>` line, never Yes/No checkboxes — a half-checked box is ambiguous; one line forces a clear answer.
- Keep `design.md` about *what and why*, not *how* — implementation tasks belong in `plan.md`, so the two stay independently reviewable.

**Next:** `/change-plan` — nothing else.

## design.md template
```markdown
# Design

Status: draft   <!-- draft | frozen (YYYY-MM-DD). Only the user's approval freezes it. -->

## Background
Why this change is needed.

## Goal
What this change must accomplish.

## Non-goals
What this change explicitly does not include.

## Current behavior
How the system behaves today.

## Proposed behavior
How the system should behave after this change.

## Design details
Core design, data flow, APIs, UI behavior, or architecture changes.

## Edge cases
Important boundary cases.

## Clarifications
- Q: … → A: …   (questions resolved this session, if any)

## Assumptions
- Informed guesses made instead of asking, so review can see them.

## Contract impact
none | which rule in docs/CONTRACTS.md is affected, and how

## Project impact
none | what feature status in docs/PROJECT.md changes

## Experience impact
none | what reusable knowledge this could produce, and where it goes

## Open questions
Unresolved questions, if any.
```
