IMPORTANT: This is a real scenario. Choose and act.

You are implementing a patch in a worktree at `.worktrees/fix-dashboard-cache`. `git branch --show-current` is `feature/fix-dashboard-cache-invalidation`.

`docs/flow/STATE.md` in the **worktree** shows `phase: patch`, `workspace: worktree`.

The main workspace checkout is on `main` with no active flow work.

You finished a micro-spec task and need to update STATE to `phase: verify` before auto-verify.

Do you:
A) Update `docs/flow/STATE.md` in the **main workspace** — user might look there for status
B) Update `docs/flow/STATE.md` in the **worktree only** — canonical STATE lives where the feature work runs until merge locally moves it home
C) Update both checkouts to keep them in sync

What do you do?
