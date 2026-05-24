---
name: flow-finish
description: Merge, push, or close out flow work with STATE and worktree cleanup. Invoke with /flow-finish.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-finish
---

# Flow Finish

**Triggered by:** `/flow-finish` — also when the user requests merge/push/done outside the verify menu, or when `/flow-verify` menu options 1, 2, or 4 are chosen.

Integrate completed work and run Flow cleanup. **Read and follow** `flow-shared/references/finish-gate.md` (resolve via path resolver in `flow/SKILL.md`).

This skill is intentionally thin — `finish-gate.md` holds the checklists; this file routes intent and blocks raw git without cleanup.

## When to use

| User intent | Action |
|-------------|--------|
| "Merge back into main" / "merge locally" | Merge locally section in finish-gate |
| "Push the branch" | Push branch section |
| "Done for now" / pause without git | Done for now section |
| Chose verify menu option 1, 2, or 4 | Same sections — verify already passed |

**Do not use** for: running tests or requirements checklist (that's `/flow-verify`), or branch review (verify option 3 / clean-code-reviewer).

## Prerequisites

- Tests and checklist green — verify auto-ran from execute/patch, user ran `/flow-verify`, or user explicitly confirms
- Read `docs/flow/STATE.md` — confirm branch/topic matches current work

**Before updating STATE:** read `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`). Unrelated active STATE → session gate first.

## Process

1. Read `finish-gate.md` — prerequisites and STATE fields
2. Determine intent from user message or verify menu choice (merge / push / done for now)
3. Execute the matching finish-gate section **in order** — do not skip STATE update
4. Report what was done: git actions, worktree removed (if any), STATE `phase: done`, branch cleanup offered

## Red flags — never

- **Raw merge without finish-gate** — `git merge` alone is not sufficient for active flow work
- **Skip `phase: done`** after successful merge or push
- **Remove worktree** before merge succeeds
- **Auto-delete** feature branch without user confirmation (offer `git branch -d` instead)

## Integration

- **`/flow-verify`** — options 1, 2, 4 read this skill or `finish-gate.md` for actions
- **`worktree-setup.md`** — worktree removal rules defer to finish-gate merge path
