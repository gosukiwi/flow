---
name: flow-shared
description: Shared prompts and references for flow-* skills. Not invoked directly.
disable-model-invocation: true
metadata:
  internal: true
  flow:
    role: shared-assets
---

# Flow Shared Assets

**Do not invoke directly.** Bundles prompts and references for orchestrator skills (`flow-execute`, `flow-patch`, `flow-verify`, `flow-finish`, and others via path resolver).

## Contents

- `flow-shared/prompts/implementer.md`
- `flow-shared/prompts/spec-reviewer.md`
- `flow-shared/prompts/correctness-reviewer.md`
- `flow-shared/references/plan-execution.md`
- `flow-shared/references/tdd-red-green.md`
- `flow-shared/references/verification-gate.md`
- `flow-shared/references/verify-gate.md`
- `flow-shared/references/branch-gate.md`
- `flow-shared/references/session-gate.md`
- `flow-shared/references/worktree-setup.md`
- `flow-shared/references/root-cause-tracing.md`
- `flow-shared/references/finish-gate.md`
- `flow-shared/references/state-setup.md`
- `flow-shared/references/artifact-commit-gate.md`

## Usage

Orchestrator skills resolve this directory via the path resolver in `flow/SKILL.md`, then read prompt files before dispatching subagents.
