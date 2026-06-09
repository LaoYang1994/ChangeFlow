#!/usr/bin/env python3
"""Generate Codex project skills from ChangeFlow's canonical Claude commands.

Usage:
    python3 sync-codex.py <commands-dir> <output-skills-dir> [--force]

For each command file (except changeflow-init), writes
<output-skills-dir>/<name>/SKILL.md with Codex frontmatter (name, description)
followed by the command body.

By default existing SKILL.md files are left untouched (non-destructive /
idempotent); pass --force to regenerate them after editing the commands.

Codex-specific transforms:
- change-* skill descriptions get an explicit human-initiation hint appended
  (so Codex does not auto-trigger them).
- Claude's `$ARGUMENTS` placeholder — which Codex does NOT substitute — is
  rewritten to plain wording so the generated skill reads correctly.
"""
import sys
from pathlib import Path

SKIP = {"changeflow-init"}
HINT = "Invoke only when the user explicitly asks; never on your own."
ARGS_PLACEHOLDER = "$ARGUMENTS"
ARGS_REPLACEMENT = "(the text the user provided when invoking this skill; may be empty)"


def parse_frontmatter(text):
    """Return (meta: dict, body: str).

    Frontmatter is recognized ONLY when the first line is exactly '---' and a
    later line is exactly '---'. Flat 'key: value' pairs only (values may
    contain colons; split once). CRLF tolerated. Anything else => no
    frontmatter, everything is body (so a body that opens with a '---'
    horizontal rule is never mistaken for frontmatter).
    """
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = text.split("\n")
    if not lines or lines[0].strip() != "---":
        return {}, text
    close = next((i for i in range(1, len(lines)) if lines[i].strip() == "---"), None)
    if close is None:
        return {}, text
    meta = {}
    for line in lines[1:close]:
        if line.strip() and ":" in line:
            k, v = line.split(":", 1)
            meta[k.strip()] = v.strip()
    body = "\n".join(lines[close + 1:]).lstrip("\n")
    return meta, body


def quote(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    force = "--force" in sys.argv[1:]
    if len(args) != 2:
        print(__doc__)
        sys.exit(1)
    commands_dir, out_dir = Path(args[0]), Path(args[1])
    if not commands_dir.is_dir():
        print(f"error: commands dir not found: {commands_dir}", file=sys.stderr)
        sys.exit(1)

    wrote, skipped = [], []
    for cmd in sorted(commands_dir.glob("*.md")):
        name = cmd.stem
        if name in SKIP:
            continue
        out_file = out_dir / name / "SKILL.md"
        if out_file.exists() and not force:
            skipped.append(name)
            continue
        meta, body = parse_frontmatter(cmd.read_text())
        desc = meta.get("description", name).strip().strip('"')
        if name.startswith("change-") and HINT not in desc and "human-initiated" not in desc.lower():
            desc = f"{desc} {HINT}"
        body = body.replace(ARGS_PLACEHOLDER, ARGS_REPLACEMENT)
        out_file.parent.mkdir(parents=True, exist_ok=True)
        out_file.write_text(
            "---\n"
            f"name: {name}\n"
            f"description: {quote(desc)}\n"
            "---\n\n"
            f"{body.rstrip()}\n"
        )
        wrote.append(name)

    print(f"codex skills -> {out_dir}  (wrote {len(wrote)}, skipped {len(skipped)})")
    for n in wrote:
        print(f"  wrote: {n}")
    for n in skipped:
        print(f"  skip (exists; use --force): {n}")


if __name__ == "__main__":
    main()
