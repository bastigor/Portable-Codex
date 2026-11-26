// ProseMirror/TipTap plugin — block editor integration
use prosemirror::prelude::*;

#[tauri::command]
fn new_editor() -> String {
    "Novo editor de blocos".to_string()
}
