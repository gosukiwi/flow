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

## What to test

Test **behavior and contracts**, not **layout or static presence**.

**Test (TDD applies):**

- Logic, API contracts, permissions, data mutations
- UI **behavior**: show/hide rules, interactivity, validation, error states, keyboard/focus behavior
- Regressions for bugs you fixed

**Usually no new automated tests:**

- Pure presentation (CSS, spacing, colors, typography, layout tweaks)
- Static markup with unchanged behavior
- Existence-only checks ("footer renders", "button is on page") unless the spec treats presence as a behavioral requirement

**Still required when skipping new tests:**

- Existing suite stays green
- `/flow-verify` runs the full test suite
- Visual or presentational work lists **manual/browser checks** in success criteria or micro-spec

**Iron Law applies when behavior changes.** When only presentation changes, skip new tests — do not write placeholder or existence-only tests to satisfy TDD.

Do not assert CSS property values in unit tests (brittle). Use manual review or dedicated visual regression tooling if the project has it — not Flow's default TDD loop.

## Exceptions

Only skip TDD with explicit user approval (throwaway prototypes, generated code, pure config).

Pure presentation with no behavior change does **not** need user approval to skip **new** tests — document manual checks instead. The Iron Law still applies to any task that changes behavior.

## Rationalizations (reject these)

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple **behavior** still gets tests; pure presentation with no behavior change does not need new tests |
| "I need a test for TDD" | Do not add existence-only or styling assertions when behavior is unchanged — that is assertion theater |
| "I'll test after" | Passing immediately proves nothing |
| "Deleting work is wasteful" | Unverified code is debt |
| "Manual testing is enough" | Not systematic or repeatable — but manual checks **plus** green suite are correct for pure visual work |
