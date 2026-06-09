#!/usr/bin/env bash
# Scaffold ChangeFlow into a target repository.
#
# Usage: init.sh <plugin-root> [target-dir]
#
# Never overwrites existing files. Creates the docs/ structure, writes the
# bootstrap docs from templates, and generates Codex skills under .codex/skills/.
set -euo pipefail

PLUGIN_ROOT="${1:?usage: init.sh <plugin-root> [target-dir]}"
TARGET="${2:-$PWD}"

copy_if_missing() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    echo "  skip (exists): ${dst#$TARGET/}"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  create: ${dst#$TARGET/}"
  fi
}

echo "ChangeFlow init -> $TARGET"

echo "[dirs]"
for d in docs docs/changes/active docs/changes/archive docs/experiences; do
  mkdir -p "$TARGET/$d"
  echo "  ensure: $d/"
done

echo "[docs]"
copy_if_missing "$PLUGIN_ROOT/templates/AGENTS.md"   "$TARGET/AGENTS.md"
copy_if_missing "$PLUGIN_ROOT/templates/CLAUDE.md"   "$TARGET/CLAUDE.md"
copy_if_missing "$PLUGIN_ROOT/templates/PROJECT.md"  "$TARGET/docs/PROJECT.md"
copy_if_missing "$PLUGIN_ROOT/templates/CONCEPTS.md" "$TARGET/docs/CONCEPTS.md"
copy_if_missing "$PLUGIN_ROOT/templates/CONTRACTS.md" "$TARGET/docs/CONTRACTS.md"

echo "[codex]"
python3 "$PLUGIN_ROOT/scripts/sync-codex.py" "$PLUGIN_ROOT/commands" "$TARGET/.codex/skills" \
  | sed 's/^/  /'

echo "done."
echo
echo "Next:"
echo "  1. Fill in docs/PROJECT.md, docs/CONCEPTS.md, docs/CONTRACTS.md."
echo "  2. Replace the example Critical rules in AGENTS.md with your real rules."
echo "  3. Accept the workspace trust dialog so project-scope config loads."
