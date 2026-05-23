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

### 2. Per task (serial — one implementer at a time)

```
Implementer subagent
  → Spec compliance reviewer subagent
  → Code quality reviewer subagent (only after spec ✅)
  → Mark task complete
```

**Before each dispatch:** Read prompt templates from `flow-shared/prompts/`:

- `implementer.md`
- `spec-reviewer.md`
- `code-quality-reviewer.md`

Paste **full task text** into subagent prompts. Subagents must not read plan files themselves.

#### Implementer

Dispatch with implementer prompt. Handle status:

| Status | Action |
|--------|--------|
| DONE | Proceed to spec review |
| DONE_WITH_CONCERNS | Read concerns; fix or proceed |
| NEEDS_CONTEXT | Provide context; re-dispatch |
| BLOCKED | Escalate to user |

#### Spec compliance review

Dispatch spec reviewer. Loop: implementer fixes → re-review until ✅.

**Wrong order is forbidden:** do not run code quality review before spec compliance ✅.

#### Code quality review

Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). Dispatch code quality reviewer. Loop until ✅ Approved.

### 3. After all tasks

Run `/flow-verify` against spec + plan.

Update `docs/flow/STATE.md`: `phase: verify`.

## Red flags — never

- Skip subagents and implement inline
- Skip spec or code quality review
- Parallel implementer subagents (merge conflicts)
- Make subagent read the plan file (provide full text)
- Move to next task with open review issues
- Commit on main/master without approval

## Continuous execution

Do not pause between tasks for progress check-ins. Stop only when: blocked, ambiguous, or all tasks complete.
