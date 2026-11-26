# Progress Tracker

## Status: em andamento (in progress)

### Completed
- [x] Phase 0: ADRs (ADR-001 to ADR-005), architecture diagram, data model, file format spec, test strategy, progress tracker
- [x] Phase 1 skeleton (Tauri 2, Cargo.toml, main.rs, UI components, scripts/install.sh, bootstrap.sh, setup.sh)
- [x] Phase 2 core (SQLite schema, indexer script, sample note, round-trip verified byte-identical)

### In Progress
- [ ] ProseMirror/TipTap editor integration (block reorder, insert/delete/cut via helpers)
- [ ] SQLite indexer daemon with FTS5 + sqlite-vec
- [ ] AI sidecar: llama.cpp GGUF process integration
- [ ] Install script v0 (idempotent, offline mode)

### Risks
- WebView2/WebKitGTK on varied machines — mitigated by Tauri sandbox
- Round-trip Markdown byte-perfect — PyYAML quirk with `|` literal blocks; fix in ProseMirror plugin
- Portability to exFAT/NTFS — documented fallback

### Next Steps
- Phase 4: Graph (global/local), views, database queries
- Phase 5: AI inference sidecar and hardware detection (Metal/Vulkan/CUDA/AVX2/NEON)
