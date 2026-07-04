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
  read -rp "Select agents (comma-separated numbers, or 'a' for all): " selection

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
# Installation functions per agent
# ════════════════════════════════════════════════════════════════

combine_rules() {
  # Concatenates all rule files into a single markdown block
  local output=""
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
# Main
# ════════════════════════════════════════════════════════════════

main() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  ContextSect — Token Optimization Framework         ║${NC}"
  echo -e "${CYAN}║  Agent-Agnostic • Evidence-Based • Modular          ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Check for --agent flag for explicit selection
  if [[ "${1:-}" == "--agent" ]] && [[ -n "${2:-}" ]]; then
    IFS=',' read -ra DETECTED_AGENTS <<< "$2"
    echo -e "${CYAN}Using specified agents: ${DETECTED_AGENTS[*]}${NC}"
    echo ""
  else
    detect_agents
  fi

  if [[ ${#DETECTED_AGENTS[@]} -eq 0 ]]; then
    echo -e "${RED}No agents selected. Exiting.${NC}"
    exit 1
  fi

  echo ""
  echo -e "${CYAN}Installing for ${#DETECTED_AGENTS[@]} agent(s)...${NC}"

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

  echo ""
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  ✅ Installation complete!${NC}"
  echo ""
  echo -e "  Agents configured: ${DETECTED_AGENTS[*]}"
  echo -e "  Rules installed:   $(ls "${RULES_DIR}"/*.md 2>/dev/null | wc -l | tr -d ' ') files"
  echo ""
  echo -e "  ${YELLOW}Tip:${NC} Re-run anytime to update. Existing files backed up automatically."
  echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
}

main "$@"
