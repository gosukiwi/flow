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

**Read and follow** `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Session gate before any STATE write; branch and workspace confirmation is a **blocking user gate** — same weight as micro-spec approval.

## Process

### 1. Session and workspace gate (required)

Follow `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Session gate first: if STATE shows active unrelated work, stop before any STATE write. Then apply branch-gate detection matrix. **Stop until the user confirms branch name and workspace option (when offered).**

Do **not** in the same turn: create/switch branches, create worktrees, create TodoWrite for tasks, dispatch implementers, or start Task 1.

After confirmation:

- **Option 1 (in-place):** create or switch to the branch in the current workspace; record `workspace: in-place` in `docs/flow/STATE.md`
- **Option 2 (worktree):** follow `flow-shared/references/worktree-setup.md`; all subsequent work happens in the worktree

Then proceed to step 2.

### 2. Load plan

Read plan once. Extract every task with full text. Create TodoWrite per task.

Raise concerns to user before starting if plan has critical gaps.

### 3. Per task (strictly serial)

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

**Before each dispatch:** Read prompt templates (resolve via path resolver in `flow/SKILL.md`):

- `flow-shared/prompts/implementer.md`
- `flow-shared/prompts/spec-reviewer.md`
- `flow-shared/prompts/code-quality-reviewer.md`

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

### 4. After all tasks

Run `/flow-verify` against spec + plan.

Update `docs/flow/STATE.md`: `phase: verify` when starting verify. User menu and `phase: done` are handled by `/flow-verify`.

## Red flags — never

- Skip subagents and implement inline
- Skip spec or code quality review
- **Propose a branch/workspace and start Task 1 in the same turn** — workspace gate requires waiting for user reply
- **Create a worktree without user confirming option 2**
- **Start Task N+1 while Task N reviews are incomplete** (most common violation)
- Dispatch parallel subagents across tasks (different tasks or roles at once)
- Make subagent read the plan file — provide full task text in prompts
- Move to next task after implementer DONE but before both reviews ✅

## Continuous execution

Do not pause between **completed** tasks for progress check-ins.

**Continuous ≠ parallel.** Finish the full gate for Task N before dispatching anything for Task N+1.

**Continuous ≠ skip workspace gate.** Branch and workspace confirmation happens once up front and always blocks until the user responds.

Stop only when: blocked, ambiguous, or all tasks complete.
