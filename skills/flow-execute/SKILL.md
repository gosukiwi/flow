---
name: flow-execute
description: Execute an approved plan with subagents, TDD, and two-stage review. Invoke with /flow-execute when resuming or plan already exists.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-execute
---

# Flow Execute

**Triggered by:** `/flow-execute`

Run an approved plan when spec and plan artifacts exist. **Subagents only** — never implement tasks inline in the orchestrator session.

## When to use

- User invokes `/flow-execute` after `/flow-spec` handoff (`phase: planned`)
- Plan already written at `docs/flow/plans/...`
- Resuming after interruption with `STATE.md` `phase: execute` and partial task progress

## Prerequisites

- Approved spec at `docs/flow/specs/...`
- Plan at `docs/flow/plans/...` (self-reviewed per flow-spec)
- Resolve `flow-shared` via path resolver in `flow/SKILL.md`

## Process

**Read and follow** `flow-shared/references/plan-execution.md` (resolve via path resolver in `flow/SKILL.md`) — session/workspace gate through verify.

When the user invokes this skill: run branch gate (if needed) → artifact commit → load plan → tasks → verify. **Do not stop** mid-lane for another `/flow-execute` handoff.

When resuming with `branch` already in `STATE.md` for this topic: skip branch gate; run artifact commit if artifacts are still uncommitted; then continue from the next task.

## Red flags — never

- Skip `plan-execution.md` and implement inline
- **Inline Task 1** — subagents only; dispatch implementer per plan-execution step 4
- **Stop with `/flow-execute` handoff** when the user already invoked this skill
- **Skip artifact commit** before Task 1 when flow artifacts exist uncommitted on the branch
- **Treat a plan's last "Final verification" / full-suite task as substitute for verify menu** — see plan-execution §5
- **End with uncommitted changes** on the feature branch without commits or `/flow-patch`
