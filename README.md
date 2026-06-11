# ChangeFlow

A repo-native change workflow and documentation system for AI-assisted
engineering. Packaged as a Claude Code plugin, with first-class Codex support.

ChangeFlow organizes engineering work around a **change** with a consistent
lifecycle, and keeps long-term project knowledge in a fixed, predictable place
so any agent — or human — always knows where to look and where to write.

```
/change-design → /change-plan → /change-implement → /change-review → /change-validate → /change-archive
```

Supporting commands: `/experience-capture`, `/workflow-capture`, `/docs-refresh`, `/changeflow-init`.

---

## Why it exists (design philosophy)

1. **The repo is the source of truth, not the agent.** Knowledge lives in the
   repository — versioned, shared, tool-agnostic — not in chat history, model
   memory, or plugin state. Any agent, any session, can pick up where the last
   left off.
2. **Separate ephemeral from durable.** Per-change docs (`design`/`plan`/
   `review`/`validation`) record the history of *one* change. Durable docs
   (`PROJECT`/`CONCEPTS`/`CONTRACTS`/`experiences`/`workflows`) record the
   project's *current* truth. On archive, the durable knowledge is distilled out
   of the change.
3. **Knowledge has a direction of travel.** Prefer enforcing a lesson as a
   **test or hook**; else write a **contract** (hard rule); else capture an
   **experience** (pattern) or a **workflow** (procedure); else define a
   **concept** (vocabulary). Experiences are a holding pen, not a dumping ground.
4. **Human-initiated: the agent suggests, the human decides.** ChangeFlow never
   auto-creates state — a human command is the trigger. This keeps the human in
   control and avoids spurious documentation.
5. **Minimal but structured.** A fixed taxonomy means everyone knows where to
   look and write; no random markdown files. Only docs that earn their place.
6. **Tool-agnostic.** Works in Claude Code and Codex through the shared
   `AGENTS.md` + project-level skills standard. No tool lock-in.

---

## Install

### Claude Code — via marketplace (recommended)

```
/plugin marketplace add LaoYang1994/ChangeFlow
/plugin install changeflow@laoyang1994
```

Then run `/reload-plugins` (or restart Claude Code). CLI equivalents:

```
claude plugin marketplace add LaoYang1994/ChangeFlow
claude plugin install changeflow@laoyang1994
```

### Claude Code — via skills directory (no marketplace; good for hacking on it)

Clone (or symlink) the repo into your skills directory; it auto-loads as
`changeflow@skills-dir` on the next session:

```
git clone https://github.com/LaoYang1994/ChangeFlow ~/.claude/skills/changeflow
# …or symlink a local clone so your edits are live:
ln -s /path/to/ChangeFlow ~/.claude/skills/changeflow
```

### Codex

Codex reads project-level skills from `.codex/skills/` and instructions from
`AGENTS.md` — both per-repo. ChangeFlow installs them into your repo:

- **If you also use Claude Code:** just run `/changeflow-init` in your repo — it
  scaffolds `AGENTS.md` + `docs/` and generates `.codex/skills/`.
- **Codex-only:** clone the plugin once, then scaffold your repo with its script:
  ```
  git clone https://github.com/LaoYang1994/ChangeFlow ~/changeflow-plugin
  bash ~/changeflow-plugin/scripts/init.sh ~/changeflow-plugin /path/to/your-repo
  ```
  This writes `AGENTS.md` (which Codex reads natively) and
  `.codex/skills/<command>/SKILL.md` for each workflow. Refresh after the plugin
  updates with `python3 ~/changeflow-plugin/scripts/sync-codex.py ~/changeflow-plugin/commands /path/to/your-repo/.codex/skills --force`.

---

## Quick start

In your project:

```
/changeflow-init
```

This scaffolds the `docs/` structure, writes `AGENTS.md` + `CLAUDE.md`, installs
the Codex skills — and, **on an existing codebase, explores the code and drafts
`docs/PROJECT.md`** from what's actually there (and proposes `CONCEPTS`/
`CONTRACTS` seeds for you to confirm). You can scope the exploration, e.g.
`/changeflow-init the perception module`.

Then drive a change through the lifecycle:

```
/change-design "support multi-condition benchmark comparison"
/change-plan
/change-implement
/change-review
/change-validate
/change-archive
```

---

## The documentation structure ChangeFlow maintains

```
repo/
├── AGENTS.md            # always-on agent instructions (read by Claude & Codex)
├── CLAUDE.md            # @AGENTS.md import + Claude-specific bits
└── docs/
    ├── PROJECT.md       # what the project is + current feature status
    ├── CONCEPTS.md      # stable domain vocabulary
    ├── CONTRACTS.md     # hard rules code must obey (a living document)
    ├── workflows/       # reusable step-by-step procedures (one file each + INDEX.md)
    ├── experiences/     # reusable lessons, pitfalls, debugging notes (+ INDEX.md)
    └── changes/
        ├── active/<YYYY-MM-DD>-<slug>/   # in-flight change (design/plan/…)
        └── archive/<YYYY-MM-DD>-<slug>/  # completed changes (immutable)
```

- **Ephemeral** (per change, under `changes/`): `design.md`, `plan.md`,
  `review.md`, `validation.md`.
- **Durable** (the project's current truth): `PROJECT`, `CONCEPTS`, `CONTRACTS`,
  `workflows/`, `experiences/`.
- Changes are referenced by their **immutable ID** `<YYYY-MM-DD>-<slug>`, never
  by path; `archive/` is consulted only for forensics, not in the default read
  order.

---

## Commands

| Command | What it does |
|---|---|
| `/changeflow-init` | Scaffold the structure; on an existing repo, draft `PROJECT.md` from the code. |
| `/change-design` | Clarify requirements, confirm scope, freeze a design → `design.md`. |
| `/change-plan` | Turn the design into a task checklist (stable IDs + file paths) → `plan.md`. |
| `/change-implement` | Implement strictly per the plan; stops if there is no frozen design + plan. |
| `/change-review` | Self-review against design/plan/contracts → `review.md` (P1/P2/P3 + verdict). |
| `/change-validate` | Record real test/benchmark evidence → `validation.md` (no claim without fresh output). |
| `/change-archive` | Update durable docs, then move the change `active/ → archive/`. |
| `/experience-capture` | Record a reusable lesson/pitfall (`experiences/`), or graduate it to a test/hook/contract. |
| `/workflow-capture` | Record a reusable step-by-step procedure (`workflows/`). |
| `/docs-refresh` | Global GC: detect doc drift against the code; report or `--apply`. |

Every `/change-*` command takes an optional change-id; with one active change it
uses that, with several it asks which.

---

## How it stays tool-agnostic

`commands/*.md` is the single source of truth. The Codex skills under
`.codex/skills/` are **generated** from it by `scripts/sync-codex.py` (which
rewrites Claude's `$ARGUMENTS` placeholder for Codex and marks `change-*` skills
as explicit-invocation-only, since ChangeFlow is human-initiated). `CLAUDE.md`
imports `AGENTS.md` via `@AGENTS.md`; Codex reads `AGENTS.md` natively.

## Repository layout (this plugin)

```
.
├── .claude-plugin/
│   ├── plugin.json         # plugin manifest
│   └── marketplace.json    # single-plugin marketplace catalog
├── commands/               # canonical Claude slash commands (source of truth)
├── templates/              # bootstrap docs (AGENTS/CLAUDE/PROJECT/CONCEPTS/CONTRACTS/WORKFLOW)
├── scripts/
│   ├── init.sh             # scaffolds a target repo (Claude + Codex)
│   └── sync-codex.py       # generates .codex/skills/ from commands/
├── AGENTS.md, CLAUDE.md    # this repo's own agent instructions (it dogfoods itself)
├── docs/                   # this repo's own durable docs (PROJECT/CONCEPTS/CONTRACTS/workflows/experiences)
└── README.md
```

ChangeFlow uses ChangeFlow on itself: this repo's durable docs live in `docs/`
and its agent rules in `AGENTS.md`. The stubs under `templates/` are what the
plugin *ships* to other repos — not this repo's own docs.
