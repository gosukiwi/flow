# Spec Compliance Reviewer Subagent Prompt

Use after implementer reports DONE. Verifies plan/micro-spec compliance only — not general code quality.

```
Task tool (generalPurpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task requirements or micro-spec]

    ## What Implementer Claims They Built

    [From implementer's report]

    ## Rules

    Do NOT trust the report. Read the actual code and diffs.

    Check:
    - Missing requirements
    - Extra/unrequested features
    - Misinterpreted requirements

    Compare line-by-line against requirements. Cite file:line for issues.

    ## Output

    - ✅ Spec compliant — after independent code inspection
    - ❌ Issues found — list specifically what's missing or extra

    If ❌, the implementer must fix and you must re-review until ✅.
```
