#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_DIR="$ROOT/skills"
FAILED=0

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; FAILED=1; }

echo "=== validate-skills ==="

REQUIRED_SKILLS=(
  flow
  flow-brainstorm
  flow-spec
  flow-execute
  flow-patch
  flow-debug
  flow-verify
  flow-shared
)

for skill in "${REQUIRED_SKILLS[@]}"; do
  skill_dir="$SKILLS_DIR/$skill"
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    fail "Missing $skill_file"
    continue
  fi

  # name field must match directory
  name=$(grep -E '^name:' "$skill_file" | head -1 | sed 's/^name: *//' | tr -d ' ')
  if [[ "$name" != "$skill" ]]; then
    fail "$skill: name '$name' != directory '$skill'"
  else
    pass "$skill: name matches directory"
  fi

  # description required
  if ! grep -qE '^description:' "$skill_file"; then
    fail "$skill: missing description"
  else
    pass "$skill: has description"
  fi

  # disable-model-invocation for explicit flow skills
  if [[ "$skill" != "flow-shared" ]]; then
    if grep -q 'disable-model-invocation: true' "$skill_file"; then
      pass "$skill: disable-model-invocation set"
    else
      fail "$skill: missing disable-model-invocation: true"
    fi

    if grep -q 'Triggered by:' "$skill_file"; then
      pass "$skill: has Triggered by"
    else
      fail "$skill: missing 'Triggered by:' line"
    fi
  fi
done

# flow-shared prompts
PROMPTS=(implementer spec-reviewer code-quality-reviewer whole-change-reviewer)
for prompt in "${PROMPTS[@]}"; do
  p="$SKILLS_DIR/flow-shared/prompts/${prompt}.md"
  if [[ -f "$p" ]]; then
    pass "flow-shared/prompts/${prompt}.md exists"
  else
    fail "Missing $p"
  fi
done

# flow-shared references
REFS=(tdd-red-green verification-gate branch-gate worktree-setup root-cause-tracing)
for ref in "${REFS[@]}"; do
  r="$SKILLS_DIR/flow-shared/references/${ref}.md"
  if [[ -f "$r" ]]; then
    pass "flow-shared/references/${ref}.md exists"
  else
    fail "Missing $r"
  fi
done

echo ""
echo "=== validate-prompt-refs ==="

# flow-execute: subagents only, no inline implementation
execute_file="$SKILLS_DIR/flow-execute/SKILL.md"
if grep -q 'flow-shared/prompts/' "$execute_file"; then
  pass "flow-execute: references flow-shared prompts"
else
  fail "flow-execute: must reference flow-shared/prompts/"
fi
if grep -qi 'subagent' "$execute_file" && grep -qi 'never implement inline\|subagents only' "$execute_file"; then
  pass "flow-execute: requires subagent execution"
else
  fail "flow-execute: must forbid inline implementation"
fi

# flow-patch: inline implementation + subagent review
patch_file="$SKILLS_DIR/flow-patch/SKILL.md"
if grep -q 'flow-shared/prompts/' "$patch_file"; then
  pass "flow-patch: references flow-shared prompts"
else
  fail "flow-patch: must reference flow-shared/prompts/"
fi
if grep -qi 'inline' "$patch_file" && grep -qi 'spec-reviewer\|spec compliance reviewer' "$patch_file"; then
  pass "flow-patch: inline execution with subagent review"
else
  fail "flow-patch: must require inline execution and subagent review"
fi

# flow-brainstorm: conditional handoff to patch or spec
brainstorm_file="$SKILLS_DIR/flow-brainstorm/SKILL.md"
if grep -q '/flow-patch' "$brainstorm_file" && grep -q '/flow-spec' "$brainstorm_file"; then
  pass "flow-brainstorm: references both /flow-patch and /flow-spec handoff"
else
  fail "flow-brainstorm: must reference both /flow-patch and /flow-spec in handoff"
fi

branch_gate="$SKILLS_DIR/flow-shared/references/branch-gate.md"
if grep -q 'Hard gate' "$branch_gate" && grep -q 'Stop until' "$branch_gate"; then
  pass "branch-gate: has hard gate with stop-until language"
else
  fail "branch-gate: must have hard gate with stop-until user confirmation"
fi

if grep -q 'worktree' "$branch_gate" && grep -q 'Detection matrix' "$branch_gate"; then
  pass "branch-gate: has workspace gate with worktree detection matrix"
else
  fail "branch-gate: must include workspace gate and detection matrix for worktrees"
fi

worktree_setup="$SKILLS_DIR/flow-shared/references/worktree-setup.md"
if grep -q 'git check-ignore' "$worktree_setup" && grep -q 'git worktree add' "$worktree_setup"; then
  pass "worktree-setup: has ignore check and worktree add steps"
else
  fail "worktree-setup: must document ignore verification and git worktree add"
fi

if grep -q 'worktree-setup' "$execute_file" && grep -q 'worktree-setup' "$patch_file"; then
  pass "flow-execute and flow-patch: reference worktree-setup"
else
  fail "flow-execute and flow-patch: must reference worktree-setup.md"
fi

if grep -q 'workspace: worktree' "$SKILLS_DIR/flow-verify/SKILL.md"; then
  pass "flow-verify: documents worktree cleanup on merge"
else
  fail "flow-verify: must document worktree cleanup for merge option"
fi

if grep -q 'path resolver' "$SKILLS_DIR/flow/SKILL.md"; then
  pass "flow: documents path resolver"
else
  fail "flow: missing path resolver"
fi

flow_router="$SKILLS_DIR/flow/SKILL.md"
if grep -q 'Hard gate' "$flow_router" && grep -q 'When `/flow` is invoked' "$flow_router"; then
  pass "flow: router has manual handoff hard gate"
else
  fail "flow: must have When /flow is invoked and Hard gate for triage-only routing"
fi

for path in '.agents/skills/flow-shared' '.cursor/skills/flow-shared'; do
  if grep -q "$path" "$SKILLS_DIR/flow/SKILL.md"; then
    pass "flow: mentions $path"
  else
    fail "flow: missing $path in path resolver"
  fi
done

# No references to repo-root prompts/ or tests/ in skill files
while IFS= read -r -d '' f; do
  [[ "$f" == *"/flow-shared/SKILL.md" ]] && continue
  if grep -qE '(^prompts/|tests/fixtures)' "$f"; then
    fail "Bad path reference in $f (use flow-shared/, not repo-root prompts/ or tests/)"
  fi
done < <(find "$SKILLS_DIR" -name 'SKILL.md' -print0)

echo ""
if [[ "$FAILED" -eq 0 ]]; then
  echo "All static checks passed."
  exit 0
else
  echo "Static checks failed."
  exit 1
fi
