# Plan Execution

Shared process for running an approved plan with **subagents only** — never implement tasks inline in the orchestrator session.

**Used by:** `/flow-spec` (auto-continue after plan) and `/flow-execute` (resume). Resolve `flow-shared` via path resolver in `flow/SKILL.md`.

## Prerequisites

- Approved spec at `docs/flow/specs/...`
- Plan at `docs/flow/plans/...` (self-reviewed per flow-spec)
- `docs/flow/STATE.md` with `phase: planned` or `phase: execute` (resume)
- Prompt templates under `flow-shared/prompts/`

## Branch rule

**Read and follow** `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Session gate before any STATE write; branch and workspace confirmation is a **blocking user gate** — same weight as micro-spec approval.

## Process

### 1. Session and workspace gate (required)

Follow `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Session gate first: if STATE shows active unrelated work, stop before any STATE write. Then apply branch-gate detection matrix. **Stop until the user confirms branch name and workspace option (when offered).**

Do **not** in the same turn: create/switch branches, create worktrees, create TodoWrite for tasks, dispatch implementers, or start Task 1.

After confirmation:

- **Option 1 (in-place):** create or switch to the branch in the current workspace; record `workspace: in-place` in `docs/flow/STATE.md`
- **Option 2 (worktree):** follow `worktree-setup.md`; all subsequent work happens in the worktree

Update `phase: execute` in `docs/flow/STATE.md` when branch/workspace is confirmed (or when resuming with branch already recorded).

**After branch confirm:** proceed to step 2 — **Forbidden:** `Run /flow-execute` handoff, stopping for user to invoke `/flow-execute`, or Task 1 in the same turn as branch setup.

If `STATE.md` already records a confirmed `branch` (and `workspace` when applicable) for this topic, **skip the branch gate** and begin at step 2.

### 2. Artifact commit (required)

**Read and follow** `flow-shared/references/artifact-commit-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Run after branch/workspace is confirmed — **before** loading the plan or Task 1. Commit brainstorm, spec, and plan paths from STATE on the confirmed feature branch only.

If resuming and artifacts are already committed on the branch, skip.

### 3. Load plan

Read plan once. Extract every task with full text. Create TodoWrite per task.

Raise concerns to user before starting if plan has critical gaps.

### 4. Per task (strictly serial)

**One task at a time. One subagent role at a time.**

Do not dispatch Task N+1 — implementer, reviewer, or any role — while Task N is still in progress.

```
Task N gate (all steps required, in order):

  [ ] 1. Implementer subagent        → DONE
  [ ] 2. Spec compliance reviewer    → ✅
  [ ] 3. Correctness reviewer        → ✅ Approved
  [ ] 4. Mark Task N complete in TodoWrite

Only then start Task N+1 step 1.
```

**Forbidden:** Starting Task N+1 while Task N is still in spec or correctness review — even if the implementer already finished. Reviews are blocking gates, not background work.

**Before each dispatch:** Read prompt templates (resolve via path resolver in `flow/SKILL.md`):

- `flow-shared/prompts/implementer.md`
- `flow-shared/prompts/spec-reviewer.md`
- `flow-shared/prompts/correctness-reviewer.md`

Paste **full task text** into subagent prompts. Subagents must not read plan files themselves.

Track the **current task** explicitly in your head and in TodoWrite (`in_progress` = at most one task).

#### Step 1 — Implementer

Dispatch with implementer prompt. Handle status:

| Status | Action |
|--------|--------|
| DONE | Proceed to step 2 (spec review) — do not start next task |
| DONE_WITH_CONCERNS | Read concerns; fix or proceed to step 2 |
| NEEDS_CONTEXT | Provide context; re-dispatch implementer |
| BLOCKED | Escalate to user |

#### Step 2 — Spec compliance review

Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). **SHAs are diff anchors only** — pass them to reviewers for `git diff BASE..HEAD`; never instruct subagents to `git checkout` a SHA. Dispatch spec reviewer with both SHAs in the prompt. Loop: implementer fixes → refresh `HEAD_SHA` → re-review until ✅.

**Do not start step 3 or the next task until spec review is ✅.**

**Forbidden:** Approving from the implementer report without an independent diff review. Passing tests do not replace spec review.

#### Step 3 — Correctness review

Refresh `HEAD_SHA` if the implementer committed fixes after spec review. Reuse `BASE_SHA`. Dispatch correctness reviewer (task mode).

**Do not mark the task complete or start the next task until reviewer returns ✅ Approved.**

Reviewer returns **Block / Fix / Suggest**. Loop until ✅ Approved:

- **Block or Fix present:** implementer (subagent) fixes all Block and Fix items → re-review
- **Suggest only:** ✅ Approved — Suggest is advisory, do not block

Reviewers do not edit code.

#### Step 4 — Complete task

Mark Task N completed in TodoWrite. **Then** begin Task N+1 step 1.

### 5. Verify (auto-run)

When all **implementation** plan tasks are complete, **immediately continue into verify** — do not hand off or wait for the user to invoke `/flow-verify`.

**Plan task ≠ Flow verify finish.** A plan step or task named "Final verification", "Run full test suite", or similar is **implementation work** — it does **not** replace step 5 below. Even if the last plan task ran lint/build/test and updated STATE to `phase: verify`, you must still run the verify checklist and present the **numbered user menu** from `verify-gate.md`.

1. Read `flow-verify/SKILL.md` and `flow-shared/references/verify-gate.md` (resolve via path resolver in `flow/SKILL.md`)
2. Follow verify-gate process — full test suite, requirements checklist against spec + plan
3. Update `docs/flow/STATE.md`: `phase: verify` when starting (per verify-gate)
4. If verify fails → route to `/flow-debug` or `/flow-patch`; do not present the done menu
5. If verify passes → present the verify user menu per `verify-gate.md` (numbered options 1–4 — **not** ad hoc "commits or PR?" or implementation summary as the final message)

**Before presenting the menu:** on the feature branch, run `git status`. If there are **uncommitted changes** from any task → do **not** claim execute or verify complete. Commit per plan task steps, dispatch implementer fixes, or route to `/flow-patch` — then re-run verify steps 2–5.

**Do not run verify option 2 (branch review) automatically** — only when the user chooses it from the menu.

**Forbidden:** Stopping after all tasks with a "Run `/flow-verify`" handoff when implementation succeeded. User requests to skip re-running tests do not override this gate — per-task tests ≠ full verify.

## Red flags — never

- Skip subagents and implement inline
- Skip spec or correctness review
- **Hand off verify instead of running it** after all tasks complete
- **Wait for `/flow-verify` invocation** before running the full test suite or requirements checklist
- **Trust the implementer report for spec compliance** — spec reviewer must inspect the diff independently
- **Skip spec review because tests pass** — spec and correctness are separate gates
- **Propose a branch/workspace and start Task 1 in the same turn** — workspace gate requires waiting for user reply
- **Skip artifact commit** before Task 1 when flow artifact files exist uncommitted on the branch
- **Commit flow artifacts on `main`/`master`** during execute
- **Create a worktree without user confirming option 2**
- **Start Task N+1 while Task N reviews are incomplete** (most common violation)
- **`git checkout <commit-sha>`** (implementer or reviewer) — detaches HEAD; commits miss the feature branch. Stay on the branch name; use SHAs only in `git diff`
- Dispatch parallel subagents across tasks (different tasks or roles at once)
- Make subagent read the plan file — provide full task text in prompts
- Move to next task after implementer DONE but before both reviews ✅
- **Treat a plan "Final verification" / last-task test run as Flow verify finish** — still present the numbered verify menu; plan verification ≠ `verify-gate.md` completion
- **Stop with implementation summary + "commits or PR?"** instead of the verify user menu (options 1–4)
- **Stop with `Run /flow-execute` after branch confirm** — continue steps 2–5 in the same session
- **Claim execute or verify complete with uncommitted changes** on the feature branch — commit per plan or `/flow-patch` first

## Continuous execution

After branch confirm: artifact commit → tasks → verify with **no** mid-lane pauses or `/flow-execute` handoffs.

Do not pause between **completed** tasks. **Continuous ≠ parallel** — finish Task N reviews before Task N+1.

Stop only when: blocked, ambiguous, verify menu presented, uncommitted work on the feature branch, or user picks a menu option.
