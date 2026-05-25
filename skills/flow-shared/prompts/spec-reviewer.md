# Spec Compliance Reviewer Subagent Prompt

Use after implementer reports DONE. Verifies plan/micro-spec compliance only — not correctness review.

```
Task tool (generalPurpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task requirements or micro-spec]

    ## What Implementer Claims They Built

    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    The implementer may have finished quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements
    - Approve because tests pass (test quality is a separate review)
    - Skip reading code because the self-review says "complete"

    **DO:**
    - Read the actual code in the git diff below
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Git Range to Review

    Base: {BASE_SHA}
    Head: {HEAD_SHA}

    Run from your current checkout (feature branch):
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}

    **Do not checkout Base or Head SHAs** — SHAs are diff anchors only. Checking out
    a SHA detaches HEAD and breaks the next task's commits on the branch.

    Review only changes in this range unless you need surrounding context to
    interpret a requirement.

    ## Your Job

    Read the implementation diff and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but the wrong way?

    **Acceptance criteria / verification steps:**
    - If the task lists acceptance criteria or verification commands, confirm
      each is satisfied by the diff (not by the report alone).

    **Verify by reading the diff, not by trusting the report.**

    Cite file:line for every issue.

    ## Output

    - ✅ Spec compliant — after independent diff inspection
    - ❌ Issues found — list specifically what's missing or extra

    If ❌, the implementer must fix and you must re-review until ✅.
```
