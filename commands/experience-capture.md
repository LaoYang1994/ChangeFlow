---
description: Use when the user captures a reusable lesson/pitfall/root-cause into docs/experiences/, or when you notice one worth recording. For step-by-step procedures use /workflow-capture; enforceable rules graduate to a test/hook/contract.
argument-hint: <what was learned>
---

Run the ChangeFlow **experience-capture** workflow. Open with: "Running experience-capture …".

Lesson from the user (may be empty): $ARGUMENTS

For repeated bugs, debugging patterns, performance pitfalls, CUDA/TensorRT gotchas, benchmark/alignment lessons.

## Should I record this, and where?
- Only if it's **reusable**, not a one-off: *would this save a future session time, here or elsewhere?* If no, don't write it.
- This is a **lesson/pitfall/root-cause** ("we hit X, the rule is Y") → continue here.
- It's a **recurring procedure** ("to do X: first A, then B") → use `/workflow-capture` instead.
- It's an **enforceable rule** → graduate: write a test/hook, or promote to `docs/CONTRACTS.md`; then down-reference or omit.

## Steps
1. **Search `docs/experiences/` first.** If a near-match exists, **update it** — duplicates drift apart. Record the search outcome even when nothing matched (a visible "no existing match" note is the audit signal; don't silently skip).
2. Write/update `docs/experiences/<domain>/<slug>.md` from the template below.
3. Add or update its one-line entry in `docs/experiences/INDEX.md` (`- [Title](domain/slug.md) — problem it addresses`) so it stays discoverable.

## Rules (rule — why)
- Capture the **reusable rule, not the war story** — "In session X we…" is a narrative no future session can apply.
- No task summaries or unverified guesses — the durable layer is for verified, reusable knowledge.
- Reference related changes by **ID**, never by `active/`/`archive/` path — so the link survives archival.
- Living doc — prune or merge when superseded; graduate to test/hook/contract when a lesson becomes enforceable.

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
