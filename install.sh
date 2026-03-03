#!/usr/bin/env bash

# ========================================
# install.sh - Install wordimg to your local bin
# ========================================

set -e

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

# -------- Dependency Checks --------
require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo -e "${RED}✗ '$1' is required but not installed.${RESET}"
    echo "  → On macOS: brew install $1"
    echo "  → On Debian/Ubuntu: sudo apt install $1"
    exit 1
  fi
}

require_command cp
require_command chmod

# -------- Config --------
BIN_NAME="wordimg"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/bin/wordimg"

# -------- Validate Source --------
if [ ! -f "$SOURCE_FILE" ]; then
  echo -e "${RED}✗ Error: $SOURCE_FILE not found.${RESET}"
  echo "  Make sure you are running install.sh from the project root."
  exit 1
fi

# -------- Helpers --------
confirm() {
  local prompt reply
  prompt="${1:-Are you sure? } (Y/y): "
  if [ ! -t 0 ] || [ ! -t 1 ]; then
    echo "Skipping prompt: '$prompt' (non-interactive mode)" >&2
    return 1
  fi

  while true; do
    echo -en "$prompt"
    read -r reply
    case "$reply" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      *) return 1 ;;
    esac
  done
}

# -------- Resolve Install Directory --------
if [ -d "$HOME/.local/bin" ]; then
  INSTALL_DIR="$HOME/.local/bin"
elif [ -d "/usr/local/bin" ]; then
  if confirm "No local bin found. Installing ${BLUE}$BIN_NAME${RESET} system-wide to ${BLUE}/usr/local/bin${RESET} — this will prompt for your sudo password. Proceed?"; then
    INSTALL_DIR="/usr/local/bin"
  else
    echo -e "${RED}✗ Aborting installation.${RESET}"
    exit 1
  fi
else
  echo -e "${RED}✗ Error: No suitable install directory found.${RESET}"
  exit 1
fi

# -------- Install --------
echo -e "→ Installing ${BLUE}$BIN_NAME${RESET} to ${BLUE}$INSTALL_DIR"${RESET}
chmod +x "$SOURCE_FILE"

if [ -w "$INSTALL_DIR" ]; then
  cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
else
  sudo cp "$SOURCE_FILE" "$INSTALL_DIR/$BIN_NAME"
fi

echo -e "${GREEN}✓ Installed successfully.${RESET}"