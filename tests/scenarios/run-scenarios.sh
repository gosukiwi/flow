#!/usr/bin/env bash
# Layer 2 — manual agent scenario tests. Lists scenarios; does not run agents.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Flow scenario tests (Layer 2 — manual)"
echo "======================================="
echo ""
echo "Guide: tests/writing-skills.md"
echo ""
echo "Discipline/gate changes require RED + GREEN evidence before commit:"
echo "  tests/scenarios/evidence/<scenario>.md  (see AGENTS.md §Evidence gate)"
echo ""
echo "For each scenario:"
echo "  1. Fresh Cursor session or Task subagent + install only relevant skills"
echo "  2. RED:  run against pre-change commit — expect violation; record in evidence/"
echo "  3. GREEN: run with updated skills — expect compliance; record in evidence/"
echo ""
echo "Scenarios:"
echo ""

for f in "$ROOT/tests/scenarios"/flow-*.md; do
  [[ -f "$f" ]] || continue
  echo "  - $(basename "$f")"
done

echo ""
echo "Paste scenario file content as the user message (see tests/scenarios/README.md)."
