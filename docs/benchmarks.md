# Benchmarks

## Our Findings

Measured from **8 Kiro sessions** (aggressive profile), **116 assistant messages**, **158 tool calls**.

### Output Optimization

| Metric | With ContextSect | Without (industry avg) | Result |
|--------|:---:|:---:|:---:|
| Avg tokens per response | **56** | 200–300 | **-78%** |
| Filler phrases | **0%** | 60–80% | **Eliminated** |
| Messages under 500 chars | **93%** | ~40% | Dense output |
| Verbose responses (>2000 chars) | **3%** | ~35% | Rare |

### Input Optimization

| Metric | With ContextSect | Observation |
|--------|:---:|---|
| Avg input tokens/session | **5,501** | Progressive loading keeps context lean |
| Avg tool calls/session | **19** | Search-first avoids unnecessary file reads |
| Context window usage | **32–35%** | Never saturating — room for actual reasoning |

### What This Means (Cost)

At typical pricing ($3/M input, $15/M output):

| Scenario | Without | With ContextSect | Savings |
|----------|:---:|:---:|:---:|
| 50 sessions/week | ~$2.10 | ~$0.55 | **~74%** |
| 200 sessions/week (team) | ~$8.40 | ~$2.20 | **~74%** |

---

## How We Benchmarked

### What We Measured

Kiro stores session transcripts at `~/.kiro/sessions/`. Each session contains structured messages with types: `user`, `assistant`, `tool_call`, `tool_result`. We analyzed:

- **Output tokens** — character count of assistant messages (÷4 for token approximation)
- **Input tokens** — user prompts + tool results loaded into context
- **Filler rate** — messages starting with pleasantries ("Sure!", "Certainly!", "Happy to help")
- **Message length distribution** — percentage of concise vs verbose responses
- **Context saturation** — how much of the context window was consumed (Kiro reports this)

### What We Compared Against

No controlled A/B test (yet). The "without" baseline comes from:
- [Caveman's published benchmarks](https://github.com/JuliusBrussee/caveman) — 200-300 tokens/response is typical unoptimized output
- [implicator.ai analysis](https://www.implicator.ai/caveman-claude-code-skill-cuts-output-20-your-bill-barely-notices-2/) — 60-80% of responses contain filler in default mode
- General LLM output characteristics documented in [AGENTS.md study](https://arxiv.org/abs/2601.20404)

---

## Comparison with Alternatives

| Solution | Optimizes | Savings | How Measured | Price | Agents |
|----------|-----------|---------|---|-------|:---:|
| **ContextSect** | Both | 78% output (measured) | 8 sessions, 116 messages | Free | 10 |
| [Caveman](https://github.com/JuliusBrussee/caveman) | Output only | 65% output | 10-prompt benchmark | Free | 30+ |
| [Minimize-Cursor-Cost](https://github.com/inboxpraveen/Minimize-Cursor-Cost) | Both | 60-70% total | 20-task sample | Free | 6 |
| [Distill](https://distill.codes) | Output | 50.6% output | 16-task internal | $4/mo | 2 |
| [TokenShift](https://pointfive.co/tokenshift) | Input | 12-21% | Production workloads | Enterprise | 5 |
| [AgentDiet](https://arxiv.org/abs/2509.23586v1) | Input | 40-60% input | Peer-reviewed | N/A | N/A |

---

## Reproduce It Yourself

### What to Track

| Metric | Where to find it | What good looks like |
|--------|---|---|
| Output tokens/message | Count chars in assistant messages ÷ 4 | < 100 tokens |
| Filler rate | Grep for "Sure!", "Certainly!", "Happy to help" at message start | 0% |
| Context usage % | Kiro session metadata (`contextUsage`) | < 40% |
| Tool calls/session | Count `tool_call` entries | Lower = more targeted reads |
| Task completion | Did the task actually get done correctly? | Should not degrade |

### How to Compare

1. Run `contextsect disable` — work normally for a few sessions
2. Run `contextsect enable` — work normally for a few sessions
3. Compare the metrics above between the two periods
4. Report: did output shrink? Did quality stay the same?

---

## Honest Caveats

- **No controlled A/B yet.** Same task, same codebase, with vs without — not done. Our comparison is against published industry baselines.
- **Aggressive profile.** These numbers are from aggressive mode. Balanced will show smaller gains with less friction.
- **Tool args count as output.** On most providers, tool call arguments are billed as output tokens.
- **Rules cost ~2,400 input tokens.** 8 rules loaded every session. Pays for itself after 1-2 assistant responses.
- **Your mileage varies.** If you already write specific prompts and get terse answers, savings will be lower.
