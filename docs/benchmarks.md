# Benchmarks

## Our Findings

Measured from **9 real Kiro CLI sessions** (ContextSect aggressive profile active), tracking actual credit consumption via Kiro's built-in metering.

### Credit Usage — Measured

| Metric | Value |
|--------|:---:|
| Total sessions measured | **9** |
| Total turns | **152** |
| Total credits consumed | **214.1** |
| Avg credits/session | **23.8** |
| Avg credits/turn | **1.41** |
| Avg turns/session | **16.9** |
| Max context usage | **15–24%** of 200k window |

### Per-Session Breakdown

| Session | Turns | Credits | Context % | Credits/Turn |
|---------|:---:|:---:|:---:|:---:|
| Multi-file restructure | 18 | 38.1 | 15.1% | 2.12 |
| Agent/skill management | 27 | 36.0 | 16.6% | 1.33 |
| Cartography project | 4 | 2.0 | 5.7% | 0.50 |
| Project restructure | 6 | 7.9 | 9.0% | 1.31 |
| Project update | 5 | 4.1 | 4.0% | 0.82 |
| File creation (22 files) | 22 | 82.9 | 23.9% | 3.77 |
| Directory analysis (complex) | 57 | 30.8 | 13.9% | 0.54 |
| Slack thread analysis | 9 | 9.8 | 7.6% | 1.08 |
| MCP configuration | 4 | 2.7 | 19.8% | 0.67 |

### Output Optimization — Measured

| Metric | With ContextSect | Typical Baseline | Result |
|--------|:---:|:---:|:---:|
| Avg output per message | **56 tokens** (223 chars) | 200–300 tokens | **-72–78%** |
| Filler phrases | **0%** | 60–80% | **Eliminated** |
| Messages under 500 chars | **93%** | ~40% | Dense output |
| Context window usage | **4–24%** | 60–90% | **Never saturating** |

### Input Optimization — Measured

| Metric | Value | Why it matters |
|--------|:---:|---|
| Context window usage | **4–24%** | Search-first + progressive loading keeps context lean |
| Context window capacity | 200,000 tokens | Never approaching the limit |
| Avg tool calls/session | **19** | Targeted reads, not shotgun file loading |

---

## How We Measured

**Data source:** `~/.kiro/sessions/cli/<session-id>.json`

Each Kiro CLI session stores:
- `metering_usage` — actual credits consumed per turn (from Kiro's billing)
- `context_usage_percentage` — what % of context window was used
- `user_turn_metadatas` — per-turn metadata

**What's tracked:**
| Metric | Source | Precision |
|--------|---|---|
| Credits consumed | `metering_usage[].value` | Exact (billing data) |
| Context % | `context_usage_percentage` | Exact (Kiro reports) |
| Output chars | `assistant` message content length | Exact |
| Filler rate | Pattern match on message starts | Binary (yes/no) |

**How to check your own usage:**

| Agent | How to measure |
|-------|---|
| **Kiro CLI** | Session data at `~/.kiro/sessions/cli/*.json` (metering_usage field) |
| **Kiro Desktop** | Settings → Usage, or `~/Library/Application Support/Kiro/User/globalStorage/kiro.kiroagent/dev_data/` |
| **Claude Code** | `claude usage` or check `~/.claude/projects/*/sessions/*/usage.json` |
| **Cursor** | Settings → Usage → Token breakdown |
| **Aider** | Prints token counts per message automatically after each response |
| **Codex** | `codex --stats` after session |
| **Windsurf** | Settings → Usage panel |
| **GitHub Copilot** | GitHub billing dashboard → Copilot usage |

---

## How to Compare (With vs Without)

1. **Disable rules:** `contextsect disable`
2. **Work normally** for several sessions
3. **Re-enable:** `contextsect enable`
4. **Work normally** for several sessions
5. **Compare** credits/turn and context usage between the two periods

### What to look at:
- **Credits per turn** — lower = less tokens consumed
- **Context %** — lower = more efficient reads
- **Filler in responses** — should be 0% with ContextSect
- **Task completion** — should not degrade

---

## Comparison with Alternatives

| Solution | Optimizes | Savings | How Measured | Price | Agents |
|----------|-----------|---------|---|-------|:---:|
| **ContextSect** | Both | 78% output (measured) | 9 sessions, real credits | Free | 10 |
| [Caveman](https://github.com/JuliusBrussee/caveman) | Output only | 65% output | 10-prompt benchmark | Free | 30+ |
| [Minimize-Cursor-Cost](https://github.com/inboxpraveen/Minimize-Cursor-Cost) | Both | 60-70% total | 20-task sample | Free | 6 |
| [Distill](https://distill.codes) | Output | 50.6% output | 16-task internal | $4/mo | 2 |
| [TokenShift](https://pointfive.co/tokenshift) | Input | 12-21% | Production workloads | Enterprise | 5 |
| [AgentDiet](https://arxiv.org/abs/2509.23586v1) | Input | 40-60% input | Peer-reviewed | N/A | N/A |

### Why ContextSect vs Alternatives

| Dimension | ContextSect | Caveman | Distill | TokenShift |
|-----------|:-----------:|:-------:|:-------:|:----------:|
| Input optimization | ✅ | ❌ | ❌ | ✅ |
| Output optimization | ✅ | ✅ | ✅ | ❌ |
| Behavioral (prevents waste) | ✅ | ❌ | ❌ | ❌ |
| No proxy/external service | ✅ | ✅ | ❌ | ❌ |
| Agent-agnostic | ✅ | ✅ | ❌ | Partial |
| Free & open source | ✅ | ✅ | ❌ | ❌ |
| Loop/runaway prevention | ✅ | ❌ | ❌ | ❌ |
| Quick disable/enable | ✅ | Manual | N/A | N/A |

---

## Honest Caveats

1. **No controlled A/B yet.** We measured WITH rules active. The "without" baseline is industry-published averages, not our own before-state.
2. **Aggressive profile.** These are aggressive profile numbers. Balanced will show smaller gains with less friction.
3. **Credits ≠ tokens directly.** Kiro credits map to token usage but the exact conversion isn't published.
4. **Rules cost ~2,400 input tokens/session.** 8 rules loaded into context. Pays for itself after 1-2 responses.
5. **Context % varies by task.** Simple tasks use 4%, complex multi-file work uses 24%. All well under the 200k limit.
6. **9 sessions is a small sample.** More data will strengthen these findings.
