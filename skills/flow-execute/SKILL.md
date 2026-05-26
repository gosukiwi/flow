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

Resume or start plan execution when a plan already exists. **Subagents only** — never implement tasks inline in the orchestrator session.

## When to use

- User invokes `/flow-execute` with an existing plan (router: "Plan already written?")
- Resuming after interruption with `STATE.md` `phase: execute`
- **Not** the only entry — `/flow-spec` auto-continues into plan-execution **step 1** (branch gate) after plan self-review; user invokes `/flow-execute` after branch setup

## Prerequisites

- Approved spec at `docs/flow/specs/...`
- Plan at `docs/flow/plans/...` (self-reviewed per flow-spec)
- Resolve `flow-shared` via path resolver in `flow/SKILL.md`

## Process

**Read and follow** `flow-shared/references/plan-execution.md` (resolve via path resolver in `flow/SKILL.md`) — session/workspace gate through verify.

When the user invokes this skill: after branch/workspace setup (if needed), **proceed to step 2** — do not stop with another `/flow-execute` handoff. When resuming with `branch` already in `STATE.md` for this topic, skip the gate and begin at step 2.

## Red flags — never

- Skip `plan-execution.md` and implement inline
- **Inline Task 1** — subagents only; dispatch implementer per plan-execution step 3
- **Stop with `/flow-execute` handoff** when the user already invoked this skill and branch is ready — begin at plan-execution step 2
- **Treat a plan's last "Final verification" / full-suite task as substitute for verify menu** — see plan-execution §4
- **End with uncommitted changes** on the feature branch without commits or `/flow-patch`
