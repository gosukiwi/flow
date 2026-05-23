---
name: flow-execute
description: Execute an approved plan with subagents, TDD, and two-stage review. Invoke with /flow-execute.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-execute
---

# Flow Execute

**Triggered by:** `/flow-execute`

Execute an approved plan using **subagents only** — never implement tasks inline in the orchestrator session.

## Prerequisites

- Approved spec at `docs/flow/specs/...`
- Plan at `docs/flow/plans/...` (self-reviewed per flow-spec)
- Resolve `flow-shared` via path resolver in `flow/SKILL.md`

## Branch rule

- Work on a **feature branch** (create one if needed)
- **Never commit on `main`/`master`** without explicit user approval
- Git worktrees: out of scope for v1 (may be added later)

## Process

### 1. Load plan

Read plan once. Extract every task with full text. Create TodoWrite per task.

Raise concerns to user before starting if plan has critical gaps.

### 2. Per task (strictly serial)

**One task at a time. One subagent role at a time.**

Do not dispatch Task N+1 — implementer, reviewer, or any role — while Task N is still in progress.

```
Task N gate (all steps required, in order):

  [ ] 1. Implementer subagent        → DONE
  [ ] 2. Spec compliance reviewer    → ✅
  [ ] 3. Code quality reviewer       → ✅ Approved
  [ ] 4. Mark Task N complete in TodoWrite

Only then start Task N+1 step 1.
```

**Forbidden:** Starting Task N+1 while Task N is still in spec or code quality review — even if the implementer already finished. Reviews are blocking gates, not background work.

**Before each dispatch:** Read prompt templates from `flow-shared/prompts/`:

- `implementer.md`
- `spec-reviewer.md`
- `code-quality-reviewer.md`

Paste **full task text** into subagent prompts. Subagents must not read plan files themselves.

Track the **current task** explicitly in your head and in TodoWrite (`in_progress` = at most one task).

#### Step 1 — Implementer

Dispatch with implementer prompt. Handle status:

| Status | Action |
|--------|--------|
| DONE | Proceed to step 2 (spec review) — do not start next task |
| DONE_WITH_CONCERNS | Read concerns; fix or proceed to step 2 |
| NEEDS_CONTEXT | Provide context; re-dispatch implementer |
| BLOCKED | Escalate to user |

#### Step 2 — Spec compliance review

Dispatch spec reviewer. Loop: implementer fixes → re-review until ✅.

**Do not start step 3 or the next task until spec review is ✅.**

#### Step 3 — Code quality review

Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). Dispatch code quality reviewer.

**Do not mark the task complete or start the next task until reviewer returns ✅ Approved.**

Reviewer returns **Block / Fix / Suggest**. Loop until ✅ Approved:

- **Block or Fix present:** implementer (subagent) fixes all Block and Fix items → re-review
- **Suggest only:** ✅ Approved — Suggest is advisory, do not block

Reviewers do not edit code.

#### Step 4 — Complete task

Mark Task N completed in TodoWrite. **Then** begin Task N+1 step 1.

### 3. After all tasks

Run `/flow-verify` against spec + plan.

Update `docs/flow/STATE.md`: `phase: verify` when starting verify. User menu and `phase: done` are handled by `/flow-verify`.

## Red flags — never

- Skip subagents and implement inline
- Skip spec or code quality review
- **Start Task N+1 while Task N reviews are incomplete** (most common violation)
- Dispatch parallel subagents across tasks (different tasks or roles at once)
- Make subagent read the plan file — provide full task text in prompts
- Move to next task after implementer DONE but before both reviews ✅

## Continuous execution

Do not pause between **completed** tasks for progress check-ins.

**Continuous ≠ parallel.** Finish the full gate for Task N before dispatching anything for Task N+1.

Stop only when: blocked, ambiguous, or all tasks complete.
