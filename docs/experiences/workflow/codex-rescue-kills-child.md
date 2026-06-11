# Codex rescue subagent kills its child process

## Problem
A long Codex task (a full code review) dispatched through the `codex:codex-rescue`
subagent died mid-run: the job log froze after the investigation phase, status
stayed `"running"`, and no final report was ever produced.

## Root cause
The rescue subagent returned after handing the task to the Codex companion, and
the Codex child process was torn down when the subagent's process tree ended —
the companion's async handoff isn't fully detached in this environment.

## Pattern / Rule
For long Codex jobs (reviews, blind judging, multi-file analysis), drive
`codex exec` **directly** in the background and read its output file, rather than
relying on the rescue subagent's async handoff.

## How to apply
```bash
codex exec -C <workdir> -s read-only - < prompt.txt > out.md 2>&1   # run_in_background
```
Read `out.md` when notified. The final report is at the END of the file (the
output includes the full session transcript before it).

## Validation
Every directly-driven `codex exec` run in this project completed and produced a
full report; the subagent-dispatched one froze and produced nothing.

## Pitfalls
- Don't parse the whole transcript — grep/seek to the final report block.
- Use `-C <dir>` so read-only reads resolve under the right workdir.

## Related changes
- (pre-dates change tracking on this repo)

## Related contracts
- —
