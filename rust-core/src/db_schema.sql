# Codex Portátil - SQLite Index Schema

## Database Structure

### Main Notes Table

```sql
CREATE TABLE notes (
    id TEXT PRIMARY KEY,
    vault_id TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    modified DATETIME DEFAULT CURRENT_TIMESTAMP,
    ai_suggested INTEGER DEFAULT 0,
    suggestion_source TEXT,
    suggested_by TEXT,
    provenance_notes TEXT[],
    FOREIGN KEY (vault_id) REFERENCES vaults(id)
);

CREATE INDEX idx_notes_vault ON notes(vault_id);
CREATE INDEX idx_notes_created ON notes(created DESC);
```

### Full-Text Search (FTS5)

```sql
CREATE VIRTUAL TABLE notes_fts USING fts5(
    title, content, properties_text,
    content='journal',
    contentrow=notes.rowid,
    smart_ceiling=1
);

-- Keep FTS table in sync with main table
CREATE TRIGGER update_notes_fts AFTER INSERT ON notes BEGIN
    INSERT INTO notes_fts(rowid, title, content, properties_text) 
    VALUES (new.id, new.title, new.content, json_extract(new.properties, '$'));
END;

CREATE TRIGGER delete_notes_fts AFTER DELETE ON notes BEGIN
    INSERT INTO notes_fts(notes_fts.rowid, title, content, properties_text) 
    VALUES (old.id, old.title, old.content, json_extract(old.properties, '$'));
END;

CREATE TRIGGER replace_notes_fts AFTER UPDATE ON notes BEGIN
    INSERT INTO notes_fts(note_ids, title, content, properties_text) 
    VALUES (new.id, new.title, new.content, json_extract(new.properties, '$'));
    DELETE FROM notes_fts WHERE rowid = new.id;
END;
```

### Properties Table

```sql
CREATE TABLE note_properties (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id TEXT NOT NULL REFERENCES notes(id),
    property_name TEXT NOT NULL,
    property_value TEXT NOT NULL,
    property_type TEXT DEFAULT 'string',  -- string, number, date, selection, checkbox, relation, multi_string
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
);

CREATE INDEX idx_properties_note ON note_properties(note_id);
CREATE INDEX idx_properties_name ON note_properties(property_name);
```

### Tags Table

```sql
CREATE TABLE note_tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id TEXT NOT NULL REFERENCES notes(id),
    tag TEXT NOT NULL UNIQUE,
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tags_note ON note_tags(note_id);
```

### Wikilinks Table (Backlinks)

```sql
CREATE TABLE note_links (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_note_id TEXT NOT NULL REFERENCES notes(id),
    target_note_id TEXT NOT NULL REFERENCES notes(id),
    link_type TEXT DEFAULT 'regular',  -- regular, backlink, forward_link
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(source_note_id, target_note_id)
);

CREATE INDEX idx_links_source ON note_links(source_note_id);
CREATE INDEX idx_links_target ON note_links(target_note_id);
```

### Vector Embeddings Table

```sql
-- For semantic search (sqlite-vec extension or external embedding process)
CREATE TABLE note_embeddings (
    id TEXT PRIMARY KEY REFERENCES notes(id),
    embedding BLOB NOT NULL,  -- Float32 array as blob
    dimension INTEGER NOT NULL DEFAULT 768,
    model_version TEXT DEFAULT 'bge-m3-small',
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- If using sqlite-vec extension:
CREATE VIRTUAL TABLE note_embeddings_ivf USING vec(
    id, embedding,
    distance_type='cosine',
    nprobe=10
);
```

### Vault Information Table

```sql
CREATE TABLE vaults (
    id TEXT PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    name TEXT,
    last_indexed DATETIME DEFAULT CURRENT_TIMESTAMP,
    note_count INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1
);
```

### User Configuration Table

```sql
CREATE TABLE user_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
```

## Indexing Strategy

### Incremental Indexing

1. **File Watcher** detects .md changes in vault directory
2. **Debounced processing** (500ms delay) to avoid excessive writes
3. **Batch operations**: Update multiple notes in single SQLite transaction
4. **FTS5 reindexing** on bulk updates using `REINDEX` command

### Performance Optimizations

```sql
-- Enable WAL mode for concurrent reads/writes
PRAGMA journal_mode = WAL;

-- Increase cache size (tune based on available RAM)
PRAGMA cache_size = -6400;  -- 64MB in pages (1KB each)

-- Sync frequency for durability
PRAGMA sync_normal;

-- Timeout for long operations
PRAGMA busy_timeout = 5000;  -- 5 seconds
```

## Migration from Obsidian

### Import Process

1. Copy `.md` files to `/data/vaults/{vault-name}/`
2. Run import script:
   ```bash
   codex-indexer --import /path/to/obsidian-vault --output /data/index/
   ```
3. Script generates unique IDs, extracts properties/tags from frontmatter
4. Backlinks updated automatically based on `[[link]]` syntax

### Data Preservation

- Original filenames preserved for migration tracking
- Frontmatter merged with Codex schema
- Links to non-existent notes flagged as broken (not auto-created)
