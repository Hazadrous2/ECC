#!/bin/bash
set -euo pipefail

# Only run in remote (cloud) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REPO_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Install npm dependencies if needed
if [ ! -d "$REPO_DIR/node_modules" ]; then
  echo "[session-start] Installing npm dependencies..."
  (cd "$REPO_DIR" && npm install --no-audit --no-fund --loglevel=error)
else
  echo "[session-start] node_modules present, skipping npm install."
fi

# Install ECC into ~/.claude if not already installed
if [ ! -f "$HOME/.claude/ecc/install-state.json" ]; then
  echo "[session-start] Installing ECC into ~/.claude/ ..."
  (cd "$REPO_DIR" && node scripts/install-apply.js python)
else
  echo "[session-start] ECC already installed, skipping."
fi
