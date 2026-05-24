# 2026-05-23 — flow-spec — structure path contradiction

## Scenario
tests/scenarios/flow-spec-structure-contradiction.md

## Skill change
- File: skills/flow-spec/SKILL.md
- Change: §5 structure & path consistency, contradiction stop rule, §6 audit user gate

## GREEN (after fix)
- Agent chose: **B** — block user gate, fix spec test paths to include `common/`, re-run self-review
- Cited: §5 Calibration, Structure & path consistency, Contradiction stop rule, §6 user gate
- Rationalizations rejected: A ("close enough"), C ("plan phase will sort it out")
- Run: subagent with flow-spec/SKILL.md loaded (Layer 2 manual equivalent)
