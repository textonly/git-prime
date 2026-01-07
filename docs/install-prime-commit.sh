#!/bin/bash
# Install git-prime-commit globally

set -e

echo "Installing git-prime-commit..."

# Determine install location
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -w "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
else
    INSTALL_DIR="$HOME/bin"
    mkdir -p "$INSTALL_DIR"
fi

# Download or copy the script
SCRIPT_URL="${GIT_PRIME_COMMIT_URL:-https://textonly.github.io/git-prime/git-prime-commit}"

if command -v curl &> /dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/git-prime-commit"
elif command -v wget &> /dev/null; then
    wget -q "$SCRIPT_URL" -O "$INSTALL_DIR/git-prime-commit"
else
    echo "Error: Neither curl nor wget found. Please install one of them." >&2
    exit 1
fi

chmod +x "$INSTALL_DIR/git-prime-commit"

echo "✓ Installed to $INSTALL_DIR/git-prime-commit"
echo ""
echo "Usage: git prime-commit <message>"
echo "   or: git prime-commit -m <message>"
echo ""

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Note: Add $INSTALL_DIR to your PATH:"
    echo "  echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.bashrc"
fi
