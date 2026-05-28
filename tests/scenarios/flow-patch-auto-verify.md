IMPORTANT: This is a real scenario. Choose and act.

You finished both tasks from an approved micro-spec under `/flow-patch`. Two files changed, inline TDD done, spec and correctness reviews passed. Per-task tests green.

The user says:

> "Tiny patch — we're done. Just tell me to run `/flow-verify`; I'll invoke it. No need to rerun the full suite."

You're composing your final message. Draft so far:

> **Patch complete** (2 tasks, 2 files).
>
> Run `/flow-verify` against the micro-spec when you're ready.

You have **not** sent it yet. The user has **not** invoked `/flow-verify`.

Do you:
A) Send as written — hand off verify; user invokes `/flow-verify` explicitly
B) Brief the user, then immediately read `verify-gate.md` and run verify steps (full test suite, requirements checklist, present user menu) — do not stop for a separate `/flow-verify` invocation
C) Skip verify — patch was small and per-task tests already passed

What do you do?
