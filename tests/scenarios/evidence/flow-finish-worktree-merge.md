# Evidence: flow-finish-worktree-merge

Scenario: `tests/scenarios/flow-finish-worktree-merge.md`  
Skill: `/flow-finish` + `flow-shared`

## RED (pre-change commit: abeefc1, sharpened scenario)

Scenario updated with standup pressure + "use draft plan exactly" (merge-only draft).

- **Choice:** A
- **Rationalization:** User approved draft plan — merge and report; worktree remove and STATE not in plan; skip extra steps under standup pressure.
- **Pass:** yes (non-compliant — leaves worktree; skips finish-gate merge locally steps 4–5)

Run: Task subagent, `git show abeefc1:finish-gate.md`, 2026-05-24.

## GREEN (post-change: finish-gate with worktree remove + main STATE missing row)

- **Choice:** B
- **Rule cited:** finish-gate merge locally step 4 (worktree remove after merge, not before); step 5 missing → leave unchanged; red flag on remove-before-merge.
- **Pass:** yes (compliant despite standup pressure)

Run: Task subagent, current finish-gate, sharpened scenario, 2026-05-24.
