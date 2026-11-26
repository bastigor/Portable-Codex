#!/bin/bash
# setup.sh — One-command portable installer (Windows cmd/PowerShell, macOS/Linux sh/bash)
# Detects OS/arch; runs bootstrap then install.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Codex Portátil — Setup ==="
echo "Project: $PROJECT_ROOT"
echo ""

# Step 1: Bootstrap
echo "[1/2] Running bootstrap..."
bash "$SCRIPT_DIR/bootstrap.sh"
echo ""

# Step 2: Install (idempotent)
echo "[2/2] Running install..."
chmod +x "$SCRIPT_DIR/install.sh"
bash "$SCRIPT_DIR/install.sh"
echo ""
echo "=== Setup complete ==="
echo "Data lives in: $PROJECT_ROOT/data"
