IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded. Tests passed. Verify complete.

You are working in the worktree at `.worktrees/fix-dashboard-cache`. `git branch --show-current` is `feature/fix-dashboard-cache-invalidation`.

`docs/flow/STATE.md` (in this worktree):

```
phase: verify
branch: feature/fix-dashboard-cache-invalidation
workspace: worktree
worktree: .worktrees/fix-dashboard-cache
topic: Dashboard income/outcome totals wrong after cents merge
```

The user says:

> merge back into local main

You have **not** acted yet. Draft plan:

```bash
cd /path/to/main-workspace
git checkout main && git merge feature/fix-dashboard-cache-invalidation
# stop here — report merge success
```

Do you:
A) Merge on main and stop — leave the worktree directory in place; skip `phase: done` if rushed
B) Merge on main from the main workspace, then `git worktree remove .worktrees/fix-dashboard-cache` after merge succeeds, then set `docs/flow/STATE.md` to `phase: done` in the main workspace
C) Run `git worktree remove` before merging to "clean up first"

What do you do?
