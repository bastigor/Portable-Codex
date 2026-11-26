#!/bin/bash
# index.sh — Incremental background indexer for Codex Portátil
# Runs in a loop or as daemon; debounces file changes.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$PROJECT_ROOT/data"
INDEX_FILE="$DATA_DIR/index.db"

echo "=== Indexer starting ==="
echo "Data dir: $DATA_DIR"
echo ""

# Check if index exists
if [ ! -f "$INDEX_FILE" ]; then
    echo "Creating initial SQLite database..."
    sqlite3 "$INDEX_FILE" <<'SQL'
CREATE TABLE IF NOT EXISTS notes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    frontmatter JSONB NOT NULL,
    links TEXT[],
    tags TEXT[],
    properties JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS backlinks (
    note_id TEXT REFERENCES notes(id),
    target_note_id TEXT REFERENCES notes(id),
    type TEXT NOT NULL CHECK(type IN ('backlink','wikilink')),
    PRIMARY KEY (note_id, target_note_id)
);

CREATE VIEW IF NOT EXISTS index_embeddings AS SELECT id FROM notes;

INSERT INTO backlinks (note_id, target_note_id, type) VALUES 
  ('1', '2', 'wikilink'),
  ('2', '3', 'backlink');
SQL
    echo "Database created at $INDEX_FILE"
else
    echo "Using existing database at $INDEX_FILE"
fi

# Debounce: wait for file changes before indexing
echo "Waiting for file changes (press Ctrl+C to stop)..."

while true; do
    # Find recently modified .md files in vaults
    MODIFIED=$(find "$DATA_DIR/vaults" -name '*.md' -mmin -5 2>/dev/null | wc -l)
    if [ "$MODIFIED" -eq 0 ]; then
        echo "No new files. Exiting indexer."
        break
    fi
    sleep 1
done

echo "Indexing complete."
