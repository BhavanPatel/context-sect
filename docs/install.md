# Installation

## Quick Start

```bash
curl -sL https://contextsect.vercel.app/install.sh | bash
```

The script **auto-detects** which agents you have installed and configures each one in its native format.

---

## What Happens

```mermaid
flowchart LR
    A[./install.sh] --> B{Auto-detect agents}
    B --> C[Kiro detected]
    B --> D[Claude Code detected]
    B --> E[Cursor detected]
    B --> F[Others...]
    
    C --> C1[".kiro/steering/*.md<br/>.kiro/skills/*/SKILL.md<br/>.kiro/hooks/*.json"]
    D --> D1["~/.claude/CLAUDE.md<br/>(all rules combined)"]
    E --> E1[".cursor/rules/*.mdc<br/>(YAML frontmatter added)"]
    F --> F1["Agent-native format"]

    style A fill:#1a1a2e,stroke:#a78bfa,color:#fff
    style B fill:#2d2d44,stroke:#f59e0b,color:#fff
    style C1 fill:#1a4d2e,stroke:#10b981,color:#fff
    style D1 fill:#1a4d2e,stroke:#10b981,color:#fff
    style E1 fill:#1a4d2e,stroke:#10b981,color:#fff
    style F1 fill:#1a4d2e,stroke:#10b981,color:#fff
```

---

## Manual Agent Selection

If auto-detection doesn't find your agents, the script falls back to interactive selection:

```
Available agents:
  1) Kiro CLI
  2) Claude Code
  3) Cursor
  4) Windsurf
  5) Cline
  6) OpenCode
  7) Aider
  8) RooCode
  9) GitHub Copilot
 10) OpenAI Codex
  a) All

Select agents (comma-separated numbers, or 'a' for all): 1,2,3
```

## Explicit Agent Selection

```bash
./install.sh --agent kiro,claude-code,cursor
```

---

## CLI Reference

```bash
# Auto-detect and install (interactive profile selection)
./install.sh

# Install with specific profile (non-interactive)
./install.sh --profile balanced

# Install for specific agents with profile
./install.sh --agent kiro,claude-code,cursor --profile aggressive

# Change profile (re-installs with new settings)
./install.sh --profile conservative

# Update after pulling new rules
git pull && ./install.sh --profile balanced
```

---

## Updating

```bash
cd ContextSect
git pull
./install.sh    # Re-installs with latest rules (backs up existing files)
```
