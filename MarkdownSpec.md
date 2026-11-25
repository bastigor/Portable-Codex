# Codex Portátil - Markdown File Format Specification

## Overview

All notes are standard Markdown files with optional extended frontmatter for:
- Embedded IDs (unique per vault)
- Provenance metadata (tracking AI suggestions)
- Database indexes (properties, tags)
- Block-level references (for linking and graph)

## Base Syntax

Notes use **CommonMark + GFM** syntax to remain readable in any editor.

### Required Frontmatter Fields

```yaml
---
id: vault-id/unique-slug
created: 2026-11-24T10:30:00Z
modified: 2026-11-24T10:35:00Z
# Optional tags and properties are listed below
---
```

### ID Generation Rules

- Format: `{vault-id}/{unique-slug}`
- Vault ID: First 8 hex chars of SHA-256 hash of vault root path
- Unique slug: Lowercase, hyphenated, from filename or user-generated
- Example: `abc123def/notes/my-awesome-note`

## Provenance Fields (AI-Assisted Content)

```yaml
ai_suggested: true          # AI contributed to this note
suggestion_source: links    # 'links', 'structure', 'format', 'tagging'
suggested_by: qwen-3-0.5b   # Model identifier
provenance_notes: - "Added link to related-note"
                      - "Suggested section hierarchy"
```

**Rules**:
- `ai_suggested: true` only when AI made meaningful contributions
- `provenance_notes` is discrete, line-by-line audit trail
- User can filter/sort by `ai_suggested` field in views

## Extended Block Syntax (Codex Extensions)

### 1. Embedded Note Reference

```markdown
[[notes/related-note#section]]  # Internal link with anchor
[[notes/related-note^block]]    # Link to specific block
```

**Storage**: These are stored as-is; no migration needed for basic [[links]].

### 2. Block-Level IDs

```markdown
{id: notes/my-note}
---
Some content here.
```

Block IDs can be embedded in text for reference tracking.

### 3. Property Fields in Frontmatter

```yaml
properties:
  - name: Project
    value: Codex Portátil
    type: string
  - name: Status
    value: Active
    type: selection
    values: [Active, Archived, Deprecated]
```

**Round-trip guarantee**: Properties are stored in YAML frontmatter, readable by any Markdown editor.

### 4. Callouts (GFM-compatible)

```markdown
> [!NOTE]
> Important information that needs attention.
> 
> [!WARNING]
> This could cause problems.
```

**Compatibility**: Native GFM syntax; works in GitHub, Obsidian, VS Code.

### 5. Tables

```markdown
| Column 1 | Column 2 |
|----------|----------|
| Cell A1  | Cell B1  |
```

**Round-trip**: Standard Markdown tables are preserved exactly.

## Link Resolution

- `[[notes/slug]]` → Resolves to `notes/slug.md`
- `[[notes/slug#anchor]]` → Resolves with fragment
- `[[^backlink]]` → Backlink (reverse lookup from index)
- `[[!tagged-note]]` → Alias resolution

**Warning**: Links to non-existent notes are NOT auto-created. This preserves data sovereignty.

## Migration Compatibility

### From Obsidian

Obsidian vaults can be imported directly:
1. Copy `.md` files to `/data/vaults/`
2. Run `indexer --import /path/to/vault`
3. Generate unique IDs via script
4. Backlinks updated automatically

**No data loss**: Original filenames preserved; internal references only updated.

### From Other Editors

- **Notion exports**: Convert .md → Codex format (scripts provided)
- **Text files**: Auto-detect and wrap in frontmatter template

## Search Index Schema

SQLite schema for full-text search:

```sql
CREATE TABLE notes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created DATETIME,
    modified DATETIME,
    ai_suggested INTEGER DEFAULT 0,
    FOREIGN KEY (vault_id) REFERENCES vaults(id)
);

CREATE VIRTUAL TABLE notes_fts USING fts5(
    title, content, properties,
    content='journal',
    contentrow=notes.rowid
);
```

Vector table for semantic search:

```sql
CREATE TABLE note_embeddings (
    id TEXT PRIMARY KEY REFERENCES notes(id),
    embedding BLOB NOT NULL,  -- Float32 array as blob
    dimension INTEGER NOT NULL,
    model_version TEXT DEFAULT 'bge-m3-small'
);
```

## File Format Enforcement

**No changes to file content on save unless**:
1. User explicitly edits the file
2. AI suggestion accepted and merged
3. Provenance metadata added/updated

**Round-trip test**: Save a note → reopen → compare byte-for-byte (excluding provenance fields).

## Validation Rules

- ID must be unique within vault
- Created timestamp cannot be in future
- Modified timestamp must be >= created timestamp
- `ai_suggested` cannot be true without corresponding `provenance_notes`
