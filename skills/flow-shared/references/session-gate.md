# Session Gate

Read before **any** write to `docs/flow/STATE.md`. Resolves concurrent-session conflicts on the same checkout. Git/worktree mutations defer to `branch-gate.md`; worktree creation to `worktree-setup.md` (resolve via path resolver in `flow/SKILL.md`).

## Hard gate

```
NO STATE.md WRITE UNTIL SESSION IS CONFIRMED
```

Proposing resume or worktree is not confirmation. **Stop and wait for the user's reply** before:

- Updating `docs/flow/STATE.md` (phase, paths, branch, workspace)
- Saving brainstorm briefs, specs, or plans that imply a new flow lane when STATE is occupied by unrelated work

Reading files, exploring, clarifying, and writing artifacts for **same-topic** handoffs is fine.

## Active phases

Treat STATE as **occupied** when `phase` is:

`brainstorm`, `spec`, `execute`, `patch`, `debug`, `verify`

`phase: done` or missing STATE → new work allowed.

## Topic matching

### Same topic — proceed (update STATE OK)

- User continues artifact in STATE (`brainstorm` / `spec` / `plan` path)
- Explicit handoff on same initiative (brainstorm → spec; spec → execute; debug → patch for same bug; execute → verify)
- Debug of failure tied to the active plan/spec/patch on this branch
- User says "continue" / "resume" / names the active artifact

### Unrelated topic — stop before STATE write

- Active STATE for topic A; user starts work for topic B
- No artifact link and no user confirmation to replace state

## Detection matrix

| Context | Agent behavior |
|---------|----------------|
| No STATE or `phase: done` | Proceed; optional confirm "Starting new flow work?" |
| Active STATE, same topic | Proceed; update STATE as skill requires |
| Active STATE, unrelated topic | Session gate message below. **Do not write STATE.** Stop until user picks. |
| Active STATE, ambiguous intent | One clarifying question. Do not write STATE until clear. |
| Same branch, same topic, two terminals | Do not suggest worktree. Warn: "Another session may share this checkout." Confirm continue. |

## User gate message

Send **only** the gate — do not combine with saving artifacts or updating STATE.

> Active flow work on this branch (`phase: <phase>`, `<artifact path if any>`). This request looks unrelated.
> 1. **Resume current work** — continue the active flow lane here
> 2. **Worktree** — new branch at `.worktrees/<slug>/` (recommended for concurrent unrelated work)
>
> Confirm option (1 or 2). I won't update `STATE.md` until you choose.

**Stop until the user responds.**

Forbidden in the same message: saving brainstorm/spec/plan files for the new topic, updating STATE, or starting implementation.

## After confirmation

### Option 1 — resume current work

Stop the new request; route user to the active phase/skill (e.g. `/flow-execute`).

### Option 2 — worktree

Follow `branch-gate.md` + `worktree-setup.md` for branch name and worktree path. All new work — including brainstorm brief, spec, and STATE — happens in the **worktree**. Do not overwrite STATE in the main workspace for the new topic.

## Intentional handoffs (do not block)

- brainstorm → `/flow-spec` or `/flow-patch` when brief matches
- spec → `/flow-execute` when plan exists
- debug → `/flow-patch` for same bug
- execute → `/flow-verify` for same plan
- verify → `/flow-finish` for merge/push/done on same branch

These are same-topic even when `phase` changes.

## Red flags — never

- Overwrite STATE with unrelated `phase` while active work exists
- Save a new-topic brainstorm/spec while unrelated STATE is active without gate
- Bundle session gate question with artifact save or STATE update in one message
- Suggest worktree for same-topic resume on the same branch

## Skills that must follow this reference

Before first STATE write in the session:

- `flow-brainstorm` — before §5 Write brainstorm brief
- `flow-spec` — before §6 user gate STATE update (and before §4 if saving spec would start a new lane on occupied unrelated STATE)
- `flow-debug` — before `phase: debug` (allow same-topic without gate)
- `flow-patch` — before workspace gate
- `flow-execute` — before workspace gate
- `flow-verify` — confirm STATE matches current work before `phase: verify`
