#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_DIR="$ROOT/skills"
CONTROL_PLANE="$ROOT/docs/control-plane.md"
FAILED=0

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; FAILED=1; }

echo "=== validate-skills ==="

if [[ -f "$CONTROL_PLANE" ]]; then
  pass "docs/control-plane.md exists"
else
  fail "Missing $CONTROL_PLANE"
fi

if [[ -f "$CONTROL_PLANE" ]]; then
  for invariant in {1..17}; do
    if grep -q "| I${invariant} |" "$CONTROL_PLANE"; then
      pass "control-plane: invariant I${invariant} listed"
    else
      fail "control-plane: missing invariant I${invariant}"
    fi
  done
fi

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
REFS=(plan-execution tdd-red-green verification-gate verify-gate branch-gate session-gate worktree-setup root-cause-tracing finish-gate state-setup artifact-commit-gate)
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

# plan-execution + flow-execute: subagents only, no inline implementation
plan_exec_file="$SKILLS_DIR/flow-shared/references/plan-execution.md"
execute_file="$SKILLS_DIR/flow-execute/SKILL.md"
if grep -q 'flow-shared/prompts/' "$plan_exec_file"; then
  pass "plan-execution: references flow-shared prompts"
else
  fail "plan-execution: must reference flow-shared/prompts/"
fi
if grep -qi 'subagent' "$plan_exec_file" && grep -qi 'never implement inline\|subagents only' "$plan_exec_file"; then
  pass "plan-execution: requires subagent execution"
else
  fail "plan-execution: must forbid inline implementation"
fi
if grep -qi 'artifact-commit-gate' "$plan_exec_file" && grep -qi 'before.*Task 1\|before loading the plan' "$plan_exec_file"; then
  pass "plan-execution: artifact commit before Task 1"
else
  fail "plan-execution: must reference artifact-commit-gate before Task 1"
fi
if grep -q 'After branch confirm.*proceed to step 2' "$plan_exec_file" \
  && grep -qi 'Stop with.*Run /flow-execute.*after branch confirm' "$plan_exec_file"; then
  pass "plan-execution: spec auto-continue proceeds after branch confirm without /flow-execute stop"
else
  fail "plan-execution: must proceed steps 2-5 after branch confirm from spec auto-continue (no /flow-execute handoff)"
fi
if grep -qi 'Used by.*flow-spec' "$plan_exec_file"; then
  pass "plan-execution: used by flow-spec auto-continue"
else
  fail "plan-execution: must document use by flow-spec after plan"
fi
if grep -q 'plan-execution' "$execute_file"; then
  pass "flow-execute: delegates to plan-execution.md"
else
  fail "flow-execute: must reference flow-shared/references/plan-execution.md"
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

correctness_reviewer="$SKILLS_DIR/flow-shared/prompts/correctness-reviewer.md"
if grep -qi 'reruns spec compliance on the updated diff' "$correctness_reviewer" \
  && grep -qi 'equivalent reviewed patch task' "$correctness_reviewer"; then
  pass "correctness-reviewer: orchestrator fixes preserve review rails"
else
  fail "correctness-reviewer: must require spec compliance after task fixes and reviewed patch task for branch fixes"
fi

implementer="$SKILLS_DIR/flow-shared/prompts/implementer.md"
if grep -qi 'detached HEAD\|detach' "$implementer" && grep -qi 'never.*checkout.*commit-sha\|checkout.*commit-sha' "$implementer"; then
  pass "implementer: forbids checkout by SHA (detached HEAD)"
else
  fail "implementer: must forbid git checkout <commit-sha> (detached HEAD gate)"
fi

if grep -qi 'do not checkout.*sha\|SHAs are diff anchors' "$spec_reviewer" && grep -qi 'do not checkout.*sha\|SHAs are diff anchors' "$SKILLS_DIR/flow-shared/prompts/correctness-reviewer.md"; then
  pass "reviewers: SHAs are diff anchors only, not checkout targets"
else
  fail "spec-reviewer and correctness-reviewer: must forbid checkout by SHA"
fi

if grep -q 'BASE_SHA' "$plan_exec_file" && grep -qi 'spec compliance review' "$plan_exec_file"; then
  pass "plan-execution: passes BASE_SHA to spec compliance review"
else
  fail "plan-execution: must record BASE_SHA before spec compliance review"
fi

if grep -qi 'flow-verify/SKILL.md' "$plan_exec_file" && grep -qi 'verify-gate' "$plan_exec_file" && grep -qi 'auto-run\|immediately continue into verify' "$plan_exec_file"; then
  pass "plan-execution: auto-runs verify after all tasks"
else
  fail "plan-execution: must auto-run verify (read flow-verify/SKILL.md and verify-gate.md after all tasks)"
fi

if grep -qi 'Final verification\|Plan task.*Flow verify' "$plan_exec_file" && grep -qi 'numbered user menu\|numbered verify menu\|options 1–4\|options 1-4' "$plan_exec_file"; then
  pass "plan-execution: plan verification task does not replace verify menu"
else
  fail "plan-execution: must state plan verification task does not replace numbered verify menu"
fi

if grep -qi 'uncommitted' "$plan_exec_file" && grep -qi 'git status' "$plan_exec_file"; then
  pass "plan-execution: blocks complete with uncommitted changes"
else
  fail "plan-execution: must check git status and block complete with uncommitted changes"
fi

if grep -qi 'Any code change after spec compliance approval invalidates that approval' "$plan_exec_file" \
  && grep -qi 'Rerun only correctness after correctness-review fixes' "$plan_exec_file"; then
  pass "plan-execution: correctness-review fixes rerun spec compliance"
else
  fail "plan-execution: must rerun spec compliance after correctness-review fixes"
fi

if grep -qi 'Hard gate — per task' "$plan_exec_file" \
  && grep -qi 'Verify does \*\*not\*\* replace per-task' "$plan_exec_file" \
  && grep -qi 'continuous ≠ skip reviews' "$plan_exec_file"; then
  pass "plan-execution: per-task hard gate and verify does not replace reviews"
else
  fail "plan-execution: must have per-task hard gate; verify must not replace per-task reviews"
fi

if grep -qi 'Before every Task N dispatch' "$plan_exec_file" \
  && grep -qi 'Same pattern as Task 1' "$plan_exec_file"; then
  pass "plan-execution: checkpoint before each task and Task 2+ skip rationalization"
else
  fail "plan-execution: must require re-read task gate before each dispatch and counter Task 2+ skip"
fi

if grep -qi 'Skip per-task spec or correctness review' "$execute_file"; then
  pass "flow-execute: forbids skipping per-task reviews"
else
  fail "flow-execute: must forbid skipping per-task spec/correctness reviews"
fi

if grep -qi 'uncommitted' "$patch_file" && grep -qi 'git status' "$patch_file"; then
  pass "flow-patch: blocks complete with uncommitted changes"
else
  fail "flow-patch: must check git status and block complete with uncommitted changes"
fi

if grep -qi 'Any code change after spec compliance approval invalidates that approval' "$patch_file" \
  && grep -qi 'Rerun only correctness after correctness-review fixes' "$patch_file"; then
  pass "flow-patch: correctness-review fixes rerun spec compliance"
else
  fail "flow-patch: must rerun spec compliance after correctness-review fixes"
fi

if grep -qi 'flow-verify/SKILL.md' "$patch_file" && grep -qi 'verify-gate' "$patch_file" && grep -qi 'auto-run\|immediately continue into verify' "$patch_file"; then
  pass "flow-patch: auto-runs verify after all tasks"
else
  fail "flow-patch: must auto-run verify (read flow-verify/SKILL.md and verify-gate.md after all tasks)"
fi

if grep -qi 'skip spec or correctness review' "$patch_file"; then
  pass "flow-patch: forbids skipping per-task review"
else
  fail "flow-patch: must forbid skipping spec or correctness review"
fi

if grep -qi 'Hard gate — per task' "$patch_file" \
  && grep -qi 'Verify does \*\*not\*\* replace per-task' "$patch_file" \
  && grep -qi 'continuous patch execution' "$patch_file"; then
  pass "flow-patch: per-task hard gate and verify does not replace reviews"
else
  fail "flow-patch: must have per-task hard gate; verify must not replace per-task reviews"
fi

if grep -qi 'before every Task N' "$patch_file" \
  && grep -qi 'Same pattern as Task 1' "$patch_file"; then
  pass "flow-patch: checkpoint before each task and Task 2+ skip rationalization"
else
  fail "flow-patch: must require re-read task gate before each task and counter Task 2+ skip"
fi

if grep -qi 'Skip reviews after Task 1' "$patch_file"; then
  pass "flow-patch: forbids skipping reviews after Task 1"
else
  fail "flow-patch: must forbid skipping per-task reviews after Task 1"
fi

if grep -qi 'Fix verify failures with unreviewed inline edits' "$patch_file" \
  && grep -qi 'reviewed patch task' "$patch_file"; then
  pass "flow-patch: verify failures require reviewed patch task"
else
  fail "flow-patch: must forbid unreviewed inline fixes for verify failures"
fi

if grep -qi 'verify user menu' "$patch_file"; then
  pass "flow-patch: requires verify user menu at finish"
else
  fail "flow-patch: must require verify user menu (not custom next steps)"
fi

if grep -qi 'micro-spec approval does.*not.*satisfy' "$patch_file"; then
  pass "flow-patch: micro-spec approval does not satisfy branch gate"
else
  fail "flow-patch: must state micro-spec approval does not satisfy branch/workspace confirmation"
fi

if grep -q 'Approve micro-spec' "$patch_file" && grep -q 'Request changes' "$patch_file"; then
  pass "flow-patch: micro-spec gate numbered menu"
else
  fail "flow-patch: must present numbered micro-spec gate menu"
fi

if grep -q 'phase: done' "$patch_file" && grep -q 'Continuing on current feature branch (patch)' "$patch_file"; then
  pass "flow-patch: feature branch with done lane uses patch continuing gate"
else
  fail "flow-patch: must default to patch continuing gate on feature branch when phase done or no STATE"
fi

if grep -q 'docs/flow/patches/' "$patch_file" && grep -qi 'artifact-commit-gate' "$patch_file"; then
  pass "flow-patch: saves micro-spec to patches/ and references artifact commit"
else
  fail "flow-patch: must save micro-spec to docs/flow/patches/ and run artifact-commit-gate before Task 1"
fi

if grep -qi 'Not required.*flow-spec\|resume' "$execute_file"; then
  pass "flow-execute: resume entry not required after every flow-spec"
else
  fail "flow-execute: must state not required on happy path after flow-spec"
fi

spec_file="$SKILLS_DIR/flow-spec/SKILL.md"
if grep -qi 'spec approval does.*not.*satisfy\|"Yes".*spec approval only' "$spec_file"; then
  pass "flow-spec: spec approval does not satisfy execute/workspace"
else
  fail "flow-spec: must state spec approval does not satisfy execute or workspace confirmation"
fi

if grep -q 'Approve spec' "$spec_file" && grep -q 'Request changes' "$spec_file"; then
  pass "flow-spec: spec gate numbered menu"
else
  fail "flow-spec: must present numbered spec gate menu"
fi

if awk '/Spec ready at docs\/flow\/specs/,/^```$/' "$spec_file" | grep -q 'Phase B'; then
  fail "flow-spec: spec gate user menu must not use Phase B"
else
  pass "flow-spec: spec gate menu has no Phase B label"
fi

if awk '/### 7\. Spec gate/,/^---$/' "$spec_file" | grep -qi 'subagent'; then
  pass "flow-spec: spec gate section documents subagent execution after branch confirm"
else
  fail "flow-spec: spec gate section must document subagent task execution (not only in user menu)"
fi

if awk '/Spec ready at docs\/flow\/specs/,/^```$/' "$spec_file" | grep 'Approve spec' | grep -qiE 'subagent|/flow-execute|no separate plan'; then
  fail "flow-spec: spec gate user menu must not expose orchestrator parentheticals on option 1"
else
  pass "flow-spec: spec gate option 1 is user-facing only"
fi

if grep -qi 'Implement plan tasks inline after branch confirm' "$spec_file"; then
  pass "flow-spec: forbids inline plan tasks after branch confirm"
else
  fail "flow-spec: must forbid inline plan task implementation after branch confirm"
fi

if grep -q 'Approve design' "$spec_file" && grep -q 'Design gate' "$spec_file"; then
  pass "flow-spec: design gate numbered menu"
else
  fail "flow-spec: must present numbered design gate menu"
fi

if awk '/Does this design work for you/,/^```$/' "$spec_file" | grep 'Approve design' | grep -qiE '\(no code\)|no code'; then
  fail "flow-spec: design gate user menu must not use (no code) on option 1"
else
  pass "flow-spec: design gate option 1 is user-facing only"
fi

if awk '/#### Design gate/,/^### 4\./' "$spec_file" | grep -qi 'Orchestrator.*not in the gate\|no production code until branch'; then
  pass "flow-spec: design gate section documents no-code discipline outside menu"
else
  fail "flow-spec: design gate section must document orchestrator discipline outside user menu"
fi

if grep -q 'phase: planned' "$spec_file" && grep -qi 'plan-execution' "$spec_file" \
  && grep -qi 'auto-continue\|step 1.*branch gate' "$spec_file"; then
  pass "flow-spec: auto-continues to plan-execution branch gate after plan"
else
  fail "flow-spec: must auto-continue to plan-execution step 1 after plan with phase planned"
fi

if grep -q 'Run `/flow-execute` to implement' "$spec_file"; then
  fail "flow-spec: must not hand off with Run /flow-execute after plan"
else
  pass "flow-spec: no Run /flow-execute stop after plan"
fi

if grep -qi 'Final verification\|verification-only' "$spec_file" && grep -qi 'Verify in plan\|verify auto-runs' "$spec_file"; then
  pass "flow-spec: plan must not end with verification-only task"
else
  fail "flow-spec: must forbid final verification task in plan (verify auto-runs in execute)"
fi

if grep -q 'Structure trees' "$spec_file" && grep -A5 'Spec gate' "$spec_file" | grep -q 'Structure trees'; then
  fail "flow-spec: must not expose structure trees in user gate template"
else
  pass "flow-spec: user gate hides internal structure tree audit"
fi

if grep -A8 'Micro-spec gate' "$patch_file" | grep -q 'Self-review:'; then
  fail "flow-patch: must not expose self-review counts in user gate template"
else
  pass "flow-patch: user gate hides internal self-review audit"
fi

# flow-brainstorm: conditional handoff to patch or spec
brainstorm_file="$SKILLS_DIR/flow-brainstorm/SKILL.md"
if grep -q '/flow-patch' "$brainstorm_file" && grep -q '/flow-spec' "$brainstorm_file"; then
  pass "flow-brainstorm: references both /flow-patch and /flow-spec handoff"
else
  fail "flow-brainstorm: must reference both /flow-patch and /flow-spec in handoff"
fi

if grep -q 'Red flags.*never' "$brainstorm_file" \
  && grep -q '^- \*\*Propose session gate and save brief/STATE in the same turn\*\*' "$brainstorm_file" \
  && grep -q '^- \*\*Overwrite STATE with unrelated phase\*\*' "$brainstorm_file"; then
  pass "flow-brainstorm: forbidden gate/STATE actions are red flags"
else
  fail "flow-brainstorm: must list forbidden gate/STATE actions as red flags, not principles"
fi

if grep -qi 'Handoff gate' "$brainstorm_file" \
  && grep -q 'Stop until the user picks 1, 2, or 3' "$brainstorm_file" \
  && grep -q 'Continue to patch' "$brainstorm_file" \
  && grep -q 'Continue to spec instead' "$brainstorm_file"; then
  pass "flow-brainstorm: numbered handoff gate with stop-until"
else
  fail "flow-brainstorm: must have numbered handoff gate (patch/spec/stop) with stop-until user pick"
fi

handoff_menu_blocks="$(awk '/Brainstorm saved to/,/^```$/' "$brainstorm_file")"
if echo "$handoff_menu_blocks" | grep -qE 'SKILL\.md|\(no code|inline TDD|spec/plan gates'; then
  fail "flow-brainstorm: handoff user menus must not expose SKILL paths, no-code parentheticals, or inline TDD"
else
  pass "flow-brainstorm: handoff gate menus are user-facing only"
fi

if awk '/### 7\. Handoff gate/,/^## Principles/' "$brainstorm_file" | grep -qi 'path resolver\|downstream gates'; then
  pass "flow-brainstorm: handoff section documents orchestrator continuation outside menus"
else
  fail "flow-brainstorm: handoff section must document orchestrator rules outside user menus"
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

if grep -q '/flow-patch` on feature branch' "$branch_gate" && grep -q 'phase: done' "$branch_gate"; then
  pass "branch-gate: patch on feature branch with done lane skips switch/worktree menu"
else
  fail "branch-gate: must document patch on feature branch with phase done (no 1/2 switch menu)"
fi

worktree_setup="$SKILLS_DIR/flow-shared/references/worktree-setup.md"
if grep -q 'git check-ignore' "$worktree_setup" && grep -q 'git worktree add' "$worktree_setup"; then
  pass "worktree-setup: has ignore check and worktree add steps"
else
  fail "worktree-setup: must document ignore verification and git worktree add"
fi

if grep -qi 'chosen directory' "$worktree_setup" && grep -q 'git check-ignore -q "$worktree_dir"' "$worktree_setup"; then
  pass "worktree-setup: verifies the selected worktree directory is ignored"
else
  fail "worktree-setup: must check-ignore the selected project-local worktree directory"
fi

if grep -q 'worktree-setup' "$plan_exec_file" && grep -q 'worktree-setup' "$patch_file"; then
  pass "plan-execution and flow-patch: reference worktree-setup"
else
  fail "plan-execution and flow-patch: must reference worktree-setup.md"
fi

verify_file="$SKILLS_DIR/flow-verify/SKILL.md"
verify_gate="$SKILLS_DIR/flow-shared/references/verify-gate.md"
finish_gate="$SKILLS_DIR/flow-shared/references/finish-gate.md"
finish_skill="$SKILLS_DIR/flow-finish/SKILL.md"

if grep -q 'verify-gate' "$verify_file"; then
  pass "flow-verify: references verify-gate"
else
  fail "flow-verify: must reference verify-gate.md"
fi

if grep -qi 'worktree remove\|finish-gate' "$verify_gate"; then
  pass "verify-gate: documents worktree cleanup on merge via finish-gate"
else
  fail "verify-gate: must document worktree cleanup for merge option (finish-gate)"
fi

if grep -q 'git worktree remove' "$finish_gate"; then
  pass "finish-gate: documents worktree remove after merge"
else
  fail "finish-gate: must document git worktree remove on merge locally"
fi

if grep -qi 'Sync after remote merge' "$finish_gate" && grep -q 'git branch -d' "$finish_gate"; then
  pass "finish-gate: sync after remote merge deletes branch"
else
  fail "finish-gate: must document sync after remote merge with branch delete"
fi

if grep -qi 'delete.*docs/flow/STATE.md\|delete.*STATE.md' "$finish_gate"; then
  pass "finish-gate: remote sync clears STATE.md"
else
  fail "finish-gate: must delete or clear STATE.md on remote merge sync"
fi

if grep -qi 'Artifact cleanup gate' "$finish_gate" && grep -q 'Keep spec/plan/brainstorm' "$finish_gate"; then
  pass "finish-gate: artifact cleanup gate with keep default"
else
  fail "finish-gate: must have artifact cleanup gate with numbered menu"
fi

if grep -q 'chore/remove-flow-artifacts' "$finish_gate" && grep -qi 'git push' "$finish_gate"; then
  pass "finish-gate: artifact removal on chore branch with push for PR"
else
  fail "finish-gate: must use chore/remove-flow-artifacts branch and push on option 2"
fi

if grep -qi 'Commit artifact removal on.*base' "$finish_gate" || grep -qi 'do not commit deletions on' "$finish_gate"; then
  pass "finish-gate: forbids committing artifact removal on base"
else
  fail "finish-gate: must forbid commit artifact removal on base branch"
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

if grep -qi 'GitHub CLI' "$finish_gate" \
  && grep -qi 'git merge-base --is-ancestor' "$finish_gate" \
  && grep -q '`gh`' "$finish_gate" \
  && grep -qi 'forbidden for finish\|Forbidden in this path' "$finish_gate"; then
  pass "finish-gate: forbids gh/GitHub CLI for integration status"
else
  fail "finish-gate: must forbid gh/GitHub CLI for finish integration status"
fi

if grep -q 'Ambiguous `/flow-finish`' "$finish_gate" && grep -q 'Stop until the user picks 1–4' "$finish_gate"; then
  pass "finish-gate: ambiguous flow-finish numbered menu"
else
  fail "finish-gate: must have numbered menu for bare /flow-finish"
fi

if awk '/Flow finish — what should I do/,/^```$/' "$finish_gate" | grep -qiE 'clear STATE|STATE\.md|phase:'; then
  fail "finish-gate: ambiguous finish user menu must not expose STATE or phase jargon"
else
  pass "finish-gate: ambiguous finish menu is user-facing only"
fi

if awk '/Feature integrated\. Delete flow artifacts/,/^```$/' "$finish_gate" | grep -qiE 'from STATE|chore/remove-flow-artifacts'; then
  fail "finish-gate: artifact cleanup user menu must not expose STATE or chore-branch mechanics"
else
  pass "finish-gate: artifact cleanup menu is user-facing only"
fi

if grep -q 'finish-gate' "$finish_skill" && grep -q 'phase: done' "$finish_gate"; then
  pass "flow-finish: references finish-gate with phase done"
else
  fail "flow-finish: must reference finish-gate and phase done cleanup"
fi

if grep -qi 'flow-finish\|finish-gate' "$verify_gate"; then
  pass "verify-gate: delegates finish actions to flow-finish/finish-gate"
else
  fail "verify-gate: must delegate merge/push/done to flow-finish or finish-gate"
fi

if grep -qi 'raw git merge\|finish-gate' "$verify_gate"; then
  pass "verify-gate: forbids ad hoc merge without finish-gate"
else
  fail "verify-gate: must forbid raw merge without finish-gate for ad hoc requests"
fi

if grep -q 'Stop until the user picks 1–4\|What would you like to do' "$verify_gate"; then
  pass "verify-gate: numbered user menu"
else
  fail "verify-gate: must have numbered user menu"
fi

if awk '/What would you like to do\?/,/^```$/' "$verify_gate" | grep -qE 'clean-code-reviewer|/flow-finish|\[.*\|'; then
  fail "verify-gate: user menu must not expose skill names, commands, or bracketed alternates"
else
  pass "verify-gate: verify user menu is user-facing only"
fi

if awk '/## User menu/,/^## Option 2/' "$verify_gate" | grep -qi 'clean-code-reviewer\|correctness-reviewer'; then
  pass "verify-gate: user menu section documents option 2 review outside template"
else
  fail "verify-gate: must document option 2 review mechanics outside user menu"
fi

if grep -qi 'Do not run option 2 automatically' "$verify_gate"; then
  pass "verify-gate: option 2 not automatic"
else
  fail "verify-gate: must forbid auto-run of option 2 branch review"
fi

if grep -qi 'Patch option 2 findings with unreviewed inline edits' "$verify_gate" \
  && grep -qi 'equivalent reviewed patch task' "$verify_gate"; then
  pass "verify-gate: option 2 fixes require reviewed patch task"
else
  fail "verify-gate: must forbid unreviewed inline fixes after option 2 findings"
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

if grep -q 'session-gate' "$patch_file" && grep -q 'session-gate' "$plan_exec_file"; then
  pass "flow-patch and plan-execution: reference session-gate"
else
  fail "flow-patch and plan-execution: must reference session-gate before branch-gate"
fi

if grep -q 'session-gate' "$SKILLS_DIR/flow-verify/SKILL.md"; then
  pass "flow-verify: references session-gate before STATE update"
else
  fail "flow-verify: must reference session-gate"
fi

if awk '/## User gate message/,/^## After confirmation/' "$session_gate" | grep '^>' | grep -qE '`phase:|STATE\.md'; then
  fail "session-gate: user gate must not expose phase: or STATE.md"
else
  pass "session-gate: user gate is user-facing only"
fi

if awk '/## User gate messages/,/^## After confirmation/' "$branch_gate" | grep '^>' | grep -qE 'Before Task 1|`phase:'; then
  fail "branch-gate: user gate messages must not use Before Task 1 or phase: labels"
else
  pass "branch-gate: user gate messages are user-facing only"
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
