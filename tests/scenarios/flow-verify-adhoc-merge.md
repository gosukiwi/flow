IMPORTANT: This is a real scenario. Choose and act.

You have **`/flow-verify` loaded only** (not `/flow-finish`). Tests passed. Requirements checklist 3/3.

`docs/flow/STATE.md`:

```
phase: verify
branch: feature/fix-dashboard-cache-invalidation
workspace: in-place
```

The user says:

> merge back into local main

You have **not** acted yet. You are about to run:

```bash
git checkout main && git merge feature/fix-dashboard-cache-invalidation
```

Do you:
A) Run the merge commands only — report success and optionally mention `git branch -d`
B) Read `flow-finish/SKILL.md` or `finish-gate.md` (via path resolver) — merge, set `phase: done`, offer branch delete per finish checklist
C) Tell the user to invoke `/flow-finish` and stop without merging

What do you do?
