# Artifact Commit Gate

Runs after branch/workspace confirmation — **before** Task 1 or any TDD step. Invoked from **`/flow-spec`** auto-continue and **`/flow-execute`** resume via `plan-execution.md` step 2, and from **`/flow-patch`** step 4. Resolve via path resolver in `flow/SKILL.md`.

Specs, plans, brainstorms, and patch micro-specs under `docs/flow/` are **tracked** artifacts (`state-setup.md`). `STATE.md` stays local/gitignored.

## Hard gate

```
NO TASK 1 OR TDD UNTIL FLOW ARTIFACTS ARE COMMITTED ON THE CONFIRMED BRANCH
```

**Forbidden:** Committing flow artifacts on `main`/`master` without explicit user approval. **Forbidden:** Deferring artifact commit to the user ("commit when ready").

## When to run

| Situation | Action |
|-----------|--------|
| After branch gate confirmation (execute or patch) | Run this gate before loading plan / Task 1 |
| Resume with `branch` in STATE, artifacts already committed on that branch | Skip |
| Resume with `branch` in STATE, artifacts still uncommitted on disk | Run gate (no branch gate skip for uncommitted artifacts) |
| No artifact files exist on disk | Skip — nothing to commit |

## Collect paths

From `docs/flow/STATE.md` and files written this session, collect every path that **exists on disk**:

| STATE field | Path |
|-------------|------|
| `brainstorm:` | `docs/flow/brainstorms/...` |
| `spec:` | `docs/flow/specs/...` |
| `plan:` | `docs/flow/plans/...` |
| `patch:` | `docs/flow/patches/...` (patch micro-spec file) |

Deduplicate. Patch-only lanes may have only `patch:`.

## Worktree sync (required when `workspace: worktree`)

Artifact files are often written on the **main workspace** checkout during `/flow-spec` or `/flow-brainstorm` before the worktree exists.

Before commit, in the **worktree** (canonical workspace per `worktree-setup.md`):

1. For each collected path that exists in the main workspace but not in the worktree → copy file into the same relative path in the worktree
2. Commit from the worktree only — all subsequent work stays in the worktree

Do not commit artifacts from the main workspace when `workspace: worktree`.

## Commit (agent — on confirmed feature branch only)

```bash
git add <each path that exists>
git commit -m "docs(flow): add artifacts for <topic>"
```

Replace `<topic>` with spec/plan filename slug, patch topic, or branch slug.

If `git status` shows all artifact paths already committed on this branch → skip commit; proceed to Task 1.

## After commit

Proceed to next step (`plan-execution` load plan / patch inline execution). Do not combine artifact commit report with Task 1 dispatch in a rationalization that skips the commit step.

## Red flags — never

- Start Task 1, TodoWrite for tasks, TDD, or subagent dispatch with uncommitted artifact files on the feature branch
- Commit artifacts on `main`/`master` during execute or patch
- Tell the user to commit artifacts manually
- Skip worktree copy — worktree branch missing spec/plan/brainstorm/patch files
- Gitignore all of `docs/flow/` — only `STATE.md` is local

## Skills that use this reference

- `flow-spec` — auto-continue via `plan-execution.md` step 2 (after branch confirm)
- `flow-execute` — resume via `plan-execution.md` step 2
- `flow-patch` — step 4 before inline execution
