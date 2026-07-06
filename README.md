<p align="center">
  <strong>⚡ ContextSect</strong><br/>
  <em>Agent-agnostic token optimization. One framework, every AI coding client.</em>
</p>

<p align="center">
  <a href="https://contextsect.vercel.app"><img src="https://img.shields.io/badge/website-contextsect.vercel.app-a78bfa?style=flat-square" alt="Website" /></a>
  <a href="docs/architecture.md"><img src="https://img.shields.io/badge/version-1.0.0-a78bfa?style=flat-square" alt="Version" /></a>
  <a href="docs/agents.md"><img src="https://img.shields.io/badge/agents-10_supported-10b981?style=flat-square" alt="Agents" /></a>
  <a href="docs/rules.md"><img src="https://img.shields.io/badge/rules-8_modules-f59e0b?style=flat-square" alt="Rules" /></a>
  <a href="docs/research.md"><img src="https://img.shields.io/badge/research-12_papers-3b82f6?style=flat-square" alt="Research" /></a>
</p>

<p align="center">
  <a href="https://contextsect.vercel.app"><strong>Website</strong></a> ·
  <a href="docs/architecture.md"><strong>Architecture</strong></a> · 
  <a href="docs/install.md"><strong>Install</strong></a> · 
  <a href="docs/research.md"><strong>Research</strong></a>
</p>

---

## Why ContextSect?

> Running AI coding agents = **wasted tokens** on filler, full-file reads, wrong-direction implementations, and runaway loops. ContextSect reduces this by **45–60%** with universal rules that auto-adapt to each agent's native format.

Every AI coding tool has its own config format — `CLAUDE.md`, `.cursorrules`, `.windsurf/rules/`, `.clinerules/`, `.kiro/steering/`, `AGENTS.md`... but the optimization rules are the SAME regardless of agent.

**The solution:** Write rules once in plain markdown → auto-adapt to each agent's native format on install.

---

## The Solution

ContextSect installs **8 universal rules** that optimize token usage across two pillars:

| Pillar | What it does | Savings |
|--------|---|---|
| **Input Optimization** | Prevents unnecessary context loading before work begins | -40–55% input tokens |
| **Output Optimization** | Minimizes generated tokens after reasoning | -50–65% output tokens |

Combined with the 5x output token cost multiplier, this yields **45–60% total cost reduction**.

| Metric | Before | After |
|--------|:------:|:-----:|
| Input tokens per task | Baseline | **-40–55%** |
| Output tokens per task | Baseline | **-50–65%** |
| Total cost per session | Baseline | **-45–60%** |
| First-attempt success | ~60% | **~85%** |
| Runaway loops | Occasional | **Near zero** |

---

## Install

```bash
curl -sL https://contextsect.vercel.app/install.sh | bash
```

Auto-detects installed agents, selects a profile, and configures everything in native format. That's it.

```bash
# Or explicit
./install.sh --agent kiro,claude-code,cursor --profile balanced
```

---

## How It Works

| Step | What happens |
|:----:|---|
| 1 | Install script auto-detects which AI agents are installed |
| 2 | You choose a profile (conservative → ultra-aggressive) |
| 3 | Rules are transformed into each agent's native config format |
| 4 | Agent loads rules at session start, optimizes automatically |

Your agents see **8 rules** that prevent token waste at every stage — from prompt alignment to output compression.

---

## Documentation

| | |
|:--|:--|
| <a href="docs/install.md"><img src="https://img.shields.io/badge/Install-a78bfa?style=flat-square&logo=gnubash&logoColor=white" alt="Install"></a> | [Installation flow, CLI flags, manual selection, updating](docs/install.md) |
| <a href="docs/architecture.md"><img src="https://img.shields.io/badge/Architecture-a78bfa?style=flat-square&logo=blueprint&logoColor=white" alt="Architecture"></a> | [Two-pillar design, token economics, system flow diagram](docs/architecture.md) |
| <a href="docs/rules.md"><img src="https://img.shields.io/badge/Rules-a78bfa?style=flat-square&logo=checkmarx&logoColor=white" alt="Rules"></a> | [All 8 rules with savings, synergies, implementation priority](docs/rules.md) |
| <a href="docs/profiles.md"><img src="https://img.shields.io/badge/Profiles-a78bfa?style=flat-square&logo=slideshare&logoColor=white" alt="Profiles"></a> | [4 intensity levels, per-agent config, mid-session switching](docs/profiles.md) |
| <a href="docs/agents.md"><img src="https://img.shields.io/badge/Agents-a78bfa?style=flat-square&logo=dependabot&logoColor=white" alt="Agents"></a> | [10 supported agents, detection logic, config formats](docs/agents.md) |
| <a href="docs/adaptation.md"><img src="https://img.shields.io/badge/Adaptation-a78bfa?style=flat-square&logo=convertio&logoColor=white" alt="Adaptation"></a> | [How rules transform per agent, adding new agents](docs/adaptation.md) |
| <a href="docs/examples.md"><img src="https://img.shields.io/badge/Examples-a78bfa?style=flat-square&logo=readthedocs&logoColor=white" alt="Examples"></a> | [Before/after comparisons showing token savings](docs/examples.md) |
| <a href="docs/research.md"><img src="https://img.shields.io/badge/Research-a78bfa?style=flat-square&logo=googlescholar&logoColor=white" alt="Research"></a> | [12 papers and production measurements backing every decision](docs/research.md) |

---

## Supported Agents

Kiro · Claude Code · Cursor · Windsurf · Cline · OpenCode · Aider · RooCode · GitHub Copilot · OpenAI Codex

All auto-detected. All configured in native format. See [docs/agents.md](docs/agents.md) for details.

---

## Project Structure

```
ContextSect/
├── rules/              # Universal rules (agent-agnostic markdown)
├── adapters/           # Agent-specific transformations
├── docs/               # Full documentation
├── website/            # contextsect.vercel.app source
└── install.sh          # Auto-detect + install for all agents
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=BhavanPatel/ContextSect&type=Date)](https://star-history.com/#BhavanPatel/ContextSect&type=Date)

---

## Author

<p>
  <a href="https://github.com/BhavanPatel"><strong>Bhavan Patel</strong></a>
</p>

## License

MIT
