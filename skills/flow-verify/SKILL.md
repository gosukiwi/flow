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

Evidence before assertions. Read `flow-shared/references/verification-gate.md`.

**Verify is not code review** — tests + spec checklist only. Code review is `/flow-review`.

## Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

## Process

### 1. Identify proof commands

Determine what commands prove: tests pass, build succeeds, spec requirements met.

### 2. Run verification (fresh, this session)

Run the **full** test suite (or project-standard equivalent). Read complete output.

### 3. Requirements checklist

Against spec, plan, or micro-spec — verify each requirement line by line:

| Requirement | Evidence |
|-------------|----------|
| ... | file/test/command reference |

List gaps explicitly. Do not claim complete with open gaps.

### 4. Report

Only after steps 2–3:

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
