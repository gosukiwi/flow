#!/usr/bin/env bash
set -euo pipefail

# Install flow skills into the current project (or global with -g).
#
# Usage:
#   ./scripts/install.sh              # from GitHub (set FLOW_SKILLS_REPO)
#   ./scripts/install.sh ./skills     # from local path
#   ./scripts/install.sh -g           # global install

REPO="${FLOW_SKILLS_REPO:-gosukiwi/flow}"
SOURCE=""
GLOBAL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -g|--global) GLOBAL="-g"; shift ;;
    *) SOURCE="$1"; shift ;;
  esac
done

ARGS=(-a cursor --skill '*' -y)
if [[ -n "$GLOBAL" ]]; then
  ARGS+=("$GLOBAL")
fi

if [[ -n "$SOURCE" ]]; then
  echo "Installing from local path: $SOURCE"
  npx skills add "$SOURCE" "${ARGS[@]}"
else
  echo "Installing from GitHub: $REPO"
  npx skills add "$REPO" "${ARGS[@]}"
fi

cat <<'EOF'

Installed skills:
  /flow            — router
  /flow-brainstorm — explore; small scope → patch, larger → spec
  /flow-spec       — spec + plan
  /flow-execute  — subagent execution
  /flow-patch    — small changes
  /flow-debug    — root cause first
  /flow-verify   — tests + spec checklist; user menu
  /flow-finish   — merge/push/done + STATE and worktree cleanup

Project artifacts: docs/flow/{brainstorms,specs,plans,STATE.md}

EOF
