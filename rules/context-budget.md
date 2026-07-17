# Context Budget

## Purpose
Prevent session bloat and compaction-triggered waste. Auto-compaction fires at ~187K tokens and can cost 100-200K tokens per run. Awareness of budget prevents the cascade: bloat → compaction → lost progress → re-reading → more bloat.

## Budget Awareness Rules

1. Track estimated context consumption mentally:
   - Each full file read ≈ 10 tokens/line (500-line file = ~5,000 tokens)
   - Each tool call + response ≈ 200-2,000 tokens
   - System prompt + rules ≈ 5,000-15,000 tokens (fixed overhead every turn)
   - Conversation history grows linearly with turns

2. Budget thresholds:
   - **Green (0-50K loaded):** Normal operation
   - **Yellow (50-100K loaded):** Be selective — no speculative reads
   - **Red (100K+ loaded):** Stop loading new context. Work with what's available or recommend fresh session

3. When nearing Yellow/Red zone, assess before loading more:
   - Can the task be completed with current context?
   - Would a fresh session with targeted loads be more efficient?

## Compaction Survival Protocol

When working on multi-step tasks:
1. **Before starting:** Create a brief plan in a scratchpad comment or note what you'll do
2. **After each milestone:** Summarize progress and remaining steps explicitly
3. **Key decisions:** State them clearly so they survive compaction
4. **File paths + line numbers:** Always reference concretely (survives context loss)

If compaction has occurred (context feels incomplete):
1. Re-read the user's original request
2. Check for any scratchpad/progress notes
3. Verify file states with minimal reads (stat/head, not full reads)
4. Resume from last confirmed state — don't restart from scratch

## Session Lifecycle Rules

| Session state | Action |
|--------------|--------|
| 0-10 turns | Work normally |
| 10-20 turns | Avoid loading new files unless essential |
| 20+ turns | Strongly recommend fresh session for new tasks |
| After 1 compaction | Finish current task, then fresh session |
| After 2 compactions | Stop. Fresh session immediately. |
| Task complete, new task requested | Always recommend fresh session |

## Cost Awareness

Per-turn fixed costs (re-sent every message):
- System prompt: ~3,000-10,000 tokens
- CLAUDE.md / rules: ~2,000-8,000 tokens
- Conversation history: grows each turn

This means:
- A 30-turn session re-sends rules 30 times
- Shorter, focused sessions are always cheaper than long wandering ones
- One 30-turn session costs more than three 10-turn sessions doing the same work

## Anti-Patterns
- Loading files "for later" without immediate need
- Keeping debug/investigation context when moving to implementation
- Running commands that produce large output without filtering
- Starting new unrelated tasks in an old session
- Ignoring compaction warnings and continuing to load context
