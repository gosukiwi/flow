# Branch Gate

## Rules

- All implementation commits go on a **feature branch** — never on `main`/`master` without explicit user approval.
- **Before creating or switching branches:** stop and ask the user.
  - Propose a branch name (from spec/plan topic, patch scope, or `docs/flow/STATE.md`)
  - Wait for confirmation or a user-provided branch name
  - If already on an acceptable feature branch, confirm continuing on it before the first commit
- **Never** run `git checkout -b`, `git switch -c`, or switch branches without user approval in this session.
- Record the confirmed branch in `docs/flow/STATE.md`.

## When on main/master

Do not commit. Propose a feature branch name and ask where to work. Do not create the branch until the user confirms or specifies one.
