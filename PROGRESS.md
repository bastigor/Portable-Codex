---
title: "Codex Portátil - Project Progress"
last_updated: "2026-11-24"
phase: 1
status: "in progress"
---

## Completed (Phase 0)

- [x] Project workspace initialized
- [x] Initial TypeScript/Tauri structure created
- [x] Architecture decisions documented (ADR #1, ADR #2)
- [x] Mermaid architecture diagram created
- [x] Markdown file format specification defined
- [x] Round-trip test suite designed
- [x] Test strategy and coverage plan established

## Completed (Phase 1 - Skeleton)

- [x] Rust core structure created
- [x] Path validation enforcement implemented
- [x] SQLite schema with FTS5 designed
- [x] Unit tests written

## In Progress

### Phase 1: Portable Skeleton
- [ ] File watcher with platform fallbacks
- [ ] "No external writes" enforcement test

## Blockers

|| Blocker | Impact | Workaround |
|---------|--------|------------|
| Rust toolchain verification failed (winget upgrade needed) | High | Run: `winget upgrade --accept-source-agreements` then verify with `cargo --version`

## Files Created in This Session

| File | Purpose | Size |
|------|---------|------|
| PROGRESS.md | Project status tracker | - |
| README.md | Project overview | - |
| package.json | Node.js dependencies | - |
| tsconfig.json | TypeScript configuration | - |
| vite.config.ts | Vite bundler config | - |
| tauri.conf.json | Tauri desktop app config | - |
| index.html | Entry point HTML | - |
| src/main.tsx | React entry point | - |
| src/App.tsx | Main application component | - |
| MarkdownSpec.md | File format specification | 4.5KB |
| test-roundtrip.test.ts | Round-trip test examples | 5KB |
| TEST_STRATEGY.md | Test suite overview | 4.7KB |
| ADRS/ADR001.md | Stack decision (Tauri vs Electron) | - |
| ADRS/ADR002.md | AI architecture decision | - |
| ARCHITECTURE.md | System diagram | - |
| rust-core/Cargo.toml | Rust dependencies | - |
| rust-core/src/lib.rs | Core state and IPC messages | - |
| rust-core/src/bin/codex-watcher.rs | File watcher with path validation | - |
| rust-core/src/db_schema.sql | SQLite schema design | - |
| INSTALL_INSTRUCTIONS.md | Rust installation guide | - |
| PHASE1_PLAN.md | Phase 1 implementation plan | - |

## Technical Decisions Summary

### 1. Desktop Framework: Tauri 2
**Decision**: Tauri 2 over Electron
**Rationale**: 
- 43x smaller binary (~5MB vs ~165MB)
- Faster cold start (0.3-1s vs 1-3s)
- Better security sandboxing

### 2. AI Architecture: Sidecar Pattern
**Decision**: llama-server sidecar with JSON-RPC IPC
**Rationale**:
- Cancellation support at any point
- Streaming tokens without buffering
- Memory isolation (AI crashes don't crash app)
- Priority queue for interactive typing > background indexing

### 3. Database: SQLite + FTS5 + Vector Extension
**Decision**: SQLite with optional sqlite-vec extension
**Rationale**:
- Zero external dependencies
- Cross-platform binary distribution
- WAL mode for concurrent access

## Acceptance Criteria (Phase 0)

1. [ ] ADRs document all major architectural decisions ✓
2. [ ] Architecture diagram provides clear system overview ✓
3. [ ] Markdown format spec defines provenance and round-trip guarantees ✓
4. [ ] Test suite validates round-trip serialization ⏳ (pending implementation)
5. [ ] Spike tests confirm Tauri 2 meets cold start requirements ⏳ (pending)

## Next Steps (Phase 0 Completion)

1. **Spike 1: Tauri 2 Binary Size & Startup**
   - Build minimal Tauri app with React frontend
   - Measure compressed binary size (target: <50MB)
   - Measure cold start on USB 3.0 (target: <5s)
   
2. **Spike 2: File Watcher Reliability**
   - Test in-memory file watcher vs polling
   - Test on exFAT, NTFS, ext4
   - Determine fallback strategy for unreliable platforms

3. **Markdown Implementation**
   - Build Markdown parser/serializer with provenance tracking
   - Implement round-trip tests (target: 100% byte-identical)
   - Validate against Obsidian vault import

## Metrics to Measure

| Metric | Target | Status |
|--------|--------|--------|
| Cold start (Tauri standalone) | <5s | Pending |
| Binary size (compressed) | <50MB | Pending |
| Markdown round-trip | 100% byte-identical | Pending |
| Index update latency | <3s for 1000 notes | Pending |
| Search latency (50K notes) | <150ms | Pending |

## Risks and Mitigations

| Risk | Impact | Mitigation | Status |
|------|--------|------------|--------|
| exFAT file watcher reliability | High | Polling fallback when events unreliable | Identified |
| SQLite on exFAT performance | Medium | WAL mode, batch operations, RAM cache | Identified |
| Windows WebView2 availability | High | Bundle fixed version or Tauri fallback | Documented |
| macOS Gatekeeper quarantine | Low | Document workaround; optional notarization | Documented |
| Linux library dependencies | Medium | Static linking or AppImage approach | Documented |

## User Questions (For Decision)

1. Should I proceed with Tauri 2 or consider Electron if you need larger ecosystem packages?
2. What's your target minimum RAM for the AI model (8GB/16GB recommended)?
3. Should Portuguese-language embedding models be included in the manifest?
