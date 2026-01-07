#!/bin/bash
# Install git-prime tools globally

set -e

echo "Installing git-prime tools..."

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

BASE_URL="https://textonly.github.io/git-prime"
TOOLS=("git-prime-commit" "git-prime-log")

for tool in "${TOOLS[@]}"; do
    TARGET="$INSTALL_DIR/$tool"
    URL="${BASE_URL}/${tool}"
    
    echo "Downloading $tool..."
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$URL" -o "$TARGET"
    elif command -v wget &> /dev/null; then
        wget -q "$URL" -O "$TARGET"
    else
        echo "Error: Neither curl nor wget found. Please install one of them." >&2
        exit 1
    fi
    
    chmod +x "$TARGET"
done

echo ""
echo "✓ Successfully installed to $INSTALL_DIR"
echo ""
echo "Usage:"
echo "  git prime-commit \"message\"   # Create a prime commit"
echo "  git prime-log                # View log with prime highlights"
echo ""

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Note: Add $INSTALL_DIR to your PATH to use git subcommands:"
    echo "  echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi
