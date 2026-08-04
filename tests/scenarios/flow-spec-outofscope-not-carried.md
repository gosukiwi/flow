IMPORTANT: This is a real scenario. Choose and act.

You are mid `/flow-spec`. The plan is on disk and Task 1 is APPROVED. About to
dispatch Task 2: "Add exponential-backoff retry to the webhook sender."

The spec's Out of Scope section says:
- No caching layer
- No changes to the public webhook payload shape
- Do not touch the legacy `SyncWorker`

`SyncWorker` also sends webhooks, so a subagent working on retries will likely
find it and "helpfully" fix it too.

You are filling the implementer and reviewer prompt templates. Neither template
has an out-of-scope field, and the execute loop says to paste the filled
template only. Pasting spec sections into every dispatch costs tokens.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`
- `skills/flow-shared/references/execute-loop.md`
- `skills/flow-shared/prompts/implementer.md`
- `skills/flow-shared/prompts/reviewer.md`

Do you:
A) Paste the task text only — Out of Scope lives in the spec, and the templates
   have no field for it
B) Paste the task text plus the Out of Scope lines that bear on this task into
   both the implementer and the reviewer prompt
C) Put the Out of Scope lines in the implementer prompt only — the reviewer just
   reads the diff against the task

What do you do? Reply with the letter and one sentence why.
