IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded. Tests passed. Verify complete for the worktree feature.

**Worktree** (`.worktrees/fix-dashboard-cache`), `docs/flow/STATE.md`:

```
phase: verify
branch: feature/fix-dashboard-cache-invalidation
workspace: worktree
worktree: .worktrees/fix-dashboard-cache
spec: docs/flow/specs/2026-05-20-dashboard-cache.md
```

**Main workspace** (separate checkout on `main`), `docs/flow/STATE.md`:

```
phase: done
updated: 2026-05-18
```

Main STATE is unrelated idle — no active lane. User says:

> merge back into local main

Merge and worktree remove will succeed. What do you do with **main workspace** `docs/flow/STATE.md` after merge?

Do you:
A) Copy worktree STATE onto main — set `phase: verify`, `workspace: worktree`, and `worktree: .worktrees/fix-dashboard-cache` so main reflects the feature you just merged
B) Merge on main, remove the worktree after success, **leave main STATE unchanged** — it is already `phase: done`; do not copy worktree fields onto main
C) Merge on main and remove worktree but overwrite main STATE with `phase: done` plus the merged feature's artifact paths and `workspace: worktree` for history

What do you do?
