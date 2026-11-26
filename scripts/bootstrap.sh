#!/bin/bash
# bootstrap.sh — OS detection & minimal setup
# Runs on first launch, sets up environment variables pointing to /data/

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PORTABLE_ROOT="$PROJECT_ROOT"
export DATA_DIR="$PROJECT_ROOT/data"

echo "=== Codex Portátil — Bootstrap ==="
echo "Portable root: $PORTABLE_ROOT"

# Create data dirs
mkdir -p "$DATA_DIR/vaults" "$DATA_DIR/index.db" "$DATA_DIR/config" "$DATA_DIR/cache" "$DATA_DIR/logs"
mkdir -p "$DATA_DIR/models"

echo "Data directories ready at $DATA_DIR"
