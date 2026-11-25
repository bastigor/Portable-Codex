# Spike Assessment Report - Codex Portátil Fase 0

## System Info
- OS: Windows
- Architecture: AMD64
- Processor: AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD
- Python: 3.14.9
- Rust available: False
- llama-cpp-python: NOT AVAILABLE

## Key Findings for Phase 0

### 1. SQLite + Vector Extension (sqlite-vec)
- **Verdict**: USE sqlite-vec OR vec1 (both C-based, portable)
- **Risks**: exFAT has no native Unix permissions; must use atomic writes + rename
- **Mitigation**: Implement file watcher fallback (polling on exFAT), WAL mode for SQLite

### 2. Llama.cpp Integration
- **Verdict**: USE llama-server sidecar + IPC, NOT Python bindings directly
- **Reason**: Better control over memory, cancellation, concurrency
- **Alternative**: Consider sqlite-lembed for zero-process embedding generation

### 3. Portability Concerns
- **exFAT**: No Unix permissions → SQLite must use absolute paths only; no relative path traversal
- **WebView2 (Windows)**: Embedded as fixed version bundle or use Tauri with WebView fallback
- **macOS Gatekeeper**: Document workaround, don't require notarization for MVP
- **Linux libraries**: Use AppImage or statically linked binaries

## Recommended Stack (Phase 1)

### Core
- **Language**: TypeScript + Tauri 2 (smaller than Electron, better security)
- **Frontend**: React + TipTap (editor blocks) + sigma.js (graph)
- **Backend**: Rust core for file watcher + IPC

### AI Sidecar
- **Server**: llama-server (--host 127.0.0.1 --port 8080)
- **Embeddings**: bge-m3-small en-v1.5 GGUF (~140MB) or all-MiniLM-L6-v2 (~200MB)
- **IPC**: JSON-RPC over Unix socket (Windows: named pipe, macOS: Unix socket, Linux: Unix socket)

### Database
- **Engine**: SQLite with sqlite-vec extension OR standalone vector index in memory
- **Strategy**: Store embeddings as BLOBs; use ANN search via Python/Rust sidecar when needed

## Next Steps - Phase 0 Deliverables

1. Write ADR #1: Stack Decision (Tauri vs Electron)
2. Write ADR #2: AI Architecture (sidecar vs bindings)
3. Create architecture diagram (Mermaid)
4. Define Markdown file format spec with embedded IDs, provenance metadata
5. Write test suite for round-trip Markdown serialization
6. Create portable installer v0 script

### Questions for User
1. Do you want me to proceed with Tauri 2 or Electron for the desktop framework?
2. What's your target minimum RAM for the AI model (8GB/16GB recommended)?
3. Should I include Portuguese-language embedding models in the manifest?

