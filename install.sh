#!/bin/bash
set -euo pipefail

# art CLI installer for macOS/Linux/WSL
# Downloads the latest release binary from GitHub.
# Repo is private — requires GITHUB_TOKEN.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/artalytics/.github/main/install.sh | bash

REPO="artalytics/art-cli"
INSTALL_DIR="$HOME/.local/bin"

# ── Auth check ──────────────────────────────────────────────
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "Error: GITHUB_TOKEN is required to download art (private repo)."
  echo ""
  echo "Get a PAT from: https://github.com/settings/tokens"
  echo "  Required scope: repo (Full control of private repositories)"
  echo ""
  echo "Then run:"
  echo "  export GITHUB_TOKEN=\"ghp_...\""
  echo "  curl -fsSL https://raw.githubusercontent.com/artalytics/.github/main/install.sh | bash"
  exit 1
fi

AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

# ── Detect platform ─────────────────────────────────────────
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)  ARCH="x64" ;;
  aarch64) ARCH="arm64" ;;
  arm64)   ARCH="arm64" ;;
  *)
    echo "Error: Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

TARGET="${OS}-${ARCH}"
BINARY_NAME="art-${TARGET}"

echo "Installing art for ${TARGET}..."

# ── Download latest release ──────────────────────────────────
# For private repos, use the API asset endpoint (not browser_download_url,
# which fails because curl drops auth headers on S3 redirects).
RELEASE_JSON=$(curl -fsSL -H "$AUTH_HEADER" \
  "https://api.github.com/repos/${REPO}/releases/latest")

ASSET_URL=$(echo "$RELEASE_JSON" \
  | grep -B 3 "\"name\": \"${BINARY_NAME}\"" \
  | grep '"url"' \
  | head -1 \
  | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
  echo "Error: No binary found for ${TARGET} in latest release."
  echo "Available at: https://github.com/${REPO}/releases"
  exit 1
fi

mkdir -p "$INSTALL_DIR"
curl -fsSL -H "$AUTH_HEADER" -H "Accept: application/octet-stream" \
  "$ASSET_URL" -o "$INSTALL_DIR/art"
chmod +x "$INSTALL_DIR/art"

echo "  Installed: $INSTALL_DIR/art"

# ── Ensure PATH includes install dir ────────────────────────
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "Add to your shell profile (~/.zshrc or ~/.bashrc):"
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi

# ── Check for Claude Code ───────────────────────────────────
if ! command -v claude &>/dev/null; then
  echo ""
  echo "Claude Code not found. Installing..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

echo ""
echo "Done! Next steps:"
echo "  art login    # Authenticate with Claude"
echo "  art setup    # Install plugins and build profiles"
