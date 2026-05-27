# Branch Gate (Workspace Gate)

Also covers **in-place branch** vs **git worktree** selection. Worktree creation steps live in `worktree-setup.md`. **Read `session-gate.md` before any STATE write** when unrelated work may conflict (resolve via path resolver in `flow/SKILL.md`).

## Hard gate

```
NO IMPLEMENTATION WORK UNTIL BRANCH AND WORKSPACE ARE CONFIRMED
```

Proposing a branch name or workspace option is not confirmation. **Stop and wait for the user's reply** before any of the following:

- `git checkout -b`, `git switch -c`, or switching branches
- `git worktree add` or other worktree creation
- Dispatching implementer subagents or writing production code
- Starting Task 1 (or any task that commits)
- Running TDD steps toward a commit

Reading plans, specs, or micro-specs to prepare is fine on `main`/`master`. Implementation is not.

## Detection matrix

Before any git mutation, detect context and choose the gate message:

| Context | Agent behavior |
|---------|----------------|
| On `main`/`master` | Offer **1) branch here** or **2) worktree** (keeps `main` checked out here). Stop until user picks. |
| On feature branch, request matches `STATE.md` / same topic | Confirm continuing on this branch. **Do not** suggest worktree. |
| On feature branch, unrelated new work, **active** occupied `phase` | Offer **1) switch branch here** (warn: disrupts WIP) or **2) worktree** (recommended). For `/flow-patch`, run **session gate first** — do not skip to this menu while STATE is occupied. Stop until confirmed. |
| `/flow-patch` on feature branch, `phase: done` or no STATE | Continue on **current branch** — use **Continuing on current feature branch** (patch). **Do not** offer switch/worktree 1/2 menu. User may request isolation (`worktree`, `new branch`, branch name). |
| Already inside a worktree (`git worktree list` shows cwd) | Confirm branch for *this* worktree; proceed in cwd. |
| User says "use a worktree" / "don't switch my branch" | Worktree only — confirm branch name, then follow `worktree-setup.md`. |

**Same branch, two terminals:** Git allows only one worktree per branch. Do not suggest a worktree to isolate two agents on the same branch in the same checkout. If `STATE.md` shows active work and intent is ambiguous, ask one clarifying question.

## Rules

- All implementation commits go on a **feature branch** — never on `main`/`master` without explicit user approval.
- **Before creating or switching branches or worktrees:** stop and ask the user.
  - Propose a branch name (from spec/plan topic, patch scope, or `docs/flow/STATE.md`)
  - When on `main`/`master`, or unrelated work on a feature branch with **active** occupied `phase` (execute/spec/plan path), offer workspace option (in-place vs worktree)
  - **`/flow-patch` on a feature branch** with `phase: done` or no STATE: default in-place on current branch; offer isolation only when the user asks
  - **Wait for confirmation or a user-provided branch name and option**
  - If already on an acceptable feature branch with matching work, confirm continuing on it before the first commit
- **Never** run `git checkout -b`, `git switch -c`, switch branches, or `git worktree add` without user approval in this session.
- Record the confirmed branch and workspace in `docs/flow/STATE.md`:

```markdown
workspace: in-place | worktree
worktree: .worktrees/feature-topic   # when workspace: worktree
branch: feature/topic
```

## User gate messages

Send **only** the gate question — do not combine with starting work.

### On `main`/`master`

> We're on `main`. Before Task 1:
> 1. **Branch here** — `feature/<topic>` (switches this workspace off main)
> 2. **Worktree** — new branch at `.worktrees/<topic>/` (main stays on main here)
>
> Confirm branch name and option (1 or 2).

### Unrelated work on existing feature branch (active lane)

Use only when `STATE.md` has an **occupied** `phase` (not `done`) and the new work is unrelated. **Not for `/flow-patch` after `phase: done`** — use patch continuing gate below.

> You're on `feature/<current>` with active flow work (`phase: <phase>`). This work is unrelated.
> 1. **Switch branch here** — disrupts WIP checked out in this workspace
> 2. **Worktree** — `<proposed-branch>` at `.worktrees/<slug>/` (recommended)
>
> Confirm branch name and option (1 or 2).

### Continuing on current feature branch

> On `feature/<topic>` — continue here for this work? Confirm before the first commit.

### Continuing on current feature branch (`/flow-patch`)

Use when on a **feature branch** (not `main`), prior lane is **`phase: done`** or STATE is absent, and micro-spec is approved. Default: patch commits stay on the current branch.

> Patch will run on `feature/<current>` (prior flow work on this branch is done). Continue here?
>
> Say **continue** / **yes** / **same branch** / **work here** to confirm. Say **worktree** or **new branch** if you want isolation.

**Do not** map **work here** to option 1 (switch branch) from the unrelated 1/2 menu — that menu must not be sent for this patch context.

**Stop until the user responds** (or explicit opt-in to isolation).

Forbidden in the same message: proposing `feature/<new-topic>` switch/worktree 1/2 menu for finished-lane patch work.

Forbidden in the same message: "Starting Task 1…", dispatching subagents, editing production code, creating branches, or creating worktrees.

## After confirmation

Branch and workspace setup only in this turn — **not** Task 1, TodoWrite, subagents, production code, or artifact commit.

### Option 1 — in-place

Create or switch to the branch in the current workspace. Set `workspace: in-place` in `docs/flow/STATE.md`.

### Option 2 — worktree

Follow `flow-shared/references/worktree-setup.md` (resolve via path resolver in `flow/SKILL.md`). All subsequent work happens in the worktree.

### Then continue (execute or patch only)

- **From `/flow-spec` auto-continue or `/flow-execute`:** proceed to `plan-execution.md` step 2 after setup — no `/flow-execute` handoff, no Task 1 in the branch-setup turn
- **From `/flow-patch`:** proceed to save micro-spec + artifact commit (patch §4), then inline execution

## Red flags — never

- Propose branch/workspace and start Task 1 in the same turn
- Create a worktree without user confirming option 2
- Switch branches for unrelated work when user chose worktree
- Suggest worktree when continuing matched work on the current branch
- Mix unrelated commits onto a branch with **active** occupied `phase` for a different topic (not when prior lane is `phase: done` and `/flow-patch` continues on the same branch)
- Send execute-style switch/worktree 1/2 menu for `/flow-patch` on a feature branch when `phase: done` or no STATE
- Treat **work here** / **same branch** as "switch to proposed new branch" during patch continuing gate
