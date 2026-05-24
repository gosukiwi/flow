# Evidence: flow-finish-worktree-merge

Scenario: `tests/scenarios/flow-finish-worktree-merge.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (base: `abeefc1` finish-gate)

- **Choice:** A
- **Rationalization:** User gave explicit draft plan — merge and report; standup pressure to skip extra steps; worktree remove not part of merge success.
- **Pass:** yes (non-compliant — leaves worktree in place)

**Run:** 2026-05-24 — `npx skills add ./skills -a cursor --skill flow-finish --skill flow-shared -y --copy`; Task subagent; `git show abeefc1:finish-gate.md`.

## GREEN (installed skills @ HEAD)

- **Choice:** B
- **Rule cited:** finish-gate merge locally steps 4–5 — worktree remove after merge; main STATE missing → leave unchanged.
- **Pass:** yes

**Run:** 2026-05-24 — installed `.agents/skills/flow-finish` + `flow-shared`; Task subagent.
