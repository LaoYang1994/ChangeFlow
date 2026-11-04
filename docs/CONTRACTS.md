# Contracts

Hard rules this plugin must obey. A living document — amend when a rule is
discovered. (Short, high-frequency subset is mirrored in `AGENTS.md`.)

## Source of truth
### Rules
- `commands/*.md` is the single source of truth for command behavior.
- `.agents/skills/` are GENERATED from `commands/` by `scripts/sync-codex.py` —
  never hand-edit; regenerate with `--force` after changing a command.
- Per-change templates (design/plan/review/validation) are embedded inside their
  command bodies, NOT referenced from `templates/` — Codex skills can't read the
  plugin root.

### Invalid examples
- Editing a `.agents/skills/*/SKILL.md` directly (it will be overwritten).

## Command prompts
### Rules
- The `description` frontmatter is trigger/"use when"-only, never a workflow
  summary (a summary makes the agent follow the blurb and skip the body).
- Bodies state each rule with its rationale ("rule — why"); keep them concise.
- `change-*` commands are human-initiated: they never auto-create a change; the
  generated Codex skills are marked explicit-invocation-only.
- Every `/change-*` command takes an optional change-id; with one active change
  use it, with several ask which.
- `design.md` and `plan.md` carry a `Status:` line (`draft | frozen (date) | stale`).
  Only the user's explicit approval sets `frozen`; `change-implement` refuses to
  start unless both are `frozen`.

## Scripts
### Rules
- `init.sh` never overwrites existing files (`copy_if_missing`); it preflights
  `python3` only when Codex skills are requested.
- `sync-codex.py` rewrites the `$ARGUMENTS` placeholder and `/cmd` mentions (→ `$cmd`) for Codex and skips
  `changeflow-init` (Claude-only scaffolder).
- Generated skills carry a `GENERATED` header; `sync-codex.py --prune` removes only
  skills with that header whose command no longer exists.
- `init.sh --tools claude|codex|both`: always writes the tool-agnostic `AGENTS.md`
  + docs/; adds `CLAUDE.md` only for Claude; installs Codex skills user-level
  (`~/.agents/skills/`) by default, or into `.agents/skills/` with `--codex-in-repo`.
  A repo never gets a tool's command tree unless explicitly vendored.

## Docs & tooling
### Rules
- This repo has no root `CLAUDE.md` (`claude plugin validate --strict` warns about it);
  Claude Code reads `AGENTS.md` directly. `templates/CLAUDE.md`, shipped to other
  repos, imports `@AGENTS.md` and does not duplicate it.
- Reference a change by its immutable ID, never by `active/`/`archive/` path.
- `docs/changes/archive/` is immutable history and is not in the default read
  order (forensic/pointer-only).
- `python3 scripts/lint.py` and `claude plugin validate . --strict` must pass
  before committing (lint enforces much of this file mechanically). If
  `plugin.json` and the marketplace entry both set `version`, they must agree.
- Don't run markdown auto-formatters (mdformat/prettier) over `docs/changes/` —
  `plan.md` checkboxes are a state machine; reformatting corrupts them.
- No file larger than ~1 MB enters git without explicit human acceptance —
  `change-review` flags added/changed files > 1 MB (and stray binaries) as P1;
  optionally enforce with the pre-commit hook in the README. Legit large assets → Git LFS.

## Process
### Rules
- ChangeFlow does not manage commits, merges, PRs, or review tools — that's the
  user's VCS workflow. **One carved-out exception:** `change-implement` may create
  a per-change git worktree (`.worktrees/<change-id>/`, branch `change/<change-id>`)
  and `change-archive` may remove it — both opt-in via an explicit ask, never
  silent. It still never commits, merges, or pushes. **Docs live with the code:**
  once a worktree is opened, `change-implement` moves the change's docs into it, and
  every `/change-*` command looks for a change in the current tree *and* all
  worktrees (a worktree copy wins). `change-archive` offers worktree removal only
  after the branch is merged.
- `.worktrees/` is git-ignored.
- **Never push to the remote without explicit, per-action user permission.**
- **No scratch files in `/tmp`.** Temp/scratch work goes in `./tmp/` inside the
  project (git-ignored) and is cleaned up afterwards.
