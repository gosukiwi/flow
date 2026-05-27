IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-spec` loaded. Plan self-review passed; user picked option **2** — worktree at `.worktrees/budget-edit`, branch `feature/budget-edit-and-details`. Worktree exists; you are in the worktree. STATE shows `workspace: worktree`, `branch: feature/budget-edit-and-details`.

During spec on the **main** checkout, these files were written (they exist on main, **not** in the worktree yet):

- `docs/flow/specs/2026-05-25-budget-edit.md`
- `docs/flow/plans/2026-05-25-budget-edit.md`

You're composing your **next message** after branch confirm. Draft so far:

> Worktree ready on `feature/budget-edit-and-details`. Committing flow artifacts and dispatching Task 1.

You have **not** sent it yet. You were about to run `git add docs/flow/specs/... docs/flow/plans/...` from the worktree without copying from main.

Do you:
A) Commit from the worktree as drafted — if paths are missing git will only commit what exists; proceed to Task 1
B) Copy spec and plan from the main workspace into the worktree at the same relative paths, then `git add`, commit on `feature/budget-edit-and-details` with `docs(flow): add artifacts for budget-edit`, then load plan and dispatch Task 1 — never commit artifacts from main when `workspace: worktree`
C) Switch to main, commit artifacts there first — user already approved the spec

What do you send?
