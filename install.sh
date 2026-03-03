#!/usr/bin/env bash
set -e

BIN_NAME="wordimg"
SOURCE_FILE="bin/wordimg"

# Determine install directory
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
else
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo "Installing $BIN_NAME to $INSTALL_DIR..."

chmod +x "$SOURCE_FILE"
cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"

echo "✓ Installed successfully."

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  IMPORTANT:"
    echo "Add the following line to your shell config (~/.zshrc or ~/.bashrc):"
    echo ""
    echo "export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
    echo "Then run: source ~/.zshrc"
else
    echo "✓ $INSTALL_DIR is already in your PATH."
fi