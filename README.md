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

Optional pre-build gate: `/change-plan-review` (between plan and implement).

Hands-off mode: `/change-autopilot` runs the whole lifecycle for one change and stops only to ask when blocked.

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

### Codex — via marketplace

Install the same GitHub marketplace and plugin in Codex:

```bash
codex plugin marketplace add LaoYang1994/ChangeFlow --ref main
codex plugin add changeflow@laoyang1994
```

For an existing installation (including v0.2.0), refresh it with:

```bash
codex plugin marketplace upgrade laoyang1994
```

In a new chat, invoke `$changeflow:changeflow-init` to scaffold a project or
`$changeflow:change-design` to start a change. The plugin ships all 12 skills.
If you previously installed standalone copies in `~/.agents/skills/`,
`~/.codex/skills/`, or a project's `.agents/skills/`, move **only** the
ChangeFlow copies you no longer use outside those directories after verifying
the namespaced skills. Keep copies with your own edits for reference.

**Standalone option.** From a clone, run
`bash scripts/init.sh "$PWD" /path/to/your-repo --tools codex` to scaffold the
project and install user-level skills. Add `--codex-in-repo` to vendor the skills.
Standalone skills use names such as `$change-design` and follow the clone's version.

### Antigravity

Install the plugin directly from GitHub (or from a local clone):

```bash
agy plugin install https://github.com/LaoYang1994/ChangeFlow
# or from a local clone:
agy plugin install /path/to/ChangeFlow
```

---

## Quick start

In Claude Code, run this in your project (in Codex use `$changeflow:changeflow-init`):

```
/changeflow-init
```

It asks which tool(s) to set up (Claude / Codex / both), scaffolds the `docs/`
structure + `AGENTS.md` (+ `CLAUDE.md` for Claude), uses the installed Codex marketplace skills when invoked from that plugin — and, **on an existing codebase, explores the code and drafts
`docs/PROJECT.md`** from what's actually there (proposing `CONCEPTS`/`CONTRACTS`
seeds to confirm). You can scope the exploration, e.g.
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

Or hand the whole change to the agent: `/change-autopilot "support multi-condition benchmark comparison"`.
It asks its questions once up front, then runs every phase on its own: it self-approves the
routine gates (`Status: frozen (<date>, autopilot)`), always runs the plan-review gate,
and stops to ask on real blockers (scope or design changes, contract changes, repeated
failures, anything destructive). It never commits, merges, or pushes.

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
| `/change-design` | Clarify requirements, confirm scope, ask once whether to isolate in a git worktree (`.worktrees/<id>/`), freeze a design → `design.md`. |
| `/change-plan` | Turn the design into a task checklist (stable IDs + file paths) → `plan.md`. |
| `/change-plan-review` | (Opt-in) pre-build gate: confront design + plan with the real code/data + contracts before implementing; fold fixes into design/plan. |
| `/change-implement` | Implement strictly per the plan (in the change's worktree if one was chosen); stops if there is no frozen design + plan. |
| `/change-review` | Self-review against design/plan/contracts → `review.md` (P1/P2/P3 + verdict). |
| `/change-validate` | Record real test/benchmark evidence → `validation.md` (no claim without fresh output). |
| `/change-archive` | Update durable docs, then move the change `active/ → archive/`. |
| `/change-autopilot` | Drive one change through every phase unattended (questions up front, self-approved gates tagged `autopilot`, mandatory plan-review); stops to ask on real blockers. |
| `/experience-capture` | Record a reusable lesson/pitfall (`experiences/`), or graduate it to a test/hook/contract. |
| `/workflow-capture` | Record a reusable step-by-step procedure (`workflows/`). |
| `/docs-refresh` | Global GC: detect doc drift against the code; report or `--apply`. |

Every `/change-*` command takes an optional change-id; with one active change it
uses that, with several it asks which.

---

## Optional: block large files before commit

`/change-review` flags added/changed files over ~1 MB as P1. To hard-block them
at commit time, install this opt-in pre-commit hook:

```bash
if [ -e .git/hooks/pre-commit ]; then
  echo "A pre-commit hook already exists — merge this check into it by hand."
else
cat > .git/hooks/pre-commit <<'EOF'
#!/usr/bin/env bash
# Block staged files larger than 1 MB. Override with: git commit --no-verify
fail=0
while read -r f; do
  s=$(git cat-file -s ":$f" 2>/dev/null) || continue   # size of the staged blob
  [ "$s" -gt 1048576 ] && { echo "blocked (>1MB): $f ($s bytes)"; fail=1; }
done < <(git diff --cached --name-only --diff-filter=ACM)
[ "$fail" = 0 ] || { echo "Large file(s) staged — use 'git commit --no-verify' to override, or Git LFS."; exit 1; }
EOF
  chmod +x .git/hooks/pre-commit
fi
```

`.git/hooks/` isn't versioned. To share the hook with collaborators, commit it
under e.g. `.githooks/` and run `git config core.hooksPath .githooks`.

---

## How it stays tool-agnostic

`commands/*.md` is the single source of truth. The Codex skills are **generated**
from it by `scripts/sync-codex.py` (which rewrites Claude's `$ARGUMENTS`
placeholder for Codex and marks `change-*` skills explicit-invocation-only via `agents/openai.yaml`,
since ChangeFlow is human-initiated). The marketplace ships generated files in
`codex/skills/`. Maintainers regenerate them when editing a command:

```bash
python3 scripts/sync-codex.py commands codex/skills --plugin --force --prune
python3 scripts/lint.py
```

`CLAUDE.md` imports `AGENTS.md` via `@AGENTS.md`; Codex reads `AGENTS.md` natively.

## Repository layout (this plugin)

```
.
├── .claude-plugin/
│   ├── plugin.json         # plugin manifest
│   └── marketplace.json    # single-plugin marketplace catalog
├── .codex-plugin/plugin.json        # Codex manifest using the packaged skills
├── .antigravity-plugin/plugin.json  # Antigravity manifest using the packaged skills
├── codex/skills/           # packaged, generated skills (Codex & Antigravity)
├── commands/               # canonical Claude slash commands (source of truth)
├── templates/              # bootstrap docs (AGENTS/CLAUDE/PROJECT/CONCEPTS/CONTRACTS/WORKFLOW)
├── scripts/
│   ├── init.sh             # scaffolds a target repo (tool-selectable via --tools)
│   ├── sync-codex.py       # generates Codex skills from commands/ (dest configurable)
│   └── lint.py             # checks this plugin's own contracts (run before committing)
├── AGENTS.md               # this repo's own agent instructions (it dogfoods itself)
├── docs/                   # this repo's own durable docs (PROJECT/CONCEPTS/CONTRACTS/workflows/experiences)
└── README.md
```

ChangeFlow uses ChangeFlow on itself: this repo's durable docs live in `docs/`
and its agent rules in `AGENTS.md`. The stubs under `templates/` are what the
plugin *ships* to other repos — not this repo's own docs.
