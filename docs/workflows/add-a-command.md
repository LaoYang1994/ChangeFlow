# Add a command

## Purpose
Add (or replace) a ChangeFlow slash command correctly, so it works in both
Claude Code and Codex.

## When to use
Whenever you create a new `commands/<name>.md` or materially change one.

## Steps
1. Write `commands/<name>.md`: frontmatter `description` is trigger/"use when"-only
   (never a workflow summary); body states each rule with its *why*; embed any
   output template **inline** (Codex skills can't reach `templates/`).
2. If it's a `change-*` lifecycle command, sync will mark its Codex skill
   explicit-invocation-only automatically; supporting commands stay suggestible.
3. Update `README.md` (command table + supporting-commands line) and `AGENTS.md`
   if the command produces or reads a durable doc.
4. Regenerate the marketplace package with
   `python3 scripts/sync-codex.py commands codex/skills --plugin --force --prune`.
   Include the resulting changes in the same commit as the command.
5. Run `python3 scripts/lint.py` and `claude plugin validate . --strict` — both must pass.
6. Commit. Get explicit permission before pushing.

## Gotchas
- A description that summarizes the workflow makes the agent follow the blurb and
  skip the body — keep it trigger-only.
- Never hand-edit `codex/skills/*` — they're generated; regenerate instead.
- Forgetting `--force` leaves stale Codex skills (sync skips existing by default).

## Related
- Contracts: `docs/CONTRACTS.md#command-prompts`, `#source-of-truth`
