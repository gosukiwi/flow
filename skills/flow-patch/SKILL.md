---
name: flow-patch
description: Small bounded change with micro-spec, inline TDD, and per-task review. Invoke with /flow-patch.
disable-model-invocation: true
---

# Flow Patch

Single bounded change (roughly ≤3 files, one concern). Larger → `/flow-spec`.

Implement **inline** in this session. Resolve `flow-shared` via path resolver in `flow-shared/SKILL.md`.

## 1. Micro-spec

Present inline in chat:

```markdown
## Micro-spec

**Problem:**
**Success criteria:**
**Files:**
**Out of scope:**
**Testing:** RED-GREEN

### Task 1: [name]
- [ ] RED — failing test
- [ ] Verify RED
- [ ] Implement
- [ ] Verify GREEN
- [ ] Commit
```

Get the user's OK before coding.

## 2. Execute (inline)

For each task, in order:

1. Note `BASE_SHA`
2. Implement inline — follow `flow-shared/references/tdd-red-green.md`
3. Note `HEAD_SHA`
4. Review inline - follow `flow-shared/prompts/reviewer.md`
5. If issues → fix → review again → repeat until no issues
6. Only then start Task N+1

## 3. Verify

Run the project's usual checks — tests, lint, typecheck, formatters, build — whichever exist. Check each Success Criterion. Report pass/fail. Stop — user owns merge/push.
