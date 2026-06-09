---
description: Start a new change or revise an existing one — clarify requirements, freeze the design, and write design.md. Human-initiated; run only when the user explicitly invokes it.
argument-hint: "[<change-id> | <short description>]"
---

Run the ChangeFlow **change-design** workflow.

Argument (may be empty): $ARGUMENTS
- If it matches an existing **active** change-id (`<YYYY-MM-DD>-<slug>`), **revise** that change's `design.md` (do not create a new folder).
- Otherwise treat it as a short description of a **new** change.

This command is **human-initiated**. Never open a change folder on your own — only when the user runs this command (or explicitly accepts your suggestion to).

## Steps
1. **Determine the target:**
   - Argument matches an existing active change-id → you are **revising** it; skip folder creation and update that change's `design.md`.
   - Argument is a description or empty → you are **creating** a new change. If active changes already exist and it is unclear whether the user means to revise one, list them and ask before creating.
2. Read `AGENTS.md` (and `CLAUDE.md` if running under Claude Code).
3. Read `docs/PROJECT.md`.
4. Read `docs/CONCEPTS.md` if domain terms are involved.
5. Read `docs/CONTRACTS.md` if contracts may be affected.
6. Search `docs/experiences/` for related lessons. Only read an archived change if an experience or `PROJECT.md` points to it by ID — do **not** blind-search `docs/changes/archive/`.
7. If other active changes exist, glance at their `plan.md` "Files to change" and **warn** if this change is likely to overlap.
8. Ask clarifying questions only if needed.
9. **New change only:** create the active change folder `docs/changes/active/<YYYY-MM-DD>-<slug>/`, where `<YYYY-MM-DD>` is **today's date** (the creation date, fixed forever) and `<slug>` is a short kebab-case description.
10. Write (or, when revising, update) `design.md` using the template below.

## Rules
- Do not start implementation during this command.
- Do not create `requirements.md`, `brainstorm.md`, or any docs outside the active change folder.
- Impact fields use a single `none | <details>` line, never Yes/No checkboxes.
- Keep `design.md` focused on requirements and design, not implementation tasks.

## design.md template
```markdown
# Design

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

## Contract impact
none | which rule in docs/CONTRACTS.md is affected, and how

## Project impact
none | what feature status in docs/PROJECT.md changes

## Experience impact
none | what reusable knowledge this could produce, and where it goes

## Open questions
Unresolved questions, if any.
```
