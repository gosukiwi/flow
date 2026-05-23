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

If a brainstorm brief exists at `docs/flow/brainstorms/`, read it first and carry forward agreed direction. If requirements are still fuzzy, redirect to `/flow-brainstorm`.

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

### 4. Write spec

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

### 5. Spec self-review

Fix inline:

- No TBD/TODO/placeholder requirements
- No internal contradictions
- No ambiguous requirements (two interpretations)
- Focused enough for one plan

### 6. User gate (required)

> Spec written to `docs/flow/specs/...`. Please review and approve before I write the plan.

**Stop until user approves.** If they request changes, update spec and re-run self-review.

Update `docs/flow/STATE.md` with spec path and `phase: spec`.

---

## Phase B — Plan (no user approval)

Runs automatically after spec approval.

### 1. Scope check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

If splitting is needed, stop and get user agreement on which subsystem this plan covers before writing tasks.

### 2. Write plan

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

Bite-sized steps (2–5 minutes each). Checkbox syntax: `- [ ]`.

**Plan failures (never write these):**

- TBD, TODO, "add tests", "handle edge cases"
- "Similar to Task N" without repeating code
- Steps without actual code or commands
- References to types, functions, or methods not defined in any task

### 5. Plan self-review loop

Repeat until all pass:

| Check | Question |
|-------|----------|
| Spec coverage | Every spec requirement maps to a task? |
| Placeholders | Any vague steps? |
| Consistency | Names/signatures match across tasks? |
| Undefined references | Any type, function, or method used but not defined in an earlier task? |
| TDD | Behavior changes have RED-GREEN steps? |
| Granularity | Steps are 2–5 minute actions? |

Fix issues inline. **Do not ask user to approve the plan.**

If a plan gap requires a spec decision, stop and ask the user to update the spec.

### 6. Handoff

When plan self-review passes:

> Plan written to `docs/flow/plans/...`. Spec approved; plan reviewed. Run `/flow-execute` to implement.

Update `docs/flow/STATE.md`: `phase: execute`, add plan path.

**Do not implement.** Terminal state is handoff to `/flow-execute`.
