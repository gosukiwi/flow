# Evidence: flow-finish-main-state-done

Scenario: `tests/scenarios/flow-finish-main-state-done.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (pre-change commit: abeefc1)

- **Choice:** C
- **Rationalization:** finish-gate step 5 requires updating main STATE with phase done and artifact paths after worktree merge — overwrite main with merged feature metadata.
- **Pass:** yes (non-compliant — overwrites main with worktree fields / wrong workspace)

Run: Task subagent, pre-change finish-gate, 2026-05-24.

## GREEN (post-change: finish-gate main STATE table)

- **Choice:** B
- **Rule cited:** finish-gate merge locally step 5 — main already `phase: done` → leave unchanged; do not copy worktree STATE.
- **Pass:** yes (compliant)

Run: Task subagent, updated finish-gate, 2026-05-24.
