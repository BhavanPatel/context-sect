#!/usr/bin/env bash
set -euo pipefail

# ContextSect — Agent-Agnostic Token Optimization Framework
# Detects installed AI coding agents and installs optimized rules for each.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="${SCRIPT_DIR}/rules"
ADAPTERS_DIR="${SCRIPT_DIR}/adapters"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ════════════════════════════════════════════════════════════════
# Agent detection
# ════════════════════════════════════════════════════════════════

declare -a DETECTED_AGENTS=()

detect_agents() {
  echo -e "${CYAN}Detecting installed AI coding agents...${NC}"
  echo ""

  # Kiro CLI
  if command -v kiro-cli &>/dev/null || command -v kiro &>/dev/null || [[ -d "${HOME}/.kiro" ]]; then
    DETECTED_AGENTS+=("kiro")
    echo -e "  ${GREEN}✓${NC} Kiro CLI"
  fi

  # Claude Code
  if command -v claude &>/dev/null || [[ -d "${HOME}/.claude" ]]; then
    DETECTED_AGENTS+=("claude-code")
    echo -e "  ${GREEN}✓${NC} Claude Code"
  fi

  # Cursor
  if [[ -d "${HOME}/.cursor" ]] || [[ -d "/Applications/Cursor.app" ]] || [[ -d "${HOME}/Library/Application Support/Cursor" ]]; then
    DETECTED_AGENTS+=("cursor")
    echo -e "  ${GREEN}✓${NC} Cursor"
  fi

  # Windsurf
  if [[ -d "${HOME}/.windsurf" ]] || [[ -d "/Applications/Windsurf.app" ]] || [[ -d "${HOME}/Library/Application Support/Windsurf" ]]; then
    DETECTED_AGENTS+=("windsurf")
    echo -e "  ${GREEN}✓${NC} Windsurf"
  fi

  # Cline (VS Code extension)
  if [[ -d "${HOME}/.cline" ]] || find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*cline*" -print -quit 2>/dev/null | grep -q .; then
    DETECTED_AGENTS+=("cline")
    echo -e "  ${GREEN}✓${NC} Cline"
  fi

  # OpenCode
  if command -v opencode &>/dev/null || [[ -f "${HOME}/.config/opencode/config.json" ]]; then
    DETECTED_AGENTS+=("opencode")
    echo -e "  ${GREEN}✓${NC} OpenCode"
  fi

  # Aider
  if command -v aider &>/dev/null || [[ -f "${HOME}/.aider.conf.yml" ]]; then
    DETECTED_AGENTS+=("aider")
    echo -e "  ${GREEN}✓${NC} Aider"
  fi

  # RooCode (VS Code extension)
  if [[ -d "${HOME}/.roo" ]] || find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*roo*" -print -quit 2>/dev/null | grep -q .; then
    DETECTED_AGENTS+=("roocode")
    echo -e "  ${GREEN}✓${NC} RooCode"
  fi

  # GitHub Copilot
  if find "${HOME}/.vscode/extensions" -maxdepth 1 -name "*copilot*" -print -quit 2>/dev/null | grep -q . || command -v gh &>/dev/null; then
    DETECTED_AGENTS+=("github-copilot")
    echo -e "  ${GREEN}✓${NC} GitHub Copilot"
  fi

  # Codex
  if command -v codex &>/dev/null || [[ -f "${HOME}/.codex/config.toml" ]]; then
    DETECTED_AGENTS+=("codex")
    echo -e "  ${GREEN}✓${NC} OpenAI Codex"
  fi

  echo ""

  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No agents auto-detected. Choose manually:${NC}"
    select_agents_manually
  fi
}

select_agents_manually() {
  echo ""
  echo "Available agents:"
  echo "  1) Kiro CLI"
  echo "  2) Claude Code"
  echo "  3) Cursor"
  echo "  4) Windsurf"
  echo "  5) Cline"
  echo "  6) OpenCode"
  echo "  7) Aider"
  echo "  8) RooCode"
  echo "  9) GitHub Copilot"
  echo " 10) OpenAI Codex"
  echo "  a) All"
  echo ""
  read -rp "Select agents (comma-separated numbers, or 'a' for all): " selection </dev/tty

  if [[ "$selection" == "a" ]]; then
    DETECTED_AGENTS=("kiro" "claude-code" "cursor" "windsurf" "cline" "opencode" "aider" "roocode" "github-copilot" "codex")
  else
    IFS=',' read -ra choices <<< "$selection"
    for choice in "${choices[@]}"; do
      choice=$(echo "$choice" | tr -d ' ')
      case "$choice" in
        1) DETECTED_AGENTS+=("kiro") ;;
        2) DETECTED_AGENTS+=("claude-code") ;;
        3) DETECTED_AGENTS+=("cursor") ;;
        4) DETECTED_AGENTS+=("windsurf") ;;
        5) DETECTED_AGENTS+=("cline") ;;
        6) DETECTED_AGENTS+=("opencode") ;;
        7) DETECTED_AGENTS+=("aider") ;;
        8) DETECTED_AGENTS+=("roocode") ;;
        9) DETECTED_AGENTS+=("github-copilot") ;;
        10) DETECTED_AGENTS+=("codex") ;;
      esac
    done
  fi
}

# ════════════════════════════════════════════════════════════════
# Profile selection
# ════════════════════════════════════════════════════════════════

SELECTED_PROFILE=""

get_profile_desc() {
  case "$1" in
    conservative)     echo "Zero risk. Full exploration. Minimal constraints." ;;
    balanced)         echo "Recommended. Significant savings with minimal friction." ;;
    aggressive)       echo "Maximum savings for familiar codebases. Tight budgets." ;;
    ultra-aggressive) echo "Absolute minimum tokens. Automated/repetitive tasks only." ;;
  esac
}

get_profile_settings() {
  case "$1" in
    conservative) cat <<'SETTINGS'
alignment-gate: disabled (no blocking)
output-compression: lite (no filler, but full sentences)
search-first: advisory (prefer search, allow full reads)
loop-detection: 5 repetitions before halt
plan-required: disabled
investigation-budget: 10 tool calls
shell-output-hygiene: advisory (suggest compact flags, allow verbose)
context-budget: monitor only (no session-limit enforcement)
tool-selection: advisory (prefer specific tools, allow generic)
SETTINGS
      ;;
    balanced) cat <<'SETTINGS'
alignment-gate: active on 3+ file changes
output-compression: full (fragments OK, no filler, diff-only)
search-first: enforced (search before reading files >50 lines)
loop-detection: 3 repetitions before halt
plan-required: 3+ file modifications
investigation-budget: 5 tool calls
shell-output-hygiene: enforced (always use compact flags)
context-budget: enforced (warn at 50K, recommend fresh at 100K)
tool-selection: enforced (prefer specific tools, budget per task)
SETTINGS
      ;;
    aggressive) cat <<'SETTINGS'
alignment-gate: active on 2+ file changes
output-compression: ultra (maximum density)
search-first: strict (never read full files >30 lines)
loop-detection: 2 repetitions before halt
plan-required: 2+ file modifications
investigation-budget: 3 tool calls
shell-output-hygiene: strict (always quiet/summary first, never verbose)
context-budget: strict (hard stop at 100K, fresh session at 15 turns)
tool-selection: strict (minimum calls, batch aggressively)
SETTINGS
      ;;
    ultra-aggressive) cat <<'SETTINGS'
alignment-gate: active on ALL multi-step tasks
output-compression: ultra-max (no explanations unless asked)
search-first: strict symbol-only (no grep, no broad reads)
loop-detection: 1 repetition before halt
plan-required: ALL tasks with >1 file
investigation-budget: 2 tool calls
session-limit: single task per session
shell-output-hygiene: maximum (pipe everything through head/tail, no raw output)
context-budget: maximum (hard stop at 50K, fresh session at 10 turns)
tool-selection: maximum (1-2 calls per step, zero exploratory calls)
SETTINGS
      ;;
  esac
}

get_profile_savings() {
  case "$1" in
    conservative)     echo "Input: -15–25% | Output: -20–30% | Risk: Zero" ;;
    balanced)         echo "Input: -40–55% | Output: -50–65% | Risk: Low" ;;
    aggressive)       echo "Input: -60–75% | Output: -70–85% | Risk: Medium" ;;
    ultra-aggressive) echo "Input: -80–90% | Output: -85–95% | Risk: High" ;;
  esac
}

select_profile() {
  echo -e "${CYAN}Select optimization profile:${NC}"
  echo ""
  echo -e "  ${GREEN}1) conservative${NC}    — $(get_profile_desc conservative)"
  echo -e "     Savings: $(get_profile_savings conservative)"
  echo ""
  echo -e "  ${GREEN}2) balanced${NC} ⭐     — $(get_profile_desc balanced)"
  echo -e "     Savings: $(get_profile_savings balanced)"
  echo ""
  echo -e "  ${GREEN}3) aggressive${NC}      — $(get_profile_desc aggressive)"
  echo -e "     Savings: $(get_profile_savings aggressive)"
  echo ""
  echo -e "  ${GREEN}4) ultra-aggressive${NC} — $(get_profile_desc ultra-aggressive)"
  echo -e "     Savings: $(get_profile_savings ultra-aggressive)"
  echo ""
  echo -e "  ${YELLOW}Recommended: balanced (best tradeoff for daily development)${NC}"
  echo ""
  read -rp "  Choose profile [1-4, default=2]: " choice </dev/tty

  case "${choice:-2}" in
    1) SELECTED_PROFILE="conservative" ;;
    2) SELECTED_PROFILE="balanced" ;;
    3) SELECTED_PROFILE="aggressive" ;;
    4) SELECTED_PROFILE="ultra-aggressive" ;;
    conservative) SELECTED_PROFILE="conservative" ;;
    balanced) SELECTED_PROFILE="balanced" ;;
    aggressive) SELECTED_PROFILE="aggressive" ;;
    ultra-aggressive) SELECTED_PROFILE="ultra-aggressive" ;;
    *) SELECTED_PROFILE="balanced" ;;
  esac

  echo ""
  echo -e "  ${GREEN}✓${NC} Profile: ${SELECTED_PROFILE}"
  echo ""
}

generate_profile_header() {
  local settings
  settings="$(get_profile_settings "$SELECTED_PROFILE")"
  cat <<EOF
# ContextSect — Active Profile: ${SELECTED_PROFILE}
# Generated: $(date +%Y-%m-%d)
# Re-run: ./install.sh --profile ${SELECTED_PROFILE}

## Profile Settings
${settings}

---

EOF
}

# ════════════════════════════════════════════════════════════════
# Installation functions per agent
# ════════════════════════════════════════════════════════════════

combine_rules() {
  # Concatenates profile header + all rule files into a single markdown block
  local output=""
  output+="$(generate_profile_header)"
  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    output+="$(cat "$rule_file")"
    output+=$'\n\n---\n\n'
  done
  echo "$output"
}

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    cp "$path" "${path}.bak.$(date +%s)"
    echo -e "    ${YELLOW}↳ Backed up existing: $(basename "$path")${NC}"
  fi
}

install_kiro() {
  echo -e "\n  ${BLUE}Installing for Kiro...${NC}"
  local target="${HOME}/.kiro"
  mkdir -p "${target}/steering" "${target}/skills" "${target}/hooks"

  # Profile steering file
  local profile_file="${target}/steering/000-profile.md"
  backup_if_exists "$profile_file"
  generate_profile_header > "$profile_file"
  echo -e "    ${GREEN}✓${NC} steering/000-profile.md (${SELECTED_PROFILE})"

  # Steering files
  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local name
    name="$(basename "$rule_file")"
    backup_if_exists "${target}/steering/${name}"
    cp "$rule_file" "${target}/steering/${name}"
    echo -e "    ${GREEN}✓${NC} steering/${name}"
  done

  # Hook
  if [[ -f "${ADAPTERS_DIR}/kiro-hooks.json" ]]; then
    backup_if_exists "${target}/hooks/token-optimization.json"
    cp "${ADAPTERS_DIR}/kiro-hooks.json" "${target}/hooks/token-optimization.json"
    echo -e "    ${GREEN}✓${NC} hooks/token-optimization.json"
  fi

  # Skills
  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local skill_name
    skill_name="$(basename "$rule_file" .md)"
    mkdir -p "${target}/skills/${skill_name}"
    # Create SKILL.md with frontmatter
    {
      echo "---"
      echo "name: ${skill_name}"
      echo "description: >-"
      head -3 "$rule_file" | grep "^##" | sed 's/^## /  /'
      echo "---"
      echo ""
      cat "$rule_file"
    } > "${target}/skills/${skill_name}/SKILL.md"
    echo -e "    ${GREEN}✓${NC} skills/${skill_name}/SKILL.md"
  done
}

install_claude_code() {
  echo -e "\n  ${BLUE}Installing for Claude Code...${NC}"
  local target="${HOME}/.claude"
  mkdir -p "${target}"

  # Global CLAUDE.md
  local claude_md="${target}/CLAUDE.md"
  backup_if_exists "$claude_md"

  {
    echo "# Token Optimization Rules"
    echo ""
    echo "These rules are loaded automatically by Claude Code at session start."
    echo "Source: ContextSect framework (https://github.com/BhavanPatel/ContextSect)"
    echo ""
    combine_rules
  } > "$claude_md"
  echo -e "    ${GREEN}✓${NC} ~/.claude/CLAUDE.md"
}

install_cursor() {
  echo -e "\n  ${BLUE}Installing for Cursor...${NC}"
  local target="${HOME}/.cursor/rules"
  mkdir -p "${target}"

  # Profile file (loaded first due to 000 prefix)
  local profile_mdc="${target}/000-profile.mdc"
  backup_if_exists "$profile_mdc"
  {
    echo "---"
    echo "description: \"ContextSect active profile: ${SELECTED_PROFILE}\""
    echo "globs:"
    echo "alwaysApply: true"
    echo "---"
    echo ""
    generate_profile_header
  } > "$profile_mdc"
  echo -e "    ${GREEN}✓${NC} .cursor/rules/000-profile.mdc (${SELECTED_PROFILE})"

  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local name
    name="$(basename "$rule_file" .md)"
    local mdc_file="${target}/9${name}.mdc"
    backup_if_exists "$mdc_file"

    # Create .mdc with YAML frontmatter
    {
      echo "---"
      echo "description: \"Token optimization: ${name}\""
      echo "globs:"
      echo "alwaysApply: true"
      echo "---"
      echo ""
      cat "$rule_file"
    } > "$mdc_file"
    echo -e "    ${GREEN}✓${NC} .cursor/rules/9${name}.mdc"
  done
}

install_windsurf() {
  echo -e "\n  ${BLUE}Installing for Windsurf...${NC}"
  local target="${HOME}/.windsurf/rules"
  mkdir -p "${target}"

  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local name
    name="$(basename "$rule_file")"
    backup_if_exists "${target}/${name}"
    cp "$rule_file" "${target}/${name}"
    echo -e "    ${GREEN}✓${NC} .windsurf/rules/${name}"
  done
}

install_cline() {
  echo -e "\n  ${BLUE}Installing for Cline...${NC}"
  local target="${HOME}/.clinerules"
  mkdir -p "${target}"

  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local name
    name="$(basename "$rule_file")"
    backup_if_exists "${target}/${name}"
    cp "$rule_file" "${target}/${name}"
    echo -e "    ${GREEN}✓${NC} .clinerules/${name}"
  done
}

install_opencode() {
  echo -e "\n  ${BLUE}Installing for OpenCode...${NC}"
  local target="${HOME}"
  local opencode_md="${target}/opencode.md"
  backup_if_exists "$opencode_md"

  {
    echo "# Token Optimization Rules"
    echo ""
    combine_rules
  } > "$opencode_md"
  echo -e "    ${GREEN}✓${NC} ~/opencode.md"
}

install_aider() {
  echo -e "\n  ${BLUE}Installing for Aider...${NC}"
  local target="${HOME}"
  local conventions="${target}/.aider.conventions.md"
  backup_if_exists "$conventions"

  {
    echo "# Token Optimization Conventions"
    echo ""
    combine_rules
  } > "$conventions"

  # Also add read reference to .aider.conf.yml if it exists
  local aider_conf="${target}/.aider.conf.yml"
  if [[ -f "$aider_conf" ]]; then
    if ! grep -q "conventions" "$aider_conf" 2>/dev/null; then
      echo "read: [\".aider.conventions.md\"]" >> "$aider_conf"
      echo -e "    ${GREEN}✓${NC} Updated .aider.conf.yml with read reference"
    fi
  else
    echo "read: [\".aider.conventions.md\"]" > "$aider_conf"
    echo -e "    ${GREEN}✓${NC} Created .aider.conf.yml"
  fi
  echo -e "    ${GREEN}✓${NC} ~/.aider.conventions.md"
}

install_roocode() {
  echo -e "\n  ${BLUE}Installing for RooCode...${NC}"
  local target="${HOME}/.roo/rules"
  mkdir -p "${target}"

  for rule_file in "${RULES_DIR}"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local name
    name="$(basename "$rule_file")"
    backup_if_exists "${target}/${name}"
    cp "$rule_file" "${target}/${name}"
    echo -e "    ${GREEN}✓${NC} .roo/rules/${name}"
  done
}

install_github_copilot() {
  echo -e "\n  ${BLUE}Installing for GitHub Copilot...${NC}"
  # Global instructions (user-level)
  local target="${HOME}/.github"
  mkdir -p "${target}"
  local instructions="${target}/copilot-instructions.md"
  backup_if_exists "$instructions"

  {
    echo "# Token Optimization Rules"
    echo ""
    combine_rules
  } > "$instructions"
  echo -e "    ${GREEN}✓${NC} ~/.github/copilot-instructions.md"
}

install_codex() {
  echo -e "\n  ${BLUE}Installing for OpenAI Codex...${NC}"
  local target="${HOME}"
  local agents_md="${target}/AGENTS.md"
  backup_if_exists "$agents_md"

  {
    echo "# Token Optimization Rules"
    echo ""
    combine_rules
  } > "$agents_md"
  echo -e "    ${GREEN}✓${NC} ~/AGENTS.md"
}

# ════════════════════════════════════════════════════════════════
# Companion Stack Info (display only — no auto-install)
# ════════════════════════════════════════════════════════════════

install_companions() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  Companion Stack — Maximize Token Savings            ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ContextSect handles behavioral optimization (Layer 1)."
  echo -e "  For maximum savings, add these companion tools:"
  echo ""
  echo -e "  ${BLUE}Layer 2: CLI Output Compression (60-90% savings)${NC}"
  echo -e "    RTK:         brew install rtk && rtk init -g"
  echo -e "    Token Juice: tokenjuice install claude-code"
  echo -e "    ${YELLOW}→ https://github.com/rtk-ai/rtk${NC}"
  echo -e "    ${YELLOW}→ https://github.com/vincentkoc/tokenjuice${NC}"
  echo ""
  echo -e "  ${BLUE}Layer 3: API Payload Compression (60-94% savings)${NC}"
  echo -e "    Headroom:    pip install headroom-ai && headroom wrap claude"
  echo -e "    ${YELLOW}→ https://github.com/chopratejas/headroom${NC}"
  echo ""
  echo -e "  ${BLUE}Layer 4: Codebase Knowledge Graph (49-71x reduction)${NC}"
  echo -e "    Graphify:    pip install graphifyy && graphify index ."
  echo -e "    ${YELLOW}→ https://github.com/safishamsi/graphify${NC}"
  echo ""
  echo -e "  ${GREEN}Full guide: docs/companion-stack.md${NC}"
}

# ════════════════════════════════════════════════════════════════
# Main
# ════════════════════════════════════════════════════════════════

main() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  ContextSect — Token Optimization Framework         ║${NC}"
  echo -e "${CYAN}║  Agent-Agnostic • Evidence-Based • Modular          ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Parse arguments
  local WITH_COMPANIONS=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agent)
        IFS=',' read -ra DETECTED_AGENTS <<< "$2"
        echo -e "${CYAN}Using specified agents: ${DETECTED_AGENTS[*]}${NC}"
        shift 2
        ;;
      --profile)
        SELECTED_PROFILE="$2"
        echo -e "${CYAN}Using specified profile: ${SELECTED_PROFILE}${NC}"
        shift 2
        ;;
      --with-companions)
        WITH_COMPANIONS=true
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  # Agent detection (if not specified via flag)
  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    detect_agents
  fi

  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    echo -e "${RED}No agents selected. Exiting.${NC}"
    exit 1
  fi

  # Profile selection (if not specified via flag)
  echo ""
  if [[ -z "$SELECTED_PROFILE" ]]; then
    select_profile
  else
    echo -e "  ${GREEN}✓${NC} Profile: ${SELECTED_PROFILE}"
    echo ""
  fi

  echo -e "${CYAN}Installing for ${#DETECTED_AGENTS[@]} agent(s) with profile '${SELECTED_PROFILE}'...${NC}"

  for agent in "${DETECTED_AGENTS[@]}"; do
    case "$agent" in
      kiro)           install_kiro ;;
      claude-code)    install_claude_code ;;
      cursor)         install_cursor ;;
      windsurf)       install_windsurf ;;
      cline)          install_cline ;;
      opencode)       install_opencode ;;
      aider)          install_aider ;;
      roocode)        install_roocode ;;
      github-copilot) install_github_copilot ;;
      codex)          install_codex ;;
      *)              echo -e "  ${YELLOW}⚠ Unknown agent: ${agent}${NC}" ;;
    esac
  done

  # Companion stack installation
  if [[ "$WITH_COMPANIONS" == true ]]; then
    install_companions
  fi

  echo ""
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  ✅ Installation complete!${NC}"
  echo ""
  echo -e "  Profile:           ${SELECTED_PROFILE}"
  echo -e "  Agents configured: ${DETECTED_AGENTS[*]}"
  echo -e "  Rules installed:   $(ls "${RULES_DIR}"/*.md 2>/dev/null | wc -l | tr -d ' ') files"
  echo ""
  echo -e "  ${YELLOW}Change profile:${NC}  contextsect profile aggressive"
  echo -e "  ${YELLOW}Update rules:${NC}    contextsect update"
  echo -e "  ${YELLOW}Disable/enable:${NC}  contextsect disable | contextsect enable"
  echo -e "  ${YELLOW}Check status:${NC}    contextsect status"
  echo -e "  ${YELLOW}Companions:${NC}      contextsect companions"
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
}

main "$@"
