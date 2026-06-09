---
description: Complete a change — update long-term docs, then move the folder from active/ to archive/.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-archive** workflow.

Target change-id (optional): $ARGUMENTS

## Steps
1. Locate the active change. If a change-id is given, use it. If omitted: one active change → use it; multiple → list them and ask which.
2. Check `design.md` reflects final behavior.
3. Check `plan.md` task status is accurate.
4. Check whether `review.md` exists or is needed.
5. Check whether `validation.md` exists or is needed.
6. Ensure plan tasks are complete or explicitly deferred.
7. Update `docs/PROJECT.md` if feature status changed.
8. Update `docs/CONTRACTS.md` if stable behavior changed.
9. Update `docs/CONCEPTS.md` if stable vocabulary changed.
10. Update or create `docs/experiences/` if reusable knowledge was learned. Prefer a test or hook when the lesson is enforceable; prefer a contract when it is a stable hard rule.
11. **Rewrite stray references:** grep the repo for any `active/<slug>` path references to this change and rewrite them to `archive/<slug>`. (Well-behaved references use the change ID, not the path.)
12. Move the folder from `docs/changes/active/<change>/` to `docs/changes/archive/<change>/`.

## Archive checklist
```markdown
## Archive checklist
- [ ] `design.md` reflects final behavior.
- [ ] `plan.md` task status is accurate.
- [ ] Required review is complete.
- [ ] Required validation is complete.
- [ ] `docs/PROJECT.md` updated if needed.
- [ ] `docs/CONTRACTS.md` updated if needed.
- [ ] `docs/CONCEPTS.md` updated if needed.
- [ ] `docs/experiences/` updated if needed.
- [ ] Stray `active/<slug>` path references rewritten to `archive/<slug>`.
- [ ] Active folder moved to archive.
```

## Rules
- Do not archive incomplete changes unless explicitly marked as abandoned or deferred.
- Do not create experience docs for trivial one-off changes.
- Prefer tests or hooks over documentation when a lesson can be enforced automatically.
- Do not delete historical change docs — archive is immutable.
