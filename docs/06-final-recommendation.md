# Part 6: Final Recommendation

## Context

This recommendation assumes daily use of Kiro on large production software projects (10,000+ lines, multiple services, production deployments). The goal: maximum token efficiency without sacrificing the implementation quality that makes AI-assisted development worthwhile.

---

## Skills That Should ALWAYS Remain Enabled

### 1. output-compression (Full intensity)
**Why always:** Output tokens cost 5x input tokens. This is pure waste elimination with zero quality risk. The caveman skill proves 65% output reduction is achievable; our professional-tone variant achieves 40–65% without the informal style. There is no scenario where filler words improve implementation quality.

### 2. loop-breaker
**Why always:** This is insurance against catastrophic failure. A single misconfigured tool or stuck pattern can waste 10x–100x normal tokens in minutes. The detection overhead is near-zero; the downside of not having it is unbounded. GitHub documented a 64-turn waste loop from one misconfiguration.

### 3. diff-only
**Why always:** Writing full files when only lines changed is the most common output waste pattern. A 200-line file with a 5-line fix wastes ~780 output tokens (at 5x input cost). SEARCH/REPLACE is the industry standard across Aider, Claude Code, and Cursor. No quality tradeoff.

### 4. search-first
**Why always:** Agents waste 80% of tokens on finding things. Reading full files when only one function matters loads irrelevant context that dilutes attention (lost-in-middle effect). Measured savings: 40–80% on file reading operations. The only risk is missing some context, which the progressive loading approach mitigates.

---

## Skills That Should Be TASK-SPECIFIC

### 5. alignment-gate
**When to enable:** Multi-file changes, architectural decisions, vague prompts, unfamiliar code.
**When to disable:** Rapid iteration on single files, pair programming, when user is giving step-by-step instructions.
**Rationale:** The alignment gate's value is enormous on complex tasks (prevents 5,000–50,000 token waste) but adds friction on obvious tasks. The hook-based trigger with skip conditions handles this automatically in most cases.

### 6. plan-before-act
**When to enable:** Changes spanning 3+ files, new feature development, refactoring.
**When to disable:** Single-file fixes, documentation changes, when user has already provided the plan.
**Rationale:** Planning catches misalignment before expensive implementation. But over-planning trivial tasks adds latency and token overhead. The 3-file threshold is well-calibrated for most workflows.

### 7. investigation-mode
**When to enable:** Debugging, performance diagnosis, understanding unfamiliar code.
**When to disable:** Implementation tasks, code review, documentation.
**Rationale:** Structured investigation prevents the fix-try-fail-retry loop that wastes tokens on speculative fixes. But applying it to non-diagnostic tasks adds unnecessary structure.

### 8. context-hygiene
**When to enable:** Sessions expected to exceed 10 turns, long debugging sessions, multi-task sessions.
**When to disable:** Quick single-question interactions, short focused tasks.
**Rationale:** Context accumulation is invisible until it causes quality degradation. But for 3-turn interactions, the overhead of monitoring context is unnecessary.

---

## Skills/Approaches That Should Be AVOIDED

### Ultra-Aggressive Compression (terse-ultra / caveman-ultra)
**Why avoid:** The SkillReducer paper shows that invented abbreviations (cfg/impl/req/res/fn) tokenize to the SAME number of tokens as full words under modern tokenizers. Zero actual savings. Meanwhile, they cost decode clarity for humans and can confuse the model in subsequent turns. The caveman style also reduces professional credibility in team settings.

### Over-Restrictive File Read Budgets
**Why avoid:** Setting max-files-per-task too low (e.g., 3 files) causes the agent to miss critical dependencies and produce incorrect implementations. The academic evidence shows that too-little context degrades quality more than too-much context. Progressive loading (search → targeted read) is better than hard limits.

### Forced Single-Task Sessions
**Why avoid:** Session overhead (initial context loading, steering, system prompt) costs 2,000–5,000 tokens. Forcing new sessions for every task wastes this repeatedly. Sessions should continue when context remains relevant and reset when switching domains.

### Output Compression for Safety/Security Content
**Why avoid:** Compressed security warnings are dangerous. When confirming destructive operations or reporting vulnerabilities, full clarity prevents human error. The 50-token savings is not worth the risk of a misunderstood "DROP TABLE" confirmation.

---

## Optimal Default Configuration

### Recommended: "Balanced" Profile

```yaml
profile: balanced
skills:
  output-compression: full        # Always — zero risk, high savings
  search-first: enforced          # Always — proven 40-80% input savings
  loop-breaker: enabled           # Always — catastrophic failure insurance
  diff-only: enabled              # Always — eliminates most output waste
  alignment-gate: enabled         # Auto-triggers on complex tasks
  plan-before-act: enabled        # Auto-triggers on multi-file changes
  context-hygiene: enabled        # Session awareness
  investigation-mode: auto        # Auto-detects debugging prompts
steering:
  output-contract: full           # Global output compression
  alignment-rules: enabled        # Alignment gate protocol
thresholds:
  loop-detection-repetitions: 3   # Halt after 3 identical patterns
  alignment-gate-file-count: 3    # Align on 3+ file changes
  plan-required-file-count: 3     # Plan on 3+ file changes
  investigation-tool-budget: 5    # Max 5 tool calls per investigation round
```

### Why This Configuration

| Dimension | Choice | Rationale |
|-----------|--------|-----------|
| Output compression | Full | Proven 40–65% savings, zero quality risk |
| Alignment threshold | 3 files | Catches complex tasks, skips trivial |
| Loop detection | 3 reps | Catches real loops, avoids false positives |
| Search enforcement | Strict | Prevents context pollution on large repos |
| Plan requirement | 3+ files | Matches alignment gate — consistent UX |
| Investigation budget | 5 calls | Enough to diagnose, not enough to wander |

### Expected Total Savings (Balanced Profile)

| Metric | Estimate | Confidence |
|--------|----------|-----------|
| Input token reduction | -40–55% | High (based on search-first + progressive loading research) |
| Output token reduction | -50–65% | High (based on compression + diff-only measurements) |
| Total cost reduction | -45–60% | High (weighted by 5x output cost multiplier) |
| Implementation success rate | Maintained or improved | High (alignment + planning prevent rework) |
| Reasoning quality | Maintained or improved | High (less noise = better focus per lost-in-middle research) |

---

## Pillar Integration: How Input + Output Optimization Work Together

```
User Prompt
    │
    ▼
┌─────────────────────────┐
│  Pillar 1: INPUT GATE   │ ← Alignment check, search-first, context hygiene
│  "Is this worth doing?" │
│  "Do I have the right   │
│   context?"             │
└────────────┬────────────┘
             │ (Only proceeds with confirmed intent + targeted context)
             ▼
┌─────────────────────────┐
│  Agent Reasoning        │ ← With clean, focused, relevant-only context
│  (Planning + Execution) │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Pillar 2: OUTPUT GATE  │ ← Compression, diff-only, no narration
│  "Minimum tokens for    │
│   maximum information"  │
└────────────┬────────────┘
             │
             ▼
        User Receives
        Dense, Accurate Response
```

**Pillar 1** ensures the model works on the right thing with the right context — preventing the 50–70% of tokens wasted on wrong direction and irrelevant file reads.

**Pillar 2** ensures the model's output contains maximum information per token — preventing the 40–65% of output tokens wasted on filler, restatement, and unnecessary code duplication.

**Together:** They compound. A correctly-aligned agent with focused context producing compressed output achieves 60–80% total token reduction compared to an unoptimized baseline.

---

## Implementation Priority

### Week 1 (Immediate, zero risk)
1. Deploy `output-contract.md` steering file
2. Deploy `prompt-interceptor.json` hooks
3. Deploy `alignment-rules.md` steering file

### Week 2 (After validating Week 1)
4. Enable `search-first` skill enforcement
5. Enable `loop-breaker` monitoring
6. Enable `plan-before-act` for multi-file tasks

### Week 3+ (Iterate based on experience)
7. Tune alignment gate thresholds based on actual trigger frequency
8. Tune loop detection thresholds based on false positive rate
9. Add project-specific skip conditions
10. Consider `investigation-mode` for debugging-heavy workflows

---

## Measurement Strategy

Track these metrics to validate the framework:

1. **Tokens per task completion** — Total tokens (input + output) per successfully completed user request
2. **First-attempt success rate** — % of tasks completed without user correction or retry
3. **Alignment gate trigger rate** — How often the gate fires (target: 20–40% of prompts)
4. **Loop detection trigger rate** — How often loops are caught (target: <5% of sessions, non-zero)
5. **User override rate** — How often users say "skip alignment" or "just do it" (if >30%, thresholds too aggressive)

---

## Sources Summary

| Evidence Source | Type | Key Finding |
|---|---|---|
| GitHub Agentic Workflows blog | Production measurement | 62% savings from eliminating unnecessary tool turns |
| SkillReducer (arxiv 2603.29919) | Academic study (55k skills) | 60% of skill content is non-actionable waste |
| AGENTS.md paper (arxiv 2601.20404) | Academic study (124 PRs) | 17% output reduction, 29% runtime reduction |
| Efficient Context Engineering (arxiv 2606.10209) | Academic benchmark | Pruning to last 5 tool calls: 64% fewer tokens, HIGHER completion |
| Caveman skill (JuliusBrussee) | Community benchmark (83k stars) | 65% output token reduction measured |
| Progressive Context Loading | Multiple implementations | 60% input token savings measured |
| Lost in the Middle (arxiv 2307.03172) | Foundational LLM research | Context position affects quality; less = more focused |
| Claude Code prompt caching blog | Anthropic production | 60–90% input cost reduction from stable prefix caching |
| VS Code optimize usage docs | Official documentation | Plan-first + model routing as recommended practice |
| AgentDiet (arxiv 2509.23586) | Academic benchmark | 40–60% input reduction maintaining performance |
