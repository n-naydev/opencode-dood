#!/bin/bash

# Determine the absolute path to the gemini.sh script
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$INSTALL_DIR/gemini.sh"
BASHRC="$HOME/.bashrc"

echo "Installing Gemini CLI wrapper..."

# Ensure ~/.gemini/instructions exists and copy GEMINI.md there
mkdir -p "$HOME/.gemini/instructions"
cp "$INSTALL_DIR/GEMINI.md" "$HOME/.gemini/instructions/GEMINI.md"
echo "✅ Copied GEMINI.md to $HOME/.gemini/instructions/GEMINI.md"

# Check if the script is already sourced in .bashrc
if grep -q "source \"$SCRIPT_PATH\"" "$BASHRC"; then
    echo "✅ gemini.sh is already sourced in $BASHRC"
else
    # Backup .bashrc
    cp "$BASHRC" "$BASHRC.bak"
    
    # Append the source command
    echo "" >> "$BASHRC"
    echo "# Gemini CLI Wrapper" >> "$BASHRC"
    echo "source \"$SCRIPT_PATH\"" >> "$BASHRC"
    echo "✅ Added source command to $BASHRC"
fi

echo ""
echo "Installation complete!"
echo "Please run 'source $BASHRC' or restart your terminal to start using 'gemini'."
