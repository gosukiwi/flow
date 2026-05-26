# Finish Gate

Read before **any** local merge, push, or flow close-out when `docs/flow/STATE.md` shows active work (`phase` is not `done` or missing with completed verify).

Also used by `/flow-verify` menu options 1, 3, and 4, and by `/flow-finish` when the user requests merge/push outside the menu.

Resolve via path resolver in `flow/SKILL.md`.

## Hard gate

```
NO RAW GIT MERGE/PUSH FOR ACTIVE FLOW WORK WITHOUT THIS CHECKLIST
```

**Forbidden:** Running `git checkout main && git merge <feature>` (or equivalent) and reporting success **without** following **merge locally** STATE rules (step 5): in-place → set `phase: done`; worktree → read main STATE and apply the table (leave unchanged if already `phase: done`; session gate if unrelated active — do not silently overwrite).

Ad hoc user messages ("merge back into main", "push the branch", "we're done") trigger this gate — route to `/flow-finish` or follow the matching section below.

## Prerequisites

Before merge or push:

- Verify passed (auto-run from execute/patch, standalone `/flow-verify`, or user explicitly confirms tests + checklist are green)
- If verify has **not** run and user has not confirmed → run verify steps first or ask

Branch review (verify option 2 / clean-code-reviewer) is **optional** — do not block finish on suggestions-only reviews unless user wants fixes first.

## Read STATE first

From `docs/flow/STATE.md` (local/gitignored per `state-setup.md` — never committed):

- `branch` — feature branch being integrated
- `workspace` — `in-place` or `worktree`
- `worktree` — path when `workspace: worktree`
- Current `phase` — should be `verify` or recent active phase

Confirm `git branch --show-current` matches `STATE.branch` (or user is in the worktree path from STATE).

## Canonical STATE location

| `workspace` | Finish action | Update `STATE` in |
|-------------|---------------|-------------------|
| `in-place` | merge / push / done for now | Current checkout |
| `worktree` | push or done for now | **Worktree path** (worktree kept) |
| `worktree` | merge locally | **Main workspace** after merge succeeds and worktree is removed |

See `worktree-setup.md` **Canonical STATE location** for the full lifecycle table.

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

   **Before step 4:** read worktree `docs/flow/STATE.md` for branch and artifact paths (`brainstorm`, `spec`, `plan`) — record paths for **Artifact cleanup gate**; do not copy STATE to main yet.

5. **Update main workspace STATE** — after worktree remove (or immediately when `workspace: in-place`):

   Read **main workspace** `docs/flow/STATE.md` (not the worktree copy — removed after step 4). **Record artifact paths** (`brainstorm`, `spec`, `plan`) for **Artifact cleanup gate** before applying the table. Apply:

   | Main STATE before finish | Action |
   |--------------------------|--------|
   | `phase: done` or missing | **Leave unchanged** — lane already closed; specs/plans merged via git |
   | Active, same merged branch or stale for that feature | Set `phase: done`; clear `workspace` / `worktree` fields |
   | Active, **unrelated** topic | **Session gate** — stop; do not overwrite silently (see below) |

   **Do not** copy worktree STATE onto main (`workspace: worktree`, dead `worktree:` path, or `phase: verify` from the merged feature).

   When `workspace: in-place`, set `phase: done` in the current checkout (same checkout throughout merge).

   **Unrelated active STATE on main** — send session gate only; do not combine with merge report:

   > Main checkout has active flow work (`phase: <phase>`, `<artifact path>`). Worktree feature merged and removed.
   > 1. **Keep main STATE** — in-progress work on main unchanged
   > 2. **Replace main STATE** — set `phase: done` for the merged feature only (you lose main resume pointer)
   >
   > Confirm (1 or 2). I won't update main `STATE.md` until you choose.

6. **Offer branch cleanup** — after successful merge:

   > Feature branch merged. Delete local branch? `git branch -d <feature-branch>`

   Do not delete without user confirmation unless they already asked to clean up.

7. **Artifact cleanup gate** — follow **Artifact cleanup gate (after integration)** below (paths recorded before STATE changes)

8. **Report** — base branch, merge commit/ref, worktree removed (if any), main STATE action taken (unchanged / updated / gated), artifact gate outcome

## Option: Push branch

1. Confirm user wants push **without** local merge
2. From feature branch (or worktree):

   ```bash
   git push -u origin HEAD
   ```

3. **Update STATE** — `phase: done` in the **worktree** when `workspace: worktree` (canonical location until merge); current checkout when `workspace: in-place`
4. **Keep worktree** — do not remove on push-only
5. **Report** — remote tracking set; user opens PR when ready. **After the PR merges on GitHub:** run `/flow-finish` → **sync after remote merge** (below) — pull base, delete local branch, remove worktree if any, clear `STATE.md`.

## Option: Sync after remote merge

Use when the PR merged on GitHub (or remote) and integration did **not** happen via **merge locally** in this repo. Typical after verify menu **push branch** or when the user returns and says "PR merged, sync local, clean up."

**Do not use** when the user wants a local merge — use **merge locally** instead.

### Prerequisites

- User confirms the PR/feature is merged on the remote (or you verified the feature branch is an ancestor of the base branch after `git fetch` / `git pull`)
- Read `docs/flow/STATE.md` for `branch`, `workspace`, `worktree`, and artifact paths (`brainstorm`, `spec`, `plan`)
- If verify never ran and integration is uncertain → confirm with user before deleting branch/STATE

### Steps (main workspace)

**Record artifact paths** from STATE before step 6 (read worktree `STATE.md` before worktree remove if `workspace: worktree`). Keep the list for **Artifact cleanup gate (after integration)**.

1. **Confirm base branch** with user (default `main`)
2. **Checkout base and pull:**

   ```bash
   git checkout <base>
   git pull
   ```

3. **Verify feature branch is integrated** — `git merge-base --is-ancestor <feature-branch> <base>` must succeed after pull. If not → stop; PR may not be merged locally yet.
4. **Remove worktree** if `STATE` had `workspace: worktree` and `worktree:` path — from **main workspace**, after confirming no uncommitted work in that worktree:

   ```bash
   git worktree remove <worktree-path>
   ```

5. **Delete local feature branch:**

   ```bash
   git branch -d <feature-branch>
   ```

   Use `-D` only if user confirms force-delete. Do not delete unrelated branches.

6. **Clear STATE** — **delete** `docs/flow/STATE.md` in the **main workspace** (do not leave `phase: done` with stale `branch` / `worktree` / artifact paths).

7. **Artifact cleanup gate** — follow **Artifact cleanup gate (after integration)** below (use paths recorded before step 6)

8. **Report** — base updated, branch deleted, worktree removed (if any), `STATE.md` removed, artifact gate outcome

**Forbidden in this path:**

- `git merge <feature-branch>` on base when remote already merged
- Reporting success after `git pull` only — branch delete and STATE clear are required
- Leaving `docs/flow/STATE.md` with old `branch:` or `workspace: worktree` after sync

## Artifact cleanup gate (after integration)

Runs at the end of **merge locally** (step 7) and **sync after remote merge** (step 7) — not after **push branch** or **done for now**.

### Record paths before STATE is cleared

From `docs/flow/STATE.md` (or worktree copy before remove), collect every path that exists:

- `brainstorm:` → `docs/flow/brainstorms/...`
- `spec:` → `docs/flow/specs/...`
- `plan:` → `docs/flow/plans/...`

Deduplicate. If none exist on disk after integration → **skip** this gate.

### Gate (required when any file exists)

Send **only** this message — do not combine with integration report, branch delete offer, or file removal:

```
Feature integrated. Delete flow artifacts for this topic?

1. Keep spec/plan/brainstorm (default)
2. Delete flow artifacts from STATE — I'll open a chore branch, commit removals, and push for a PR into <base>

Stop until the user picks 1 or 2.
```

Replace `<base>` with the integration base branch (e.g. `main`).

### After user picks

**Option 1 — Keep (default):** Done. Artifacts remain in the repo.

**Option 2 — Delete on chore branch (agent commits and pushes):**

1. On `<base>` checkout (up to date after integration). Derive `<topic>` from spec/plan filename or merged branch name.
2. **Create cleanup branch** — do not commit deletions on `<base>`:

   ```bash
   git checkout -b chore/remove-flow-artifacts-<topic>
   ```

3. For each recorded path that exists:
   - Tracked: `git rm <path>`
   - Untracked only: remove file; if nothing ends up staged → report "nothing to remove" and stop (delete branch if empty)
4. If no staged deletions → report and stop
5. **Commit on the chore branch** — do not ask the user to commit:

   ```bash
   git commit -m "Remove flow artifacts for <topic>"
   ```

6. **Push for PR** — do not merge into `<base>` locally:

   ```bash
   git push -u origin HEAD
   ```

7. **Report** — branch name, removed paths, commit SHA; user opens PR into `<base>` when ready (same handoff as verify **push branch**)

**Forbidden:**

- Delete artifact files without user picking **2**
- Tell the user to delete files or "commit when you're ready"
- **Commit artifact removal on `<base>`** — use `chore/remove-flow-artifacts-<topic>` only
- **`git merge` cleanup branch into `<base>`** without explicit user request
- Skip `git push` after option **2** when removals were committed
- Bundle this gate with branch-delete confirmation or sync/merge report in the same message
- Auto-pick option 2 because integration is complete

## Option: Done for now

Pause without merge or push. **`phase: done` closes the flow lane** — branch and worktree stay as-is for you to resume or integrate later.

1. **No git actions** — no merge, push, or worktree remove
2. **Update STATE** — `phase: done` in the **worktree** when `workspace: worktree`; current checkout when `workspace: in-place`
3. **Report** — work paused; branch and worktree (if any) preserved

## Red flags — never

- Merge active flow work without setting `phase: done` afterward
- Remove worktree before merge succeeds or with dirty state
- Push or merge when verify failed and user has not acknowledged
- Update main-workspace `STATE.md` during worktree implementation — canonical STATE is in the worktree (see **Canonical STATE location**)
- Update **both** main and worktree `STATE.md` to sync during worktree work
- Copy worktree STATE onto main after merge (dead `worktree:` path, `workspace: worktree`, or merged feature's `phase: verify`)
- Overwrite unrelated active main STATE after worktree merge without session gate
- Treat clean-code-reviewer **Suggest** items as blocking merge unless user asks to fix them first
- **Sync after remote merge:** stop at pull only; skip branch delete or STATE removal
- **Sync after remote merge:** set `phase: done` but keep stale `branch` / `worktree` fields — delete `STATE.md` instead
- **Artifact cleanup:** delete flow docs or commit removal without user picking option **2**
- **Artifact cleanup:** defer artifact-removal commit to the user — agent commits and pushes on option **2**
- **Artifact cleanup:** commit removals on `<base>` instead of `chore/remove-flow-artifacts-<topic>`

## Skills that use this reference

- `flow-finish` — primary orchestrator for merge/push/done
- `flow-verify` — menu options 1, 3, 4 delegate here
