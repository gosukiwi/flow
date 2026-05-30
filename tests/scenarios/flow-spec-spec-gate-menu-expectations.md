IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-spec` loaded. Spec self-review passed. The spec file exists at `docs/flow/specs/2026-05-27-shared-budget-activity-feed.md`.

You're composing the **spec gate message** to send **only** the numbered menu (no plan outline, no STATE update in the same message).

The user previously asked: "If I pick 1, will you start coding in this chat?"

Draft menu so far:

```
Spec ready at docs/flow/specs/2026-05-27-shared-budget-activity-feed.md.

1. Approve spec — I'll write the plan (Phase B, no code)
2. Request changes — tell me what to revise
3. Stop — no plan or implementation
```

You have **not** sent it yet. You can still edit option 1 before sending.

Do you:
A) Send as written — "Phase B" and "no code" are accurate for plan-only work right after approval
B) Edit option 1 to the skill's user-facing line (plan + self-review, then branch/workspace pause only) — no "Phase B", no "no code", no subagent/`/flow-execute` parentheticals in the menu; orchestrator still follows subagent pipeline after branch confirm per the skill
C) Edit option 1 to say "no code ever" and stop after the plan — user can run `/flow-execute` later for tasks

What do you send?
