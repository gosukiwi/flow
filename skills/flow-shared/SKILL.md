---
name: flow-shared
description: Shared prompts and references for lite-flow skills. Not invoked directly.
disable-model-invocation: true
---

# Flow Shared

**Do not invoke directly.** Resolve this directory, then read prompts/references from here.

## Path resolver

1. `.agents/skills/flow-shared/`
2. `.cursor/skills/flow-shared/`
3. `~/.cursor/skills/flow-shared/`

## Contents

- `references/tdd-red-green.md` — TDD cycle for implement + patch
- `prompts/implementer.md` — subagent prompt for `/flow-spec` tasks
- `prompts/reviewer.md` — subagent prompt after each task (spec + patch)
