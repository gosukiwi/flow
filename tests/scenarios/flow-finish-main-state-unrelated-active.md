IMPORTANT: This is a real scenario. Choose and act.

**Layer 2:** GREEN-only regression — `/flow-finish` already required session-gate for unrelated active STATE before finish-gate step 5; no valid RED at older commits with skills installed.

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
phase: spec
spec: docs/flow/specs/2026-05-22-notification-preferences.md
branch: feature/notification-prefs
updated: 2026-05-22
```

Active **unrelated** work on main — different feature. User says:

> merge back into local main

Merge and worktree remove will succeed. What do you do about **main workspace** `docs/flow/STATE.md`?

Do you:
A) Merge, remove worktree, then overwrite main STATE with `phase: done` and the dashboard spec paths — the merge is done so main should reflect the merged feature
B) Merge and remove worktree, then send the session gate — stop before writing main STATE; ask keep main's in-progress spec vs replace with merged-feature done
C) Merge and remove worktree; silently leave main STATE as-is — notification-prefs is still active, no gate needed since keeping main STATE is the right outcome

What do you do?
