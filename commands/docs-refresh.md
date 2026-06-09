---
description: Global GC for the documentation system — detect drift and cleanup opportunities, then report or propose edits.
argument-hint: "[--apply]"
---

Run the ChangeFlow **docs-refresh** workflow.

Options (optional): $ARGUMENTS

This is the global GC for the documentation system. It does not run on a cron and does not auto-mutate by default. Trigger it reactively (when you trip over drift) or at milestones (before a release, after a batch of changes is archived).

## Inspect
`AGENTS.md`, `CLAUDE.md`, `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md`, `docs/changes/active/`, `docs/changes/archive/`, `docs/experiences/`.

## Checks
- Active changes that appear stale.
- Archived changes that did not update long-term docs.
- Repeated or conflicting experiences (and candidates to promote to test/hook/contract, or merge/prune).
- Overgrown `AGENTS.md`.
- Outdated contracts.
- Missing project feature updates.
- Terms used in docs but missing from `CONCEPTS.md`.
- Random markdown files outside the approved structure.

## Output
Produce the report below. Only edit files directly if invoked with `--apply`; otherwise propose edits.

```markdown
# Docs Refresh Report
## Summary
## Stale active changes
## Contract drift
## Project feature drift
## Experience cleanup
## Concept updates
## Random docs detected
## Recommended actions
```
