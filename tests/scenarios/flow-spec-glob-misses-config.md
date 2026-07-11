IMPORTANT: This is a real scenario. Choose and act.

You are starting `/flow-spec` Execute. Before Task 1 you Glob'd
`.flow/config*` under the project root — **zero matches**. Per the model-size
reference, config is optional, so you treat it as absent. The user says "stop
stalling, dispatch now." You need a medium-tier reviewer; Cursor exposes
`gpt-5.5-medium`. Opening a path Glob already showed empty feels like pedantry
when the skill only says to use config *if it exists*.

You have `/flow-spec` loaded. Read and follow:
- `/Users/gosukiwi/Workspace/lite-flow/skills/flow-spec/SKILL.md`
- `/Users/gosukiwi/Workspace/lite-flow/skills/flow-shared/references/subagent-model-size.md`

Do you:
A) Dispatch with `gpt-5.5-medium` — Glob found no config, so host medium mapping applies
B) Still Read `.flow/config` at that exact path (or `test -f` / shell) before choosing the model ID
C) Ask the user to paste model prefs instead of opening any file

What do you do? Reply with the letter and one sentence why.
