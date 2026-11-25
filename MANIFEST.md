# Codex Portátil — Artifacts Manifest

**Version:** 0.1.0-alpha
**Date:** 2026-11-24

## Binários por Plataforma

| Platform | Architecture | Binary Name | Download Source | SHA-256 |
|----------|--------------|-------------|-----------------|---------|
| Windows  | x86_64       | codex-portable-win-x64.exe | GitHub Release | [placeholder] |
| Windows  | arm64        | codex-portable-win-arm64.exe | GitHub Release | [placeholder] |
| macOS    | x86_64       | codex-portable-macos-intel.dmg | GitHub Release | [placeholder] |
| macOS    | arm64        | codex-portable-macos-applesilicon.dmg | GitHub Release | [placeholder] |
| Linux    | x86_64       | codex-portable-linux-x86_64.AppImage | GitHub Release | [placeholder] |
| Linux    | arm64        | codex-portable-linux-arm64.AppImage | GitHub Release | [placeholder] |

## Modelos de IA (não versionados no repositório)

Download via instalador ou URL configuráveis:

| Modelo | Size | Purpose | Filename Pattern |
|--------|------|---------|------------------|
| Qwen3-4B-Q4_0.gguf | ~2 GB | Estruturar, formatar | models/ai/qwen3-4b-q4.gguf |
| Qwen3-7B-Q4_0.gguf | ~4 GB | Conectar, RAG | models/ai/qwen3-7b-q4.gguf (opcional) |
| bge-m3-small-q4.gguf | ~200 MB | Embeddings | models/embed/bge-m3-small-q4.gguf |

## Arquivos de Configuração

| File | Purpose | Location |
|------|---------|----------|
| codex-portable.toml | App config (theme, keys, paths) | src/tauri/config/ |
| install.sh / install.ps1 / install.cmd | Installer script | scripts/ |
| manifest.json | This file | root/ |

## Verificação de Integridade

```bash
# Verificar assinaturas criptográficas (quando disponíveis)
sha256sum codex-portable-win-x64.exe > .sha256sum
```

## Licenças de Terceiros

- Tauri: MIT (Rust) + BSD-3-Clause (WebView)
- React/TypeScript: MIT
- llama.cpp: MIT
- sqlite: BSD-3-Clause

## Update Procedure

1. User downloads new release from GitHub
2. Installer compares SHA-256 of existing vs new binaries
3. If mismatch, prompt user to confirm overwrite
4. Atomic replace (temp file + rename)

