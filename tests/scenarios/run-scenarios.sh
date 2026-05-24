#!/usr/bin/env bash
# Layer 2 — manual agent scenario tests. Lists scenarios; does not run agents.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Flow scenario tests (Layer 2 — manual)"
echo "======================================="
echo ""
echo "Guide: tests/writing-skills.md"
echo "Log failures: tests/regression/"
echo ""
echo "For each scenario:"
echo "  1. Fresh Cursor session + install skills"
echo "  2. RED:  run against old skill (optional) — expect violation"
echo "  3. GREEN: run with /flow-* loaded — expect compliance"
echo ""
echo "Scenarios:"
echo ""

for f in "$ROOT/tests/scenarios"/flow-*.md; do
  [[ -f "$f" ]] || continue
  echo "  - $(basename "$f")"
done

echo ""
echo "Paste scenario file content as the user message (see tests/scenarios/README.md)."
