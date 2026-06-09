---
description: Record test, benchmark, and manual validation results with evidence in validation.md.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-validate** workflow.

Target change-id (optional): $ARGUMENTS

Required for changes involving correctness, performance, CUDA, TensorRT, metrics, benchmark behavior, data alignment, public API/data contracts, or production/release-sensitive behavior. Optional for small documentation-only or trivial code changes.

## Steps
1. Locate the active change. If a change-id is given, use it. If omitted: one active change → use it; multiple → list them and ask which.
2. Run the relevant tests/benchmarks/manual checks.
3. Write/update `validation.md` using the template below.

## Rules
- Do not claim validation without evidence.
- Record failed commands as well as successful ones.
- For performance-sensitive work, include baseline and candidate numbers where available.

## validation.md template
```markdown
# Validation

## Commands
​```bash
# commands executed
​```

## Results
Summary of test results.

## Benchmark
Performance numbers, if applicable.

## Manual checks
Manual validation steps and results.

## Known gaps
What was not validated and why.
```
