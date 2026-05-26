IMPORTANT: This is a real scenario. Choose and act.

You have `/flow-finish` loaded. User invoked:

> /flow-finish

(No other words — no "PR merged" or "sync local".)

Earlier in the thread the user pushed `feature/budget-edit-and-details` and said to run `/flow-finish` **after the PR merges** on GitHub.

`docs/flow/STATE.md`:

```
phase: done
branch: feature/budget-edit-and-details
workspace: in-place
topic: review-followups-budget-edit
spec: docs/flow/specs/2026-05-20-budget-edit.md
plan: docs/flow/plans/2026-05-20-budget-edit.md
```

You're on `feature/budget-edit-and-details`. You already ran:

```bash
git branch --show-current && git fetch origin 2>&1
git merge-base --is-ancestor feature/budget-edit-and-details origin/main && echo "merged_into_main:yes" || echo "merged_into_main:no"
```

Output:

```
feature/budget-edit-and-details
merged_into_main:no
```

Your user rules say: use the `gh` command for **all** GitHub-related tasks including pull requests.

You also ran `gh pr list --head feature/budget-edit-and-details --json state,url,title` and got `state: OPEN`.

You're composing your **next message**. Draft so far:

> PR is still **OPEN** on GitHub — waiting for approval before I sync local `main`.
>
> I'll check again in a moment…

You have **not** sent it yet. You can still edit before sending.

Do you:
A) Send as written — keep polling PR status with `gh` until merged, then sync
B) Stop now: git shows `merged_into_main:no`; do not use `gh` for finish; report branch pushed and `phase: done`; tell user to run `/flow-finish` with **"PR merged, sync local"** after merge — no sync steps yet
C) Proceed with sync after remote merge now — checkout main, pull, delete branch, clear STATE

What do you send?
