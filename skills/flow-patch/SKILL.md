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

**Read and follow** `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`). Session gate before any STATE write; branch and workspace confirmation before implementation.

**Patch on `main`/`master`:** use branch-gate **On main** menu (branch here vs worktree) — never commit patch work on `main` without explicit approval.

**Patch on a feature branch:** default **continue on current branch** when `phase: done` or no STATE; use branch-gate **Continuing on current feature branch (patch)** — not the execute-style switch/worktree 1/2 menu. User may opt into **worktree** or **new branch** explicitly.

Branch and workspace confirmation is a **blocking user gate** — same weight as micro-spec approval. Micro-spec approval does **not** satisfy branch or workspace confirmation.

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
**Testing:** [RED-GREEN for behavior changes | no new tests + manual checks for presentation-only — see `tdd-red-green.md`]

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

### 2. Micro-spec gate (required)

Run micro-spec self-review internally (§1). **Do not proceed to §2 while blocked.** Then present the micro-spec and send **only** this gate — do not combine with workspace setup or Task 1:

```
Micro-spec ready.

1. Approve micro-spec — proceed to workspace setup
2. Request changes — tell me what to revise
3. Stop — no implementation
```

Do **not** expose internal self-review checklist names (criteria mapping counts, structure trees, Status/Blocked) in the gate message — the user reviews the micro-spec content, not the agent's audit worksheet. Do not ask the user to find contradictions you should have caught in self-review.

**Stop until the user picks 1, approves the micro-spec explicitly, or requests changes (2).** Option 3 ends the patch. If they request changes, update micro-spec and re-run self-review.

**"Yes" / "approve" / "proceed" after this gate counts as micro-spec approval only** — not branch or workspace confirmation. If the user bundles other permissions in the same message (e.g. "yes, reset STATE.md"), handle each permission separately; micro-spec approval still does not skip §3.

### 3. Session and workspace gate (required)

Follow `flow-shared/references/session-gate.md` then `flow-shared/references/branch-gate.md` (resolve via path resolver in `flow/SKILL.md`).

**Order:**

1. **Session gate** — if STATE shows **active** unrelated work (occupied `phase`, not `done`), stop before any STATE write; send session gate only.
2. **Branch/workspace by checkout:**
   - **`main`/`master`:** send branch-gate **On main** menu (1 branch here / 2 worktree). Stop until user picks 1 or 2.
   - **Feature branch, `phase: done` or no STATE:** send branch-gate **Continuing on current feature branch (patch)** only — **do not** send unrelated switch/worktree 1/2 menu. Stop until user confirms continue or opts into isolation.
   - **Feature branch, active unrelated lane** (after session gate if needed): follow session outcome — worktree via `worktree-setup.md`, or resume; do not invent a new branch without user approval.

Do **not** in the same turn: create/switch branches, create worktrees, update STATE, or start implementation (Task 1, code edits, TDD steps).

**Forbidden rationalizations:** "User said yes", "micro-spec approved", "unrelated topic needs new branch", **"work here" means switch branch here"**, "feature branch off main is obvious", "STATE reset permission covers workspace" — none of these satisfy this gate.

After confirmation:

- **Patch continue on current branch (default on feature branch):** no `git switch -c`; record `workspace: in-place`, `branch:` = current branch in `docs/flow/STATE.md`
- **Option 1 (in-place new branch)** — `main` menu pick 1, or user named a new branch: create or switch in current workspace; `workspace: in-place`
- **Option 2 (worktree)** — user chose worktree or session gate option 2: follow `flow-shared/references/worktree-setup.md`

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

4. Record `BASE_SHA` (commit before task) and `HEAD_SHA` (current). **SHAs are diff anchors only** — for `git diff BASE..HEAD`; never `git checkout` a SHA (detached HEAD). Dispatch **spec compliance reviewer** — read `flow-shared/prompts/spec-reviewer.md` (resolve via path resolver in `flow/SKILL.md`); paste full task text + micro-spec context + both SHAs. Loop: fix inline → refresh `HEAD_SHA` → re-review until ✅

   **Forbidden:** Approving from your own implementer report without an independent diff review. Passing tests do not replace spec review.

5. Refresh `HEAD_SHA` if fixes landed after spec review. Reuse `BASE_SHA`. Dispatch **correctness reviewer** (task mode) — read `flow-shared/prompts/correctness-reviewer.md` (resolve via path resolver in `flow/SKILL.md`). Reviewer returns **Block / Fix / Suggest**. Loop until ✅ Approved:
   - **Block or Fix present:** fix inline → re-review
   - **Suggest only:** ✅ Approved — Suggest is advisory, do not block
   Reviewers do not edit code.
6. **Commit** per micro-spec task Step 5 — on the user-confirmed feature branch only. One commit per task (or as the micro-spec specifies). Refresh `HEAD_SHA` after commit.
7. Mark task completed in TodoWrite

**One task at a time.** Do not start Task N+1 until Task N passes both reviews.

**Forbidden:** Starting verify or marking the task complete while Task N is still in spec or correctness review — even if tests pass or the user says the fix is tiny.

**Forbidden:** Marking a task complete or starting the next task with **uncommitted changes** from that task — commit per micro-spec Step 5 first.

**Fixes after ❌:** orchestrator implements fixes inline, then re-dispatches the reviewer — reviewers do not edit code.

Stop when blocked, ambiguous, or verify steps complete and user menu presented. Do not guess.

### 5. Verify (auto-run)

When all micro-spec tasks are complete, **immediately continue into verify** — do not hand off or wait for the user to invoke `/flow-verify`.

1. Read `flow-verify/SKILL.md` (resolve via path resolver in `flow/SKILL.md`)
2. Follow verify process: `verification-gate.md`, full test suite, requirements checklist against micro-spec
3. Update `docs/flow/STATE.md`: `phase: verify` when starting
4. If verify fails → route to `/flow-debug` or fix inline; do not present the done menu
5. If verify passes → present the verify user menu per `flow-verify/SKILL.md`

**Before presenting the menu:** on the feature branch, run `git status`. If there are **uncommitted changes** from any task → do **not** claim patch or verify complete. Commit per micro-spec task Step 5, then re-run verify steps 2–5.

**Do not run verify option 2 (branch review) automatically** — only when the user chooses it from the menu.

**Forbidden:** Stopping with a "Run `/flow-verify`" handoff when patch tasks succeeded.

**Forbidden:** Presenting ad hoc "next steps" or a custom merge/PR menu — use the **exact** verify user menu from `flow-verify/SKILL.md` (numbered options 1–4). Manual QA notes may appear **above** the menu, not instead of it.

## Redirect rules

- User scope grows during patch → stop and switch to `/flow-spec`
- Path or mirror layout needs a full tree → `/flow-spec`
- Root cause unclear → `/flow-debug` first

## Red flags — never

- **Treat micro-spec "yes" as branch/workspace confirmation** — §2 and §3 are separate gates; send workspace menu only after micro-spec approval
- **Propose a branch/workspace and start Task 1 in the same turn** — workspace gate requires waiting for user reply
- **Create a worktree for unrelated work without offering workspace choice**
- **Send execute-style switch/worktree 1/2 menu on a feature branch when `phase: done` or no STATE** — use patch continuing gate; stay on current branch unless user opts into isolation
- **Map "work here" to switching to a proposed new branch** — on patch continuing gate it means stay on current branch
- Skip micro-spec approval or branch/workspace confirmation
- **Skip spec or correctness review** — including when the user says the patch is tiny or done
- **`git checkout <commit-sha>`** — detaches HEAD; commits miss the feature branch. Stay on the branch name; use SHAs only in `git diff`
- **Trust self-review or passing tests instead of dispatching reviewers**
- Dispatch implementer subagent (patch is inline only)
- **Hand off verify instead of running it** after all tasks complete
- **Replace the verify user menu with custom next steps** — merge/PR/iterate lists are not substitutes for options 1–4
- **Claim patch or verify complete with uncommitted changes** on the feature branch — commit per micro-spec task Step 5 first
