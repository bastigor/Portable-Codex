# Codex Portátil — Minimal App Skeleton

## Structure
```
app/
  src/
    main.rs
    ui/
      theme.ts
      sidebar.ts
      editor.ts
      index.ts
    plugins/
      prose-mirror/
        lib.rs
  scripts/
    install.sh          # portable installer (Windows cmd/PowerShell, macOS/Linux sh/bash)
    bootstrap.sh        # OS detection & minimal setup
```

## Notes
- No network calls at runtime. All data under `/data/` relative to executable.
- Round-trip Markdown: ProseMirror → .md file → identical bytes on save.
- AI sidecar runs as separate process (llama.cpp GGUF).
