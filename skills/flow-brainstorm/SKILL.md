---
name: flow-brainstorm
description: Explore ideas and design before committing to a spec. Invoke with /flow-brainstorm when requirements are still fuzzy.
disable-model-invocation: true
metadata:
  flow:
    command: /flow-brainstorm
---

# Flow Brainstorm

**Triggered by:** `/flow-brainstorm`

Explore intent, options, and design **before** formal requirements. No production code. No implementation plan.

Use when the idea is fuzzy, large, or needs decomposing. When direction is clear and approved, hand off to **`/flow-patch`** when scope is small and bounded; **`/flow-spec`** when multi-step or multi-concern.

## When to use

| Use `/flow-brainstorm` | Skip to |
|------------------------|---------|
| "I'm not sure how to build this" | — |
| Multiple valid approaches | — |
| Large initiative needing decomposition | — |
| Fuzzy but resolves to small bounded change | `/flow-patch` (after lightweight brainstorm) |
| Scope already clear, multi-step feature | `/flow-spec` |
| Single bounded fix | `/flow-patch` |
| Bug or failing test | `/flow-debug` |

## Hard gate

Do **not** write production code, scaffold features, or create an implementation plan in this skill.

## Process

### 1. Explore context

Read relevant files, docs, recent commits. Understand existing patterns and constraints.

### 2. Clarify (one question at a time)

Ask until you understand purpose, constraints, and success criteria at a **directional** level — not every spec detail.

Prefer multiple-choice when possible. One question per message.

**Multiple-choice format:** Label options A/B/C/D (and E if needed). Mark exactly one option with **`(Recommended)`** based on codebase context, stated constraints, and MVP scope. Add one sentence after the options explaining why you recommend it — do not hide the recommendation only in prose after the list.

Example:

```
How should draft vs. published work in the MVP?

A) Always live — saving makes chapters visible immediately
B) Fic-level publish — whole fic hidden until author publishes
C) **(Recommended)** Chapter-level publish — per-chapter draft/publish, plus "publish all"
D) Writer-only — no public reading yet

Recommend C: matches your writer-first goal and allows flexible publish workflow without fic-level lock-in.
```

If the user already stated a preference, skip recommending a different option — confirm their choice instead.

If the request spans multiple independent subsystems, help decompose: what are the pieces, how do they relate, what order?

#### Scope assessment

After clarifying purpose and constraints, evaluate scope using the same criteria as `/flow-patch`:

| Route to `/flow-patch` | Route to `/flow-spec` |
|------------------------|----------------------|
| ≤3 files, one concern | >3 files or multiple concerns |
| Clear success criteria | Multi-step / multi-subsystem |
| Design direction settled | Needs formal plan with many tasks |

- **Clearly small from the start** (no real design ambiguity left): redirect immediately to `/flow-patch` — skip the brainstorm brief; the micro-spec in patch replaces it.
- **Still exploring but likely small**: continue with a lightweight brainstorm, then hand off to `/flow-patch`.
- **Multi-step or multi-concern**: continue full brainstorm, then hand off to `/flow-spec`.

Re-assess scope before handoff. If scope grew during brainstorm, route to `/flow-spec`. If scope is small and bounded, route to `/flow-patch`.

### 3. Propose approaches

Present 2–3 options with trade-offs. Mark one **`(Recommended)`** and explain why in one sentence.

**Small-scope exception:** When routing to `/flow-patch` and only one sensible approach exists, skip artificial alternatives — present one recommended approach and get user approval.

### 4. Present design

Scale to complexity — a few sentences for simple topics, more for nuanced ones. Cover as needed:

- Architecture and components
- Data flow
- Error handling
- Testing approach (high level)

Get user approval on the design direction. Revise until aligned.

### 5. Session gate (required)

**Read and follow** `flow-shared/references/session-gate.md` (resolve via path resolver in `flow/SKILL.md`).

Before saving the brief or updating `docs/flow/STATE.md`: if STATE shows active unrelated work, send the session gate message and **stop**. Do **not** save the brief or write STATE in the same turn as the gate.

After gate passes (same topic, empty STATE, or user confirmed worktree for new topic): proceed to §6.

### 6. Write brainstorm brief

Save to:

```
docs/flow/brainstorms/YYYY-MM-DD-<topic>.md
```

Use the **Next Step** that matches scope assessment — pick one, not both:

**Small bounded scope → patch:**

```markdown
# [Topic] — Brainstorm

## Problem / Goal
## Constraints
## Decisions Made
<!-- Each row: question → chosen answer -->
## Approaches Considered
## Recommended Direction
## Design Summary
## Out of Scope (for now)
## Open Questions
## Next Step
→ Run `/flow-patch` — small bounded scope; use this brief as context for the micro-spec
```

**Multi-step or multi-concern → spec:**

```markdown
# [Topic] — Brainstorm

## Problem / Goal
## Constraints
## Decisions Made
<!-- Each row: question → chosen answer -->
## Approaches Considered
## Recommended Direction
## Design Summary
## Out of Scope (for now)
## Open Questions
## Next Step
→ Run `/flow-spec` — multi-step change; lock requirements and generate implementation plan
```

Self-review the brief before saving: no contradictions, open questions resolved or listed explicitly.

Update `docs/flow/STATE.md`: `phase: brainstorm`, add brief path.

### 7. Handoff

When user approves the direction, use the message that matches scope:

**Small bounded scope:**

> Brainstorm saved to `docs/flow/brainstorms/...`. Run `/flow-patch` — use this brief as context for the micro-spec.

**Multi-step or multi-concern:**

> Brainstorm saved to `docs/flow/brainstorms/...`. Run `/flow-spec` to lock requirements and generate the implementation plan.

Do **not** auto-run the next skill. User invokes `/flow-patch` or `/flow-spec` explicitly.

At handoff, default to `/flow-patch` when scope meets patch criteria; use `/flow-spec` only when it doesn't.

## Principles

- YAGNI — cut unnecessary ideas early
- One question at a time
- Mark **`(Recommended)`** on multiple-choice options
- Incremental validation — get approval before going deeper
- Brainstorm explores; patch or spec commits; patch saves micro-spec to `docs/flow/patches/`

## Red flags — never

- **Propose session gate and save brief/STATE in the same turn** — session gate requires waiting for user reply
- **Overwrite STATE with unrelated phase** while active work exists on this checkout
