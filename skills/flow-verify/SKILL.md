---
name: flow-verify
description: Final verification gate before claiming work complete. Invoke with /flow-verify.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-verify
---

# Flow Verify

**Triggered by:** `/flow-verify`

Evidence before assertions. **Read and follow** `flow-shared/references/verification-gate.md` (resolve path via `flow/SKILL.md` path resolver).

**Verify is not code review** — tests + spec checklist only. Code review is `/flow-review`.

## Process

1. Read `verification-gate.md` — follow the gate for all completion claims
2. Run the **full** test suite (or project-standard equivalent); read complete output
3. Requirements checklist against spec, plan, or micro-spec — verify each requirement line by line:

| Requirement | Evidence |
|-------------|----------|
| ... | file/test/command reference |

List gaps explicitly. Do not claim complete with open gaps.

4. Report only after steps 2–3:

```
Verification complete:
- Tests: [command] → [result with counts]
- Requirements: [N/N met] or [gaps listed]
- Ready for: /flow-review
```

If anything fails, do **not** claim done. Route to `/flow-debug` or `/flow-patch`.

Update `docs/flow/STATE.md`: `phase: verify` when starting; after pass, hand off to `/flow-review` (do not set `phase: done` here).

## Handoff

> Verification complete. Run `/flow-review` for final code review.
