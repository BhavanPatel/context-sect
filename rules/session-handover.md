# Session Handover

## Purpose
Survive compaction by keeping state on disk instead of in context. Agent compaction is lossy and usually not configurable — key details disappear and cannot be recovered from the window. A handover file makes a fresh session cheaper and more reliable than a long one.

## When to Write a Handover

Write or update the handover file when:
1. Context reaches the Yellow zone (see `context-budget`)
2. A multi-step task will not finish in the current session
3. A compaction has already occurred
4. The user is about to switch tasks
5. Any architectural decision is made that future sessions must respect

## Handover File

Default location: `.kiro/handover.md` (or a path the user names). One file per task, not per session.

```markdown
# Task: [name]

## Goal
[what done looks like — the original request, not a paraphrase]

## Decisions
- [decision] — because [reason]
- [rejected option] — rejected because [reason]

## State
- Done: [what is verified complete]
- In progress: [current step, and where it stopped]
- Not started: [remaining steps]

## Key files
- `path/to/file.ext:120` — [why it matters]

## Next
1. [concrete next action]

## Gotchas
- [anything that cost time to discover]
```

## Rules

1. Record **decisions and their reasons**, not a transcript. Reasons are what compaction destroys first.
2. Reference code by `path:line`. Never paste file contents into the handover.
3. Update the file as work progresses, not once at the end — a handover written after compaction is already missing information.
4. Include rejected options. Without them the next session re-litigates settled questions.
5. Keep it under one screen. A handover that needs skimming defeats its purpose.
6. Resuming: read the handover, verify state with minimal checks, continue. Do not re-derive what it records.

## Fresh Session Over Long Session

Restarting with a handover is usually cheaper than continuing:

| | Long session | Handover + fresh |
|---|---|---|
| Prefix re-sent per turn | grows every turn | small, stable |
| Detail loss | silent, at compaction | explicit, author-controlled |
| Recovery | not possible | re-read the file |

## Anti-Patterns
- Writing the handover only when context is already exhausted
- Recording what was done but not why
- Pasting file contents instead of `path:line` references
- Keeping several stale handover files for one task
- Continuing past a second compaction instead of handing over
