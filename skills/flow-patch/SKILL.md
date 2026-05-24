---
name: flow-patch
description: Small bounded changes with micro-spec, inline TDD, and per-task review. Invoke with /flow-patch.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-patch
---

# Flow Patch

**Triggered by:** `/flow-patch`

For **single bounded changes** — too small for a full spec doc. Implement **inline** in this session so the user sees work in real time. Review after each task via subagents.

## When to use

| Use `/flow-patch` | Redirect to `/flow-spec` |
|-------------------|--------------------------|
| ≤3 files, one concern | >3 files or multiple concerns |
| Clear success criteria | Needs design exploration |
| Bug fix with known cause | Architectural change |

## Branch rule

**Read and follow** `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`). Branch and workspace confirmation is a blocking user gate — proposing a name or option is not enough; wait for the user's reply before any implementation.

## Process

### 1. Micro-spec (required)

If `docs/flow/STATE.md` or the user points to a brainstorm brief at `docs/flow/brainstorms/...`, read it first and carry forward agreed decisions into the micro-spec.

Write inline before any code. Break work into one or more tasks with bite-sized steps:

```markdown
## Micro-spec

**Problem:** [what's wrong or needed]
**Success criteria:** [how we know it's done]
**Files:** [expected touch list]
**Out of scope:** [what we will NOT do]

### Task 1: [name]

- [ ] Step 1: Write failing test …
- [ ] Step 2: Verify RED …
- [ ] Step 3: Implement …
- [ ] Step 4: Verify GREEN …
- [ ] Step 5: Commit
```

Single-task patches are fine. Multi-step work gets one review cycle per task, not per checkbox.

**Micro-spec failures (never write these):** TBD/TODO, "add tests", "handle edge cases", steps without code or commands, vague success criteria.

**Micro-spec self-review** — fix inline until all blocking checks pass. **Do not proceed to §2 while blocked.**

**Calibration:** Contradictions and unmapped success criteria are **blocking**. Wording polish is **advisory**.

- **General:** No placeholders; no internal contradictions; no unrequested scope (YAGNI)
- **Success criteria audit:** Each success criterion must cite **Problem**, **Files**, or a task step that satisfies it. Missing backing → fix or remove the criterion
- **Out of scope:** Task steps must not touch anything listed under **Out of scope**

### 2. User gate

> Micro-spec above.
>
> Self-review: [N/N success criteria mapped]
>
> Approve to proceed?

Surface audit results only — do not ask the user to find internal contradictions.

**Stop until approved.** If they request changes, update micro-spec and re-run self-review.

### 3. Workspace gate (required)

Follow `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Apply the detection matrix: on `main`/`master`, unrelated work on a feature branch, or continuing matched work each have different gate messages. **Stop until the user confirms branch name and workspace option (when offered).**

Do **not** in the same turn: create/switch branches, create worktrees, or start implementation (Task 1, code edits, TDD steps).

After confirmation:

- **Option 1 (in-place):** create or switch to the branch in the current workspace; record `workspace: in-place` in `docs/flow/STATE.md`
- **Option 2 (worktree):** follow `flow-shared/references/worktree-setup.md`; all subsequent work happens in the worktree

Update `phase: patch` in `docs/flow/STATE.md`, then proceed to step 4.

### 4. Inline execution (per task)

**Implement in this session** — do not dispatch an implementer subagent. User should see edits and test runs live.

Read `flow-shared/references/tdd-red-green.md` (resolve via path resolver in `flow/SKILL.md`).

For each task:

1. Mark task in_progress in TodoWrite
2. Follow each step exactly; run verifications as specified
3. **Self-review** before dispatching reviewers:

   - All task requirements implemented, nothing extra (YAGNI)
   - Tests verify real behavior, not mocks
   - TDD cycle followed (watched test fail before implementing)
   - Names clear; files focused
   - No task step touches anything under micro-spec **Out of scope**

4. Dispatch **spec compliance reviewer** — read `flow-shared/prompts/spec-reviewer.md` (resolve via path resolver in `flow/SKILL.md`); paste full task text + micro-spec context. Loop: fix inline → re-review until ✅
5. Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). Dispatch **code quality reviewer** — read `flow-shared/prompts/code-quality-reviewer.md` (resolve via path resolver in `flow/SKILL.md`). Reviewer returns **Block / Fix / Suggest**. Loop until ✅ Approved:
   - **Block or Fix present:** fix inline → re-review
   - **Suggest only:** ✅ Approved — Suggest is advisory, do not block
   Reviewers do not edit code.
6. Mark task completed in TodoWrite

**One task at a time.** Do not start Task N+1 until Task N passes both reviews.

**Fixes after ❌:** orchestrator implements fixes inline, then re-dispatches the reviewer — reviewers do not edit code.

Stop when blocked, ambiguous, or all tasks complete. Do not guess.

### 5. Verify

Run `/flow-verify` against the micro-spec.

## Redirect rules

- User scope grows during patch → stop and switch to `/flow-spec`
- Path or mirror layout needs a full tree → `/flow-spec`
- Root cause unclear → `/flow-debug` first

## Red flags — never

- **Propose a branch/workspace and start Task 1 in the same turn** — workspace gate requires waiting for user reply
- **Create a worktree for unrelated work without offering workspace choice**
- Skip micro-spec approval or branch/workspace confirmation
- Dispatch implementer subagent (patch is inline only)
