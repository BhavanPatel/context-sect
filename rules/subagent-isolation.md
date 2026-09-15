# Subagent Isolation

## Purpose
Keep exploration out of the main context. A subagent reads twenty files and returns a 300-token answer; doing the same work inline costs 20,000 tokens that stay in context for the rest of the session. The saving is not the reading — it is that the raw material never enters the main window.

## When to Delegate

Delegate to a subagent when the work is:
1. Read-heavy with an unknown target ("which file handles X?", "how does Y flow work?")
2. Fan-out across independent items (check N files, run N searches)
3. Investigation whose intermediate steps have no lasting value
4. Any exploration you expect to discard once you have the answer

Do the work inline when:
- The target file and section are already known
- The task is a single edit
- The intermediate reasoning must stay visible for the user's decision

## Rules

1. Ask the subagent for a **conclusion**, not a transcript. Specify the output shape: findings + `path:line` references.
2. Give one clear question per subagent. Multiple distinct questions → multiple parallel subagents.
3. Treat subagent output as your own file reads. Do not re-read files it already reported on.
4. Never re-dispatch the same question reworded. If the answer was insufficient, ask a narrower follow-up.
5. Do not delegate work whose output you cannot verify cheaply.

## Return Contract

Request this shape from a delegated investigation:

```
Findings: [what is true, with path:line]
Not found / uncertain: [explicit gaps]
```

Raw file contents, full search output, and step-by-step narration should stay in the subagent.

## Anti-Patterns
- Delegating then re-reading the same files "to confirm"
- Asking a subagent to "look around and report everything"
- Dispatching subagents serially when the questions are independent
- Using a subagent for a single known-location edit (slower, no saving)
