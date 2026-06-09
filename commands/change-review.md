---
description: Use when the user explicitly self-reviews a change before completion — check the diff against design.md, plan.md, and CONTRACTS.md; record P1/P2/P3 findings in review.md. Human-initiated. Not a substitute for human code review.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-review** workflow. Open with: "Running change-review for …".

Target change-id (optional): $ARGUMENTS

`review.md` is your **structured self-review** — a pre-completion gate, not a mirror of any external code-review tool (those are out of scope). Durable lessons from human review are promoted to `docs/experiences/` or `docs/CONTRACTS.md`, not copied here.

## Steps (do in order — don't propose fixes while still reading)
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
2. **Read** the diff/code against `design.md`, `plan.md`, and `docs/CONTRACTS.md`.
3. **Coverage check.** Does the implementation match the frozen design? Does every `plan.md` task trace to real work, and every design decision to a task? Report `CLEAN` / `DRIFT (built beyond design)` / `MISSING (design point not implemented)`.
4. **Classify** findings into the format below.
5. Write/update `review.md`, then give a **verdict**: `ready-to-archive` / `archive-with-fixes` / `not-ready`.

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
