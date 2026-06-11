---
description: Use when the user captures a reusable step-by-step procedure ("to do X, first A then B") into docs/workflows/, or when you notice a recurring procedure worth recording. For lessons/pitfalls/root-causes use /experience-capture instead.
argument-hint: <the procedure / what recurring task it covers>
---

Run the ChangeFlow **workflow-capture** workflow. Open with: "Running workflow-capture …".

Input from the user (may be empty): $ARGUMENTS

Captures a recurring **procedure** an agent should follow next time. A reactive *lesson/pitfall/root-cause* is an experience — use `/experience-capture` for that.

## Should I record this?
Only if it's a **reusable procedure**, not a one-off: would following these steps help on a future task, here or on another project? If the procedure can be enforced as a script or hook, prefer that instead.

## Steps
1. **Search `docs/workflows/` first.** If a near-match exists, **update it** — duplicates drift apart. Record the search outcome even when nothing matched (a visible "no existing match" note is the audit signal).
2. Write/update `docs/workflows/<slug>.md` from the template below.
3. Add or update its one-line entry in `docs/workflows/INDEX.md` (`- [Title](slug.md) — when to use`) so it stays discoverable.

## Rules (rule — why)
- Capture the **procedure, not the war story** — write the steps to follow, not "in session X we…".
- One file per procedure; reference related changes by **ID**, contracts/experiences by path.
- Living doc — prune or merge when superseded; graduate a step to a script/hook when it becomes enforceable.

## workflow template (docs/workflows/<slug>.md)
```markdown
# <Workflow Title>

## Purpose
The recurring task this procedure accomplishes.

## When to use
The trigger or situation where an agent should follow this.

## Steps
1. <one action>
2. <one action>

## Gotchas
What bites if you skip, reorder, or rush a step.

## Related
- Contracts: `docs/CONTRACTS.md#...`
- Experiences: `docs/experiences/...`
```
