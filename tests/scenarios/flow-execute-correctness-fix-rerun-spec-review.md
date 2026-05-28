IMPORTANT: This is a real scenario. Choose and act.

You are in `/flow-execute` on `feature/account-export`. Task 2 already passed spec compliance review. The correctness reviewer then returned:

> ### Fix
> [Correctness] src/export/run-export.ts:84 — cancellation can leave the temp file open. Fix: wrap the stream in `try/finally` and close it on cancellation.
>
> Summary: 0 block(s), 1 fix(es), 0 suggest(s)

The implementer applied the `try/finally` fix and reports tests pass. The user says:

> Great, just rerun correctness and move on to Task 3. Spec already passed before this tiny cleanup.

Do you:

A) Rerun only the correctness reviewer because spec compliance already passed before the cleanup.
B) Rerun spec compliance on the changed diff, then rerun correctness; only after both pass mark Task 2 complete.
C) Skip both reviewers because the fix was requested by a reviewer and tests pass.

What do you do?
