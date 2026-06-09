#!/usr/bin/env python3
"""Generate Codex project skills from ChangeFlow's canonical Claude commands.

Usage:
    python3 sync-codex.py <commands-dir> <output-skills-dir>

For each command file (except changeflow-init), writes
<output-skills-dir>/<name>/SKILL.md with Codex frontmatter (name, description)
followed by the command body. change-* skills get an explicit-invocation hint
appended to their description so Codex does not auto-trigger them (ChangeFlow
changes are human-initiated).
"""
import sys
from pathlib import Path

# Commands that are Claude-plugin scaffolding only, not Codex workflows.
SKIP = {"changeflow-init"}


def parse_frontmatter(text):
    """Return (meta: dict, body: str). Minimal YAML: flat key: value pairs."""
    meta, body = {}, text
    if text.startswith("---"):
        end = text.find("\n---", 3)
        if end != -1:
            block = text[3:end].strip("\n")
            body = text[end + 4:].lstrip("\n")
            for line in block.splitlines():
                if ":" in line:
                    k, v = line.split(":", 1)
                    meta[k.strip()] = v.strip()
    return meta, body


def quote(s):
    """Quote a YAML scalar safely."""
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    commands_dir = Path(sys.argv[1])
    out_dir = Path(sys.argv[2])
    if not commands_dir.is_dir():
        print(f"error: commands dir not found: {commands_dir}", file=sys.stderr)
        sys.exit(1)

    written = []
    for cmd in sorted(commands_dir.glob("*.md")):
        name = cmd.stem
        if name in SKIP:
            continue
        meta, body = parse_frontmatter(cmd.read_text())
        desc = meta.get("description", name).strip().strip('"')
        if name.startswith("change-") and "explicit" not in desc.lower():
            desc += " Invoke only when the user explicitly asks; never on your own."

        skill_dir = out_dir / name
        skill_dir.mkdir(parents=True, exist_ok=True)
        content = (
            "---\n"
            f"name: {name}\n"
            f"description: {quote(desc)}\n"
            "---\n\n"
            f"{body.rstrip()}\n"
        )
        (skill_dir / "SKILL.md").write_text(content)
        written.append(name)

    print(f"synced {len(written)} Codex skills -> {out_dir}")
    for n in written:
        print(f"  - {n}")


if __name__ == "__main__":
    main()
