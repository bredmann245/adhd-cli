#!/usr/bin/env sh
set -e

REPO="bredmann245/adhd-cli"
BIN="adhd"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

OS="$(uname -s)"

case "$OS" in
  Darwin) ASSET="$BIN-macOS.tar.gz" ;;
  Linux)  ASSET="$BIN-Linux.tar.gz" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

URL="https://github.com/$REPO/releases/latest/download/$ASSET"

echo "⬇️  Downloading: $URL"
tmpdir="$(mktemp -d)"
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

mkdir -p "$INSTALL_DIR"

curl -fsSL "$URL" -o "$tmpdir/$ASSET"
tar -xzf "$tmpdir/$ASSET" -C "$tmpdir"

if [ ! -f "$tmpdir/$BIN" ]; then
  echo "❌ Expected '$BIN' inside the archive root, but didn't find it."
  echo "   Fix your release packaging so the tar.gz contains just the '$BIN' binary."
  exit 1
fi

chmod +x "$tmpdir/$BIN"
mv "$tmpdir/$BIN" "$INSTALL_DIR/$BIN"

echo "✅ Installed $BIN -> $INSTALL_DIR/$BIN"

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo "⚠️  '$INSTALL_DIR' is not in your PATH."
  echo "Add this to your shell config (zsh/bash):"
  echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc"
  echo "  source ~/.zshrc"
fi

echo "🎉 Try: $BIN --help"
