#!/bin/bash

# Determine the absolute path to the opencode.sh script
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$INSTALL_DIR/opencode.sh"
BASHRC="$HOME/.bashrc"

echo "Installing OpenCode CLI wrapper..."

# Ensure ~/.opencode exists and copy AGENTS.md there
mkdir -p "$HOME/.opencode"
cp "$INSTALL_DIR/AGENTS.md" "$HOME/.opencode/AGENTS.md"
echo "✅ Copied AGENTS.md to $HOME/.opencode/AGENTS.md"

# Check if the script is already sourced in .bashrc
if grep -q "source \"$SCRIPT_PATH\"" "$BASHRC"; then
    echo "✅ opencode.sh is already sourced in $BASHRC"
else
    # Backup .bashrc
    cp "$BASHRC" "$BASHRC.bak"
    
    # Append the source command
    echo "" >> "$BASHRC"
    echo "# OpenCode CLI Wrapper" >> "$BASHRC"
    echo "source \"$SCRIPT_PATH\"" >> "$BASHRC"
    echo "✅ Added source command to $BASHRC"
fi

echo ""
echo "Installation complete!"
echo "Please run 'source $BASHRC' or restart your terminal to start using 'opencode'."
