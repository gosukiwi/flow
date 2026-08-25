# Design — Part 1: spec scoping

Status: done, pending a Grok 4.5 High confirmation run. Scope of this change: **how
`/flow-spec` decides what one spec contains.** Nothing else.

## Result

RED and GREEN both ran on Opus 5 (subagent model choice here has no version pinning,
so 4.7/4.8 were unavailable; row 106 set the precedent of REDing on Opus 5). Since
Opus 5 is likely *stronger* than the weakest large tier, a RED failure on it is
conservative evidence. Grok 4.5 High still wants a confirmation run.

Two findings worth keeping:

- `flow-spec-oversized-single-feature.md` REDed first try, reproducing the enumeration
  defect verbatim: *"the skill's only split trigger is work that 'spans independent
  subsystems'"*.
- `flow-spec-scope-not-trimmed.md` was **compliant on the first attempt** — the agent
  found a hook in the old text's "each shippable on its own." Per `AGENTS.md:89` that
  made the scenario too weak, not the skill adequate. Sharpening it (many
  individually-trivial adjacent items, where compliance looks like absurd process
  overhead, and with the criterion no longer given away in the setup) produced a clean
  RED whose rationalization is exactly the reported complaint: *"B invents a minimality
  rule the text doesn't contain."*

## Problem

`flow-spec/SKILL.md:35` currently says:

> If the work spans independent subsystems, split it into separate specs — one per
> subsystem, each shippable on its own.

Two defects.

**It enumerates one case instead of stating a property.** `tests/writing-skills.md:67`
warns about exactly this: "Phrase a rule as a property of the artifact, not a step in
a sequence… Predicate phrasing self-extends to cases you did not enumerate." The rule
only fires when the user hands over several unrelated things. It cannot split *one
large coherent feature* — "add multi-tenancy" is a single tightly-coupled subsystem
and forty files, and the rule reads as not applying. That is the hard case, and it is
the case the rule misses.

**There is no criterion for trimming.** The spec template has an `Out of Scope`
section, but nothing says what belongs there, so the agent trims on taste and does it
inconsistently.

## The rule

Replaces the sentence above:

> A spec is one slice: small enough that a single agent session can hold its spec,
> plan, and task coordination; shippable on its own; testable on its own. Work that
> exceeds any of these is more than one spec — split it and spec only the first slice.
>
> Anything not required for this slice to ship and pass its own tests belongs in Out
> of Scope.

Three conditions, phrased as properties of the artifact, so they fire on any oversized
spec rather than only on independent-subsystem asks. The trimming criterion falls out
of the same rule rather than being a separate judgement.

Known trade-off: "session-sized" is a judgement call where "independent subsystems"
was nearly mechanical. The rule buys coverage at some cost in crispness, and the
scenarios are what hold it honest.

Regression risk: the four-independent-subsystems case
(`tests/scenarios/flow-spec-monolith-spec.md`) must still split. Under the new
phrasing it is caught by *session-sized* rather than by independence — a combined
billing + notifications + dashboard + audit-log spec is arguably shippable and
testable as a unit, it is just far too large for one session. That scenario gets a
GREEN re-run and a reworded Baseline row.

## Files

| File | Change |
|---|---|
| `skills/flow-spec/SKILL.md` | replace the split sentence in §1 |
| `AGENTS.md:138` | invariant row "Independent subsystems → separate specs" is rewritten |
| `tests/writing-skills.md` | two new Baseline rows; reword the monolith row |
| `tests/scenarios/flow-spec-oversized-single-feature.md` | new |
| `tests/scenarios/flow-spec-scope-not-trimmed.md` | new |

`README.md` needs no change — it carries no subsystem or splitting language.

## Out of scope for Part 1

- Any new artifact. No committed consumer file, no backlog, no knowledge base.
- Build order. Nothing records which slice comes next; that stays with the user.
- Escalation to another lane. Cannot ship anyway — there is nothing to escalate to.
- `flow-patch` and `flow-debug` are untouched.

## Considered and dropped

### `flow-discover` — a knowledge-base lane

The idea: a lane above `/flow-spec` that takes an app-scale ask, resolves it into a
committed knowledge base of answered questions, and hands off to `/flow-spec` per
slice. Dropped to keep the skillset small. Recorded here because the reasoning cost
real work and the conclusions outlive the decision.

Prompted by <https://github.com/mattpocock/skills/blob/main/docs/engineering/wayfinder.md>.
Worth knowing that wayfinder is **not** a spec-splitting tool: its tickets hold
questions whose answers are decisions, explicitly "not a slice of a build to execute,"
and it ends "pointing at a spec rather than a PR." It solves *epistemic* scale — too
many open questions to spec at all — where Part 1 solves *executional* scale.

Conclusions worth keeping:

- **Plans rot; decisions do not.** A pre-written queue of six specs is worthless by
  the time you reach spec four, because the codebase moved. Answers to product
  questions ("is the audit log append-only?") stay true. Any future artifact should
  hold decisions, not planned work.
- **Pre-written dependent specs violate flow-spec's own gates.** Step 4 requires
  confirming APIs and helpers exist; step 3 forbids hedges and unresolved
  alternatives. A spec for slice 6, whose helpers slice 3 has not written yet, cannot
  clear that bar. Sharper form: dependency edges are only *needed* for dependent
  slices, and dependent slices are exactly the ones that cannot be pre-specced — the
  feature is only required where it cannot work.
- **Over-planning is the documented failure mode.** A wayfinder field report describes
  27 tickets where "by the time I got to the thirteenth, the rest no longer made
  sense." The fix is bounded destinations and prototyping, not more planning.
- **Its most-reported failure is agents writing production code mid-session.** flow
  already pays this tax deliberately (`flow-spec-orchestrator-implements.md`,
  `flow-spec-orchestrator-writes-test.md`), so a planning-only lane would inherit a
  proven pattern — but would need its own scenarios, since that failure is the
  default gravity.
- **The trigger for such a lane is fog, not size.** A forty-file effort with clear
  requirements needs no discovery — it needs slicing, which is Part 1. Escalation is
  warranted only when a spec meeting flow-spec's bar cannot be written for the *first*
  slice because product intent is undecided.
- **Termination would be "enough fog cleared to spec the next slice,"** not "KB
  complete." A whole-app KB is never done; a session must be. This also bounds the
  interview, which is otherwise the skill's worst failure mode.
- **Answer sourcing:** read the code where code exists, ask the user only where it
  cannot settle it — reusing flow-spec step 1's existing phrasing. Read-only research
  subagents would make this affordable at scale, keeping the orchestrator's context
  clean, the same shape as the execute loop without write access.
- **Lookup, not browsing.** Decisions must be phrased as question-shaped headings so
  `grep -ri currency docs/…` lands on the answer. Otherwise the agent fails to find an
  answer that exists and asks the user anyway — or worse, guesses.
- **Routing, once such a thing exists:** code for facts about the codebase, KB for
  intent, user when neither settles it — and ask on *conflict*, since a stale KB
  treated as authoritative is the mirror failure of bothering the user needlessly.
- **Placement.** It would be a committed **consumer-project** artifact — flow's first;
  everything today is gitignored (`AGENTS.md:137`). `.flow/` cannot host it: with
  `.flow/` in `.gitignore`, a `!.flow/kb/` negation silently does nothing, because git
  will not descend into an excluded directory. Verified. Making it work needs
  `.flow/*` plus a negation, which is a footgun — anyone tidying it back to `.flow/`
  silently un-commits the artifact with no error. `docs/flow/` was the proposal:
  durable next to disposable, one lifecycle per directory.

### `docs/flow/deferred.md` — a backlog of trimmed scope

A smaller version: when the sizing rule cuts something, record it as one
outcome-shaped line in a committed file. Dropped with the KB.

Worth keeping if it ever returns: `Out of Scope` currently conflates *never* with
*not yet*, and only the second wants recording. It would be a log of what a spec
actually cut, never speculative ideas — otherwise it becomes a wishlist within a
month.
