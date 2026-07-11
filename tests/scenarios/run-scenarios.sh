#!/usr/bin/env bash
# Lists scenarios; does not run agents.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Flow pressure scenarios"
echo "============================"
echo ""
echo "Guide: tests/writing-skills.md"
echo "Run via Task subagent or fresh session — see tests/writing-skills.md and AGENTS.md"

echo ""
echo "Scenarios:"
echo ""

for f in "$ROOT/tests/scenarios"/flow-*.md; do
  [[ -f "$f" ]] || continue
  echo "  - $(basename "$f")"
done

echo ""
