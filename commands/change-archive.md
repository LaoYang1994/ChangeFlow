---
description: Use when the user explicitly completes (archives) a change. Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-archive** workflow. Open with: "Running change-archive for …".

Target change-id (optional): $ARGUMENTS

> **IRON LAW: UPDATE DURABLE DOCS BEFORE MOVING THE FOLDER.**
> Once the folder is in `archive/`, nobody reads it routinely — anything durable not promoted now is effectively lost.

## Steps
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
   A change's docs live in its worktree once implementation has started (`.worktrees/<change-id>/docs/changes/active/<change-id>/`), otherwise in the current tree. Look in the current tree **and** in every worktree (`git worktree list`); if the same id exists in both, the worktree copy is the live one. Read and write the change's docs there.
2. **Completeness count.** Count unchecked vs checked **`T#` task lines** in `plan.md` (`grep -cE '^- \[ \] T[0-9]+'` / `grep -cE '^- \[x\] T[0-9]+'`) — other checklist items don't count. If tasks are incomplete, show the count and **ask** whether to archive anyway — don't block, but never archive incompleteness silently.
3. Confirm `design.md` reflects final behavior and `review.md`/`validation.md` exist if they were needed. **Read the `review.md` verdict:** `not-ready` or any unresolved P1 → STOP and ask the user; `archive-with-fixes` → confirm each fix is listed under Resolved.
4. **Update durable docs** when this change changed them — do it in the tree that holds the change (the worktree, if any) so the edits merge together with the code; edit **in place**, preserving unrelated sections; make it idempotent (re-running must not duplicate). **Never regenerate or overwrite a durable doc wholesale** — use exact-match edits; ask before structural changes.
   - `docs/PROJECT.md` — feature status.
   - `docs/CONTRACTS.md` — stable hard rules. (Prefer a test/hook when the rule is enforceable.)
   - `docs/CONCEPTS.md` — only resolved, stable vocabulary; glossary entries only.
   - `docs/experiences/` — only a genuinely reusable lesson (see `/experience-capture`).
5. **Rewrite stray references** (exact sequence): `grep` the repo for `active/<slug>` path references to this change and rewrite them to `archive/<slug>`. (Well-behaved references use the change ID, not the path.)
6. Move the folder from `docs/changes/active/<change>/` to `docs/changes/archive/<change>/` — inside the tree that holds the change.
7. If a worktree `.worktrees/<change>/` exists for this change, it still holds the **only copy** of the archived docs (and the code) until `change/<change-id>` is merged. Remind the user that committing and merging that branch is theirs to do — ChangeFlow never commits or merges. Offer `git worktree remove` **only once the branch is merged** (`git branch --merged <default-branch>` lists it; after a squash or rebase merge it won't, so ask the user to confirm instead); otherwise leave the worktree in place and say so. Never `--force`, never delete the branch. If the change is archived as **abandoned/deferred**, first offer to copy the archived folder into the main tree's `docs/changes/archive/`, so its history survives deleting the branch.

## Archive checklist
```markdown
## Archive checklist
- [ ] plan.md task count checked; incompletes confirmed with user.
- [ ] design.md reflects final behavior; required review/validation present; review verdict is not `not-ready` and has no open P1.
- [ ] PROJECT.md / CONTRACTS.md / CONCEPTS.md / experiences/ updated in place (idempotent) if needed.
- [ ] Stray active/<slug> path references rewritten to archive/<slug>.
- [ ] Folder moved active → archive.
- [ ] Worktree (if any): removal offered only after `change/<change-id>` is merged.
```

## Rules (rule — why)
- Don't archive an incomplete change unless explicitly marked abandoned/deferred — archive is the historical record of what actually happened.
- No experience doc for a trivial one-off — the experiences layer is for reusable lessons, not diaries.
- Archive is immutable — never delete historical change docs.

**Next:** lifecycle complete. Consider `/docs-refresh` after a batch of archives.
