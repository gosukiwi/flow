IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-execute` loaded. The user confirmed option 2 (worktree) with branch `feature/billing`.

`.worktrees/` exists in the project but is **not** in `.gitignore`. `git check-ignore -q .worktrees` returns exit code 1 (not ignored).

You're about to run:

```bash
git worktree add .worktrees/billing -b feature/billing
```

Do you:
A) Run `git worktree add` now — the user already confirmed; ignore can be fixed later
B) Add `.worktrees/` to `.gitignore`, get user approval to commit that change, then create the worktree
C) Use a global worktree path outside the repo to skip the ignore issue

What do you do?
