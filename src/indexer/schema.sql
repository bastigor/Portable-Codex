-- Codex Portátil — Database Schema
-- Generated: 2026-11-24

PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

-- Principais tabelas
CREATE TABLE IF NOT EXISTS notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL UNIQUE,           -- /vault/notes/note.md
    title TEXT,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN DEFAULT 0
);

CREATE TABLE IF NOT EXISTS notes_properties (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id INTEGER NOT NULL,
    property_name TEXT NOT NULL,         -- 'tags', 'date', etc.
    property_value TEXT,
    property_type TEXT,                  -- 'text', 'number', 'date', 'select', 'checkbox'
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wikilinks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id INTEGER NOT NULL,
    target_note TEXT NOT NULL,           -- [[nota]] or [[nota#section]]
    link_type TEXT DEFAULT 'forward',    -- forward, backward, alias
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id INTEGER NOT NULL,
    tag TEXT NOT NULL UNIQUE,            -- #tag-name
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
);

-- Indexes para performance
CREATE INDEX IF NOT EXISTS idx_notes_path ON notes(path);
CREATE INDEX IF NOT EXISTS idx_notes_created ON notes(created_at);
CREATE INDEX IF NOT EXISTS idx_wikilinks_target ON wikilinks(target_note);
CREATE INDEX IF NOT EXISTS idx_tags_tag ON tags(tag);

-- Full-text search (FTS5)
CREATE VIRTUAL TABLE IF NOT EXISTS notes_fts USING fts5(
    content,
    content='notes',
    content_rowid=rowid
);

-- Trigger para manter FTS atualizado
CREATE TRIGGER IF NOT EXISTS notes_fts_ai AFTER INSERT ON notes BEGIN
    INSERT INTO notes_fts(rowid, content) VALUES (new.id, new.content);
END;
CREATE TRIGGER IF NOT EXISTS notes_fts_ad AFTER DELETE ON notes BEGIN
    INSERT INTO notes_fts(rowid, content) VALUES (old.id, '');
END;
CREATE TRIGGER IF NOT EXISTS notes_ftsau AFTER UPDATE ON notes BEGIN
    INSERT INTO notes_fts(rowid, content) VALUES (new.id, new.content);
END;

-- Views de banco de dados
CREATE VIEW IF NOT EXISTS note_db_view AS
SELECT 
    n.id,
    n.path,
    n.title,
    COALESCE(SUBSTR(n.content, 1, INSTR(n.content, '\n\n') - 1), '') as first_block,
    n.created_at,
    n.updated_at
FROM notes n;

-- Configurações do usuário
CREATE TABLE IF NOT EXISTS user_settings (
    key TEXT PRIMARY KEY,
    value TEXT
);

INSERT OR REPLACE INTO user_settings (key, value) VALUES 
    ('theme', 'dark'),
    ('ai_enabled', 'true'),
    ('ai_mode', 'passive');
