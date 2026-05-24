---
name: flow-debug
description: Investigate bugs and test failures before fixing. Invoke with /flow-debug.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-debug
---

# Flow Debug

**Triggered by:** `/flow-debug`

Find root cause before proposing fixes. No fixes until investigation is complete.

## Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

## Phase 1 — Investigate

**Read and follow** `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`) before updating STATE.

Same-topic failure (matches active plan/spec/patch on this branch) → set `phase: debug` and investigate. Unrelated topic with active STATE → session gate first; do not overwrite STATE until user confirms.

1. **Read errors carefully** — full stack traces, line numbers, error codes
2. **Reproduce** — exact steps; confirm consistent failure
3. **Check recent changes** — git diff, recent commits, config/env changes
4. **Gather evidence** — in multi-component systems, add diagnostics at each boundary before guessing; log inputs/outputs between layers, run once, see where it breaks
5. **Deep stack or mystery origin** — read `flow-shared/references/root-cause-tracing.md` (resolve via path resolver in `flow/SKILL.md`); trace backward to the original trigger

Do not propose fixes during Phase 1.

## Phase 2 — Pattern & hypothesis

Before routing to patch:

1. **Pattern analysis** — find similar working code in the codebase; compare working vs broken line by line; list every difference (config, env, assumptions), however small
2. **Single hypothesis** — state clearly: "I think X is the root cause because Y"
3. **Test minimally** — smallest check to confirm or reject (read-only inspection, one diagnostic run, one log) — not a production fix
4. **Wrong?** — new hypothesis, return to Phase 1; do not stack guesses

If you don't understand yet, ask the user or gather more evidence — do not route to `/flow-patch`.

## Phase 3 — Route

| Outcome | Next step |
|---------|-----------|
| Root cause known, bounded fix | `/flow-patch` with regression test requirement — **same review and verify rails as any patch** (per-task spec + correctness reviewers, then auto-verify + user menu) |
| Fix needs design or spans subsystems | `/flow-spec` |
| Cannot reproduce or insufficient data | Ask user; gather more evidence |

## 3-fix stop

If **three** `/flow-patch` attempts for the **same underlying issue** have failed (fix didn't work, new symptoms elsewhere, or root cause keeps moving):

- **Stop** patching
- Return to Phase 1 with what you learned
- Route to `/flow-spec` or ask the user — likely an architectural problem, not a missing line fix

## Regression test requirement

When routing to `/flow-patch`, the micro-spec must include:

> Write failing test reproducing the bug before fixing (TDD RED-GREEN).

**Debug does not implement, review, or verify.** After handoff, `/flow-patch` owns inline TDD, subagent reviews per task, auto-verify, and the numbered merge/push menu — identical to a standalone patch.

## Red flags

- "Quick fix" before understanding cause
- Changing code hoping it works
- Multiple fixes without re-investigating after each failure
- "One more fix attempt" after two failed patches on the same issue
- Proposing solutions before tracing data flow or comparing to working code

Update `docs/flow/STATE.md`: `phase: debug` while investigating.
