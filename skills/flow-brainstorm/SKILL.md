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

Explore intent, options, and design **before** a formal spec. No production code. No implementation plan.

Use when the idea is fuzzy, large, or needs decomposing. When direction is clear and approved, hand off to `/flow-spec`.

## When to use

| Use `/flow-brainstorm` | Skip to |
|------------------------|---------|
| "I'm not sure how to build this" | — |
| Multiple valid approaches | — |
| Large initiative needing decomposition | — |
| Scope already clear, ready to lock requirements | `/flow-spec` |
| Single bounded fix | `/flow-patch` |
| Bug or failing test | `/flow-debug` |

## Hard gate

Do **not** write production code, scaffold features, create an implementation plan, or save files under `docs/flow/brainstorms/`.

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

### 3. Propose approaches

Present 2–3 options with trade-offs. Mark one **`(Recommended)`** and explain why in one sentence.

### 4. Present design

Scale to complexity — a few sentences for simple topics, more for nuanced ones. Cover as needed:

- Architecture and components
- Data flow
- Error handling
- Testing approach (high level)

Get user approval on the design direction. Revise until aligned.

### 5. Re-review before commit

**Do not save brainstorm sessions to disk.** Only specs and plans are persisted (`docs/flow/specs/`, `docs/flow/plans/`).

Before handoff, present a **decisions summary** in chat and self-review:

| Check | Question |
|-------|----------|
| Completeness | Every major decision captured? |
| Consistency | Any contradictions between choices? |
| Scope | Still MVP-sized? Anything to defer? |
| Open questions | Anything unresolved? |

Format:

```markdown
## Decisions summary
- [decision] → [chosen option]
...

## MVP scope (in)
...

## Out of scope (for now)
...

## Open questions
None | [list]
```

Fix contradictions or gaps in the summary before asking for approval.

**User gate:** Ask user to confirm the summary. Stop until they approve.

### 6. Handoff

When user approves the re-review summary:

> Direction agreed. Run `/flow-spec` to write the formal spec and plan.

Do **not** auto-run `/flow-spec`. User invokes it explicitly. Carry decisions forward in conversation — `/flow-spec` does not depend on a brainstorm file.

If scope shrinks to a small bounded change during brainstorm, redirect to `/flow-patch`.

## Principles

- YAGNI — cut unnecessary ideas early
- One question at a time
- Mark **`(Recommended)`** on multiple-choice options
- Incremental validation — get approval before going deeper
- Brainstorm explores in chat; spec commits to disk
- No brainstorm files — re-review summary before handoff
