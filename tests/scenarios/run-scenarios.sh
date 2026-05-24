#!/usr/bin/env bash
# Layer 2 — manual agent scenario tests. Lists scenarios; does not run agents.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Flow scenario tests (Layer 2 — manual)"
echo "======================================="
echo ""
echo "Guide: tests/writing-skills.md"
echo ""
echo "Run before tagging a release (like manual regression tests):"
echo "  1. Fresh Cursor session + install only relevant skills"
echo "  2. Paste scenario content as user message; invoke matching /flow-* if needed"
echo "  3. Confirm agent complies; note pass/fail in PR or release notes"
echo ""
echo "Discipline changes: RED→GREEN during development (see AGENTS.md)."
echo ""
echo "Scenarios:"
echo ""

for f in "$ROOT/tests/scenarios"/flow-*.md; do
  [[ -f "$f" ]] || continue
  echo "  - $(basename "$f")"
done

echo ""
echo "Paste scenario file content as the user message (see tests/scenarios/README.md)."
