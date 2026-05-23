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
  flow-review
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
PROMPTS=(implementer spec-reviewer code-quality-reviewer final-reviewer)
for prompt in "${PROMPTS[@]}"; do
  p="$SKILLS_DIR/flow-shared/prompts/${prompt}.md"
  if [[ -f "$p" ]]; then
    pass "flow-shared/prompts/${prompt}.md exists"
  else
    fail "Missing $p"
  fi
done

# flow-shared references
REFS=(tdd-red-green verification-gate)
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

ORCHESTRATORS=(flow-execute flow-patch flow-review)
for skill in "${ORCHESTRATORS[@]}"; do
  skill_file="$SKILLS_DIR/$skill/SKILL.md"
  if [[ "$skill" == "flow-review" ]]; then
    if grep -q 'final-reviewer.md' "$skill_file"; then
      pass "$skill: references final-reviewer prompt"
    else
      fail "$skill: must reference flow-shared/prompts/final-reviewer.md"
    fi
  elif grep -q 'flow-shared/prompts/' "$skill_file"; then
    pass "$skill: references flow-shared prompts"
  else
    fail "$skill: must reference flow-shared/prompts/"
  fi

  if [[ "$skill" == "flow-review" ]]; then
    if grep -qi 'Dispatch final review subagent\|dispatch.*subagent' "$skill_file"; then
      pass "$skill: dispatches review subagent"
    else
      fail "$skill: must dispatch final review subagent"
    fi
  elif grep -qi 'subagent' "$skill_file" && grep -qi 'never implement inline\|subagents only\|Never implement inline' "$skill_file"; then
    pass "$skill: requires subagent execution"
  else
    fail "$skill: must forbid inline implementation"
  fi
done

if grep -q 'path resolver' "$SKILLS_DIR/flow/SKILL.md"; then
  pass "flow: documents path resolver"
else
  fail "flow: missing path resolver"
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
