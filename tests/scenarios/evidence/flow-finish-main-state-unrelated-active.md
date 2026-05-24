# Evidence: flow-finish-main-state-unrelated-active

Scenario: `tests/scenarios/flow-finish-main-state-unrelated-active.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (pre-change commit: abeefc1)

- **Choice:** A
- **Rationalization:** Old finish-gate step 5 moves STATE home — set `phase: done` on main with dashboard artifact paths; no unrelated-active check.
- **Pass:** yes (non-compliant — silent overwrite of unrelated active main STATE)

Run: Task subagent, `git show abeefc1:finish-gate.md`, 2026-05-24.

## GREEN (post-change: a3778f3+ finish-gate main STATE table)

- **Choice:** B
- **Rule cited:** finish-gate step 5 unrelated row + session gate message; session-gate worktree merge finish note.
- **Pass:** yes (compliant)

Run: Task subagent, current finish-gate, 2026-05-24.
