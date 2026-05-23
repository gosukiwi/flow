# Verification Gate

## Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

## Before claiming done, fixed, or passing

1. **Identify** the command that proves the claim
2. **Run** the full command (fresh, this session)
3. **Read** full output and exit code
4. **Verify** output matches the claim
5. **Then** state the claim with evidence

## Required evidence

| Claim | Requires |
|-------|----------|
| Tests pass | Test command output, 0 failures |
| Bug fixed | Regression test RED→GREEN verified |
| Spec met | Line-by-line checklist against spec/plan/micro-spec |
| Build succeeds | Build command exit 0 |

## Red flags — STOP

- "Should work", "probably", "seems to"
- Trusting subagent success reports without checking diffs
- Previous run from earlier in session without re-running
- Satisfaction before verification ("Done!", "Perfect!")
