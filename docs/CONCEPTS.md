# Concepts

## change
A unit of non-trivial work tracked through the lifecycle. Lives in a folder under
`docs/changes/active/`, then moves to `archive/` when complete.

## change-id
The folder name `<YYYY-MM-DD>-<slug>` (date = creation day, fixed forever). The
**immutable cross-reference key** — reference a change by this ID, never by path.

## ephemeral vs durable
**Ephemeral** = per-change docs (design/plan/review/validation), the history of
one change. **Durable** = the project's current truth (PROJECT, CONCEPTS,
CONTRACTS, workflows, experiences). Archiving distills durable knowledge out of
the ephemeral change.

## experience
A reusable **lesson/pitfall/root-cause** ("we hit X, the rule is Y"). Lives in
`docs/experiences/`. Reactive.

## workflow
A reusable **step-by-step procedure** ("to do X, first A then B"). Lives in
`docs/workflows/`. Proactive. Distinct from an experience.

## contract
A stable **hard rule** code must obey, in `docs/CONTRACTS.md`. A living document —
editable anytime, not gated behind a change.

## concept
Stable domain **vocabulary**, in `docs/CONCEPTS.md`.

## durable-knowledge order
The preferred home for a new lesson, strongest first:
**test/hook > contract > experience/workflow > concept.** Experiences/workflows
should graduate upward or be pruned.

## human-initiated
A change exists only when a human runs a `/change-*` command. Agents never
auto-create change folders; they may *suggest*. The model B trigger.

## INDEX.md
A one-line-per-entry index in `workflows/` and `experiences/`, so an agent finds
the right file without opening every one. Maintained by the capture commands.

## skills-dir plugin
A plugin loaded by placing it under `~/.claude/skills/<name>/` (with a
`.claude-plugin/plugin.json`); auto-loads as `<name>@skills-dir`. How this plugin
is installed locally (via a symlink to the repo).

## marketplace
A catalog (`.claude-plugin/marketplace.json`) that lets users
`/plugin marketplace add` + `/plugin install`. This repo is a single-plugin
marketplace named `laoyang1994`.

## sync-codex
`scripts/sync-codex.py` — generates Codex `.codex/skills/<name>/SKILL.md` from
`commands/`. Rewrites Claude's `$ARGUMENTS` placeholder (Codex doesn't substitute
it) and appends an explicit-invocation hint to `change-*` skills.

## AGENTS.md / CLAUDE.md
`AGENTS.md` = tool-agnostic always-on instructions (read by Codex natively).
`CLAUDE.md` = Claude Code's file; it `@AGENTS.md`-imports rather than duplicates,
plus Claude-specific bits.

## worktree (per change)
Optional code isolation: at `change-implement` the agent asks whether to work in a
new git worktree at `.worktrees/<change-id>/` (branch `change/<change-id>`) or on
the current branch. Change docs stay in the main tree (so `active/` and multiple
concurrent changes keep working); only code is isolated. The one VCS action
ChangeFlow takes — it never commits, merges, or pushes.
