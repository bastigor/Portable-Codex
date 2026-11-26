# Architecture Diagram - Codex Portátil

```mermaid
graph TD
    subgraph "User Layer (Portable Install)"
        U[User clones repo to USB / pendrive]
        S[Shell/cmd/PowerShell bootstrap]
    end

    subgraph "Installer"
        I[install.sh / setup.py detects OS/arch]
        M[Download models (offline or pre-packaged)]
        C[Verify SHA-256 checksums]
        B[Write to /data/...]
    end

    subgraph "Core App (Tauri 2)"
        F[Frontend: React + TypeScript]
        E[Editor: ProseMirror/TipTap blocks]
        N[AI Sidecar: llama.cpp GGUF process]
        SCR[SQLite WAL index]
        DB[(Index DB)]
    end

    subgraph "Data Layer"
        MD[.md files in /data/vaults/]
        SQL[sqlite FTS5 + sqlite-vec]
        INDEX[Background file watcher + incremental index]
    end

    subgraph "AI Copilot"
        L[LLM: llama.cpp streaming token]
        PROP[Provenance panel]
        HIST[History / undo]
    end

    subgraph "WebView (Tauri sandbox)"
        WV[WebView2/WebKitGTK - sandboxed, no exec remote]
    end

    U --> S
    S --> I
    I --> M
    I --> C
    B --> F
    F --> E
    E --> N
    N --> DB
    DB --> INDEX
    INDEX --> MD
    INDEX --> L
    L --> PROP
    L --> HIST

    style U fill:#1a1a2e,color:#eee
    style S fill:#16213e,color:#fff
    style F fill:#0f3460,color:#fff
    style E fill:#d4a373,color:#000
    style N fill:#c0392b,color:#fff
    style DB fill:#1b5e20,color:#fff
```

## Data Flow
1. User creates/edits note in ProseMirror → writes `.md` to `/data/vaults/<name>/<id>.md`
2. Watcher detects file change → triggers incremental indexer → updates SQLite (FTS5 + sqlite-vec)
3. Index search runs instantly via FTS5; embeddings for semantic search
4. User types query → AI sidecar streams from `index.db` → proposes links/tags/structure
5. Provenance panel marks accepted content

## Platforms
- Windows: Tauri 2 + WebView2 (sandboxed), Rust binaries, no admin
- macOS: Tauri 2 + WebKitGTK (Apple Silicon supported)
- Linux: Tauri 2, static/AppImage option for GUI deps
