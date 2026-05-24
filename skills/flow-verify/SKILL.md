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

Before presenting the menu, check whether **`clean-code-reviewer`** is in your available skills.

After verification passes, present:

```
Verification complete:
- Tests: [command] → [result with counts]
- Requirements: [N/N met] or [gaps listed]

What would you like to do?

1. Merge locally — merge this branch into your base branch
2. Push the branch — I'll push; you open the PR when ready
3. Review the diff — [clean-code-reviewer | whole-change correctness review]
4. Done for now — I'll stop here; you take it from there
```

Use option 3 label **`clean-code-reviewer`** when that skill is available; otherwise **`whole-change correctness review`**.

**Option actions:**

| Option | Agent action |
|--------|--------------|
| 1 Merge locally | Confirm base branch; run merge if user confirms |
| 2 Push branch | `git push -u origin HEAD`; do not create a PR |
| 3 Review diff | See **Option 3 — whole-change review** below |
| 4 Done for now | Stop; no git actions |

Set `docs/flow/STATE.md`: `phase: done` when the user chooses option 1, 2, or 4 **after** verification passes.

### Option 3 — whole-change review

Optional extra pass before merge or push. Per-task reviews already ran during implementation; this reviews the **full branch** for cross-task quality issues.

**Do not run option 3 automatically** — only when the user chooses it.

1. Determine git range: `BASE_SHA` = merge-base with main (or first commit on branch); `HEAD_SHA` = `HEAD`
2. **If `clean-code-reviewer` is in available skills:** read and follow its `SKILL.md` on the full branch diff
3. **If not available:** dispatch a subagent using `flow-shared/prompts/whole-change-reviewer.md` (resolve via path resolver in `flow/SKILL.md`) with `BASE_SHA`, `HEAD_SHA`, and brief spec/plan/micro-spec context
4. If review returns ❌ Needs changes: fix via `/flow-patch` or inline edits → re-run verify steps 2–3 if behavior changed → re-run option 3 until ✅ Approved
5. When ✅ Approved, re-present the user menu (options 1–4). No git actions unless the user picks 1 or 2.

Flow does not run a final whole-change review unless the user chooses option 3.
