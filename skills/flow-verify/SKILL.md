---
name: flow-verify
description: Final verification gate before claiming work complete. Invoke with /flow-verify.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-verify
---

# Flow Verify

**Triggered by:** `/flow-verify` — also entered automatically at the end of `/flow-execute` and `/flow-patch` when all tasks complete.

Evidence before assertions. **Read and follow** `flow-shared/references/verify-gate.md` (resolve via path resolver in `flow/SKILL.md`).

This skill is intentionally thin — `verify-gate.md` holds the checklists and user menu; this file routes intent.

## When to use

| User intent | Action |
|-------------|--------|
| Standalone `/flow-verify` | Full verify process in verify-gate |
| Auto-run after execute/patch tasks complete | Same — do not hand off for separate invocation |
| "Are we done?" with unverified or stale evidence | Re-run verify-gate process (fresh full suite) |
| User chose verify menu option 1, 3, or 4 | Delegate to `/flow-finish` or `finish-gate.md` per verify-gate |
| User chose verify menu option 2 | Branch review per verify-gate **Option 2** |

**Do not use** for: merge/push/sync/done without verify passing (that's `/flow-finish` after verify), or auto-running branch review without user choosing option 2.

## Prerequisites

- Implementation complete (execute/patch tasks done) or user explicitly re-checking
- Read `docs/flow/STATE.md` — confirm branch/topic matches work being verified

**Before updating STATE:** read `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`). Unrelated active STATE → session gate first.

## Process

1. Read `verify-gate.md` — Iron Law, full test suite, requirements checklist, session-gate, `phase: verify`
2. If verify fails → route to `/flow-debug` or `/flow-patch`; do not present the done menu
3. If verify passes → present the numbered user menu from verify-gate (options 1–4)
4. On menu choice or ad hoc finish request → follow verify-gate option actions or `/flow-finish`

## Red flags — never

- **Skip fresh test run** — per-task tests or earlier session runs do not substitute for verify
- **Replace the numbered menu** with ad hoc next steps or implementation summary
- **Auto-run option 2** when user asks to merge or push
- **Raw merge/push** without finish-gate when user requests finish outside the menu
- **Treat plan "Final verification" task** as substitute for verify-gate completion

## Integration

- **`verify-gate.md`** — full process, menu, option 2, ad hoc finish routing
- **`verification-gate.md`** — Iron Law referenced from verify-gate step 1
- **`/flow-finish`** — menu options 1, 3, 4 and ad hoc merge/push/done
- **`plan-execution.md` / `flow-patch`** — auto-run verify after all tasks
