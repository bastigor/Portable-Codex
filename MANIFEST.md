# MANIFEST.md — Artifact Manifest

## Artifacts
- **Binary**: `codex_portable.exe` (Windows), `codex_portable.app` (macOS/Linux)
- **Models**: `/models/gguf/Qwen3-base.gguf`, etc.
- **Config**: `tauri-config.json`
- **Data dirs**: `/data/vaults/`, `/data/index.db`, `/data/config/`, `/data/cache/`, `/data/logs/`

## Checksums
SHA-256 verified at install time (add to scripts/install.sh).

## Versions
- Core: Rust 1.75+, Tauri 1.6+
- Models: GGUF quantized (Qwen3/Llama/Gemma, permissive license)
