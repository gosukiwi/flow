# 2026-05-23 — flow-verify — skip auto whole-change review

## Scenario
tests/scenarios/flow-verify-skip-auto-review.md

## Skill change
- File: skills/flow-verify/SKILL.md
- Change: Option 3 whole-change review is user-initiated only

## GREEN (after fix)
- Agent chose: **B** — present menu; do not auto-run option 3 before merge
- Cited: Option 3 "Do not run automatically", user menu options 1–4
- Rationalizations rejected: A (auto-review "safer"), C (merge without menu)

## Scenario
tests/scenarios/flow-verify-option3-fallback.md

## GREEN (after fix)
- Agent chose: **B** — dispatch whole-change-reviewer subagent when clean-code-reviewer absent
- Cited: Option 3 step 3 fallback prompt
- Rationalizations rejected: A (manual diff only), C (skip review)
