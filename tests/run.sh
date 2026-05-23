#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "flow-skillset test runner"
echo "========================="
echo ""

chmod +x "$ROOT/tests/static/validate-skills.sh"
"$ROOT/tests/static/validate-skills.sh"
echo ""
python3 "$ROOT/tests/static/validate-artifacts.py"

echo ""
echo "Layer 2 (manual): see tests/scenarios/README.md"
