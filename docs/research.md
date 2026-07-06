# Research Basis

Built on evidence from peer-reviewed papers, production measurements, and community benchmarks.

## Sources

| # | Source | Key Finding | Impact | Confidence |
|:-:|--------|-------------|--------|:---:|
| 1 | [SkillReducer](https://arxiv.org/abs/2603.29919) | 60% of skill content is non-actionable waste; pruning improves agent performance | 55k skills studied | Proven |
| 2 | [AGENTS.md Impact](https://arxiv.org/abs/2601.20404) | 17% output reduction, 29% runtime reduction across 124 PRs in 10 repos | Peer-reviewed empirical study | Proven |
| 3 | [Context Engineering](https://arxiv.org/abs/2606.10209) | Pruning context yields 64% fewer tokens with +8% task completion | Quality improves with less noise | Proven |
| 4 | [GitHub Agentic Workflows](https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/) | 62% savings by eliminating unnecessary tool turns | Production at scale | Proven |
| 5 | [Caveman Skill](https://github.com/JuliusBrussee/caveman) | 65% output reduction benchmarked across 10 prompts (83k ⭐) | Range: 22–87% reduction | Proven |
| 6 | [Lost in the Middle](https://arxiv.org/html/2307.03172) | Models attend to beginning/end of context; middle content degrades quality | Less context = better reasoning | Proven |
| 7 | [Prompt Caching](https://claude.com/blog/lessons-from-building-claude-code-prompt-caching-is-everything) | Stable prefixes enable 60–90% input cost reduction | Architecture decision | Proven |
| 8 | [AgentDiet](https://arxiv.org/abs/2509.23586v1) | 40–60% input reduction with equivalent task performance | Compression without quality loss | Proven |
| 9 | [Progressive Context Loading](https://chudinnorukam.hashnode.dev/cut-ai-token-usage-60-progressive-context-loading) | Tiered context loading cuts usage 60% with better output quality | Less noise = stronger reasoning | Proven |
| 10 | [implicator.ai Caveman Analysis](https://www.implicator.ai/caveman-claude-code-skill-cuts-output-20-your-bill-barely-notices-2/) | Real-world caveman savings ~20% on total bill (output ≈1% of volume) | Calibrates expectations | Validated |
| 11 | [Loop Waste (GitHub)](https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/) | Single misconfigured tool caused 64-turn waste loop | Unbounded cost risk | Documented |
| 12 | [SEARCH/REPLACE Standard](https://aider.chat/docs/usage/edit-formats.html) | Diff-based output is industry standard across Aider, Claude Code, Cursor | 60–90% code output reduction | Standard |

---

## Key Design Decisions

### Output compression (always-on)
Output tokens cost 5x input. Zero-filler rules have no quality tradeoff — safety exceptions only for destructive confirmations.

### Search-first (always-on)
Agents waste 80% of tokens finding things, not reasoning. Progressive loading (Tier 0→3) prevents context pollution.

### Loop detection (always-on)
Insurance against catastrophic token waste. Near-zero overhead, unbounded downside without it.

### Alignment gate (task-specific)
Prevents 5,000–50,000 token waste on complex tasks, but adds friction on obvious single-file edits. Auto-trigger on 3+ file changes.

### No ultra-compressed abbreviations
Tokenizers split abbreviated words to same token count as full words. Zero savings, lost readability (measured by caveman tokenizer analysis).

---

## What NOT to Do

| Anti-Pattern | Why It Fails | Evidence |
|---|---|---|
| **Ultra-compressed abbreviations** (cfg/impl/req/fn) | Tokenizer splits to same count as full words. Zero savings, lost readability. | Caveman repo tokenizer analysis |
| **Hard file-read limits** (max 3 files) | Agent misses dependencies → wrong code → retry costs more | AgentDiet research |
| **Forced single-task sessions** | Session overhead = 3,000–5,000 tokens. Repeated per task. | Kiro/Claude session architecture |
| **Compressing security warnings** | Misunderstood destructive confirmations → data loss | GitHub incident docs |
| **Loading all rules simultaneously** | Each rule = 300–400 tokens. 20 rules = 8,000 tokens competing for attention | SkillReducer: attention dilution |
