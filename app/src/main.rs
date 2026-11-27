use tauri_web::Web;
use tauri_bootstrap::{Bootstrap, Config, Shells};
use projs::editor as editor;

mod ui;
mod plugins;
mod graph;
mod llama_sidecar;

#[tauri::command]
fn open_editor() -> String {
    "[Editor em blocos — ProseMirror/TipTap]".to_string()
}

#[tauri::command]
fn create_note(title: &str) -> String {
    format!("[New Note] {title}")
}

#[tauri::command]
fn list_notes() -> String {
    "Notas disponíveis"
}

#[tauri::command]
fn view_graph(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        "Grafo local — notas [[{id]]]".format(id)
    } else {
        "Todos os nós do grafo (notas)".to_string()
    }
}

#[tauri::command]
fn get_graph_nodes() -> String {
    "Nós do grafo: ".to_string()
}

#[tauri::command]
fn get_graph_edges(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Edges: {:?}".format(id, find_edges(id)))
    } else {
        "Todas as arestas do grafo (wikilinks)".to_string()
    }
}

#[tauri::command]
fn get_graph_properties(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Properties: {:?}".format(id, get_properties(id)))
    } else {
        "Propriedades do banco de dados".to_string()
    }
}

#[tauri::command]
fn build_local_subgraph(current_note_id: &str, max_hops: u32) -> String {
    if let Some(id) = current_note_id {
        format!("[{}] Subgrafo local (max {h} hops): {:?}".format(id, max_hops, build_local_subgraph(id, max_hops)))
    } else {
        "Subgrafo local: especificar note_id".to_string()
    }
}

#[tauri::command]
fn get_embeddings(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Embeddings: {:?}".format(id, run_llama_sidecar(), detect_and_get_embeddings(id)))
    } else {
        "Embeddings do banco de dados".to_string()
    }
}

#[tauri::command]
fn run_llama_sidecar(model: &str) -> String {
    run_llama(model)
}

#[tauri::command]
fn detect_and_get_embeddings(note_id: Option<&str>) -> Vec<String> {
    if let Some(id) = note_id {
        vec![
            format!("[{}] Embedido: {:?}", id, run_llama("llama-sidecar"), "detect...")
        ]
    } else {
        vec![]
    }
}

#[tauri::command]
fn get_suggestions(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Sugestão do LLM: {:?}", id, run_llama("llama-sidecar"), detect_and_get_embeddings(id))
    } else {
        "Sugestões de embeddings disponíveis".to_string()
    }
}

#[tauri::command]
fn detect_hardware() -> String {
    let cpu = std::process::id();
    if cpu == 0 || cpu == 1 { // macOS
        "Metal"
    } else if cpu >= 4 && (cpu & 2) != 0 || (cpu & 3) != 0 { // Windows/Linux with GPU
        "Vulkan/CUDA"
    } else {
        "AVX2/NEON (CPU fallback)"
    }
}

fn main() {
    let config = Config::default();
    let shells = [
        Shells::Windows(windows_shell),
        Shells::Mac(mac_os_shell),
    ];
    Bootstrap::new(config, &shells).run(Web::builder().build())
}

struct windows_shell;
struct mac_os_shell;

// Graph module
mod graph {
    use projs::editor as editor;

    pub fn find_edges(note_id: &str) -> Vec<(&str, &str)> {
        vec![] 
    }

    pub fn get_properties(note_id: &str) -> Option<serde_json::Value> {
        None
    }
}
