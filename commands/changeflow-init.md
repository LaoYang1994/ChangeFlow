---
description: Scaffold ChangeFlow in the current repo — create the docs/ structure, write AGENTS.md and CLAUDE.md, and install the Codex skills.
argument-hint: "[target-dir]"
---

Scaffold ChangeFlow in a repository.

Target directory the user gave (optional): $ARGUMENTS

## Steps
1. Run the init script. Pass the plugin root, then the target directory:
   - If the user gave a target directory above, pass it as a single quoted second argument (it may contain spaces).
   - If they gave none, omit the second argument — `init.sh` defaults to the current directory.
   ```bash
   # with a user-provided target:
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/init.sh" "${CLAUDE_PLUGIN_ROOT}" "<target-dir>"
   # with no target (defaults to $PWD):
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/init.sh" "${CLAUDE_PLUGIN_ROOT}"
   ```
2. Report what was created vs. skipped (the script never overwrites existing files; existing Codex skills are preserved).
3. Remind the user to:
   - fill in `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md`;
   - replace the example **Critical rules** in `AGENTS.md` with their project's real hard rules (or move enforceable ones into tests/hooks);
   - accept the workspace trust dialog so project-scope config loads.

## What the script does
- Preflights `python3` (needed for Codex skill generation) before touching anything.
- Creates `docs/`, `docs/changes/active/`, `docs/changes/archive/`, `docs/experiences/`.
- Writes `AGENTS.md`, `CLAUDE.md`, `docs/PROJECT.md`, `docs/CONCEPTS.md`, `docs/CONTRACTS.md` from templates (only if missing).
- Generates `.codex/skills/<name>/SKILL.md` for each `change-*`, `experience-capture`, and `docs-refresh` command, so the repo works in Codex too. Existing skills are left untouched; to refresh them after editing commands, run `scripts/sync-codex.py ... --force`.
