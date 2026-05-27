---
name: flow-execute
description: Execute an approved plan with subagents, TDD, and two-stage review. Invoke with /flow-execute to resume or when plan exists without an active spec session.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-execute
---

# Flow Execute

**Triggered by:** `/flow-execute`

Resume or cold-start plan execution. **Subagents only** — never implement tasks inline in the orchestrator session.

## When to use

- Session ended with `phase: planned` or `phase: execute` (branch unset or partial progress)
- Plan exists at `docs/flow/plans/...` without an active `/flow-spec` session

**Not required** after `/flow-spec` on the happy path — spec auto-continues through branch gate and verify.

## Process

**Read and follow** `flow-shared/references/plan-execution.md` (resolve via path resolver in `flow/SKILL.md`).

Skip branch gate when STATE already has confirmed `branch` for this topic; still run artifact commit if artifacts are uncommitted.

## Red flags — never

- Skip `plan-execution.md` and implement inline
- **Stop with `/flow-execute` handoff** when this skill is already active and branch is ready
