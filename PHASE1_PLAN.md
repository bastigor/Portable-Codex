# Codex Portátil - Phase 1 Implementation Plan

## Overview

Phase 1 implements the portable core skeleton that runs entirely from a project directory with strict "no external writes" enforcement.

## Deliverables

### 1. Rust Core (rust-core/)

#### Cargo.toml
- Dependencies: tokio, serde, rusqlite, notify, crossbeam-channel
- Binaries: codex-watcher, llama-server-wrapper placeholder

#### src/lib.rs
- `AppState` struct for core state management
- IPC message types (Message enum)
- Path validation function `is_write_outside_allowed()`
- SQLite connection management with WAL mode

#### src/bin/codex-watcher.rs
- File watcher implementation using notify crate
- Project path validation (rejects external paths)
- MD file listing utility

#### src/db_schema.sql
- Complete SQLite schema with FTS5
- Tables: notes, note_properties, note_tags, note_links, note_embeddings, vaults
- Triggers for FTS5 synchronization
- PRAGMA settings for performance

### 2. Frontend Skeleton (src/)

#### src/main.rs (Tauri backend)
- IPC handler for open_vault, list_notes, get_note, save_note
- Path validation before any file operations
- Error handling with user-friendly messages

#### src/App.tsx (React frontend)
- Basic editor shell with file tree sidebar
- Vault selection dropdown
- "No external access" visual indicator

### 3. Build System

#### scripts/build.rs
- Platform detection (Windows/macOS/Linux)
- SQLite vector extension build instructions
- Binary size optimization flags

#### scripts/install-rust.sh / install-rust.ps1
- Cross-platform Rust installation script
- LLVM installation for SQLite bindings

## Implementation Order

### Step 1: Rust Core Unit Tests
```bash
cargo test --lib
cargo test --bin codex-watcher
```
Expected: Path validation tests pass, external writes rejected

### Step 2: SQLite Integration Test
```rust
#[tokio::test]
async fn test_database_operations() {
    let db_path = "/data/index/test.db";
    
    // Verify path is within project directory
    assert!(!db_path.starts_with("/tmp/"));
    
    // Open database with WAL mode
    let conn = rusqlite::Connection::open_with_flags(
        db_path,
        rusqlite::OpenFlags::SQLITE_OPEN_READ_WRITE | 
        rusqlite::OpenFlags::SQLITE_OPEN_WAL
    ).unwrap();
    
    // Initialize schema
    conn.execute_batch(include_str!("db_schema.sql")).unwrap();
    
    // Test basic CRUD operations
    let result = conn.query_row(
        "INSERT INTO notes (id, title, content) VALUES (?, ?, ?)",
        ["test-1", "Test Note", "Content here"],
        |row| row.get::<_, String>(0)
    ).unwrap();
    
    assert_eq!(result, 1); // Inserted 1 row
}
```

### Step 3: File Watcher Test
```rust
#[test]
fn test_watcher_path_validation() {
    let external_path = PathBuf::from("/tmp/external-vault");
    let internal_path = PathBuf::from(r"C:\Users\João Pedro\Documents\projetos\codex-portable\data\vault");
    
    assert!(matches!(VaultWatcher::validate_project_path(&external_path), Err(_)));
    assert!(matches!(VaultWatcher::validate_project_path(&internal_path), Ok(_)));
}
```

### Step 4: Tauri Integration
```typescript
// src-tauri/src/lib.rs (Rust backend)
#[tauri::command]
fn open_vault(path: String) -> Result<(), Error> {
    // Validate path
    if !is_path_within_project(&path) {
        return Err(Error::PathOutsideProject);
    }
    
    // Initialize database and file watcher
    let app_state = AppState::new();
    app_state.open_vault(path).await?;
    
    Ok(())
}
```

## Acceptance Criteria

### Portability Enforcement
- [x] All paths validated against project root on startup
- [ ] Runtime monitoring for unauthorized writes (file system hooks)
- [ ] Clear error messages when attempting external access

### Performance Targets
- [ ] Database operations < 10ms for typical queries
- [ ] Index update latency < 3s for 1000 notes
- [ ] File watcher debounce reduces disk I/O by >90%

### Security
- [ ] Path traversal attacks blocked
- [ ] No network access in runtime (verified by tests)
- [ ] SQLite journal mode WAL enabled

## Testing Strategy

### Unit Tests
- Rust core: `cargo test`
- Frontend: Vitest with React renderer
- Coverage target: 85%+ on critical paths

### Integration Tests
- Open vault, create/edit notes, verify round-trip
- File watcher detects changes within debounce window
- IPC communication between frontend/backend

### Security Tests
- Attempt path traversal (`../../../etc/passwd`)
- Verify all attempts logged and blocked
- Network request audit (should be zero)

## Known Limitations

1. **Rust toolchain**: Requires manual installation (documented in INSTALL_INSTRUCTIONS.md)
2. **SQLite vector extension**: May require separate build step on some platforms
3. **exFAT support**: Linux requires `mount -o exec` for binary execution

## Next Phase (Phase 2)

- Full Markdown parser/serializer with provenance tracking
- Wikilink resolution and backlink generation
- Properties editor with type validation
- Tag management interface
- Round-trip test suite execution
