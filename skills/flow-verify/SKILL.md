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

Evidence before assertions. **Read and follow** `flow-shared/references/verification-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Tests + spec checklist — not a substitute for per-task reviews during `/flow-execute` or `/flow-patch`.

## Process

1. Read `flow-shared/references/verification-gate.md` (resolve via path resolver in `flow/SKILL.md`) — follow the gate for all completion claims
2. Run the **full** test suite (or project-standard equivalent); read complete output
3. Requirements checklist against spec, plan, or micro-spec — verify each requirement line by line:

| Requirement | Evidence |
|-------------|----------|
| ... | file/test/command reference |

**Structure specs:** When the spec requires mirrored or matching paths (or documents explicit exceptions), verify segment-for-segment alignment between paired trees per that rule (e.g. `src/` ↔ `tests/`, or colocated `Foo.tsx` ↔ `Foo.test.tsx`). List any path pairs that diverge. Do not mark verify complete if Success Criteria claim mirror but trees differ.

List gaps explicitly. Do not claim complete with open gaps.

4. Report only after steps 2–3. If anything fails, do **not** claim done. Route to `/flow-debug` or `/flow-patch`.

Update `docs/flow/STATE.md`: `phase: verify` when starting.

## User menu

After verification passes, present:

```
Verification complete:
- Tests: [command] → [result with counts]
- Requirements: [N/N met] or [gaps listed]

What would you like to do?

1. Merge locally — merge this branch into your base branch
2. Push the branch — I'll push; you open the PR when ready
3. Review the diff — on your own, or with another skill
4. Done for now — I'll stop here; you take it from there
```

**Option actions:**

| Option | Agent action |
|--------|--------------|
| 1 Merge locally | Confirm base branch; run merge if user confirms |
| 2 Push branch | `git push -u origin HEAD`; do not create a PR |
| 3 Review diff | Show diff or suggest project review skills; no git actions unless asked |
| 4 Done for now | Stop; no git actions |

Set `docs/flow/STATE.md`: `phase: done` when the user chooses any option.

Flow does not run a final whole-change review. Per-task reviews already ran during implementation. Option 3 is for an extra pass before merge or push — manual review or any project skill (e.g. `clean-code-reviewer`).
