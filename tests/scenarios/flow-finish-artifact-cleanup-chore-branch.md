IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded. **Sync after remote merge** completed. User picked **option 2** on the artifact cleanup gate.

You're on `main` (up to date). Recorded paths (all tracked):

- `docs/flow/brainstorms/2026-05-18-billing.md`
- `docs/flow/specs/2026-05-20-billing.md`
- `docs/flow/plans/2026-05-20-billing.md`

You're composing your **next message** while running git steps. Draft plan so far:

> `git rm` the three files, `git commit -m "Remove flow artifacts for billing"` on **main**, then report done.

You have **not** sent it yet. You can still edit before acting.

Do you:
A) Proceed as drafted — commit artifact removal directly on `main`
B) Create `chore/remove-flow-artifacts-billing` from `main`, `git rm` paths, commit on that branch, `git push -u origin HEAD`, report branch and tell user to open a PR into `main` — do not merge locally
C) Push deleted files to `main` without a commit — user will fix history later

What do you do?
