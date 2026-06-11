# Eval a prompt change

## Purpose
Get objective, low-bias evidence that a command-prompt change actually improves
behavior — not vibes.

## When to use
After materially changing command-prompt wording, before declaring it better.

## Steps
1. Keep the OLD prompt bodies (e.g. `git show HEAD~1:commands/<cmd>.md`) and the
   NEW ones side by side.
2. Define a few scenarios with **binary** checklists (or difficulty-tiered tasks).
3. For each scenario × {old, new}, run a **fresh subagent** that follows that
   prompt body and produces the artifact/decision (no checklist leak to it).
4. Judge **blind and cross-model**: have Codex (`codex exec`) score A vs B, with
   the A/B label flipped per task so "always prefers new" and positional bias
   can't survive. Map A/B back to old/new yourself.
5. Report per-scenario old-vs-new scores; only claim improvement if new ≥ old.

## Gotchas
- Don't let the judge be the same model that wrote the prompts (self-grading bias) —
  use Codex as an independent judge.
- Give executors a REAL scaffolded repo when the artifact needs files, or they'll
  correctly refuse to fabricate and produce nothing (a harness flaw, not a prompt result).
- SWE-bench is the wrong tool — this measures process/artifact quality, not raw coding.

## Related
- Experiences: `docs/experiences/workflow/codex-rescue-kills-child.md`
