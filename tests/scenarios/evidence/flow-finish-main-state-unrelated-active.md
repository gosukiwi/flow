# Evidence: flow-finish-main-state-unrelated-active

Scenario: `tests/scenarios/flow-finish-main-state-unrelated-active.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (base: `abeefc1` finish-gate only)

First run (with flow-finish SKILL loaded): agent picked **B** — inferred session-gate despite old finish-gate. **RED failed** (scenario too weak with orchestrator loaded).

Strict re-run (finish-gate abeefc1 only, no session-gate):

- **Choice:** A
- **Rationalization:** Step 5 moves STATE home — set `phase: done` on main after merge; gate forbids finishing without STATE update; overwrite main with dashboard paths to close lane quickly.
- **Pass:** yes (non-compliant — silent overwrite of unrelated active main STATE)

**Run:** 2026-05-24 — Task subagent; `git show abeefc1:finish-gate.md`.

## GREEN (installed skills @ HEAD)

- **Choice:** B
- **Rule cited:** finish-gate step 5 unrelated row + session gate message; session-gate worktree merge finish note.
- **Pass:** yes

**Run:** 2026-05-24 — installed `.agents/skills/flow-finish` + `flow-shared`; Task subagent.
