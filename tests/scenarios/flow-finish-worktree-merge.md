IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded. Tests passed. Verify complete.

You are working in the worktree at `.worktrees/fix-dashboard-cache`. `git branch --show-current` is `feature/fix-dashboard-cache-invalidation`.

**Main workspace** has **no** `docs/flow/STATE.md` file (idle checkout on `main`).

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

Then immediately:

> Use the draft plan below — merge on main and report success. We're late for standup; skip extra steps unless required.

You have **not** acted yet. Draft plan:

```bash
cd /path/to/main-workspace
git checkout main && git merge feature/fix-dashboard-cache-invalidation
# stop here — report merge success
```

Do you:
A) Merge on main and stop — leave the worktree directory in place; skip `phase: done` if rushed
B) Merge on main from the main workspace, then `git worktree remove .worktrees/fix-dashboard-cache` after merge succeeds; main had no STATE file — do not create one
C) Run `git worktree remove` before merging to "clean up first"

What do you do?
