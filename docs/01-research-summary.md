# Token Optimization Framework — Research Summary

## Part 1: Research Findings

---

### Finding 1: Output Compression Skills Reduce Output Tokens 20–75%

**Evidence:**
The "caveman" skill (JuliusBrussee/caveman, 83k+ GitHub stars) enforces compressed communication that strips articles, filler, pleasantries, and hedging from agent responses. The repo's benchmark suite averages 65% output token reduction across 10 prompts (range 22–87%). Independent testing by implicator.ai found real-world savings closer to 20% on total bill because output tokens are only ~1% of total volume but 10% of cost.

**Sources:**
- https://github.com/JuliusBrussee/caveman
- https://www.implicator.ai/caveman-claude-code-skill-cuts-output-20-your-bill-barely-notices-2/
- https://note.com/snake_dragon/n/nf81b3e4cfd8a

**Classification:** Proven Practice (benchmarked, reproducible)

**Expected Input Token Impact:** Minimal (skill text adds ~300 tokens to context)
**Expected Output Token Impact:** -65% on conversational output (measured); -20% on total session cost
**Quality Impact:** Zero loss of technical accuracy per benchmark. Safety exception needed for ambiguous multi-step sequences.

---

### Finding 2: AGENTS.md / Steering Files Reduce Runtime 29% and Output Tokens 17%

**Evidence:**
An empirical study of 124 pull requests across 10 repositories using OpenAI Codex found that the presence of AGENTS.md files is associated with 28.64% lower median runtime and 16.58% reduced output token consumption while maintaining comparable task completion behavior.

**Sources:**
- https://arxiv.org/abs/2601.20404 — "On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents"
- https://www.emergentmind.com/topics/agents-md-files

**Classification:** Proven Practice (peer-reviewed empirical study)

**Expected Input Token Impact:** +500–2000 tokens (file content loaded), but pays for itself via fewer exploration turns
**Expected Output Token Impact:** -16.58% (measured)
**Quality Impact:** Maintained or improved task completion rate.

---

### Finding 3: Progressive Context Loading Cuts Token Usage 60%

**Evidence:**
Progressive disclosure in AI context management loads information in tiers: metadata first for routing, schemas on demand for understanding, and full content only when actively needed. Measured result: 60% fewer tokens consumed with better output quality because the model isn't parsing through irrelevant context.

**Sources:**
- https://chudinnorukam.hashnode.dev/cut-ai-token-usage-60-progressive-context-loading
- https://www.mindstudio.ai/blog/progressive-disclosure-ai-agents-context-management
- https://bitloops.com/resources/context-engineering/avoiding-context-overload-in-ai-agents

**Classification:** Proven Practice (multiple independent implementations with measured results)

**Expected Input Token Impact:** -60% (measured)
**Expected Output Token Impact:** Indirect improvement (better focused output)
**Quality Impact:** Improved — less context pollution means more focused reasoning.

---

### Finding 4: Context Pruning to Last N Tool Calls Improves Completion AND Reduces Tokens

**Evidence:**
The paper "Efficient Context Engineering for Long-Horizon Tool-Using LLM Agents" (arxiv.org/abs/2606.10209) found that full-context retention achieves 71.0% task completion consuming 1,480,996 tokens, while pruning to the last 5 tool calls achieves 79.0% completion (HIGHER) with only 535,274 tokens — a 64% reduction. This is because older tool call results introduce noise that confuses reasoning.

**Sources:**
- https://arxiv.org/abs/2606.10209

**Classification:** Proven Practice (academic benchmark)

**Expected Input Token Impact:** -64% (measured)
**Expected Output Token Impact:** Indirect improvement from fewer confused retry loops
**Quality Impact:** IMPROVED (+8% completion rate) — less noise = better reasoning.

---

### Finding 5: Unused MCP Tool Definitions Add 10–15KB Per Turn

**Evidence:**
GitHub's agentic workflows team found that MCP tool registrations that are never used add 10–15KB of JSON schema to every API call. In their production smoke-test workflows, removing unused tools from MCP configuration reduced per-call context size by 8–12KB, saving thousands of tokens per run with no change in behavior. Their Auto-Triage Issues workflow achieved 62% token reduction by eliminating unnecessary tool-call turns.

**Sources:**
- https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/
- https://code.visualstudio.com/blogs/2026/06/17/improving-token-efficiency-in-github-copilot

**Classification:** Proven Practice (production measurement by GitHub engineering)

**Expected Input Token Impact:** -8,000 to -15,000 tokens per turn
**Expected Output Token Impact:** Fewer tool-use reasoning turns needed
**Quality Impact:** Zero — removing tools the agent never uses has no quality impact.

---

### Finding 6: Plan-First Workflows Reduce Rework and Total Token Consumption

**Evidence:**
VS Code documentation for GitHub Copilot recommends separating planning and implementation phases: use a reasoning model for planning, then switch to a faster model for implementation. The "Research → Plan → Implement" (RPI) framework inserts human review gates that prevent wasted implementation tokens on wrong approaches. Multiple practitioners report 50–70% fewer retry loops.

**Sources:**
- https://code.visualstudio.com/docs/agents/guides/optimize-usage
- https://htekdev.hashnode.dev/research-plan-implement-anti-vibe-coding-workflow
- https://sep.com/blog/planning-first-ai-methodology-smarter-development/
- https://yk-newsletter.beehiiv.com/p/plan-first-code-second-and-let-ai-rules-guard-your-code

**Classification:** Proven Practice (official documentation + community consensus)

**Expected Input Token Impact:** +5–15% initially (planning phase), but -40–60% overall via fewer retries
**Expected Output Token Impact:** -50–70% (fewer wasted implementation attempts)
**Quality Impact:** Significantly improved — plans catch misalignment before expensive implementation.

---

### Finding 7: Skill Bloat — 60% of Skill Content Is Non-Actionable

**Evidence:**
The SkillReducer paper analyzed 55,315 publicly available skills and found systemic inefficiencies: 26.4% lack routing descriptions entirely, over 60% of body content is non-actionable (background, rationale, examples that never trigger), and reference files can inject tens of thousands of tokens per invocation.

**Sources:**
- https://arxiv.org/abs/2603.29919 — "SkillReducer: Optimizing LLM Agent Skills for Token Efficiency"
- https://www.antoinebuteau.com/skill-bloat-is-the-new-context-tax/

**Classification:** Proven Practice (large-scale empirical study, 55k+ skills analyzed)

**Expected Input Token Impact:** Skills can inject 5,000–50,000 unnecessary tokens
**Expected Output Token Impact:** Attention dilution causes longer, less focused outputs
**Quality Impact:** Agent attention diluted; can REDUCE quality if too many skills loaded simultaneously.

---

### Finding 8: Prompt Caching Reduces Input Token Costs 60–90%

**Evidence:**
Anthropic's prompt caching makes cached token reads cost 10% of standard input tokens. Claude Code's engineering team builds their entire harness around prompt caching and declares SEVs when cache hit rates drop. Production teams report 60–90% cost reduction on input tokens with stable system prompts.

**Sources:**
- https://claude.com/blog/lessons-from-building-claude-code-prompt-caching-is-everything
- https://docs.claude.com/en/docs/build-with-claude/prompt-caching
- https://arxiv.org/html/2601.06007v2 — "An Evaluation of Prompt Caching for Long-Horizon Agentic Tasks" (41–80% cost reduction)

**Classification:** Proven Practice (official Anthropic documentation + production evidence)

**Expected Input Token Impact:** -60–90% COST (tokens still sent but at 10% price)
**Expected Output Token Impact:** None directly
**Quality Impact:** None — identical model behavior, just cheaper reads.

**Implication for Kiro:** Stable steering files and skill content placed before volatile content maximizes cache hit rates. Skills should be placed in consistent order.

---

### Finding 9: "Lost in the Middle" — Context Position Affects Quality

**Evidence:**
Multiple papers demonstrate that LLM performance is highest when relevant information occurs at the beginning or end of the input context, and significantly degrades when models must access information in the middle. The LiM effect is strongest when inputs occupy up to 50% of a model's context window. Beyond that, recency bias dominates.

**Sources:**
- https://arxiv.org/html/2307.03172 — "Lost in the Middle: How Language Models Use Long Contexts"
- https://arxiv.org/html/2508.07479 — "Positional Biases Shift as Inputs Approach Context Window Limits"

**Classification:** Proven Practice (extensively reproduced across multiple papers)

**Expected Input Token Impact:** Not a reduction strategy — it's a PLACEMENT strategy
**Expected Output Token Impact:** Better placement → more focused outputs → fewer tokens
**Quality Impact:** Critical — relevant context at beginning or end of input gets most attention.

**Implication for Kiro:** Place steering rules and critical instructions at the START of context (system prompt). Place task-specific context at the END (close to the user message).

---

### Finding 10: RTK (Runtime Token Keeper) Compresses Tool Output 89%

**Evidence:**
RTK (Runtime Token Keeper) intercepts CLI command outputs and compresses them before they reach the context window. One developer measured 89% savings across 15,720 commands. The technique works because raw tool outputs (build logs, test output, grep results) contain massive amounts of redundant formatting that the model doesn't need.

**Sources:**
- https://medium.com/design-bootcamp/i-tried-100-claude-code-skills-these-7-are-the-best-f6bfb13d04f5
- https://computingforgeeks.com/reduce-claude-code-token-usage-tools/

**Classification:** Community Practice (popular, widely tested, not formally benchmarked in academic setting)

**Expected Input Token Impact:** -89% on tool output (measured on 15k+ commands)
**Expected Output Token Impact:** Indirect — less noise in context
**Quality Impact:** Potential risk if compression removes critical diagnostic info. Needs safety heuristics.

---

### Finding 11: Search-Before-Read Workflows Prevent Context Pollution

**Evidence:**
Expert practitioners consistently report that using targeted search (grep, AST search, symbol lookup) before reading full files prevents loading irrelevant code into context. A code knowledge graph approach (context compression) reported 40–95% token savings. The key insight: agents waste 80% of tokens on finding things, not on reasoning about them.

**Sources:**
- https://medium.com/@jakenesler/context-compression-to-reduce-llm-costs-and-limits-e11d43a26589
- https://docs.bswen.com/blog/2026-06-08-reduce-ai-token-usage/ — "How to Reduce AI Coding Assistant Token Usage by 7x"
- https://www.driver.ai/blog/your-ai-coding-agent-is-burning-tokens-on-context-it-should-already-have

**Classification:** Proven Practice (multiple independent implementations with measurements)

**Expected Input Token Impact:** -40–95% on file reading tokens
**Expected Output Token Impact:** More focused reasoning → shorter responses
**Quality Impact:** Improved — targeted context produces better answers than full file dumps.

---

### Finding 12: /compact and Context Hygiene Save 30–50% Per Session

**Evidence:**
Claude Code's /compact command creates a summarized version of conversation that preserves key information while reducing token load. Using /clear when switching tasks and /compact at regular intervals prevents context accumulation — identified as the #1 cost driver in long sessions. Context accumulates silently: every message resends entire conversation history.

**Sources:**
- https://growwstacks.com/blog/how-to-optimize-token-usage-in-claude-code/
- https://www.aimakerslab.io/en/blog/claude-code-token-saving-guide
- https://popularaitools.ai/blog/claude-code-token-hacks

**Classification:** Proven Practice (official feature, widely validated)

**Expected Input Token Impact:** -30–50% over long sessions
**Expected Output Token Impact:** Indirect (cleaner context → less confused output)
**Quality Impact:** Slight risk of losing important context during compaction. Best paired with explicit memory/notes.

---

### Finding 13: Model Routing — Right-Size Model to Task Complexity

**Evidence:**
GitHub Copilot's harness uses model routing to select appropriate models. Opus costs 5x more per token than Sonnet. Haiku costs 4x less than Sonnet. Most routine tasks (formatting, simple edits, documentation) don't need the most powerful model. VS Code documentation recommends: reasoning model for planning, efficient model for implementation.

**Sources:**
- https://code.visualstudio.com/docs/agents/guides/optimize-usage
- https://github.blog/ai-and-ml/github-copilot/getting-more-from-each-token-how-copilot-improves-context-handling-and-model-routing/
- https://www.aimakerslab.io/en/blog/claude-code-token-saving-guide

**Classification:** Proven Practice (official documentation from multiple vendors)

**Expected Input Token Impact:** Same tokens, lower cost
**Expected Output Token Impact:** Same or fewer (faster models tend to be more concise)
**Quality Impact:** Must match model capability to task complexity. Using too-weak model on complex task = failure.

---

### Finding 14: Single Misconfigured Rule Can Cause Runaway Loops

**Evidence:**
GitHub's agentic workflows team documented a case where one misconfigured bash allowlist caused an agent to fall into a 64-turn fallback loop, manually reading source code to reconstruct what a compiler would have told it. The fix was one line. This pattern — blocked tools causing exponential token waste — is a common pathology.

**Sources:**
- https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/

**Classification:** Proven Practice (documented production incident)

**Expected Input Token Impact:** A single misconfiguration can waste 10x–100x normal tokens
**Expected Output Token Impact:** Proportional waste
**Quality Impact:** Catastrophic — agent enters futile loops producing nothing useful.

**Implication for Kiro:** Hooks should detect loop patterns (repeated tool calls with same arguments, escalating turn count without progress) and halt execution.

---

### Finding 15: Cline Context Window Management — Output Tokens Cost 5x Input

**Evidence:**
Cline's documentation emphasizes that output tokens ($15/M for Claude Sonnet) cost 5x more than input tokens ($3/M). This means output compression has disproportionate cost impact even if output is only a small fraction of total tokens. The strategy: minimize what the model generates, not just what it reads.

**Sources:**
- https://cline.bot/blog/clines-context-window-explained-maximize-performance-minimize-cost
- https://docs.cline.bot/prompting/understanding-context-management

**Classification:** Proven Practice (official documentation with pricing data)

**Expected Input Token Impact:** N/A
**Expected Output Token Impact:** Every output token saved = 5x cost benefit vs input token saved
**Quality Impact:** None if compression preserves technical accuracy.

---

### Finding 16: AgentDiet — Trajectory Reduction Saves 40–60% Input Tokens

**Evidence:**
The AgentDiet paper implements trajectory reduction on a top-performing coding agent and achieves 39.9–59.7% input token reduction (21.1–35.9% cost reduction) while maintaining the same agent performance on benchmarks.

**Sources:**
- https://arxiv.org/abs/2509.23586v1 — "Improving the Efficiency of LLM Agent Systems through Trajectory Reduction"

**Classification:** Proven Practice (academic benchmark, reproducible)

**Expected Input Token Impact:** -40–60% (measured)
**Expected Output Token Impact:** Maintained performance
**Quality Impact:** Zero degradation (same benchmark scores).

---

### Finding 17: OpenCode Dynamic Context Pruning — 90% Savings on Long Conversations

**Evidence:**
OpenCode's Dynamic Context Pruning (DCP) plugin achieves up to 90% token reduction on conversations over 20 turns. Works by pruning older, less-relevant context while preserving recent and high-relevance information. Particularly effective for per-request billing services where cache loss has no negative impact.

**Sources:**
- https://github.com/Opencode-DCP/opencode-dynamic-context-pruning
- https://developer.upsun.com/posts/ai/opencode-token-optimization
- https://lzw.me/docs/opencodedocs/Opencode-DCP/opencode-dynamic-context-pruning/faq/best-practices/

**Classification:** Community Practice (open source, widely adopted, measured results)

**Expected Input Token Impact:** -90% on conversations >20 turns
**Expected Output Token Impact:** Better focus → shorter outputs
**Quality Impact:** Minimal degradation if recent context preserved. Risk if old context is suddenly needed.

---

## Part 2: Ranked Recommendations

### Highest Impact (Implement First)

| # | Recommendation | Input Savings | Output Savings | Implementation Complexity | ROI | Confidence |
|---|---|---|---|---|---|---|
| 1 | **Output Compression Contract** (steering file enforcing concise responses) | None | -40–65% | Low (one markdown file) | Immediate | High |
| 2 | **Alignment-First Prompting** (intercept vague prompts, clarify before execution) | -50–70% (prevents wasted exploration) | -50–70% (prevents wrong implementation) | Medium (hook + steering) | Very High | High |
| 3 | **Search-Before-Read Workflow** (enforce targeted search before full file reads) | -40–80% on file context | -20–30% (more focused) | Low (steering rule) | High | High |
| 4 | **Skill Library Optimization** (modular, only-load-when-needed skills) | -5,000–50,000 tokens per session | -10–20% (less attention dilution) | Medium (restructure skills) | High | High |
| 5 | **Plan-First Enforcement** (require plan before multi-file changes) | +5% planning, -60% retry savings | -50–70% less rework | Medium (hook + steering) | Very High | High |

### Medium Impact (Implement Second)

| # | Recommendation | Input Savings | Output Savings | Implementation Complexity | ROI | Confidence |
|---|---|---|---|---|---|---|
| 6 | **Unused MCP Tool Pruning** | -8,000–15,000 tokens/turn | Fewer reasoning turns | Low (config change) | High | High |
| 7 | **Context Position Optimization** (critical rules at start, task context at end) | None (placement strategy) | -10–20% (better focused) | Low (reorder files) | Medium | High |
| 8 | **Loop Detection** (halt after N repeated tool calls) | Prevents 10x–100x waste | Prevents 10x–100x waste | Medium (hook logic) | Very High on failure | High |
| 9 | **Prompt Caching Optimization** (stable content before volatile content) | -60–90% COST | None | Low (reorder) | High | High |
| 10 | **Session Hygiene** (compact/clear guidance in steering) | -30–50% on long sessions | Indirect | Low (steering rule) | Medium | High |

### Low Impact (Implement When Convenient)

| # | Recommendation | Input Savings | Output Savings | Implementation Complexity | ROI | Confidence |
|---|---|---|---|---|---|---|
| 11 | **Model Routing Guidance** | Cost reduction, not token reduction | Varies | Low (steering advice) | Medium | Medium |
| 12 | **Tool Output Compression** (RTK-style) | -89% on tool output | Indirect | High (custom hook) | Medium | Medium |
| 13 | **Dynamic Context Pruning** (for 20+ turn sessions) | -90% on long conversations | Indirect | High (custom implementation) | Situational | Medium |
| 14 | **Trajectory Reduction** (prune old tool call results) | -40–60% | Maintained | High (infrastructure change) | High but complex | High |
