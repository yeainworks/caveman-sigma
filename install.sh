#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)/skills/caveman-sigma"
DST="$HOME/.claude/skills/caveman-sigma"
mkdir -p "$HOME/.claude/skills"
rm -rf "$DST"
ln -s "$SRC" "$DST"
echo "linked $DST -> $SRC"
