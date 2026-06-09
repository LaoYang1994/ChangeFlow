# ChangeFlow

A repo-native change workflow and documentation system for AI-assisted
engineering. Packaged as a Claude Code plugin, with first-class Codex support.

## What it does

ChangeFlow organizes engineering work around a **change** with a consistent
lifecycle, and keeps long-term project knowledge in a fixed, predictable place
so humans and agents always know where to look and where to write.

```
/change-design → /change-plan → /change-implement → /change-review → /change-validate → /change-archive
```

Supporting commands: `/experience-capture`, `/docs-refresh`.

Durable knowledge lives in `docs/PROJECT.md`, `docs/CONCEPTS.md`,
`docs/CONTRACTS.md`, and `docs/experiences/`. Per-change history lives in
`docs/changes/active/` and moves to `docs/changes/archive/` when complete.

## Install (Claude Code)

Install the plugin (from a marketplace or a local path), then scaffold a repo:

```
/changeflow-init
```

`/changeflow-init` creates the `docs/` structure, writes `AGENTS.md` and
`CLAUDE.md`, and installs the Codex skills (`.codex/skills/`) so the same repo
works in both tools.

## Codex support

ChangeFlow targets two shared, repo-native mechanisms:

- **`AGENTS.md`** — read by both Codex (natively) and Claude Code (via
  `@AGENTS.md` import in `CLAUDE.md`). This is the always-on rule layer.
- **Project-level skills** — the eight workflows are generated as
  `.codex/skills/<name>/SKILL.md` from the canonical Claude commands in
  `commands/`, via `scripts/sync-codex.py`.

Codex custom prompts (`~/.codex/prompts/`) are deprecated by OpenAI; ChangeFlow
uses Codex **skills** instead, which are project-level and version-controlled.

### Cross-tool nuance

Codex skills can be auto-invoked by the model. ChangeFlow's `change-*` workflows
are **human-initiated only**, so the generated Codex skill descriptions are
phrased for explicit invocation, and every body keeps the "never open a change
on your own" guard.

## Repository layout (this plugin)

```
.
├── .claude-plugin/plugin.json
├── commands/                # canonical Claude slash commands (source of truth)
│   ├── change-design.md ... docs-refresh.md
│   └── changeflow-init.md
├── templates/               # repo-bootstrap docs (AGENTS/CLAUDE/PROJECT/CONCEPTS/CONTRACTS)
├── scripts/
│   ├── init.sh              # scaffolds a target repo
│   └── sync-codex.py        # generates .codex/skills/ from commands/
└── README.md
```

## Keeping Codex in sync

`commands/*.md` is the single source of truth. Regenerate the Codex skills with:

```
python3 scripts/sync-codex.py commands <target-repo>/.codex/skills
```

`/changeflow-init` runs this for you.
