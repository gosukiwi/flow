# Writing Flow Skills (maintainer guide)

**Repo-only — not installed to consumer projects.**

Skill changes here use the same RED→GREEN→REFACTOR cycle as code TDD. Scenarios are failing tests; `SKILL.md` files are the fix.

Full generic skill authoring (descriptions, CSO, persuasion): use [superpowers `writing-skills`](https://github.com/obra/superpowers) if available. This doc is **Flow-specific** — workflow skills, gates, and how we test them.

## Testing pyramid

| Layer | Command | What it proves |
|-------|---------|----------------|
| **3 — Real use** | Dogfood `/flow-*` in Cursor | End-to-end behavior on real work (best signal) |
| **2 — Scenarios** | `make test-scenarios` + agent runs | Agents comply under pressure |
| **1 — Static** | `make test` | Structure, refs, cheap invariants |
| **0 — Artifacts** | `validate-artifacts.py` | Spec/plan templates in consumer projects |

Run Layer 1 before every commit. Run Layer 2 before tagging a release. Layer 3 is ongoing.

## When to scenario-test a skill

**Do test** skills that:

- Enforce discipline (TDD, branch gate, review gates)
- Have compliance costs (time, extra steps)
- Can be rationalized away ("just this once", "no commit yet")

**Skip scenarios** for:

- Pure reference (`flow-shared` prompts, `tdd-red-green.md`)
- Mechanical rules already covered by `validate-skills.sh`

## RED → GREEN → REFACTOR

### RED — watch it fail

1. Write a **pressure scenario** before or while hardening the skill (see recipe below).
2. Run against the **old** skill (stash changes or use committed version).
3. Use a subagent or fresh session; ask what it would **actually do under pressure**, not the ideal answer.
4. Log verbatim in [`tests/regression/`](regression/README.md): choice, rationalization.

If the scenario passes on the old skill, it is **too weak** — sharpen it (draft-message traps work better than abstract A/B/C).

### GREEN — write the skill

1. Update `SKILL.md` / shared references to block the specific rationalization you saw.
2. Re-run the scenario with the new skill loaded.
3. Agent should choose the compliant option and cite the rule.

### REFACTOR — plug holes

1. New rationalization in real use or scenario run → add counter (red flag, hard gate, forbidden same-turn action).
2. Optional: add a grep check to `validate-skills.sh` for cheap invariants (e.g. `Hard gate` + `Stop until`).
3. Re-run scenario; stay GREEN.

## Scenario recipe

File: `tests/scenarios/flow-<skill>-<violation>.md`

```markdown
IMPORTANT: This is a real scenario. Choose and act.

[Context — be specific: on main, micro-spec approved, composing a message, etc.]

Draft or situation that tempts the violation:
> [exact text that bundles two steps, or skips a gate]

Do you:
A) [tempting wrong choice — momentum, efficiency]
B) [compliant choice]
C) [another wrong choice — different loophole]

What do you do?
```

**Sharp scenarios** trap behaviors agents already exhibit:

- Same-turn bundling ("propose branch" + "Starting Task 1…" in one message)
- "No commit yet" / "tests aren't commits" rationalizations
- User urgency without satisfying the gate

Register new scenarios in [`tests/scenarios/README.md`](scenarios/README.md).

## Flow skill conventions

Every invokable flow skill under `skills/`:

- `name` matches directory
- `description` — when to invoke (not a workflow summary)
- `disable-model-invocation: true`
- `Triggered by:` line with `/flow-*` command
- Shared prompts/refs via path resolver in `flow/SKILL.md` — never repo-root `prompts/` or `tests/`

Discipline skills: prefer **hard gates**, **stop until approved**, **red flags — never**, and a **forbidden in the same message** list (see `branch-gate.md`).

## Static checks after GREEN

Add to `tests/static/validate-skills.sh` only when GREEN proved the rule matters and grep can catch regressions cheaply. Examples:

- `flow-brainstorm` references both `/flow-patch` and `/flow-spec` handoff
- `branch-gate` has `Hard gate` and `Stop until`

Do not grep for rules that need behavioral verification — use scenarios.

## Maintainer workflow (checklist)

- [ ] Layer 1: `make test`
- [ ] If changing discipline: write or update scenario
- [ ] RED: run scenario against old skill; log in `tests/regression/` if it fails as expected
- [ ] Edit skill / shared reference
- [ ] GREEN: run scenario with new skill
- [ ] REFACTOR: optional static check; re-run scenario
- [ ] Reinstall locally: `npx skills add ./skills -a cursor --skill '*' -y --copy`
- [ ] Before release tag: run all scenarios (see `make test-scenarios`)

## Example: branch gate hardening

1. **RED** — scenario bundles branch ask + "Starting Task 1"; old skill → agent chose A ("no commit yet").
2. **GREEN** — `branch-gate.md` hard gate + forbidden same-message list; agent chose B.
3. **REFACTOR** — red flags in execute/patch; `validate-skills.sh` grep for `Hard gate`.

See [`tests/regression/README.md`](regression/README.md) for the log format.
