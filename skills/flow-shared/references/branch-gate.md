# Branch Gate

## Hard gate

```
NO IMPLEMENTATION WORK UNTIL BRANCH IS CONFIRMED
```

Proposing a branch name is not confirmation. **Stop and wait for the user's reply** before any of the following:

- `git checkout -b`, `git switch -c`, or switching branches
- Dispatching implementer subagents or writing production code
- Starting Task 1 (or any task that commits)
- Running TDD steps toward a commit

Reading plans, specs, or micro-specs to prepare is fine on `main`/`master`. Implementation is not.

## Rules

- All implementation commits go on a **feature branch** — never on `main`/`master` without explicit user approval.
- **Before creating or switching branches:** stop and ask the user.
  - Propose a branch name (from spec/plan topic, patch scope, or `docs/flow/STATE.md`)
  - **Wait for confirmation or a user-provided branch name**
  - If already on an acceptable feature branch, confirm continuing on it before the first commit
- **Never** run `git checkout -b`, `git switch -c`, or switch branches without user approval in this session.
- Record the confirmed branch in `docs/flow/STATE.md`.

## User gate message

When on `main`/`master` (or branch unclear), send **only** the branch question — do not combine with starting work:

> We're on `main`. Propose branch: `feature/<topic>`. Confirm this name or tell me another before I start Task 1.

**Stop until the user responds.**

Forbidden in the same message: "Starting Task 1…", dispatching subagents, editing files, or creating the branch.
