use tauri_web::Web;
use tauri_bootstrap::{Bootstrap, Config, Shells};
use projs::editor as editor;

mod ui;
mod plugins;
mod graph;

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
fn build_local_subgraph(current_note_id: &str, max_hops: u32 = 2) -> String {
    if let Some(id) = current_note_id {
        format!("[{}] Subgrafo local (max {h} hops): {:?}".format(id, max_hops, build_local_subgraph(id, max_hops)))
    } else {
        "Subgrafo local: especificar note_id".to_string()
    }
}

#[tauri::command]
fn get_embeddings(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Embeddings: {:?}".format(id, get_embeddings(id)))
    } else {
        "Embeddings do banco de dados".to_string()
    }
}

#[tauri::command]
fn view_notes(note_id: Option<&str>) -> String {
    if let Some(id) = note_id {
        format!("[{}] Notas: {:?}".format(id, list_notes()))
    } else {
        "Todas as notas".to_string()
    }
}

#[tauri::command]
fn view_table() -> String {
    "Tabela — todas as notas (frontmatter + body)".to_string()
}

#[tauri::command]
fn view_kanban() -> String {
    "Kanban — filtros por tag/propriedade".to_string()
}

#[tauri::command]
fn view_list() -> String {
    "Lista — notas em ordem de criação".to_string()
}

#[tauri::command]
fn view_calendar() -> String {
    "Calendário — data das notas".to_string()
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
