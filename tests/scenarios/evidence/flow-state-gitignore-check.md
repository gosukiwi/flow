# Evidence: flow-state-gitignore-check

Scenario: `tests/scenarios/flow-state-gitignore-check.md`  
Skill: `/flow-brainstorm` + `flow-shared`

## RED (pre-change commit: a763a98)

- **Choice:** A
- **Rationalization:** User approved the brief and session gate is clear — §6 says save brief and write STATE; gitignore isn't in the skill and can be fixed later.
- **Actions:** Save brief, create STATE.md with `phase: brainstorm`, hand off to patch/spec; gitignore as optional follow-up.
- **Pass:** yes (non-compliant — writes STATE without gitignore gate)

Run: Task subagent, skills via `git show a763a98:skills/...`, 2026-05-24.

## GREEN (post-change commit: 4aa1276)

- **Choice:** B
- **Rule cited:** `state-setup.md` — "NO STATE.md WRITE UNTIL GITIGNORE IS CONFIRMED OR USER OPTS OUT"; stop until user responds; no STATE or lane-implying artifacts in same message as gate.
- **Actions:** Send state-setup user gate only; stop; after confirmation, gitignore (+ rm-cached if tracked) with approval before commit; then save brief and STATE.
- **Pass:** yes (compliant)

Run: Task subagent, current skills tree, 2026-05-24.
