---
description: Use when the user explicitly records test, benchmark, or manual validation evidence for a change (validation.md). Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-validate** workflow. Open with: "Running change-validate for …".

Target change-id (optional): $ARGUMENTS

> **IRON LAW: NO "VALIDATED" CLAIM WITHOUT FRESH EVIDENCE IN THIS RUN.**
> Claiming validation without running it is dishonesty, not efficiency. Violating the letter is violating the spirit.

Required for changes touching correctness, performance, CUDA, TensorRT, metrics, benchmarks, data alignment, public API/data contracts, or release-sensitive behavior. Optional for trivial/doc-only changes.

## Gate (in order, never skip a step)
1. **IDENTIFY** the command that would prove each claim.
2. **RUN** it fresh — re-run after any edit; an earlier run proves nothing.
3. **READ + PASTE** the real output: exit code, pass/fail counts, numbers.
4. **Only then** record it as validated.

| Claim | Requires | Not enough |
|---|---|---|
| tests pass | command output, 0 failures | "should pass" / an earlier run |
| faster | before + after numbers | "feels faster" |
| metric correct | the actual metric value | code changed, assumed fixed |

## Rules (rule — why)
- A failed command is evidence too — record it; hiding failures defeats the point.
- Missing metric ≠ 0 (per `CONTRACTS.md`) — treat absent values as absent, not zero.
- Note what you did **not** validate under "Known gaps" — silent omissions read as full coverage.

**Next:** `/change-archive`.

## validation.md template
````markdown
# Validation

## Commands
```bash
# exact commands executed
```

## Results
Summary of test results (counts, exit codes).

## Benchmark
Baseline vs candidate numbers, if applicable.

## Manual checks
Manual validation steps and results.

## Known gaps
What was not validated and why.
````
