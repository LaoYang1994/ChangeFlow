---
description: Use when the user explicitly sets up ChangeFlow in a repo — scaffold the docs/ structure, write AGENTS.md/CLAUDE.md, install Codex skills, and (for an existing codebase) populate PROJECT.md from the actual code.
argument-hint: "[target-dir | area to focus the exploration on]"
---

Scaffold ChangeFlow in a repository. Open with: "Setting up ChangeFlow …".

Argument (optional): $ARGUMENTS — either a target directory, or an area/subsystem to focus the codebase exploration on. Default target is the current directory; default exploration scope is the whole repo.

## Step 1 — Scaffold (deterministic)
Run the init script. Pass the plugin root, then the target directory:
- If the user named a target directory, pass it as a single quoted second argument (may contain spaces).
- Otherwise omit it — `init.sh` defaults to the current directory.
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/init.sh" "${CLAUDE_PLUGIN_ROOT}" "<target-dir>"   # or omit the 2nd arg for $PWD
```
This creates `docs/{changes/active,changes/archive,experiences,workflows}/`, writes `AGENTS.md`, `CLAUDE.md`, and empty `docs/{PROJECT,CONCEPTS,CONTRACTS}.md` from templates (only if missing), and generates `.codex/skills/` so the repo works in Codex too. Report what was created vs. skipped.

## Step 2 — Adopt an existing codebase (only if there is real code)
A fresh `PROJECT.md` template is useless on an existing project. If the repo already has source code, populate the durable docs from what's actually there:

1. **Explore.** Scope = the whole repo, or the area the user named in the argument. Read the README, package/build manifests, and the main source tree. For anything non-trivial, dispatch Explore/general-purpose subagents to map modules in parallel rather than reading everything yourself.
2. **Draft `docs/PROJECT.md`** from the findings: what the project does, main users, core workflows, repository layout, core modules (with responsibilities), and current feature status. Base every line on something you actually read — do not invent. This draft is the highest-value output; make it reviewable.
3. **Propose seeds for `docs/CONCEPTS.md` and `docs/CONTRACTS.md`** — domain terms you saw, and candidate hard rules you inferred (e.g. invariants, data formats, layout assumptions). These are judgment calls: **list them and ask** before writing; contracts especially should be confirmed, not asserted.
4. Leave `docs/experiences/` and `docs/workflows/` empty — they fill up as work happens.

If the repo is empty/new, skip Step 2 and just leave the templates for the user to fill.

## Step 3 — Hand off
Remind the user to:
- review/adjust the drafted `PROJECT.md` and confirm the proposed CONCEPTS/CONTRACTS;
- replace the example **Critical rules** in `AGENTS.md` with real project rules (or move enforceable ones into tests/hooks);
- accept the workspace trust dialog so project-scope config loads;
- in Claude Code, run `/reload-plugins` (or restart) if commands aren't visible yet.

## Notes
- `init.sh` never overwrites existing files; existing Codex skills are preserved (refresh with `scripts/sync-codex.py ... --force`).
- Per-change templates (design/plan/review/validation) live inside their command bodies, not in `templates/`.
