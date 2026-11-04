---
description: Use when the user explicitly self-reviews a change before completion (review.md). Human-initiated. Not a substitute for human code review.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-review** workflow. Open with: "Running change-review for …".

Target change-id (optional): $ARGUMENTS

`review.md` is your **structured self-review** — a pre-completion gate, not a mirror of any external code-review tool (those are out of scope). Durable lessons from human review are promoted to `docs/experiences/` or `docs/CONTRACTS.md`, not copied here.

## Steps (do in order — don't propose fixes while still reading)
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
   A change's docs live in its worktree once implementation has started (`.worktrees/<change-id>/docs/changes/active/<change-id>/`), otherwise in the current tree. Look in the current tree **and** in every worktree (`git worktree list`); if the same id exists in both, the worktree copy is the live one. Read and write the change's docs there.
2. **Find the change's code, then read it.** If `.worktrees/<change-id>/` exists, run every git command and read code there (the change's docs live there too). The diff base is where the work branched, not `HEAD` — commits made during implementation must stay in scope:
   ```bash
   cd "$(git rev-parse --show-toplevel)"
   base=$(git merge-base HEAD origin/HEAD 2>/dev/null || git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null || echo HEAD)
   git diff --name-only "$base"; git ls-files --others --exclude-standard   # committed + uncommitted + untracked
   ```
   If the list is empty, or the work looks already committed onto the default branch (so `base` is `HEAD`), ask the user for the starting commit — never conclude "nothing to review". Then read the diff/code against `design.md`, `plan.md`, and `docs/CONTRACTS.md`.
3. **Large-file guard.** Flag any added/changed file over ~1 MB (or a stray binary blob):
   ```bash
   cd "$(git rev-parse --show-toplevel)"
   base=$(git merge-base HEAD origin/HEAD 2>/dev/null || git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null || echo HEAD)
   { git diff --name-only "$base"; git ls-files --others --exclude-standard; } 2>/dev/null | sort -u \
     | while read -r f; do [ -f "$f" ] && s=$(wc -c <"$f") && [ "$s" -gt 1048576 ] && printf 'LARGE %s (%s bytes)\n' "$f" "$s"; done
   ```
   Any output → record as **P1** (don't let a stray fixture/blob into git). For a legitimately large asset, accept the finding or move it to Git LFS.
4. **Coverage check.** Does the implementation match the frozen design? Does every `plan.md` task trace to real work, and every design decision to a task? Report `CLEAN` / `DRIFT (built beyond design)` / `MISSING (design point not implemented)`.
5. **Classify** findings into the format below.
6. Write/update `review.md`, then give a **verdict**: `ready-to-archive` / `archive-with-fixes` / `not-ready`.

## Finding format & evidence
`[P1|P2|P3] (confidence N/10) file:line — problem → concrete fix`
- **Cite or flag:** "handled elsewhere" → cite the line; "tested" → name the test; never "probably". "Looks fine" is not a finding.
- Confidence < 5/10 → move to an `## Unverified` appendix, not the main list (keeps the report credible).
- Don't invent findings to pad the report.

## Severity → action (P# — what it means)
- **P1 — blocks archive.** Surface each P1 to the user individually (one decision per P1); fix before completion.
- **P2 — fix in this change** before archiving.
- **P3 — optional.** Record for later (a TODO or `/experience-capture`); P3s may be listed together.

**Next:** `/change-validate` if evidence is needed, else `/change-archive`.

## review.md template
```markdown
# Review

## Summary
High-level result + verdict (ready-to-archive | archive-with-fixes | not-ready).

## Coverage
CLEAN | DRIFT | MISSING — one line each.

## Findings
### P1
[P1] (confidence N/10) file:line — problem → fix
### P2
[P2] (confidence N/10) file:line — problem → fix
### P3
[P3] (confidence N/10) file:line — problem → fix

## Unverified
Low-confidence (<5/10) observations, not asserted.

## Resolved
Findings that were fixed.

## Accepted risks
Known issues accepted for now.

## Follow-up items
Intentionally deferred (and where they go).
```
