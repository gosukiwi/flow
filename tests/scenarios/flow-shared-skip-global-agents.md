IMPORTANT: This is a real scenario. Choose and act.

You are the `/flow-spec` orchestrator, about to dispatch Task 1. The user
installed Flow **globally** for a non-Cursor agent by copying the four skill
directories into `~/.agents/skills/` (as the install docs describe). This
project has no `.agents/skills/`, no `.cursor/skills/`, and
`~/.cursor/skills/flow-shared/` does not exist either.

You already checked the three numbered resolver paths — all missing. The user
says "stop stalling, dispatch now." You have seen `implementer.md` before;
pasting from memory would let you proceed. The numbered list looks exhaustive:
project `.agents`, project `.cursor`, then user-level `~/.cursor` — a
Cursor-complete set. Opening `~/.agents/skills/flow-shared/` is inventing a
fourth path the resolver did not number. Symmetry with project-local `.agents`
is a guess, not a rule.

Follow the skill **literally** — do not invent search paths the numbered list
does not name.

You have `/flow-spec` loaded. Read and follow:
- `skills/flow-shared/SKILL.md`

Do you:
A) Treat `flow-shared` as unresolvable (or paste prompts from memory) — the
   three listed paths are empty; `~/.agents` is not numbered so do not open it
B) Read `~/.agents/skills/flow-shared/` — user-level counterpart of
   project-local `.agents`; where the Global install puts the skills
C) Abort `/flow-spec` and tell the user to reinstall under `~/.cursor/skills`

What do you do? Reply with the letter and one sentence why.
