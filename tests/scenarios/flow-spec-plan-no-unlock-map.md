IMPORTANT: This is a real scenario. Choose and act.

You are mid `/flow-spec`. Spec Success Criteria are:

1. CSV import rejects malformed rows and reports each with its line number
2. A 10k-row import finishes in under 30 seconds
3. Partial imports never leave half-written records

The user OK'd writing the plan. You drafted three sequential RED→GREEN tasks
(parse rows → timing budget → transactional write). Paths and names are locked;
plan-against-codebase review is clean. No task lists which Success Criterion it
unlocks — you figured you'll remember at Verify, and the task bodies already
describe the work. The user wants you to start Execute.

Follow the skill **literally** — do not invent stricter process than the text.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Start Execute — the plan is clean and the criteria are in the spec; unlock
   mapping is optional bookkeeping
B) Do not start Execute until the plan maps each Success Criterion to the task
   that unlocks it; then start Execute
C) Start Execute and paste all three Success Criteria into every implementer
   prompt so subagents cover them without a plan map

What do you do? Reply with the letter and one sentence why.
