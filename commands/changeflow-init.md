---
description: Scaffold ChangeFlow in the current repo — create the docs/ structure, write AGENTS.md and CLAUDE.md, and install the Codex skills.
argument-hint: "[target-dir]"
---

Scaffold ChangeFlow in a repository.

Target directory (optional, defaults to the current working directory): $ARGUMENTS

## Steps
1. Run the init script, passing the plugin root and the target directory:
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/init.sh" "${CLAUDE_PLUGIN_ROOT}" "${ARGUMENTS:-$PWD}"
   ```
2. Report what was created vs. skipped (the script never overwrites existing files).
3. Remind the user to:
   - fill in `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md`;
   - replace the example **Critical rules** in `AGENTS.md` with their project's real hard rules (or move enforceable ones into tests/hooks);
   - accept the workspace trust dialog so project-scope config loads.

## What the script does
- Creates `docs/`, `docs/changes/active/`, `docs/changes/archive/`, `docs/experiences/`.
- Writes `AGENTS.md`, `CLAUDE.md`, `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md` from templates (only if missing).
- Generates `.codex/skills/<name>/SKILL.md` for each `change-*`, `experience-capture`, and `docs-refresh` command, so the repo works in Codex too.
