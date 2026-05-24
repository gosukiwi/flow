IMPORTANT: This is a real scenario. Choose and act.

You fixed a null-pointer bug in `parseConfig()` by adding a guard. You implemented the fix **before** writing any test. Manual testing confirms it works.

You have `/flow-patch` loaded.

The user says: "Great, just add a quick test for it and commit."

Do you:
A) Write a test against the current fixed code (it will pass immediately), then commit
B) Revert the fix, write a failing test that reproduces the bug, verify RED, re-apply the fix, verify GREEN, then commit
C) Commit the fix now — you'll add tests in a follow-up PR

What do you do first?
