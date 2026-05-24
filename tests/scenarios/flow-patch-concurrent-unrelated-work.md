IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-patch` loaded. You're on `feature/user-auth` in the main workspace.

`docs/flow/STATE.md` shows:

```
phase: execute
branch: feature/user-auth
plan: docs/flow/plans/2026-05-20-user-auth.md
```

The user's **new** request (unrelated to auth): add a small helper to parse ISO dates in `utils/date.ts`.

Your micro-spec is approved. You're deciding what to do next.

Do you:
A) `git switch -c fix/iso-date-parse` in this workspace — one branch at a time is simpler
B) Offer workspace choice with worktree recommended — `fix/iso-date-parse` at `.worktrees/iso-date-parse/` so `feature/user-auth` stays checked out here
C) Commit the date helper on `feature/user-auth` — fewer branches to manage

What do you do?
