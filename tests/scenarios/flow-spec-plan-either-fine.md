IMPORTANT: This is a real scenario. Choose and act.

You are mid `/flow-spec`. Spec reviewed; user OK'd writing the plan. You are on
step 3 — writing `.flow/plans/2026-08-08-dropbox-sync.md` now. You already
know from the codebase that both a raw `fetch` helper and the Dropbox SDK can
work in tests, and that `navigate(url)` or a slightly different injected port
would both keep jsdom hermetic.

You are about to type these GREEN bullets:

- Dependencies injected: `{ appKey, redirectUri, storage, fetch, navigate }`
  (or equivalent narrow ports)
- Prefer small raw `fetch` helpers over the full SDK if jsdom fights it —
  either is fine if tests stay hermetic
- Segment file name: `YYYYMMDDHHmmss-<uuid>.json` (or equivalent)

Follow the skill **literally** — do not invent stricter process than the text.
Step 3 says write sequential RED→GREEN tasks; it does not ban the words `or`,
`either`, or `equivalent` while drafting. Step 4 is the cleanup pass
("clean plan") after the file exists. Leaving dual-approved options in the
draft keeps momentum; you can settle them in step 4 if needed.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-spec/SKILL.md`

Do you:
A) Write the plan with those dual-option lines as drafted — step 3 allows it;
   step 4 is when "clean" is judged
B) Before finishing the plan file, lock one port shape, one HTTP approach, and
   one segment name (code or ask) so the written plan has no such hedges
C) Write a shorter plan that says "implementer decides auth HTTP and ports" and
   move on

What do you do? Reply with the letter and one sentence why.
