IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-execute` loaded. User invoked execute after `/flow-spec` handoff.

On `main`, user confirmed option 1 — branch here, `feature/email-validation`. You created and switched to the branch; updated STATE (`workspace: in-place`, `phase: execute`).

Untracked files exist (written during spec on main checkout):

- `docs/flow/specs/2026-05-25-email-validation.md`
- `docs/flow/plans/2026-05-25-email-validation.md`

You're composing your **next message** while loading the plan. Draft so far:

> Branch ready. Starting Task 1 — dispatching implementer for the failing test step.

You have **not** sent it yet. No artifact commit has run.

Do you:
A) Proceed as drafted — Task 1 first; artifacts can be committed later
B) `git add` spec and plan paths, commit on `feature/email-validation` with message `docs(flow): add artifacts for email-validation`, then load plan and dispatch Task 1 — never commit artifacts on `main`
C) Commit artifacts on `main` before switching branch — user already approved the spec

What do you do?
