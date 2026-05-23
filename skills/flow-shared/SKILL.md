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

**Do not invoke directly.** This skill bundles prompts and references used by `flow-execute` and `flow-patch`.

## Contents

- `flow-shared/prompts/implementer.md`
- `flow-shared/prompts/spec-reviewer.md`
- `flow-shared/prompts/code-quality-reviewer.md`
- `flow-shared/references/tdd-red-green.md`
- `flow-shared/references/verification-gate.md`

## Usage

Orchestrator skills resolve this directory via the path resolver in `flow/SKILL.md`, then read prompt files before dispatching subagents.
