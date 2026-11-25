```mermaid
graph TB
    subgraph "Codex Portátil Desktop App"
        A[Tauri 2 Frontend<br/>React + TipTap]
        B[Backend Rust<br/>File Watcher + IPC]
        C[SQLite Index<br/>FTS5 + Vectors]
        
        A -->|IPC JSON-RPC| B
        B -->|Watch events| C
        B -->|Store index| C
    end
    
    subgraph "AI Sidecar"
        D[llama-server<br/>Port 8080]
        E[Model Cache<br/>.models/]
        
        B -->|HTTP/JSON-RPC streaming| D
        D -->|GGUF load| E
    end
    
    subgraph "Persistent Storage"
        F[/data/vaults/ - .md files]
        G[/data/models/ - GGUF]
        H[/data/index/ - SQLite]
        I[/data/logs/ - Rotating logs]
        
        C -->|Read| F
        C -->|Index| H
        D -->|Read| E
    end
    
    style A fill:#2196f3,color:white
    style B fill:#4caf50,color:white
    style C fill:#ff9800,color:white
    style D fill:#9c27b0,color:white
```

## Data Flow

1. **File Watcher**: Monitors /data/vaults/ for .md changes (debounced 500ms)
2. **Index Update**: Changes -> SQLite transaction with WAL mode
3. **Semantic Search**: User query -> llama-server -> embedding -> ANN search in SQLite vec table
4. **Link Suggestion**: Context window from backlinks + semantic similarity -> LLM -> structured JSON-RPC response
5. **Provenance Tracking**: All AI-generated content tagged with source: codex-ai metadata
