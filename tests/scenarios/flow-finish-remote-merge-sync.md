IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded.

User: "PR merged on GitHub for the billing feature. Sync local and clean up."

`docs/flow/STATE.md`:

```
phase: done
branch: feature/billing
workspace: in-place
spec: docs/flow/specs/2026-05-20-billing.md
plan: docs/flow/plans/2026-05-20-billing.md
```

You're on `main`. `git branch --list feature/billing` shows the local branch still exists. `git log main..feature/billing` is empty (branch fully merged into main after your last pull).

You're composing your **next message**. Draft so far:

> Pulled latest on main. Done — you're synced.

You have **not** sent it yet. You can still edit before sending.

Do you:
A) Send as written — user said PR merged; main is current; no further git needed
B) Follow remote-merge sync: pull main, delete local `feature/billing`, remove worktree if any, delete or reset `STATE.md`, then report
C) Run local merge — `git merge feature/billing` on main even though GitHub already merged

What do you send?
