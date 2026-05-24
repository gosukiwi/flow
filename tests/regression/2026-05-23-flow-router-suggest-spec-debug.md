# 2026-05-23 — flow — router suggest spec and debug

## Scenarios
- tests/scenarios/flow-router-suggest-spec.md
- tests/scenarios/flow-router-suggest-debug.md
- tests/scenarios/flow-router-suggest-brainstorm.md

## RED (before triage examples table)
- Weak RED: both scenarios chose **B** on existing **When `/flow` is invoked** rules — wrong-route drafts (/flow-patch for 20+ files, auto-run tests) already rejected

## Skill change
- File: skills/flow/SKILL.md
- Change: **When `/flow` is invoked** — triage concierge, hard gate, forbidden same-message auto-start (decision tree is authoritative; no triage examples table)

## GREEN (after fix)
- **flow-router-suggest-spec:** **B** — `/flow-spec` only; cited decision tree (not patch), hard gate (no micro-spec)
- **flow-router-suggest-debug:** **B** — `/flow-debug` only; cited bug/test-failure branch, forbidden auto-investigation
- **flow-router-suggest-brainstorm:** **B** — `/flow-brainstorm` only; cited fuzzy-idea branch, forbidden spec Goal section under `/flow`
