#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)/skills/sigma-code"
DST="$HOME/.claude/skills/sigma-code"
mkdir -p "$HOME/.claude/skills"
rm -rf "$DST"
ln -s "$SRC" "$DST"
echo "linked $DST -> $SRC"
