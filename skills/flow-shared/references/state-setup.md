# STATE Setup

Read before **any** write to `docs/flow/STATE.md` when the file is not gitignored. Runs alongside `session-gate.md` (resolve via path resolver in `flow/SKILL.md`).

`STATE.md` is a **local session bookmark** — phase, workspace, artifact paths. Specs, plans, patches, and brainstorms under `docs/flow/` stay **tracked** in git.

## Hard gate

```
NO STATE.md WRITE UNTIL GITIGNORE IS CONFIRMED OR USER OPTS OUT
```

**Forbidden:** Writing or committing `docs/flow/STATE.md` without running the ignore check below.

## Why gitignore

- Avoids stale STATE on `main` while work runs in a worktree
- Avoids wrong STATE (`workspace: worktree`, removed paths) landing on `main` after merge
- Keeps phase churn out of PRs — durable history lives in specs/plans

## Ignore check

Before creating or updating `docs/flow/STATE.md`:

```bash
git check-ignore -q docs/flow/STATE.md 2>/dev/null
```

**If already ignored:** proceed with STATE write (session gate and other gates still apply).

**If NOT ignored:** send the user gate below. **Stop until the user responds.** Do not write STATE or save artifacts that imply a new flow lane in the same message as the gate.

## User gate message

Send **only** the gate — do not combine with STATE write, brief/spec/plan save, or `.gitignore` commit.

> `docs/flow/STATE.md` is not gitignored. Flow treats it as a local session bookmark (specs/plans stay tracked).
>
> 1. **Add to `.gitignore` (recommended)** — add `docs/flow/STATE.md`; if already tracked, run `git rm --cached docs/flow/STATE.md` (keeps your local file). I'll commit `.gitignore` changes only with your approval.
> 2. **Keep tracked** — proceed without gitignore (you accept STATE in git history)
>
> Confirm option (1 or 2). I won't write `STATE.md` until you choose.

**Stop until the user responds.**

## After confirmation

### Option 1 — gitignore (recommended)

1. Add `docs/flow/STATE.md` to `.gitignore` if missing
2. If tracked: `git rm --cached docs/flow/STATE.md` (keeps local file on disk)
3. **Get user approval** before committing `.gitignore` / rm-cached changes
4. Commit only after approval
5. Proceed with STATE write per the active skill

### Option 2 — keep tracked

Proceed with STATE write. Do not add gitignore without a later explicit user request.

## Red flags — never

- Write STATE when `git check-ignore` fails without user gate (options 1 or 2)
- Add `.gitignore` or commit rm-cached without user approval
- Bundle gitignore gate with STATE write or artifact save in one message
- Gitignore all of `docs/flow/` — only `STATE.md` is local

## Skills that use this reference

Invoked via `session-gate.md` before first STATE write in a session when ignore check fails:

- `flow-brainstorm`, `flow-spec`, `flow-debug`, `flow-patch`, `flow-execute`, `flow-verify`, `flow-finish`
