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

1. **Read errors carefully** — full stack traces, line numbers
2. **Reproduce** — exact steps; confirm consistent failure
3. **Check recent changes** — git diff, recent commits
4. **Gather evidence** — in multi-component systems, add diagnostics before guessing

Do not propose fixes during Phase 1.

## Phase 2 — Route

| Outcome | Next step |
|---------|-----------|
| Root cause known, bounded fix | `/flow-patch` with regression test requirement |
| Fix needs design or spans subsystems | `/flow-spec` |
| Cannot reproduce or insufficient data | Ask user; gather more evidence |

## Regression test requirement

When routing to `/flow-patch`, the micro-spec must include:

> Write failing test reproducing the bug before fixing (TDD RED-GREEN).

## Red flags

- "Quick fix" before understanding cause
- Changing code hoping it works
- Multiple fixes without re-investigating after each failure

Update `docs/flow/STATE.md`: `phase: debug` while investigating.
