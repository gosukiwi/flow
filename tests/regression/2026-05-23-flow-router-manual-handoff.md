# 2026-05-23 — flow — router manual handoff

## Scenario
tests/scenarios/flow-router-manual-handoff.md

## RED (before fix)
- Weak RED: agents often chose **B** on old skill via implicit router role — scenario did not reliably fail
- Sharpened draft: bundles `/flow-patch` suggestion + micro-spec start; user pressure "hate typing slash commands twice"

## Skill change
- File: skills/flow/SKILL.md
- Change: **When `/flow` is invoked** — triage concierge, hard gate, forbidden same-message auto-start

## GREEN (after fix)
- Agent chose: **B** — suggestion only, no micro-spec
- Cited: When `/flow` is invoked, Hard gate, Forbidden list
- Run: subagent with updated flow/SKILL.md + user friction pressure
