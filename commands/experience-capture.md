---
description: Use when the user captures a reusable engineering lesson or a recurring procedure, or when you notice one worth recording. Lessons go to docs/experiences/; step-by-step procedures go to docs/workflows/; enforceable rules graduate to a test/hook/contract.
argument-hint: <what was learned or the procedure>
---

Run the ChangeFlow **experience-capture** workflow. Open with: "Running experience-capture …".

Input from the user (may be empty): $ARGUMENTS

## Should I record this, and where?
- Only if it is **reusable**, not a one-off: *would this save a future session time, here or on another project?* If no, don't write it.
- **Lesson / pitfall / root-cause** ("we hit X, the rule is Y") → `docs/experiences/<domain>/<slug>.md`.
- **Recurring procedure** ("to do X: first A, then B") → `docs/workflows/<slug>.md`.
- **Enforceable rule** → graduate instead: write a test/hook, or promote to `docs/CONTRACTS.md`; then down-reference or omit.

## Steps
1. **Search first** in the matching directory. If a near-match exists, **update it** — duplicates drift apart. Record the search outcome even when nothing matched (a visible "no existing match" note is the audit signal; don't silently skip).
2. Decide lesson vs procedure vs graduate (above).
3. Write/update the file from the matching template below.

## Rules (rule — why)
- Capture the **reusable rule or procedure, not the war story** — "In session X we…" is a narrative no future session can apply.
- No task summaries or unverified guesses — the durable layer is for verified, reusable knowledge.
- Reference related changes by **ID**, never by `active/`/`archive/` path — so the link survives archival.
- Experiences and workflows are living docs — prune or merge when superseded; graduate to test/hook/contract when a lesson becomes enforceable.

## experience template (docs/experiences/<domain>/<slug>.md)
```markdown
# <Experience Title>

## Problem
What recurring problem occurs (the trigger to recognize next time)?

## Root cause
Why it happens.

## Pattern / Rule
What to do instead — the reusable rule.

## How to apply
Concrete steps or guidance.

## Validation
How to verify the fix or pattern.

## Pitfalls
Common mistakes.

## Related changes
- <change-id>

## Related contracts
- `docs/CONTRACTS.md#...`
```

## workflow template (docs/workflows/<slug>.md)
```markdown
# <Workflow Title>

## Purpose
The recurring task this procedure accomplishes.

## When to use
The trigger/situation where an agent should follow this.

## Steps
1. <one action>
2. <one action>

## Gotchas
What bites if you skip, reorder, or rush a step.

## Related
- Contracts: `docs/CONTRACTS.md#...`
- Experiences: `docs/experiences/...`
```
