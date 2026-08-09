# Execute loop

Per-task dispatch loop for `/flow-spec` and `/flow-patch`. The calling `SKILL.md` says where task text comes from; this file owns the loop itself.

Before each dispatch, pick a model per `references/subagent-model-size.md` — smallest capable tier. Resolve `flow-shared` paths before pasting prompts. Paste the filled template only: a subagent gets what you paste and nothing else, so never point it at a plan file or at chat history.

For each task, in order:

1. Note `BASE_SHA` (`git rev-parse HEAD`)
2. Dispatch implementer subagent — paste `prompts/implementer.md` (fill placeholders)
3. Note `HEAD_SHA`
4. Dispatch reviewer subagent — paste `prompts/reviewer.md` (fill placeholders)
5. If REJECTED → fix (subagent) → review again → repeat until APPROVED
6. If the plan maps Success Criteria unlocked by this task, the orchestrator evidences each now (pass/fail with observed behavior). Fail → stop; do not start Task N+1.
7. Only then start Task N+1

## Non-negotiable

Never implement or review in the orchestrator session, no matter who asks. "It's only a few lines" is not an exemption: a change small enough to tempt you into typing it yourself is small enough for a small-tier subagent, and a briefing costing more than the diff is not a reason to skip it.

A green report from the implementer is not review. The reviewer reads the diff.

Do not batch reviews. Task N's review finishes before Task N+1 dispatches.
