---
description: Use when the user explicitly completes a change — fold its durable knowledge into long-term docs, then move the folder active→archive. Human-initiated.
argument-hint: "[change-id]"
---

Run the ChangeFlow **change-archive** workflow. Open with: "Running change-archive for …".

Target change-id (optional): $ARGUMENTS

> **IRON LAW: UPDATE DURABLE DOCS BEFORE MOVING THE FOLDER.**
> Once the folder is in `archive/`, nobody reads it routinely — anything durable not promoted now is effectively lost.

## Steps
1. Locate the active change (id given → use it; omitted → one active → use it; multiple → ask which).
2. **Completeness count.** Count `- [ ]` vs `- [x]` in `plan.md`. If tasks are incomplete, show the count and **ask** whether to archive anyway — don't block, but never archive incompleteness silently.
3. Confirm `design.md` reflects final behavior; `review.md`/`validation.md` exist if they were needed.
4. **Update durable docs** when this change changed them — edit **in place**, preserving unrelated sections; make it idempotent (re-running must not duplicate). **Never regenerate or overwrite a durable doc wholesale** — use exact-match edits; ask before structural changes.
   - `docs/PROJECT.md` — feature status.
   - `docs/CONTRACTS.md` — stable hard rules. (Prefer a test/hook when the rule is enforceable.)
   - `docs/CONCEPTS.md` — only resolved, stable vocabulary; glossary entries only.
   - `docs/experiences/` — only a genuinely reusable lesson (see `/experience-capture`).
5. **Rewrite stray references** (exact sequence): `grep` the repo for `active/<slug>` path references to this change and rewrite them to `archive/<slug>`. (Well-behaved references use the change ID, not the path.)
6. Move the folder from `docs/changes/active/<change>/` to `docs/changes/archive/<change>/`.

## Archive checklist
```markdown
## Archive checklist
- [ ] plan.md task count checked; incompletes confirmed with user.
- [ ] design.md reflects final behavior; required review/validation present.
- [ ] PROJECT.md / CONTRACTS.md / CONCEPTS.md / experiences/ updated in place (idempotent) if needed.
- [ ] Stray active/<slug> path references rewritten to archive/<slug>.
- [ ] Folder moved active → archive.
```

## Rules (rule — why)
- Don't archive an incomplete change unless explicitly marked abandoned/deferred — archive is the historical record of what actually happened.
- No experience doc for a trivial one-off — the experiences layer is for reusable lessons, not diaries.
- Archive is immutable — never delete historical change docs.

**Next:** lifecycle complete. Consider `/docs-refresh` after a batch of archives.
