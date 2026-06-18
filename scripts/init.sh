#!/usr/bin/env bash
# Scaffold ChangeFlow into a target repo, and (optionally) install its Codex skills.
#
# Usage:
#   init.sh <plugin-root> [target-dir] [--tools claude|codex|both] [--codex-in-repo] [--force]
#
# Always writes (tool-agnostic, never overwrites existing): the docs/ structure,
# AGENTS.md, docs/{PROJECT,CONCEPTS,CONTRACTS}.md, and the two INDEX.md files.
#   --tools claude  → also write CLAUDE.md (Claude's @AGENTS.md pointer).
#   --tools codex   → install Codex skills. Default: ${CODEX_HOME:-~/.codex}/skills
#                     (user-level — available in all your repos, NOT added to this
#                     repo). Use --codex-in-repo to vendor them into
#                     <target>/.codex/skills instead (to share via git).
#   --tools both    → both (default).
set -euo pipefail

PLUGIN_ROOT="${1:?usage: init.sh <plugin-root> [target-dir] [--tools claude|codex|both] [--codex-in-repo] [--force]}"
shift || true

TARGET="$PWD"
TOOLS="both"
CODEX_IN_REPO=0
FORCE=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --tools) TOOLS="${2:?--tools needs a value}"; shift 2 ;;
    --codex-in-repo) CODEX_IN_REPO=1; shift ;;
    --force) FORCE="--force"; shift ;;
    --*) echo "unknown flag: $1" >&2; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

want_claude=0; want_codex=0
case "$TOOLS" in
  claude) want_claude=1 ;;
  codex) want_codex=1 ;;
  both) want_claude=1; want_codex=1 ;;
  *) echo "error: --tools must be claude|codex|both (got '$TOOLS')" >&2; exit 1 ;;
esac

if [ "$want_codex" = 1 ] && ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required to generate Codex skills. Install it, or use --tools claude." >&2
  exit 1
fi

copy_if_missing() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    echo "  skip (exists): ${dst#"$TARGET"/}"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  create: ${dst#"$TARGET"/}"
  fi
}

echo "ChangeFlow init -> $TARGET   (tools: $TOOLS)"

echo "[dirs]"
for d in docs docs/changes/active docs/changes/archive docs/experiences docs/workflows; do
  mkdir -p "$TARGET/$d"; echo "  ensure: $d/"
done

echo "[shared docs]"
copy_if_missing "$PLUGIN_ROOT/templates/AGENTS.md"           "$TARGET/AGENTS.md"
copy_if_missing "$PLUGIN_ROOT/templates/PROJECT.md"          "$TARGET/docs/PROJECT.md"
copy_if_missing "$PLUGIN_ROOT/templates/CONCEPTS.md"         "$TARGET/docs/CONCEPTS.md"
copy_if_missing "$PLUGIN_ROOT/templates/CONTRACTS.md"        "$TARGET/docs/CONTRACTS.md"
copy_if_missing "$PLUGIN_ROOT/templates/WORKFLOWS_INDEX.md"  "$TARGET/docs/workflows/INDEX.md"
copy_if_missing "$PLUGIN_ROOT/templates/EXPERIENCES_INDEX.md" "$TARGET/docs/experiences/INDEX.md"

if [ "$want_claude" = 1 ]; then
  echo "[claude]"
  copy_if_missing "$PLUGIN_ROOT/templates/CLAUDE.md" "$TARGET/CLAUDE.md"
fi

if [ "$want_codex" = 1 ]; then
  if [ "$CODEX_IN_REPO" = 1 ]; then
    codex_dest="$TARGET/.codex/skills"
    echo "[codex]  vendored in this repo — commit it so collaborators get the skills via git"
  else
    codex_dest="${CODEX_HOME:-$HOME/.codex}/skills"
    echo "[codex]  user-level ($codex_dest) — available in all your repos; nothing added to this repo"
  fi
  python3 "$PLUGIN_ROOT/scripts/sync-codex.py" "$PLUGIN_ROOT/commands" "$codex_dest" $FORCE | sed 's/^/  /'
fi

echo "done."
echo
echo "Next:"
echo "  - Fill in docs/PROJECT.md, docs/CONCEPTS.md, docs/CONTRACTS.md (or let /changeflow-init draft PROJECT.md from the code)."
echo "  - Replace the example Critical rules in AGENTS.md with your project's real rules."
[ "$want_claude" = 1 ] && echo "  - Claude Code: each user installs the changeflow plugin; accept the workspace trust dialog."
[ "$want_codex" = 1 ] && [ "$CODEX_IN_REPO" = 1 ] && echo "  - Codex (vendored): commit .codex/skills/ so collaborators get the skills."
[ "$want_codex" = 1 ] && [ "$CODEX_IN_REPO" = 0 ] && echo "  - Codex (user-level): collaborators install ChangeFlow into their own ~/.codex/skills the same way."
