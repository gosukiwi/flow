# Finish Gate

Read before **any** local merge, push, or flow close-out when `docs/flow/STATE.md` shows active work (`phase` is not `done` or missing with completed verify).

Also used by `/flow-verify` menu options 1, 2, and 4, and by `/flow-finish` when the user requests merge/push outside the menu.

Resolve via path resolver in `flow/SKILL.md`.

## Hard gate

```
NO RAW GIT MERGE/PUSH FOR ACTIVE FLOW WORK WITHOUT THIS CHECKLIST
```

**Forbidden:** Running `git checkout main && git merge <feature>` (or equivalent) and reporting success **without** updating `STATE.md` to `phase: done` when merge completes in-place.

Ad hoc user messages ("merge back into main", "push the branch", "we're done") trigger this gate — route to `/flow-finish` or follow the matching section below.

## Prerequisites

Before merge or push:

- Verify passed (auto-run from execute/patch, standalone `/flow-verify`, or user explicitly confirms tests + checklist are green)
- If verify has **not** run and user has not confirmed → run verify steps first or ask

Branch review (verify option 3 / clean-code-reviewer) is **optional** — do not block finish on suggestions-only reviews unless user wants fixes first.

## Read STATE first

From `docs/flow/STATE.md`:

- `branch` — feature branch being integrated
- `workspace` — `in-place` or `worktree`
- `worktree` — path when `workspace: worktree`
- Current `phase` — should be `verify` or recent active phase

Confirm `git branch --show-current` matches `STATE.branch` (or user is in the worktree path from STATE).

## Option: Merge locally

1. **Confirm base branch** with user (default `main`; use project convention if different)
2. **Checkout base** and **merge** feature branch:

   ```bash
   git checkout <base>
   git merge <feature-branch>
   ```

3. **If merge fails** — stop; do not set `phase: done`; help resolve conflicts
4. **If `workspace: worktree`** — after successful merge, from the **main workspace** (not inside the worktree):

   ```bash
   git worktree remove <worktree-path>
   ```

   Only after merge succeeded. Do not remove a worktree with unmerged or uncommitted work.

5. **Update STATE** — set `phase: done` in the **main workspace** after worktree merge (integration complete); keep artifact paths for history; update `updated` date. Do not leave `phase: verify` in an orphaned worktree `STATE.md` without updating the canonical checkout's STATE.

   **Exception to worktree-setup "no main-workspace STATE" rule:** finish merge is the one time main-workspace STATE is updated for worktree work — integration is complete.
6. **Offer branch cleanup (in-place)** — after successful merge:

   > Feature branch merged. Delete local branch? `git branch -d <feature-branch>`

   Do not delete without user confirmation unless they already asked to clean up.

7. **Report** — base branch, merge commit/ref, worktree removed (if any), STATE updated

## Option: Push branch

1. Confirm user wants push **without** local merge
2. From feature branch (or worktree):

   ```bash
   git push -u origin HEAD
   ```

3. **Update STATE** — `phase: done`
4. **Keep worktree** — do not remove on push-only
5. **Report** — remote tracking set; user opens PR when ready

## Option: Done for now

Pause without merge or push. **`phase: done` closes the flow lane** — branch and worktree stay as-is for you to resume or integrate later.

1. **No git actions** — no merge, push, or worktree remove
2. **Update STATE** — `phase: done`
3. **Report** — work paused; branch and worktree (if any) preserved

## Red flags — never

- Merge active flow work without setting `phase: done` afterward
- Remove worktree before merge succeeds or with dirty state
- Push or merge when verify failed and user has not acknowledged
- Update STATE in the main workspace **during** active worktree implementation (see `worktree-setup.md`) — **except** finish-gate merge locally step 5 after successful merge + worktree remove
- Treat clean-code-reviewer **Suggest** items as blocking merge unless user asks to fix them first

## Skills that use this reference

- `flow-finish` — primary orchestrator for merge/push/done
- `flow-verify` — menu options 1, 2, 4 delegate here
