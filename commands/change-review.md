---
description: Self-review the change against design.md, plan.md, and CONTRACTS.md; record findings in review.md. A pre-push gate, not a substitute for human code review.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-review** workflow.

Target change-id (optional): $ARGUMENTS

`review.md` is the agent's **structured self-review** — a pre-push gate. It is not a mirror of any external human code-review tool (those are out of scope). Durable lessons from external review are promoted to `docs/experiences/` or `docs/CONTRACTS.md`, not copied here.

## Steps
1. Locate the active change. If a change-id is given, use it. If omitted: one active change → use it; multiple → list them and ask which.
2. Review against `design.md`, `plan.md`, `docs/CONTRACTS.md`, and the project code.
3. Write/update `review.md` using the template below.

## Review focus
- Does the implementation match `design.md`?
- Does it complete `plan.md`?
- Does it violate `docs/CONTRACTS.md`?
- Are tests sufficient?
- Are there hidden behavior changes?
- Are there performance or compatibility risks?
- Should `docs/PROJECT.md`, `docs/CONTRACTS.md`, or `docs/experiences/` be updated?

## Severity
- P1 = must fix before completion
- P2 = should fix
- P3 = optional improvement

## review.md template
```markdown
# Review

## Summary
High-level review result.

## Findings

### P1
Must fix before merge/archive.

### P2
Should fix.

### P3
Optional improvement.

## Resolved
Findings that were fixed.

## Accepted risks
Known issues accepted for now.

## Follow-up items
Items intentionally deferred.
```
