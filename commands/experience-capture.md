---
description: Capture a reusable engineering lesson into docs/experiences/, or graduate it into a test/hook/contract. Search first; update near-matches instead of duplicating.
argument-hint: <what was learned>
---

Run the ChangeFlow **experience-capture** workflow.

Lesson from the user (may be empty): $ARGUMENTS

Use for repeated bugs, debugging patterns, performance pitfalls, CUDA/TensorRT gotchas, benchmark validation practices, MCAP/data alignment lessons, review patterns, and release/workflow lessons.

## Steps
1. **Search existing experiences first.** If a near-match exists, **update it** instead of creating a duplicate.
2. Decide whether the lesson should graduate instead of becoming an experience:
   - enforceable → write a **test or hook**, and down-reference or omit the experience;
   - stable hard rule → promote it to `docs/CONTRACTS.md`.
3. Otherwise write/update `docs/experiences/<domain>/<slug>.md` using the template below.

## Rules
- Do not write task summaries, implementation diaries, or unverified guesses.
- Capture only durable, reusable knowledge.
- Reference related changes by **ID**, never by `active/` or `archive/` path.
- Experiences are a holding pen, not a final resting place: graduate or prune them over time. Unlike `changes/archive/`, experiences may be pruned, merged, or deleted once promoted or superseded.

## experience template
```markdown
# <Experience Title>

## Problem
What problem occurred?

## Root cause
Why did it happen?

## Pattern / Rule
What should be done next time?

## How to apply
Concrete steps or implementation guidance.

## Validation
How to verify the fix or pattern.

## Pitfalls
Common mistakes.

## Related changes
- <change-id>

## Related contracts
- `docs/CONTRACTS.md#...`
```
