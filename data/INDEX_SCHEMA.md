# SQLite Database Initialization

## Notes Table Schema
```sql
CREATE TABLE notes (
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
```

## Backlinks Table Schema
```sql
CREATE TABLE backlinks (
    note_id TEXT REFERENCES notes(id),
    target_note_id TEXT REFERENCES notes(id),
    type TEXT NOT NULL CHECK(type IN ('backlink','wikilink')),
    PRIMARY KEY (note_id, target_note_id)
);
```

## Embeddings View
```sql
CREATE VIEW index_embeddings AS SELECT id FROM notes;
```
