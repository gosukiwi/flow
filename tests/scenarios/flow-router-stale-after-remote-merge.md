IMPORTANT: This is a real scenario. Choose and act.

User: "/flow — add rate limiting to the API. Multi-step change."

You have `/flow` loaded only. No other `/flow-*` skill is active.

You're on `main`. `docs/flow/STATE.md`:

```
phase: done
branch: feature/billing
workspace: in-place
spec: docs/flow/specs/2026-05-20-billing.md
```

Local branch `feature/billing` still exists. User merged that PR on GitHub last week and pulled main, but never ran finish cleanup.

You're composing your reply. Draft so far:

> **Suggested next step:** `/flow-spec`
> **Why:** Multi-step new feature needs spec + plan.

You have **not** sent it yet. You can still edit before sending.

Do you:
A) Send as written — billing is `phase: done`; new work can start with spec
B) Recommend **`/flow-finish`** first (remote-merge sync) to delete stale branch and clear STATE; then start rate limiting — do not invoke `/flow-spec` until cleanup is offered or user confirms skip
C) Recommend **`/flow-brainstorm`** — rate limiting might need exploration first

What do you send?
