---
description: Use when the user explicitly checks the docs for drift/cleanup, or at a milestone (before a release, after a batch of changes archived). Global GC for the documentation system.
argument-hint: "[--apply]"
---

Run the ChangeFlow **docs-refresh** workflow. Open with: "Running docs-refresh …".

Options (optional): $ARGUMENTS

Global GC for the documentation system. It does not run on a cron and does not auto-mutate. Trigger it reactively (you trip over drift) or at a milestone. By default **report**; only edit directly when invoked with `--apply`.

## Method — verify against reality, don't trust prose
For each durable claim, **check it against the code/repo** (e.g. `grep` for the referenced symbol/file). A claim you didn't verify is `unverified`, not `accurate`. Inspect `AGENTS.md`, `CLAUDE.md`, `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md`, `docs/changes/active/`, `docs/changes/archive/`, `docs/experiences/`.

## Checks
- **Stale:** a doc references code/files that changed or no longer exist.
- **Contradiction:** two docs (or a doc and the code) disagree.
- **Discoverability:** durable docs are reachable from `AGENTS.md`/`PROJECT.md`.
- Active changes that look abandoned; archived changes that never updated durable docs.
- Repeated/conflicting experiences (candidates to merge, prune, or graduate to test/hook/contract).
- Terms used in docs but missing from `CONCEPTS.md`; random `.md` outside the structure.

## Rules (rule — why)
- Don't delete stale-but-historical content — move it into an "old patterns" `<details>` block; deleting context loses the "why".
- Edit durable docs in place, idempotently — never regenerate wholesale (same discipline as `change-archive`).
- Auto-apply only factual corrections (with `--apply`); **ask** before structural/narrative changes — one question per change.
- Report "no drift found" explicitly when clean — a visible no-result is the audit signal.

## Output (report)
```markdown
# Docs Refresh Report
## Summary            (or "no drift found")
## Stale active changes
## Contract drift
## Project feature drift
## Experience cleanup
## Concept updates
## Random docs detected
## Recommended actions
```
