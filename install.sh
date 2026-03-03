#!/usr/bin/env bash
set -e

BIN_NAME="wordimg"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/bin/wordimg"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "✗ Error: $SOURCE_FILE not found."
  echo "Make sure you are running install.sh from the project root."
  exit 1
fi

# Determine install directory
if [ -d "/usr/local/bin" ]; then
  INSTALL_DIR="/usr/local/bin"
elif [ -d "/opt/homebrew/bin" ]; then
  INSTALL_DIR="/opt/homebrew/bin"
else
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
fi

echo "Installing $BIN_NAME to $INSTALL_DIR..."

chmod +x "$SOURCE_FILE"

if [ -w "$INSTALL_DIR" ]; then
  cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
else
  echo "Requires sudo to install to $INSTALL_DIR"
  sudo cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
fi

echo "✓ Installed successfully."