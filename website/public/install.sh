#!/usr/bin/env bash
# ContextSect — Agent-Agnostic Token Optimization
# Usage: curl -sL https://contextsect.vercel.app/install.sh | bash
set -e

REPO="https://github.com/BhavanPatel/ContextSect.git"
INSTALL_DIR="${HOME}/.contextsect"

echo ""
echo "  ╭──────────────────────────────────────────────╮"
echo "  │   ContextSect — Token Optimization           │"
echo "  │   Agent-Agnostic • Evidence-Based • Modular  │"
echo "  ╰──────────────────────────────────────────────╯"
echo ""

# Check git
if ! command -v git &>/dev/null; then
    echo "  ✗ git not found. Install git first."
    exit 1
fi
echo "  ✓ git $(git --version | awk '{print $3}')"

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
    echo "  ↻ Updating existing installation..."
    cd "$INSTALL_DIR" && git pull --quiet
else
    echo "  ↓ Cloning ContextSect..."
    git clone --quiet "$REPO" "$INSTALL_DIR"
fi

echo "  ✓ Source ready at ${INSTALL_DIR}"
echo ""

# Run the installer
cd "$INSTALL_DIR"
chmod +x install.sh
exec ./install.sh "$@"
