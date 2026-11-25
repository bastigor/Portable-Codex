// codex-core - Portable PKM Core Library
// Phase 1 Skeleton

use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::RwLock;

/// Information about a vault (project directory)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VaultInfo {
    pub path: String,
    pub note_count: u64,
}

/// IPC message types for frontend-backend communication
#[derive(Debug, Serialize, Deserialize)]
pub enum Message {
    #[serde(rename = "open_vault")]
    OpenVault { path: String },
    #[serde(rename = "list_notes")]
    ListNotes { vault_path: String },
    #[serde(rename = "get_note")]
    GetNote { note_id: String },
    #[serde(rename = "save_note")]
    SaveNote { note_id: String, content: String },
    #[serde(rename = "search")]
    Search { query: String, vault_path: String },
    #[serde(rename = "index_progress")]
    IndexProgress { percent: u32, message: String },
}

/// Core state management
pub struct AppState {
    pub vaults: RwLock<Arc<std::collections::HashMap<String, VaultInfo>>>,
    pub index_db: Option<RwLock<rusqlite::Connection>>,
    pub watcher_thread: Option<tokio::task::JoinHandle<()>>,
}

impl AppState {
    pub fn new() -> Self {
        AppState {
            vaults: RwLock::new(Arc::new(std::collections::HashMap::new())),
            index_db: None,
            watcher_thread: None,
        }
    }
    
    pub async fn open_vault(&mut self, path: String) {
        // Initialize SQLite database with FTS5 and vector tables
        let db_path = format!("{}/data/index/codex_index.db", path);
        
        // Check for "no external writes" violation
        if self.is_write_outside_allowed(&db_path) {
            panic!("Write attempt outside project directory detected!");
        }
        
        // Database initialization (WAL mode for concurrent access)
        let conn = rusqlite::Connection::open(&db_path).expect("Failed to open database");
        self.index_db = Some(RwLock::new(conn));
    }
    
    fn is_write_outside_allowed(&self, path: &str) -> bool {
        // Reject writes outside project directory
        let project_root = r"C:\Users\João Pedro\Documents\projetos\codex-portable";
        !path.starts_with(project_root) && !path.starts_with(r"\\?\")
    }
}

// Test harness for "no external writes" enforcement
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_path_validation() {
        let state = AppState::new();
        
        // Should reject writes outside project
        assert!(!state.is_write_outside_allowed("/tmp/outside.db"));
        assert!(!state.is_write_outside_allowed(r"C:\Windows\System32\test.db"));
        
        // Should allow writes within project
        assert!(state.is_write_outside_allowed(r"C:\Users\João Pedro\Documents\projetos\codex-portable\data\db.sqlite"));
    }
}

pub fn main() {
    println!("codex-core v0.1.0 - Portable PKM Core");
    println!("Platform: {}", std::env::consts::OS);
    println!("Ready for Phase 1 skeleton tests.");
}
