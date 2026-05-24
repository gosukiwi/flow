# Evidence: flow-finish-main-state-unrelated-active

Scenario: `tests/scenarios/flow-finish-main-state-unrelated-active.md`  
Skill: `/flow-finish` + `flow-shared`

**GREEN-only** — RED N/A: `flow-finish` has required session-gate for unrelated active STATE since `41cdbde`; installed-skills RED cannot fail honestly.

## GREEN (installed skills @ HEAD)

- **Choice:** B
- **Rule cited:** finish-gate step 5 unrelated row + session gate message; session-gate worktree merge finish note.
- **Pass:** yes

**Run:** 2026-05-24 — `npx skills add ./skills -a cursor --skill flow-finish --skill flow-shared -y --copy`; Task subagent.
