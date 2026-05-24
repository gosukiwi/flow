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
  flow-finish
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
PROMPTS=(implementer spec-reviewer correctness-reviewer)
for prompt in "${PROMPTS[@]}"; do
  p="$SKILLS_DIR/flow-shared/prompts/${prompt}.md"
  if [[ -f "$p" ]]; then
    pass "flow-shared/prompts/${prompt}.md exists"
  else
    fail "Missing $p"
  fi
done

# flow-shared references
REFS=(tdd-red-green verification-gate branch-gate session-gate worktree-setup root-cause-tracing finish-gate state-setup)
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

spec_reviewer="$SKILLS_DIR/flow-shared/prompts/spec-reviewer.md"
if grep -qi 'do not trust' "$spec_reviewer" && grep -q 'git diff' "$spec_reviewer"; then
  pass "spec-reviewer: requires independent diff inspection"
else
  fail "spec-reviewer: must require Do not trust report and git diff inspection"
fi

if grep -q 'BASE_SHA' "$execute_file" && grep -qi 'spec compliance review' "$execute_file"; then
  pass "flow-execute: passes BASE_SHA to spec compliance review"
else
  fail "flow-execute: must record BASE_SHA before spec compliance review"
fi

if grep -qi 'flow-verify/SKILL.md' "$execute_file" && grep -qi 'auto-run\|immediately continue into verify' "$execute_file"; then
  pass "flow-execute: auto-runs verify after all tasks"
else
  fail "flow-execute: must auto-run verify (read flow-verify/SKILL.md after all tasks)"
fi

if grep -qi 'flow-verify/SKILL.md' "$patch_file" && grep -qi 'auto-run\|immediately continue into verify' "$patch_file"; then
  pass "flow-patch: auto-runs verify after all tasks"
else
  fail "flow-patch: must auto-run verify (read flow-verify/SKILL.md after all tasks)"
fi

if grep -qi 'skip spec or correctness review' "$patch_file"; then
  pass "flow-patch: forbids skipping per-task review"
else
  fail "flow-patch: must forbid skipping spec or correctness review"
fi

if grep -qi 'verify user menu' "$patch_file"; then
  pass "flow-patch: requires verify user menu at finish"
else
  fail "flow-patch: must require verify user menu (not custom next steps)"
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

verify_file="$SKILLS_DIR/flow-verify/SKILL.md"
finish_gate="$SKILLS_DIR/flow-shared/references/finish-gate.md"
finish_skill="$SKILLS_DIR/flow-finish/SKILL.md"

if grep -qi 'worktree remove\|finish-gate' "$verify_file"; then
  pass "flow-verify: documents worktree cleanup on merge via finish-gate"
else
  fail "flow-verify: must document worktree cleanup for merge option (finish-gate)"
fi

if grep -q 'git worktree remove' "$finish_gate"; then
  pass "finish-gate: documents worktree remove after merge"
else
  fail "finish-gate: must document git worktree remove on merge locally"
fi

if grep -qi 'Canonical STATE location' "$finish_gate" && grep -qi 'Canonical STATE location' "$worktree_setup"; then
  pass "finish-gate and worktree-setup: document canonical STATE location"
else
  fail "finish-gate and worktree-setup: must document canonical STATE location"
fi

if grep -qi 'phase: done.*Leave unchanged\|Leave unchanged.*phase: done' "$finish_gate"; then
  pass "finish-gate: leaves main STATE unchanged when already phase done"
else
  fail "finish-gate: must leave main STATE unchanged when already phase done (worktree merge)"
fi

if grep -qi 'Unrelated active STATE on main' "$finish_gate"; then
  pass "finish-gate: session gate for unrelated active main STATE at merge"
else
  fail "finish-gate: must session-gate unrelated active main STATE on worktree merge"
fi

if grep -q 'finish-gate' "$finish_skill" && grep -q 'phase: done' "$finish_gate"; then
  pass "flow-finish: references finish-gate with phase done"
else
  fail "flow-finish: must reference finish-gate and phase done cleanup"
fi

if grep -qi 'flow-finish\|finish-gate' "$verify_file"; then
  pass "flow-verify: delegates finish actions to flow-finish/finish-gate"
else
  fail "flow-verify: must delegate merge/push/done to flow-finish or finish-gate"
fi

if grep -qi 'raw git merge\|finish-gate' "$verify_file"; then
  pass "flow-verify: forbids ad hoc merge without finish-gate"
else
  fail "flow-verify: must forbid raw merge without finish-gate for ad hoc requests"
fi

state_setup="$SKILLS_DIR/flow-shared/references/state-setup.md"
session_gate="$SKILLS_DIR/flow-shared/references/session-gate.md"
flow_router="$SKILLS_DIR/flow/SKILL.md"
if grep -q 'git check-ignore' "$state_setup" && grep -q 'docs/flow/STATE.md' "$state_setup"; then
  pass "state-setup: has ignore check for docs/flow/STATE.md"
else
  fail "state-setup: must document git check-ignore for docs/flow/STATE.md"
fi

if grep -q 'state-setup' "$session_gate"; then
  pass "session-gate: references state-setup for gitignore gate"
else
  fail "session-gate: must reference state-setup.md before STATE write"
fi

if grep -qi 'gitignore\|local only' "$flow_router" && grep -q 'state-setup' "$flow_router"; then
  pass "flow router: documents gitignored STATE and state-setup"
else
  fail "flow/SKILL.md: must document gitignored STATE and reference state-setup.md"
fi

if grep -q 'Hard gate' "$session_gate" && grep -q 'Detection matrix' "$session_gate"; then
  pass "session-gate: has hard gate with detection matrix"
else
  fail "session-gate: must have hard gate and detection matrix"
fi

for skill_file in flow-brainstorm flow-spec flow-debug; do
  f="$SKILLS_DIR/$skill_file/SKILL.md"
  if grep -q 'session-gate' "$f"; then
    pass "$skill_file: references session-gate"
  else
    fail "$skill_file: must reference session-gate.md"
  fi
done

if grep -q 'session-gate' "$patch_file" && grep -q 'session-gate' "$execute_file"; then
  pass "flow-patch and flow-execute: reference session-gate"
else
  fail "flow-patch and flow-execute: must reference session-gate before branch-gate"
fi

if grep -q 'session-gate' "$SKILLS_DIR/flow-verify/SKILL.md"; then
  pass "flow-verify: references session-gate before STATE update"
else
  fail "flow-verify: must reference session-gate"
fi

if grep -q 'path resolver' "$SKILLS_DIR/flow/SKILL.md"; then
  pass "flow: documents path resolver"
else
  fail "flow: missing path resolver"
fi

flow_router="$SKILLS_DIR/flow/SKILL.md"
if grep -q '/flow-finish' "$flow_router"; then
  pass "flow: router references /flow-finish"
else
  fail "flow: must reference /flow-finish in commands or decision tree"
fi
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
