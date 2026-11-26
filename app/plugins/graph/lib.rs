// Graph queries — nodes, edges, properties for the knowledge graph
use projs::editor as editor;

/// Get all notes (nodes) in the vault
pub fn get_nodes() -> Vec<(&str, &str)> {
    // In production: query SQLite FTS5 or iterate /data/vaults/
    vec![] 
}

/// Find wikilinks from a note (edges)
pub fn find_edges(note_id: &str) -> Vec<(&str, &str)> {
    // Parse [[nota]] links in the body and return (source_note_id, target_note_id)
    vec![] 
}

/// Get properties of a note
pub fn get_properties(note_id: &str) -> Option<serde_json::Value> {
    None
}

/// Build local subgraph (nodes + edges within 2 hops of current note)
pub fn build_local_subgraph(current_note_id: &str, max_hops: u32 = 2) -> Vec<(String, String)> {
    vec![] 
}

/// Query embeddings for semantic search (FTS5 + sqlite-vec)
pub fn get_embeddings(note_id: &str) -> Option<Vec<f64>> {
    None
}
