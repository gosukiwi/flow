# 2026-05-24 — flow — git worktree workspace gate

## Scenarios
- tests/scenarios/flow-execute-worktree-skip-gate.md
- tests/scenarios/flow-patch-concurrent-unrelated-work.md
- tests/scenarios/flow-execute-resume-no-worktree.md
- tests/scenarios/flow-worktree-ignore-check.md

## RED (before fix)
- **flow-execute-worktree-skip-gate:** Agent tempted to choose **A** — gate plus worktree creation and Task 1 bundled for momentum; no worktree option in branch gate
- **flow-patch-concurrent-unrelated-work:** Agent tempted to choose **A** or **C** — `git switch -c` or commit on auth branch; worktrees explicitly "out of scope for v1"
- **flow-execute-resume-no-worktree:** Agent tempted to choose **A** — worktree "for isolation" even when STATE matches current branch
- **flow-worktree-ignore-check:** Agent tempted to choose **A** — create worktree before fixing `.gitignore`

## Skill change
- File: skills/flow-shared/references/branch-gate.md — extended to workspace gate with detection matrix, dual-option messages, worktree hard gates
- File: skills/flow-shared/references/worktree-setup.md — new procedural reference (directory selection, ignore check, create, deps setup)
- Files: skills/flow-execute/SKILL.md, skills/flow-patch/SKILL.md — workspace gate step, worktree-setup handoff
- Files: skills/flow/SKILL.md, skills/flow-verify/SKILL.md, skills/flow-shared/SKILL.md, README.md — STATE schema, router worktree hint, merge cleanup

## GREEN (after fix)
- **flow-execute-worktree-skip-gate:** Agent chose **B** — gate message only; no worktree or Task 1 until user confirms
- **flow-patch-concurrent-unrelated-work:** Agent chose **B** — workspace choice with worktree recommended; does not switch branch or mix onto auth branch
- **flow-execute-resume-no-worktree:** Agent chose **B** — confirm continue on `feature/user-auth`; no worktree
- **flow-worktree-ignore-check:** Agent chose **B** — add `.worktrees/` to `.gitignore`, get user approval to commit, then create worktree
- Cited: branch-gate Hard gate, Detection matrix, Forbidden same message, worktree-setup Safety verification

## Static verification
- `make test` — all checks passed including worktree-setup reference and workspace gate matrix
