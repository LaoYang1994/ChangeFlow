---
description: Use when the user wants a pre-implementation review of a change — confront the frozen design + plan with the real code/data and contracts before any code is written. Human-initiated; optional (skip for small changes).
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-plan-review** workflow. Open with: "Running change-plan-review for …".

Target change-id (optional): $ARGUMENTS

This is the **pre-build gate** — the cheapest place to catch design/plan gaps, before they force rework mid-implementation. Optional: run it for non-trivial or risky changes; skip small ones.

## Steps (do in order — don't fix while still reading)
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
2. Read `design.md` and `plan.md`.
3. **Confront them with reality** — this is the whole point of the gate, don't skip it:
   - Open the actual code each task/decision touches. Do the plan's assumptions hold? Did it miss a code seam, caller, or edge case the code reveals?
   - If the change is data-dependent, look at a **real data sample** (empty/edge cases and variants — e.g. missing frames, alternate source types, odd shapes).
   - Check the design/plan against `docs/CONTRACTS.md`.
4. Classify gaps as findings (format below). A finding here = something that would otherwise force a design/plan change mid-implementation.
5. Give a **verdict**: `ready-to-implement` / `revise-plan` / `revise-design`. Fold confirmed fixes back into `plan.md` / `design.md` (big unknowns → design's Open questions). **Do not write a separate review file.**

## Finding format
`[P1|P2|P3] (confidence N/10) where — gap → fix`
- Cite the code/data you actually looked at; never "probably". "Looks fine" is not a finding.
- P1 = would break or force a redesign during implement; P2 = should resolve before coding; P3 = note for later.

## Rules (rule — why)
- Confront real code/data, not just the doc — internal consistency isn't the point; catching what only the code/data reveals is (that's why this gate exists, before the expensive implement phase).
- Fixes land in `design.md` / `plan.md`, not a new file — keep the change minimal; the plan stays the source of truth.
- Human-initiated and optional — don't run it on your own; the user chooses it for changes worth the gate.

**Next:** the **user** runs `/change-implement` (after any design/plan fixes land).
