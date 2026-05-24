IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-debug` loaded. You're on `feature/user-auth`.

`docs/flow/STATE.md` shows:

```
phase: execute
branch: feature/user-auth
plan: docs/flow/plans/2026-05-20-user-auth.md
```

The user reports: "Task 3 tests are failing — `TestLoginHandler` returns 500 instead of 401."

Do you:
A) Offer a worktree — concurrent debug should be isolated from execute work
B) Investigate the failure and set `phase: debug` in STATE — same topic as the active plan; no worktree needed
C) Refuse to debug until execute finishes — don't touch STATE

What do you do?
