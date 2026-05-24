# Worktree Setup

Procedural steps for creating an isolated git worktree after the user confirms **option 2 (worktree)** in `branch-gate.md`. Do not run these steps until branch name and workspace option are confirmed.

## Directory selection

Follow this priority order:

1. **Existing directories** — check in order:
   - `.worktrees/` (preferred, hidden)
   - `worktrees/`
   If both exist, use `.worktrees/`.
2. **Project doc preference** — check `CLAUDE.md`, `AGENTS.md`, or README for a worktree directory preference.
3. **Ask user** if none found:

   > No worktree directory found. Where should I create worktrees?
   >
   > 1. `.worktrees/` (project-local, hidden)
   > 2. `~/.config/flow/worktrees/<project-name>/` (global location)
   >
   > Which would you prefer?

## Safety verification (project-local only)

For `.worktrees/` or `worktrees/` inside the repo:

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**

1. Add the directory to `.gitignore`
2. **Get user approval** before committing the `.gitignore` change
3. Commit the change
4. Then create the worktree

**Why critical:** Prevents accidentally tracking worktree contents in the repository.

Global directories (`~/.config/flow/worktrees/...`) skip ignore verification.

## Creation steps

### 1. Detect project name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Determine path

```bash
# Project-local
path=".worktrees/<branch-slug>"   # or worktrees/<branch-slug>

# Global
path="~/.config/flow/worktrees/$project/<branch-slug>"
```

Use a short slug derived from the branch name (e.g. `feature/user-auth` → `user-auth`).

### 3. Create worktree

Run from the repository root:

```bash
git worktree add "$path" -b "$BRANCH_NAME"
```

If the branch already exists remotely or locally, omit `-b` and check out the existing branch instead (only when user explicitly requested that branch).

### 4. Run project setup

Auto-detect and run appropriate setup in the worktree:

```bash
cd "$path"

# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 5. Baseline tests (optional)

**Default:** skip baseline tests — deps setup only. Mention to the user they can ask to run tests before Task 1.

If the user requests a baseline or the project has known flaky setup:

```bash
# Examples — use project-appropriate command
npm test
cargo test
pytest
go test ./...
```

If tests fail, report failures and ask whether to proceed or investigate. Do not start implementation until the user responds.

### 6. Record in STATE.md

In the **worktree** (not the main workspace), update `docs/flow/STATE.md`:

```markdown
workspace: worktree
worktree: .worktrees/<branch-slug>
branch: feature/topic
```

### 7. Operate in worktree

All implementation, STATE updates, commits, and `/flow-verify` for this session happen in the worktree path. Do not edit files in the main workspace for this feature unless the user explicitly switches back.

Report when ready:

```
Worktree ready at <full-path>
Branch: <branch-name>
Ready to implement <feature-name>
```

## Quick reference

| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check project docs → ask user |
| Directory not ignored | Add to `.gitignore` + commit (with user approval) |
| User says "don't switch my branch" | Worktree only — skip in-place option |
| Already inside a worktree | Confirm branch for this worktree; do not nest |

## Red flags — never

- Create worktree without user confirming workspace option in branch gate
- Skip ignore verification for project-local directories
- Proceed with failing baseline tests without asking (when baseline was requested)
- Update STATE.md in the main workspace when working in a worktree **during implementation** — **except** `/flow-finish` merge locally (finish-gate step 5 after successful merge + worktree remove)
- Run `git worktree add` in the same message as the workspace gate question

## Cleanup

Worktree removal is handled by `/flow-finish` (merge locally) via `finish-gate.md`. See `flow-finish/SKILL.md` and `flow-verify/SKILL.md` option 1.
