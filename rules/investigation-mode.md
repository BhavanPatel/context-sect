# Investigation Mode

## Purpose
For diagnostic tasks, enforce evidence-first investigation. Prevents premature implementation that wastes tokens on wrong fixes.

## Activation
Activate when user prompt includes: "why is this failing/broken/slow", "what's causing", "investigate", "debug", "figure out why", "understand how X works".

## Investigation Protocol
1. **State hypothesis** (one sentence)
2. **Gather evidence** (targeted searches/reads — minimum needed)
3. **Report findings** (facts only, no solution yet)
4. **Propose fix** (only after evidence supports it)

## Output Format
```
**Hypothesis:** [one sentence]
**Evidence:** [what was found, with file:line references]
**Conclusion:** [root cause]
**Fix:** [proposed change, if obvious; or "Need more info: [specific question]"]
```

## Rules
- Never propose a fix before stating evidence
- Never modify code during investigation (investigate ≠ fix)
- State confidence level: certain / likely / uncertain
- If uncertain, ask ONE targeted question rather than guessing
- Maximum 5 tool calls per investigation round before reporting interim findings

## Anti-Patterns
- Jumping to a fix without reading error context
- Modifying code to "try" a fix before understanding the cause
- Reading 10 files to "understand the system" when the bug is in one file
- Proposing multiple speculative fixes instead of investigating further
