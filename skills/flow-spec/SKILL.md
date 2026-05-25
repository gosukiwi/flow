---
name: flow-spec
description: Create an approved spec and self-reviewed implementation plan. Invoke with /flow-spec before multi-step work.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-spec
---

# Flow Spec

**Triggered by:** `/flow-spec`

Create a clear spec (user-approved) and implementation plan (AI self-reviewed). Do not write production code in this skill.

If a brainstorm brief exists at `docs/flow/brainstorms/`, read it first and carry forward agreed direction. If requirements are still fuzzy, redirect to `/flow-brainstorm`. If the brief's scope is small and bounded (≤3 files, one concern), redirect to `/flow-patch` instead of writing a spec.

## Phase A — Spec

### 1. Explore context

Read relevant files, docs, recent commits, and any brainstorm brief. Understand existing patterns.

### 2. Clarify (one question at a time)

Ask until there are **zero open questions** about:

- Purpose and success criteria
- Scope and explicit out-of-scope
- Constraints and non-goals

Prefer multiple-choice when possible. One question per message.

When offering A/B/C/D options, mark exactly one with **`(Recommended)`** and add one sentence why. See `flow-brainstorm` for format.

If requirements are still fuzzy after a few questions, redirect to `/flow-brainstorm`.

### 3. Propose design

When scope is clear:

- Present 2–3 approaches with trade-offs if genuinely ambiguous; otherwise present one recommended design
- Cover architecture, components, error handling, testing approach
- Get user approval on the design

### 4. Session gate (required)

**Read and follow** `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Before writing the spec file or updating STATE: if STATE shows active **unrelated** work, send the session gate message and **stop**. Do **not** save the spec or write STATE in the same turn as the gate.

Same-topic handoffs from an approved brainstorm brief on this initiative → proceed without gate.

### 5. Write spec

Save to:

```
docs/flow/specs/YYYY-MM-DD-<topic>.md
```

Required sections:

```markdown
# [Topic]

## Goal
## Success Criteria
## Scope
## Out of Scope
## Design
## Testing Approach
## Open Questions
```

`Open Questions` must be empty or say "None" before proceeding.

### 6. Spec self-review

Fix inline until all pass. **Do not proceed to §7 while any blocking check fails.**

Record self-review output internally (review notes, not necessarily in the spec file):

```
Status: Ready | Blocked
Blocking: [list, or none]
Advisory: [list, or none]
```

**Calibration:** Contradictions, unmapped success criteria, and path mismatches are **blocking**. Wording polish and uneven section depth are **advisory** — note but do not block.

**General**

- No TBD/TODO/placeholder requirements
- No internal contradictions
- No ambiguous requirements (two valid interpretations)
- Focused enough for one plan
- No unrequested scope beyond what the user approved in design (YAGNI)

**Success criteria audit**

- List every bullet under `## Success Criteria` as a numbered item
- For each item, cite the spec section (heading + path/tree/table/command/paragraph) that satisfies it
- If any success criterion has no supporting section, add one or remove the criterion

**Structure & path consistency** (required when spec mentions trees, paths, moves, mirroring, or file layout)

Render two columns using the **spec's documented convention** (colocated tests beside source, mirrored root such as `tests/` ↔ `src/`, hybrid, or N/A for the paired column if the spec defines none):

| Source / runtime tree | Test / mirror tree (if applicable) |
| --------------------- | ------------------------------------ |
| `...`                 | `...`                                |

Then verify:

- Segment-for-segment alignment per the documented rule — file names may differ (`Foo.tsx` vs `Foo.test.tsx`; colocated tests share directory segments)
- If success criteria or scope use **mirror**, **reflect**, or **match structure**, paired paths must preserve intermediate folders (`common/`, feature namespaces, private child folders) — not flatten them unless documented
- Import conventions in Design must not contradict the tree when the spec mandates import style
- Allowed skips must be named in Success Criteria or Design (e.g. "`index.ts` has no test counterpart")

**Contradiction stop rule**

If Success Criteria, Design tree, and Testing Approach disagree on paths or layout, **do not proceed to user gate**. Resolve by picking one rule and updating all sections, or ask the user one multiple-choice question:

- A) Strict mirror (paired tree matches source tree segment-for-segment) **(Recommended for move/refactor specs)**
- B) Flattened paired tree (document explicit exceptions in Success Criteria)
- C) Other (user specifies)

Document the chosen rule in Design or Testing Approach so the plan cannot interpret it two ways.

### 7. Spec gate (required)

Present the spec path and self-review, then send **only** this gate — do not combine with plan writing, STATE updates, or execute/workspace setup:

```
Spec ready at docs/flow/specs/.... Self-review: [N/N success criteria mapped] | Structure trees: [aligned / N/A]

1. Approve spec — I'll write the plan (Phase B, no code)
2. Request changes — tell me what to revise
3. Stop — no plan or implementation
```

Surface audit results only — do not ask the user to find internal contradictions.

**Stop until the user picks 1, approves the spec explicitly, or requests changes (2).** Option 3 ends spec work. If they request changes, update spec and re-run self-review.

**"Yes" / "approve" / "proceed" after this gate counts as spec approval only** — not plan approval (plan has no user gate), branch/workspace confirmation, or permission to run `/flow-execute`. If the user bundles other preferences in the same message (e.g. "yes, use a worktree when we implement"), note them for handoff but **do not** create branches, worktrees, or start execute during Phase B.

After spec approval: update `docs/flow/STATE.md` with spec path and `phase: spec`, then proceed to Phase B.

---

## Phase B — Plan (no user approval)

Runs automatically after spec approval.

### 1. Scope check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

If splitting is needed, stop and get user agreement on which subsystem this plan covers before writing tasks.

### 2. Write plan

Write for an implementer with **zero codebase context** — exact paths, full code, exact commands, expected output. DRY. YAGNI. TDD. Frequent commits.

Save to:

```
docs/flow/plans/YYYY-MM-DD-<topic>.md
```

Header:

```markdown
# [Topic] Implementation Plan

> **Execution:** Use /flow-execute with subagents. TDD required.

**Goal:** [one sentence]
**Spec:** docs/flow/specs/YYYY-MM-DD-<topic>.md
**Architecture:** [2-3 sentences]

---
```

### 3. File structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure — but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

### 4. Task structure

Each task: exact file paths, complete code in steps, exact commands with expected output, TDD steps (write failing test → verify fail → implement → verify pass → commit).

Bite-sized steps (2–5 minutes each). Checkbox syntax: `- [ ]`. Each TDD step is its own checkbox — do not combine RED/GREEN into one step.

Every task uses this shape:

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file`
- Modify: `exact/path/to/existing`
- Test: `exact/path/to/test`

- [ ] **Step 1: Write the failing test**

[complete test code]

- [ ] **Step 2: Run test to verify it fails**

Run: `[exact command]`
Expected: FAIL — [reason]

- [ ] **Step 3: Write minimal implementation**

[complete code or precise edit instructions with code]

- [ ] **Step 4: Run test to verify it passes**

Run: `[exact command]`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add ...
git commit -m "..."
```
````

**Plan failures (never write these):**

- TBD, TODO, "implement later", "fill in details"
- "Add tests", "add appropriate error handling", "add validation", "handle edge cases"
- "Write tests for the above" without actual test code
- "Similar to Task N" without repeating code
- Steps that describe what to do without showing how (code blocks required for code steps)
- Steps without actual code or commands
- References to types, functions, or methods not defined in any task

### 5. Plan self-review loop

Repeat until all pass. Record `Status: Ready | Blocked` with blocking vs advisory issues (same calibration as spec self-review).

| Check | Question |
|-------|----------|
| Spec coverage | Every spec requirement maps to a task? |
| Success criteria coverage | Every **Success Criteria** bullet maps to a specific task step with an **expected path or artifact** (not just "update tests")? |
| Out-of-scope guard | Any task step touches files, systems, or behavior listed under **Out of Scope** (or beyond **Scope**)? |
| Tree parity | If spec defines source + paired trees, plan task paths (moves, creates, deletes) match the spec trees segment-for-segment; flag any flatten/skip? |
| Spec diagram authority | Plan paths match the spec's canonical tree. If the plan improves on the spec, **update the spec first** — plan must not silently diverge |
| Placeholders | Any vague steps? |
| Consistency | Names/signatures match across tasks? |
| Undefined references | Any type, function, or method used but not defined in an earlier task? |
| TDD | Behavior changes have RED-GREEN steps? |
| Granularity | Steps are 2–5 minute actions? |

**Structure refactor plans:** Before handoff, produce a short mapping table in the plan or review notes:

| Success criterion | Plan task | Expected path(s) |
| ----------------- | --------- | ---------------- |
| ...               | Task N    | `exact/path/`    |

If any row is missing or paths disagree across spec/plan, loop plan self-review again.

Fix issues inline. **Do not ask user to approve the plan.**

If a plan gap requires a spec decision, stop and ask the user to update the spec.

### 6. Handoff

When plan self-review passes:

> Plan written to `docs/flow/plans/...`. Spec approved; plan reviewed. Run `/flow-execute` to implement.

Update `docs/flow/STATE.md`: `phase: execute`, add plan path.

**Do not implement.** Terminal state is handoff to `/flow-execute`.

## Red flags — never

- **Treat spec "yes" as execute or workspace confirmation** — Phase B is plan-only; branch/worktree is `/flow-execute` step 1 after handoff
- **Bundle plan outline, STATE update, worktree, or `/flow-execute` with the spec gate message** — send spec gate only; wait for approval before Phase B
- **Skip spec gate** because the user asked for implementation preferences in the same message
- Write production code in this skill
