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

# Function for interactive confirmation with default "y"
confirm() {
  local prompt="$1"
  local default="${2:-y}"  # default value is "y"
  local response

  # Show prompt with default in uppercase (manually, no ${^^})
  if [ "$default" = "y" ]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -p "$prompt" response
  response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

  if [ -z "$response" ]; then
    response="$default"
  fi

  if [ "$response" = "y" ] || [ "$response" = "yes" ]; then
    return 0  # yes
  else
    return 1  # no
  fi
}

# Determine install directory
if [ -d "$HOME/.local/bin" ]; then
  INSTALL_DIR="$HOME/.local/bin"
elif [ -d "/usr/local/bin" ]; then
  if confirm "No local bin found. Install $BIN_NAME system-wide in /usr/local/bin? This may require your password."; then
    INSTALL_DIR="/usr/local/bin"
  else
    echo "✗ Aborting installation."
    exit 1
  fi
else
  echo "✗ Error: No suitable install directory found."
  exit 1
fi

echo "Installing $BIN_NAME to $INSTALL_DIR..."
chmod +x "$SOURCE_FILE"

# Copy file (use sudo if necessary)
if [ -w "$INSTALL_DIR" ]; then
  cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
else
  echo "Requires sudo to install to $INSTALL_DIR"
  sudo cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
fi

echo "✓ Installed successfully."