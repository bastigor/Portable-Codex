# Progress Tracker

## Status: em andamento (in progress)

### Completed
- [x] Phase 0: ADRs (ADR-001 to ADR-005), architecture diagram, data model, file format spec, test strategy, progress tracker
- [x] Phase 1 skeleton (Tauri 2, Cargo.toml, main.rs, UI components, scripts/install.sh, bootstrap.sh, setup.sh)
- [x] Phase 2 core (SQLite schema, indexer script, sample note, round-trip verified byte-identical)
- [x] Phase 3: Editor in Blocs + Interface (quick switcher, tabs, templates, editor.ts) and UI components
- [x] Phase 4: Grafo e Visões de Banco de Dados (graph lib.rs, main.rs commands, graph/views UI)

### In Progress
- [ ] ProseMirror/TipTap editor integration — block reorder, insert/delete/cut via helpers
- [ ] SQLite indexer daemon with FTS5 + sqlite-vec
- [ ] AI sidecar: llama.cpp GGUF process integration
- [ ] Install script v0 (idempotent, offline mode)
- [ ] Views rendering (table/kanban/list/calendar pages)

### Risks
- WebView2/WebKitGTK on varied machines — mitigated by Tauri sandbox
- Round-trip Markdown byte-perfect — PyYAML quirk with `|` literal blocks; fix in ProseMirror plugin
- Portability to exFAT/NTFS — documented fallback

### Next Steps
- Phase 5: AI inference sidecar and hardware detection (Metal/Vulkan/CUDA/AVX2/NEON)
- Phase 6: Copiloto — structurar, formatar, conectar, etiquetar, modo socrático, proveniência
- Phase 7: Instalador final, remoção segura do pendrive (atômicas, journaling SQLite)
- Phase 8: Qualidade e entrega — performance, acessibilidade, documentação de usuário

### Push to GitHub
```
4aea229 main -> main   (https://github.com/bastigor/Portable-Codex.git)
```

### Commits
- `172b3a9` Phase 3: Editor + Interface
- `4aea229` Phase 4: Grafo e Visões de Banco de Dados
