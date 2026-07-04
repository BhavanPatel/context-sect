# Part 4: Master Configuration Profiles

## Overview

Four profiles that combine skills and steering rules to achieve different token efficiency targets. Each profile represents a deliberate tradeoff between savings and developer experience.

---

## Profile 1: Conservative

### Philosophy
Minimize risk. Preserve full developer experience. Apply only optimizations with zero quality risk.

### Enabled Skills
| Skill | Status |
|-------|--------|
| output-compression | **Lite** (no filler, full sentences) |
| alignment-gate | Disabled |
| search-first | Enabled |
| loop-breaker | Enabled |
| diff-only | Enabled |
| context-hygiene | Enabled (advisory only) |
| plan-before-act | Disabled |
| investigation-mode | Disabled |

### Steering Configuration
- Output contract: Lite compression only (remove filler, keep full sentences)
- No alignment gate (agent proceeds freely)
- Search-first advisory (prefer search, but full reads allowed)
- Loop breaker at generous thresholds (5+ repetitions before triggering)

### Expected Savings
| Metric | Estimate |
|--------|----------|
| Input token reduction | -15–25% |
| Output token reduction | -20–30% |
| Implementation risk | Zero |
| Reasoning risk | Zero |
| Code quality risk | Zero |

### Ideal Use Cases
- Onboarding new developers to Kiro
- Teaching/learning sessions
- Unfamiliar codebases where exploration is expected
- Rapid prototyping where speed > efficiency
- Teams transitioning from unoptimized workflows

### Configuration File
```yaml
# profiles/conservative.yaml
profile: conservative
skills:
  output-compression: lite
  search-first: enabled
  loop-breaker: enabled
  diff-only: enabled
  context-hygiene: advisory
  alignment-gate: disabled
  plan-before-act: disabled
  investigation-mode: disabled
steering:
  output-contract: lite
  alignment-rules: disabled
thresholds:
  loop-detection-repetitions: 5
  alignment-gate-file-count: 999  # effectively disabled
  plan-required-file-count: 999   # effectively disabled
```

---

## Profile 2: Balanced (Recommended Default)

### Philosophy
Best daily-driver configuration. Significant savings with minimal friction. Alignment gate on complex tasks only. Full output compression.

### Enabled Skills
| Skill | Status |
|-------|--------|
| output-compression | **Full** (fragments, short synonyms, no filler) |
| alignment-gate | Enabled (3+ file threshold) |
| search-first | Enabled (enforced) |
| loop-breaker | Enabled |
| diff-only | Enabled |
| context-hygiene | Enabled |
| plan-before-act | Enabled (3+ file threshold) |
| investigation-mode | Enabled (auto-detect) |

### Steering Configuration
- Output contract: Full compression (fragments OK, no filler, SEARCH/REPLACE enforced)
- Alignment gate: Activates on multi-file tasks, architectural changes, vague prompts
- Plan-before-act: Required for 3+ file modifications
- Investigation mode: Auto-activates on "why/debug/investigate" prompts

### Expected Savings
| Metric | Estimate |
|--------|----------|
| Input token reduction | -40–55% |
| Output token reduction | -50–65% |
| Implementation risk | Low (plans catch 80% of misalignment) |
| Reasoning risk | Minimal (alignment clarification improves reasoning) |
| Code quality risk | Zero to Positive (plans + investigation = better code) |

### Ideal Use Cases
- Daily development on production codebases
- Feature implementation
- Bug fixing
- Code review
- Most software engineering tasks

### Configuration File
```yaml
# profiles/balanced.yaml
profile: balanced
skills:
  output-compression: full
  alignment-gate: enabled
  search-first: enforced
  loop-breaker: enabled
  diff-only: enabled
  context-hygiene: enabled
  plan-before-act: enabled
  investigation-mode: auto
steering:
  output-contract: full
  alignment-rules: enabled
thresholds:
  loop-detection-repetitions: 3
  alignment-gate-file-count: 3
  plan-required-file-count: 3
  investigation-tool-budget: 5
```

---

## Profile 3: Aggressive Token Saving

### Philosophy
Maximum savings for cost-conscious environments. Every token must earn its place. Strict budgets. Fast alignment. Minimal exploration.

### Enabled Skills
| Skill | Status |
|-------|--------|
| output-compression | **Ultra** (abbreviations, minimal conjunctions) |
| alignment-gate | Enabled (2+ file threshold) |
| search-first | Enforced (strict — no full file reads >30 lines) |
| loop-breaker | Enabled (tight thresholds) |
| diff-only | Enforced (no exceptions except new files) |
| context-hygiene | Enforced (recommend session break after 10 turns) |
| plan-before-act | Enabled (2+ file threshold) |
| investigation-mode | Enabled (budget: 3 tool calls max) |

### Steering Configuration
- Output contract: Ultra compression (abbreviations OK, one word when sufficient)
- Alignment gate: Activates on any multi-file task
- Search-first: Strict — never read full files over 30 lines
- Context hygiene: Actively recommend session breaks
- Tool budgets: Tight per-task limits

### Expected Savings
| Metric | Estimate |
|--------|----------|
| Input token reduction | -60–75% |
| Output token reduction | -70–85% |
| Implementation risk | Medium (tight budgets may truncate complex tasks) |
| Reasoning risk | Low-Medium (ultra compression may obscure nuance occasionally) |
| Code quality risk | Low (plans still catch misalignment, but less exploration available) |

### Ideal Use Cases
- High-volume automated workflows (CI/CD agents, auto-triage)
- Cost-constrained environments with strict budgets
- Repetitive tasks on well-understood codebases
- Solo developers who know their codebase deeply
- Batch operations where interaction is minimal

### Configuration File
```yaml
# profiles/aggressive.yaml
profile: aggressive
skills:
  output-compression: ultra
  alignment-gate: enabled
  search-first: strict
  loop-breaker: enabled
  diff-only: enforced
  context-hygiene: enforced
  plan-before-act: enabled
  investigation-mode: enabled
steering:
  output-contract: ultra
  alignment-rules: enabled
thresholds:
  loop-detection-repetitions: 2
  alignment-gate-file-count: 2
  plan-required-file-count: 2
  investigation-tool-budget: 3
  max-file-read-lines: 30
  session-break-recommendation: 10  # turns
```

---

## Profile 4: Ultra-Aggressive Token Saving

### Philosophy
Absolute minimum token expenditure. Suitable only for well-defined, repetitive tasks on familiar codebases. Sacrifices some exploration capability for maximum efficiency.

### Enabled Skills
| Skill | Status |
|-------|--------|
| output-compression | **Ultra** (maximum compression) |
| alignment-gate | Enabled (ANY multi-step task) |
| search-first | Enforced (strict — symbol lookup only, no grep) |
| loop-breaker | Enabled (1 repetition = halt) |
| diff-only | Enforced (absolute — never full files) |
| context-hygiene | Enforced (new session per task) |
| plan-before-act | Enforced (any task >1 file) |
| investigation-mode | Enabled (budget: 2 tool calls) |

### Additional Restrictions
- No explanatory text unless explicitly requested
- No confirmation messages ("Done." suffices)
- No progress narration
- Maximum 3 files read per task
- Session limited to single task then reset
- No speculative reading ("might be useful")

### Steering Configuration
- Output contract: Maximum compression + no explanations
- One task per session
- Strict file read budget
- No exploratory behavior allowed

### Expected Savings
| Metric | Estimate |
|--------|----------|
| Input token reduction | -80–90% |
| Output token reduction | -85–95% |
| Implementation risk | High (very little exploration budget) |
| Reasoning risk | Medium-High (minimal context available for complex reasoning) |
| Code quality risk | Medium (may miss edge cases due to limited exploration) |

### Ideal Use Cases
- Automated CI/CD agents running pre-defined scripts
- Bulk formatting/linting tasks
- Single-file, well-specified changes (bug fix with exact file + line)
- Cost-limited environments where tokens are scarce
- Repetitive operations (same type of change across many files)

### NOT Suitable For
- Novel feature development
- Debugging complex issues
- Architectural changes
- Unfamiliar codebases
- Anything requiring exploration or creativity

### Configuration File
```yaml
# profiles/ultra-aggressive.yaml
profile: ultra-aggressive
skills:
  output-compression: ultra
  alignment-gate: enforced
  search-first: strict-symbol-only
  loop-breaker: enforced
  diff-only: enforced-absolute
  context-hygiene: enforced-single-task
  plan-before-act: enforced
  investigation-mode: minimal
steering:
  output-contract: ultra-max
  alignment-rules: enforced
  no-explanation-unless-asked: true
  single-task-sessions: true
thresholds:
  loop-detection-repetitions: 1
  alignment-gate-file-count: 1
  plan-required-file-count: 1
  investigation-tool-budget: 2
  max-file-read-lines: 20
  max-files-per-task: 3
  session-break-recommendation: 1  # new session per task
```

---

## Profile Comparison Summary

| Dimension | Conservative | Balanced | Aggressive | Ultra-Aggressive |
|-----------|:---:|:---:|:---:|:---:|
| **Input reduction** | 15–25% | 40–55% | 60–75% | 80–90% |
| **Output reduction** | 20–30% | 50–65% | 70–85% | 85–95% |
| **Exploration freedom** | Full | Moderate | Limited | Minimal |
| **Alignment friction** | None | Low (complex tasks only) | Medium (most tasks) | High (every task) |
| **Learning curve** | None | Low | Medium | High |
| **Best for** | Learning, prototyping | Daily development | Cost-sensitive, familiar code | Automated agents, bulk ops |
| **Risk level** | Zero | Low | Medium | High |
| **Developer experience** | Unchanged | Slightly constrained | Noticeably constrained | Significantly constrained |

---

## How to Choose

```
Is this a familiar codebase you work on daily?
├── No → Conservative or Balanced
└── Yes
    ├── Is this exploratory/creative work? → Balanced
    ├── Is this well-defined implementation? → Aggressive
    └── Is this automated/repetitive? → Ultra-Aggressive
```

## Switching Between Profiles

Profiles can be switched mid-session via prompt:
- "Switch to aggressive profile"
- "Use balanced mode"
- "I need full exploration — go conservative"

Or set per-project in your agent's config file:
```yaml
default-profile: balanced
```
