# Codex Portátil (Codex Portable)

Personal Knowledge Management app — local-first, Obsidian + Notion hybrid.

## Features
- **Vault**: Markdown files (.md) with YAML frontmatter, wikilinks, backlinks, graph
- **Editor**: Block-based (ProseMirror/TipTap), menu "/", drag & drop reorder
- **AI Copilot**: Local LLM (llama.cpp GGUF), silent suggestions, ghost text opt-in
- **Database**: SQLite WAL + FTS5 + sqlite-vec for embeddings
- **Views**: Tables, kanban, lists, calendar — per properties
- **Search**: Full-text, property, tag, semantic (embeddings)
- **Portable**: Single install script, no network at runtime, zero external writes

## Architecture
- Rust core + Tauri 2 frontend
- Monorepo: `/app/`, `/models/`, `/data/`, `/scripts/`, `/docs/`
- No telemetry, no cloud, no admin rights needed

## Quick Start (Windows)
```cmd
C:\Users\João Pedro\Documents\projetos\codex-portable\install.sh
```

## Requirements
- Rust 1.75+ (or cargo from crates.io)
- Tauri 1.6+
- macOS: Apple Silicon or Intel
- Linux: x86_64 or arm64

## License
MIT OR Apache-2.0
