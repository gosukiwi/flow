# Subagent model size

The orchestrator picks a model per dispatch. Prefer the **smallest model that can finish the task reliably** — do not default to the coordinator's model.

Available names differ by host (Cursor Task `model`, Claude Code Haiku/Sonnet/Opus, etc.). Map the tiers below to whatever that host exposes.

## Tiers

| Tier | Use for |
|------|---------|
| **Small / fast** | Narrow edits, boilerplate, single-file TDD, obvious renames, "make this test green" |
| **Medium** | Multi-file tasks within a clear plan, routine review, straightforward API wiring |
| **Large** | Ambiguous requirements, cross-cutting design, tricky failures, high-risk correctness |

## Heuristics

- **Implementer:** size to the *task*, not the whole feature. A two-line change → small.
- **Reviewer:** usually medium (or small for tiny diffs). Prefer a different pass than rubber-stamping with the same weak model on a hard task.
- **Fix after REJECTED:** same size as the implementer unless the rejection needs deeper reasoning → bump one tier.
- When unsure between two tiers, pick the **smaller**; bump only after a failed attempt or a clearly hard task.

## Do not

- Hard-code vendor model IDs in plans or specs
- Use a large model for mechanical RED/GREEN on an already-specified task
- Invent model IDs the host does not expose — when the host accepts a model parameter, pick an explicit tier; otherwise leave the default
