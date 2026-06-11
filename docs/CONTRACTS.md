# Contracts

Hard rules this plugin must obey. A living document — amend when a rule is
discovered. (Short, high-frequency subset is mirrored in `AGENTS.md`.)

## Source of truth
### Rules
- `commands/*.md` is the single source of truth for command behavior.
- `.codex/skills/` are GENERATED from `commands/` by `scripts/sync-codex.py` —
  never hand-edit; regenerate with `--force` after changing a command.
- Per-change templates (design/plan/review/validation) are embedded inside their
  command bodies, NOT referenced from `templates/` — Codex skills can't read the
  plugin root.

### Invalid examples
- Editing a `.codex/skills/*/SKILL.md` directly (it will be overwritten).

## Command prompts
### Rules
- The `description` frontmatter is trigger/"use when"-only, never a workflow
  summary (a summary makes the agent follow the blurb and skip the body).
- Bodies state each rule with its rationale ("rule — why"); keep them concise.
- `change-*` commands are human-initiated: they never auto-create a change; the
  generated Codex skills are marked explicit-invocation-only.
- Every `/change-*` command takes an optional change-id; with one active change
  use it, with several ask which.

## Scripts
### Rules
- `init.sh` never overwrites existing files (`copy_if_missing`), and preflights
  `python3` before scaffolding anything.
- `sync-codex.py` rewrites the `$ARGUMENTS` placeholder for Codex and skips
  `changeflow-init` (Claude-only scaffolder).
- `init.sh` is tool-agnostic: it writes `AGENTS.md` (Codex reads it) and
  `.codex/skills/`, not just Claude files.

## Docs & tooling
### Rules
- `CLAUDE.md` imports `@AGENTS.md`; it does not duplicate AGENTS content.
- Reference a change by its immutable ID, never by `active/`/`archive/` path.
- `docs/changes/archive/` is immutable history and is not in the default read
  order (forensic/pointer-only).
- `claude plugin validate . --strict` must pass before committing. If
  `plugin.json` and the marketplace entry both set `version`, they must agree.

## Process
### Rules
- ChangeFlow does not manage commits/PRs/review tools — that's the user's VCS
  workflow. Agents don't perform VCS actions in `change-*` commands.
- **Never push to the remote without explicit, per-action user permission.**
