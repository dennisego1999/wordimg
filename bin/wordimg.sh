#!/usr/bin/env bash

# ========================================
# wordimg - Extract and resize images from Word documents
# ========================================

set -e

# -------- Defaults --------
SIZE=1024
BG="white"
FIT="contain"
KEEP=false

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# -------- Usage --------
usage() {
  echo -e "${BLUE}Usage:${RESET}"
  echo "  wordimg --file FILE --output DIR [--size SIZE] [--background COLOR] [--fit contain|cover] [--keep]"
  echo ""
  echo -e "${BLUE}Options:${RESET}"
  echo "  --file       Source .docx file"
  echo "  --output     Output directory"
  echo "  --size       Target width/height in pixels (default: 1024)"
  echo "  --background Background color (default: white, use 'none' for transparency)"
  echo "  --fit        Resize mode: contain (default) or cover"
  echo "  --keep       Keep original extracted images in a _originals subfolder"
  echo "  --help       Show this help message"
  exit 1
}

# -------- Parse Arguments --------
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --file) FILE="$2"; shift ;;
    --output) OUTDIR="$2"; shift ;;
    --size) SIZE="$2"; shift ;;
    --background) BG="$2"; shift ;;
    --fit) FIT="$2"; shift ;;
    --keep) KEEP=true ;;
    --help) usage ;;
    *) echo -e "${RED}✗ Unknown option: $1${RESET}"; usage ;;
  esac
  shift
done

[[ -z "$FILE" || -z "$OUTDIR" ]] && usage

# -------- Spinner Function --------
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 "$pid" 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\r→ %c" "${spinstr:i:1}"
      sleep $delay
    done
  done
  printf "\r"
}

# -------- Temp Folder --------
TMPDIR=$(mktemp -d)

# -------- Step 1: Extract Images --------
echo -e "→ Extracting images from ${FILE}..."
if ! unzip -j "$FILE" "word/media/*" -d "$TMPDIR" >/dev/null; then
  echo -e "${RED}✗ Failed to extract images. Check that the .docx exists and is valid.${RESET}"
  exit 1
fi
echo -e "${GREEN}✓ Images extracted to temporary folder${RESET}"

# -------- Save Originals if --keep --------
if [ "$KEEP" = true ]; then
  mkdir -p "$OUTDIR/_originals"
  cp "$TMPDIR"/* "$OUTDIR/_originals"/
  echo -e "→ Originals saved to ${OUTDIR}/_originals"
fi

# -------- Step 2: Convert Images --------
mkdir -p "$OUTDIR"
resize_flag=""
if [[ "$FIT" == "cover" ]]; then
  resize_flag="^"
fi

echo -e "→ Converting images to target dimensions ${SIZE} with fit=${FIT}..."
magick mogrify \
  -path "$OUTDIR" \
  -resize "${SIZE}x${SIZE}${resize_flag}" \
  -background "$BG" \
  -gravity center \
  -extent "${SIZE}x${SIZE}" \
  "$TMPDIR"/* &
pid=$!
spinner $pid
wait $pid

echo -e "${GREEN}✓ Images resized and saved to ${OUTDIR}${RESET}"

# -------- Cleanup --------
rm -rf "$TMPDIR"
echo -e "${GREEN}✓ Done.${RESET}"
