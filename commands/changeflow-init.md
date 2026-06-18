---
description: Use when the user explicitly sets up ChangeFlow in a repo — choose tool(s), scaffold the docs/ structure + AGENTS.md, install the chosen tool's command set, and (for an existing codebase) draft PROJECT.md from the actual code.
argument-hint: "[target-dir]"
---

Set up ChangeFlow in a repository. Open with: "Setting up ChangeFlow …".

Target directory (optional): $ARGUMENTS — defaults to the current directory.

## Step 1 — Choose the tool(s)
Ask the user which tool(s) to set up, **defaulting to the tool you're running in**:
**Claude Code / Codex / both.** If the user already named a tool (in the arg or their message), honor it and skip the question. If a tool is already set up here, just offer to add the missing one — `init.sh` is idempotent and won't clobber.

If **Codex** is chosen, also ask where its skills go:
- **user-level** (`~/.codex/skills/`, default) — for you, across all your repos; nothing is added to this repo.
- **vendored in repo** (`.codex/skills/`) — committed so collaborators get the skills via git.

## Step 2 — Scaffold (deterministic)
Run the init script with the chosen flags:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/init.sh" "${CLAUDE_PLUGIN_ROOT}" "<target-dir>" \
  --tools <claude|codex|both> [--codex-in-repo]
```
It always writes the `docs/` structure + `AGENTS.md` + `docs/{PROJECT,CONCEPTS,CONTRACTS}.md` + the INDEX files (never overwriting). `--tools claude` adds `CLAUDE.md`; `--tools codex` installs the Codex skills (user-level by default, or into `.codex/skills/` with `--codex-in-repo`). Report what was created vs. skipped.

## Step 3 — Adopt an existing codebase (only if there is real code)
A blank `PROJECT.md` is useless on an existing project. If the repo already has source:
1. **Explore** — whole repo, or the area named in the argument. Use Explore/subagents for anything non-trivial.
2. **Draft `docs/PROJECT.md`** from the findings (what it does, modules, layout, feature status). Base every line on something you actually read — don't invent.
3. **Propose** seeds for `docs/CONCEPTS.md` and `docs/CONTRACTS.md` (domain terms, candidate hard rules) — list them and **ask** before writing; contracts especially get confirmed, not asserted.
4. Leave `docs/experiences/` and `docs/workflows/` empty (they fill as work happens).

## Step 4 — Hand off
Remind the user:
- review the drafted `PROJECT.md`; confirm the proposed CONCEPTS/CONTRACTS;
- replace the example **Critical rules** in `AGENTS.md` with their real rules;
- **Claude:** each user installs the changeflow plugin (commands come from the plugin, not the repo); accept the workspace trust dialog.
- **Codex (user-level):** collaborators install ChangeFlow into their own `~/.codex/skills/` the same way. **Codex (vendored):** commit `.codex/skills/` so collaborators get it via git.

## Notes
- The repo only ever holds `AGENTS.md` + `docs/` (+ `CLAUDE.md` if Claude, + `.codex/skills/` only if vendored). Command sets live per-user (`~/.claude/skills/`, `~/.codex/skills/`) unless vendored.
- To add the other tool later, just re-run this command for it (idempotent).
- Refresh Codex skills after the plugin updates: `sync-codex.py <commands> <dest> --force`.
