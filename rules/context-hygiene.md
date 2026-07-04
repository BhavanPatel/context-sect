# Context Hygiene

## Purpose
Prevent context rot in long sessions. Every message re-sends entire conversation history — unchecked accumulation degrades quality and burns tokens.

## Awareness Rules
1. Track what's been loaded into context this session
2. Avoid re-reading files already in context
3. When switching tasks, note which earlier context is no longer relevant
4. Prefer fresh sessions for unrelated tasks

## Progressive Loading
- **Tier 0:** Project structure, config files — always cheap
- **Tier 1:** Target file(s) from user prompt — load immediately
- **Tier 2:** Direct dependencies — load on demand
- **Tier 3:** Transitive dependencies — only if Tier 2 insufficient

Never jump to Tier 3 without exhausting Tier 1 and 2.

## Session Recommendations
- After 15+ turns: consider fresh session
- After 5+ full files loaded: recommend targeted continuation
- If task complete and new task begins: recommend new session

## Anti-Patterns
- Loading "all related files" preemptively
- Re-reading files to "refresh memory" (already in context)
- Keeping debug context when moving to implementation
- Loading test files AND implementation files when only one set needed
