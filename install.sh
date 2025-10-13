#!/usr/bin/env sh
# Lightweight installer for contxtify (GPL-3.0-or-later)
# Installs the single bash script into /usr/local/bin if writable,
# else falls back to ~/.local/bin. Override via env vars below.

set -eu

REPO="${REPO:-RAMCloudCode/contxtify}"   # GitHub "owner/repo"
REF="${REF:-main}"                        # branch or tag; default main
SRC_PATH="${SRC_PATH:-contxtify}"         # path to script in repo
BIN_NAME="${BIN_NAME:-contxtify}"         # install name
PREFIX="${PREFIX:-/usr/local}"            # preferred prefix (if writable)
TARGET_DIR="${TARGET_DIR:-$PREFIX/bin}"   # preferred bin dir
FALLBACK_DIR="${FALLBACK_DIR:-$HOME/.local/bin}"

# Pick install dir
INSTALL_DIR="$TARGET_DIR"
if [ ! -w "$TARGET_DIR" ] 2>/dev/null; then
  INSTALL_DIR="$FALLBACK_DIR"
  mkdir -p "$INSTALL_DIR"
fi

# Fetch helper (curl or wget)
fetch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$1" -O "$2"
  else
    echo "Error: need curl or wget" >&2
    exit 1
  fi
}

RAW_URL="https://raw.githubusercontent.com/$REPO/$REF/$SRC_PATH"
TMP="$(mktemp -t contxtify.XXXXXX)"
trap 'rm -f "$TMP"' EXIT

echo "Downloading $BIN_NAME from $RAW_URL"
fetch "$RAW_URL" "$TMP"

# Sanity check: shebang on first line
if ! head -n 1 "$TMP" | grep -q '^#!/usr/bin/env bash$'; then
  echo "Download sanity check failed (unexpected shebang)" >&2
  exit 1
fi

chmod +x "$TMP"
mv "$TMP" "$INSTALL_DIR/$BIN_NAME"

# Minimal dependency hints (non-fatal)
need() { command -v "$1" >/dev/null 2>&1; }
missing=""
for d in bash find mktemp sed cat; do need "$d" || missing="$missing $d"; done
if [ -n "$missing" ]; then
  echo "Note: missing deps (script may still work with fallbacks):$missing" >&2
fi
if ! need realpath; then
  echo "Note: 'realpath' not found. Script includes a fallback; install coreutils for best results." >&2
fi

# PATH hint
case ":$PATH:" in
  *":$INSTALL_DIR:"*) : ;;
  *) echo "Add to PATH: export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
esac

echo "Installed to $INSTALL_DIR/$BIN_NAME"
