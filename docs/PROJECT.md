# Project

## Overview
ChangeFlow is a repo-native change-workflow and documentation system for
AI-assisted engineering, packaged as a Claude Code plugin with first-class Codex
support. It organizes work around a **change** with a fixed lifecycle, and keeps
long-term knowledge in a predictable taxonomy so any agent — or human — always
knows where to look and where to write.

## Design philosophy
1. **The repo is the source of truth, not the agent.** Knowledge lives in the
   repository (versioned, shared, tool-agnostic), not in chat history, model
   memory, or plugin state.
2. **Separate ephemeral from durable.** Per-change docs (design/plan/review/
   validation) record one change's history; durable docs (PROJECT/CONCEPTS/
   CONTRACTS/workflows/experiences) record the project's current truth. Archiving
   distills the durable knowledge out of a change.
3. **Knowledge has a direction of travel.** Enforce as a test/hook > write a
   contract > capture an experience or workflow > define a concept. Experiences
   are a holding pen, not a dumping ground.
4. **Human-initiated: the agent suggests, the human decides.** No auto-created
   state; a human command is the trigger.
5. **Minimal but structured.** Fixed taxonomy, no random markdown; only docs that
   earn their place.
6. **Tool-agnostic.** Claude Code and Codex via the shared `AGENTS.md` +
   project-level skills standard.

## Users
AI coding agents (Claude Code, Codex) and the engineers who direct them.

## Core workflows
- Change lifecycle: `change-design → change-plan → change-implement →
  change-review → change-validate → change-archive`.
- Optional pre-build gate: `change-plan-review` — confront design + plan with the
  real code/data + contracts before implementing (opt-in; catches late-surfacing
  design gaps cheaply).
- Supporting: `experience-capture`, `workflow-capture`, `docs-refresh`,
  `changeflow-init`.

## Repository layout
```text
.
├── .claude-plugin/
│   ├── plugin.json          # plugin manifest
│   └── marketplace.json     # single-plugin marketplace catalog (laoyang1994)
├── commands/                # 10 slash commands — the canonical source of truth
├── templates/               # stubs the plugin ships to other repos
│   ├── AGENTS.md CLAUDE.md PROJECT.md CONCEPTS.md CONTRACTS.md WORKFLOW.md
│   └── WORKFLOWS_INDEX.md EXPERIENCES_INDEX.md
├── scripts/
│   ├── init.sh              # scaffolds a target repo (Claude + Codex)
│   └── sync-codex.py        # generates .codex/skills/ from commands/
├── AGENTS.md CLAUDE.md      # THIS repo's own agent instructions
├── docs/                    # THIS repo's own durable docs (dogfood)
└── README.md
```

## Core modules
- **commands/** — the 11 command prompts; editing a command and re-syncing is the
  main way behavior changes. Single source of truth for both tools.
- **templates/** — bootstrap docs the plugin writes into target repos.
- **scripts/init.sh** — deterministic scaffold (dirs + bootstrap docs + Codex
  skills); on an existing repo, the `changeflow-init` command then explores and
  drafts PROJECT.md.
- **scripts/sync-codex.py** — derives Codex `.codex/skills/<name>/SKILL.md` from
  `commands/`, rewriting `$ARGUMENTS` and marking `change-*` explicit-only.

## Feature status
- Status: **active, v0.1.0**. Installed locally as `changeflow@skills-dir`.
- 11 commands; Codex support via generated skills; marketplace catalog for
  `/plugin install`. Command prompts enriched and A/B-validated (Codex blind
  judge: new prompts won all 3 difficulty tiers).

## Links
- Hard rules: `docs/CONTRACTS.md`
- Vocabulary: `docs/CONCEPTS.md`
- Procedures: `docs/workflows/INDEX.md`
- Lessons: `docs/experiences/INDEX.md`
