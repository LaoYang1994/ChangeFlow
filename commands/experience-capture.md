---
description: Use when the user explicitly captures a reusable engineering lesson, or when you notice a recurring/durable lesson worth recording. Records to docs/experiences/, or graduates the lesson to a test/hook/contract.
argument-hint: <what was learned>
---

Run the ChangeFlow **experience-capture** workflow. Open with: "Running experience-capture …".

Lesson from the user (may be empty): $ARGUMENTS

For repeated bugs, debugging patterns, performance pitfalls, CUDA/TensorRT gotchas, benchmark/alignment lessons, review or release lessons.

## Should I record this?
Only if it's a **reusable rule**, not a one-off: *would this save a future session time, on this or another project?* If no, don't write it. If it's enforceable, graduate it instead (below).

## Steps
1. **Search `docs/experiences/` first.** If a near-match exists, **update it** — two docs on the same lesson inevitably drift apart. Record the search outcome even when nothing matched (a visible "no existing match" note is the audit signal; don't silently skip).
2. **Graduate, if possible:** enforceable → write a **test or hook** and down-reference/omit the experience; stable hard rule → promote to `docs/CONTRACTS.md`. Experiences are a holding pen, not a resting place.
3. Otherwise write/update `docs/experiences/<domain>/<slug>.md` from the template.

## Rules (rule — why)
- Capture the **reusable rule, not the war story** — "In session X we found…" is a narrative no future session can apply; write the trigger and the rule instead.
- No task summaries, implementation diaries, or unverified guesses — the layer is for durable, verified knowledge.
- Reference related changes by **ID**, never by `active/`/`archive/` path — so the link survives archival.

## experience template
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
