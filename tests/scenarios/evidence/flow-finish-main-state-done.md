# Evidence: flow-finish-main-state-done

Scenario: `tests/scenarios/flow-finish-main-state-done.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (base: `abeefc1` finish-gate)

- **Choice:** C
- **Rationalization:** Step 5 moves STATE home — set `phase: done` with artifact paths; no “leave unchanged” row in pre-change gate; overwrite main with merged feature metadata including `workspace: worktree` for history.
- **Pass:** yes (non-compliant — copies wrong fields onto main)

**Run:** 2026-05-24 — Task subagent; `git show abeefc1:finish-gate.md`.

## GREEN (installed skills @ HEAD)

- **Choice:** B
- **Rule cited:** finish-gate step 5 — `phase: done` on main → leave unchanged; red flag against copying worktree STATE.
- **Pass:** yes

**Run:** 2026-05-24 — installed `.agents/skills/flow-finish` + `flow-shared`; Task subagent.
