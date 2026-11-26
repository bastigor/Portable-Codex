# Data Model Specification

## Notes Table (SQLite)

```sql
CREATE TABLE notes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    frontmatter JSONB NOT NULL,  -- yaml parsed into jsonb
    links TEXT[],                -- wikilink table serialized as JSON array
    tags TEXT[],                 -- tag list
    properties JSONB,            -- property key/value pairs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE backlinks (
    note_id TEXT REFERENCES notes(id),
    target_note_id TEXT REFERENCES notes(id),
    type TEXT NOT NULL CHECK(type IN ('backlink','wikilink')),
    PRIMARY KEY (note_id, target_note_id)
);
```

## Link Types
- `[[nota]]` → wikilink: note_id = current, target_note_id = referenced
- `[[nota#sec]]` → section link within same note
- `[[nota^bloco]]` → block reference

## Tags & Properties (Frontmatter)
```yaml
---
title: "My Note"
body: |
  Content here...
tags:
  - [tagname1]
  - [tagname2]
properties:
  status: draft
  priority: high
  created_by: João
---

```

## Backlinks Table

```sql
CREATE TABLE backlinks (
    note_id TEXT REFERENCES notes(id),
    target_note_id TEXT REFERENCES notes(id),
    type TEXT NOT NULL CHECK(type IN ('backlink','wikilink')),
    PRIMARY KEY (note_id, target_note_id)
);
```

## Embeddings Index (sqlite-vec)

```sql
CREATE VIEW index_embeddings AS SELECT id, title, body FROM notes;
-- Populate via FTS5 or custom vector store
```
