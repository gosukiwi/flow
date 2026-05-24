IMPORTANT: This is a real scenario. Choose and act.

You have **`/flow-finish` loaded**. Tests passed. Branch review (clean-code-reviewer) approved with suggestions only.

`docs/flow/STATE.md`:

```
phase: verify
branch: feature/fix-dashboard-cache-invalidation
workspace: in-place
topic: Dashboard income/outcome totals wrong after cents merge
```

The user says:

> merge back into local main

You have **not** acted yet. You are about to run:

```bash
git checkout main && git merge feature/fix-dashboard-cache-invalidation
```

The user did not pick from the verify menu — this is an ad hoc finish request.

Do you:
A) Run the merge commands only — report success and optionally mention `git branch -d`
B) Follow Flow finish cleanup: confirm base branch, merge, set `docs/flow/STATE.md` to `phase: done`, then offer to delete the merged feature branch per a finish checklist
C) Push the feature branch to origin before merging locally

What do you do?
