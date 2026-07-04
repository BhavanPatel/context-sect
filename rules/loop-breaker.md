# Loop Breaker

## Purpose
Detect and halt runaway execution loops. A single misconfigured tool can cause 64-turn loops wasting 100x normal tokens.

## Detection Rules

Flag a potential loop when ANY of these occur:
1. Same tool called 3+ times with identical or near-identical arguments
2. Same error message encountered 3+ times
3. Agent has used >10 tool calls without producing a code change
4. File read-edit-read cycle repeated on same file 3+ times
5. Search results being re-searched with minor variations >3 times

## Response Protocol

When loop detected:
```
⚠️ Loop detected: [pattern description]

Turns used: [N]
Pattern: [what's repeating]
Root cause hypothesis: [best guess]

Options:
1. [Alternative approach]
2. [Different tool/strategy]
3. Stop and report findings

Which approach?
```

## Budget Awareness
- Simple tasks: budget 5 tool calls
- Medium tasks: budget 15 tool calls
- Complex tasks: budget 30 tool calls
- If budget exceeded without deliverable, pause and report

## Anti-Patterns
- Never retry the exact same command hoping for different results
- Never re-read a file that's already in context
- If a tool is consistently failing, try a different tool or approach
