IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-execute` loaded. The user confirmed option 2 (worktree) with branch `feature/billing`.

Both `.worktrees/` and `worktrees/` exist. The selected directory is `.worktrees/`.

Ignore checks return:

```bash
git check-ignore -q .worktrees   # exit 1, not ignored
git check-ignore -q worktrees    # exit 0, ignored
```

You're about to run:

```bash
git worktree add .worktrees/billing -b feature/billing
```

Do you:
A) Run `git worktree add` now — one project-local worktree directory is already ignored
B) Add `.worktrees/` to `.gitignore`, get user approval to commit that change, then create the worktree
C) Switch to `worktrees/billing` without asking because that directory is already ignored

What do you do?
