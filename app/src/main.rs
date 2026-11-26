use tauri_web::Web;
use tauri_bootstrap::{Bootstrap, Config, Shells};
use projs::editor as editor;

mod ui;
mod plugins;

#[tauri::command]
fn open_editor() -> String {
    "Editor em blocos — ProseMirror/TipTap".to_string()
}

#[tauri::command]
fn create_note(title: &str) -> String {
    format!("[New Note] {title}")
}

#[tauri::command]
fn list_notes() -> String {
    "Notas disponíveis"
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
