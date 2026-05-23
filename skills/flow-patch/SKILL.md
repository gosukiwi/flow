---
name: flow-patch
description: Small bounded changes with micro-spec, inline TDD, and per-task review. Invoke with /flow-patch.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-patch
---

# Flow Patch

**Triggered by:** `/flow-patch`

For **single bounded changes** — too small for a full spec doc. Implement **inline** in this session so the user sees work in real time. Review after each task via subagents.

## When to use

| Use `/flow-patch` | Redirect to `/flow-spec` |
|-------------------|--------------------------|
| ≤3 files, one concern | >3 files or multiple concerns |
| Clear success criteria | Needs design exploration |
| Bug fix with known cause | Architectural change |

## Branch rule

Same as flow-execute: feature branch; never commit on main/master without explicit approval.

## Process

### 1. Micro-spec (required)

Write inline before any code. Break work into one or more tasks with bite-sized steps:

```markdown
## Micro-spec

**Problem:** [what's wrong or needed]
**Success criteria:** [how we know it's done]
**Files:** [expected touch list]
**Out of scope:** [what we will NOT do]

### Task 1: [name]

- [ ] Step 1: Write failing test …
- [ ] Step 2: Verify RED …
- [ ] Step 3: Implement …
- [ ] Step 4: Verify GREEN …
- [ ] Step 5: Commit
```

Single-task patches are fine. Multi-step work gets one review cycle per task, not per checkbox.

Review the micro-spec critically before starting — raise concerns with the user if anything is unclear or risky.

### 2. User gate

> Micro-spec above. Approve to proceed?

**Stop until approved.**

Update `docs/flow/STATE.md`: `phase: patch`.

### 3. Inline execution (per task)

**Implement in this session** — do not dispatch an implementer subagent. User should see edits and test runs live.

Read `flow-shared/references/tdd-red-green.md` (resolve via `flow/SKILL.md` path resolver).

For each task:

1. Mark task in_progress in TodoWrite
2. Follow each step exactly; run verifications as specified
3. **Self-review** before dispatching reviewers:

   - All task requirements implemented, nothing extra (YAGNI)
   - Tests verify real behavior, not mocks
   - TDD cycle followed (watched test fail before implementing)
   - Names clear; files focused

4. Dispatch **spec compliance reviewer** — read `flow-shared/prompts/spec-reviewer.md`; paste full task text + micro-spec context. Loop: fix inline → re-review until ✅
5. Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). Dispatch **code quality reviewer** — read `flow-shared/prompts/code-quality-reviewer.md`. Loop: fix inline → re-review until ✅ Approved
6. Mark task completed in TodoWrite

**One task at a time.** Do not start Task N+1 until Task N passes both reviews.

**Fixes after ❌:** orchestrator implements fixes inline, then re-dispatches the reviewer — reviewers do not edit code.

Stop when blocked, ambiguous, or all tasks complete. Do not guess.

### 4. Verify

Run `/flow-verify` against the micro-spec.

## Redirect rules

- User scope grows during patch → stop and switch to `/flow-spec`
- Root cause unclear → `/flow-debug` first
