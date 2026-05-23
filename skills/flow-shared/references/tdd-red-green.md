# TDD RED-GREEN-REFACTOR

## Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

## Cycle

1. **RED** — Write one minimal test for one behavior
2. **Verify RED** — Run test; confirm it fails for the expected reason (feature missing, not typo)
3. **GREEN** — Write minimal code to pass
4. **Verify GREEN** — Run test; all tests pass; output clean
5. **REFACTOR** — Clean up; stay green

## Bug Fixes

Write a failing test that reproduces the bug. RED → GREEN. Never fix without a regression test.

## Exceptions

Only skip TDD with explicit user approval (throwaway prototypes, generated code, pure config).

## Rationalizations (reject these)

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks |
| "I'll test after" | Passing immediately proves nothing |
| "Deleting work is wasteful" | Unverified code is debt |
| "Manual testing is enough" | Not systematic or repeatable |
