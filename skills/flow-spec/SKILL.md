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

## Phase A — Spec

### 1. Explore context

Read relevant files, docs, recent commits. Understand existing patterns.

### 2. Clarify (one question at a time)

Ask until there are **zero open questions** about:

- Purpose and success criteria
- Scope and explicit out-of-scope
- Constraints and non-goals

Prefer multiple-choice when possible. One question per message.

If the request spans multiple independent subsystems, stop and help decompose. Spec one sub-project at a time.

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

### 1. Write plan

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

### 2. Task structure

Each task: exact file paths, complete code in steps, exact commands with expected output, TDD steps (write failing test → verify fail → implement → verify pass → commit).

Bite-sized steps (2–5 minutes each). Checkbox syntax: `- [ ]`.

**Plan failures (never write these):**

- TBD, TODO, "add tests", "handle edge cases"
- "Similar to Task N" without repeating code
- Steps without actual code or commands

### 3. Plan self-review loop

Repeat until all pass:

| Check | Question |
|-------|----------|
| Spec coverage | Every spec requirement maps to a task? |
| Placeholders | Any vague steps? |
| Consistency | Names/signatures match across tasks? |
| TDD | Behavior changes have RED-GREEN steps? |
| Granularity | Steps are 2–5 minute actions? |

Fix issues inline. **Do not ask user to approve the plan.**

If a plan gap requires a spec decision, stop and ask the user to update the spec.

### 4. Handoff

When plan self-review passes:

> Plan written to `docs/flow/plans/...`. Spec approved; plan reviewed. Run `/flow-execute` to implement.

Update `docs/flow/STATE.md`: `phase: execute`, add plan path.

**Do not implement.** Terminal state is handoff to `/flow-execute`.
