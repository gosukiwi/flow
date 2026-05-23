---
name: flow-review
description: Final code review after verify — whole plan or patch diff. Invoke with /flow-review.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-review
---

# Flow Review

**Triggered by:** `/flow-review`

Final **code review** after `/flow-verify` passes. Not a substitute for verify (tests + spec checklist).

## Prerequisite

`/flow-verify` must have passed in this workflow. If not, run `/flow-verify` first.

Update `docs/flow/STATE.md`: `phase: review` when starting review.

## Scope

| After | Review diff | Context |
|-------|-------------|---------|
| `/flow-execute` | Feature branch base → `HEAD` | Spec + plan paths from STATE |
| `/flow-patch` | Patch commits on branch | Micro-spec from session |

Record `BASE_SHA` (branch point or pre-patch) and `HEAD_SHA` (current).

## Process

### 1. Load context

From `docs/flow/STATE.md` and session: spec, plan, or micro-spec; branch name.

### 2. Dispatch final review subagent

Read `flow-shared/prompts/final-reviewer.md`. Resolve prompts via path resolver in `flow/SKILL.md`.

Paste full context into the subagent prompt. Subagent reads the git diff — do not skip diff inspection.

### 3. Report

Present subagent output to the user: **Block / Fix / Suggest** sections + summary line.

### 4. User menu

Do not auto-merge or claim shipped. Ask the user:

```
Review complete — N block(s), M fix(es), K suggest(s).

What next?
1. Address findings — /flow-patch with TDD per item (or batch)
2. Re-run /flow-review after fixes
3. Proceed to merge / PR (user handles git)
4. Pause — accept as-is for now
```

**Addressing findings:** Use `/flow-patch` with a micro-spec per fix (TDD required). Then `/flow-verify` → `/flow-review` again if user wants.

Set `docs/flow/STATE.md`: `phase: done` only when the user explicitly chooses proceed or pause (work accepted).

## Optional enhancements

After `/flow-review`, you may run **project** code-review skills if installed (e.g. `clean-code-reviewer`). Flow’s review is the baseline; project skills add extra checks. They do not replace `/flow-verify` or `/flow-review` unless the user asks.

## Red flags — never

- Skip review because per-task reviews already ran (this is whole-change review)
- Replace `/flow-verify` with review
- Fix Block items inline without `/flow-patch` + TDD
- Auto-merge without user choice
