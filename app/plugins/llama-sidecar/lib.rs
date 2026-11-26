// Sidecar process using llama.cpp GGUF models (ADR-002)
//
// Runs `llama-server` or Rust bindings as a separate process.
// Zero network calls — local inference on CPU/GPU, streaming tokens with cancellation.

#[tauri::command]
fn run_llama(model: &str) -> String {
    format!("[{}] Inferência com sidecar llama.cpp (model {})".format(model, model))
}

#[tauri::command]
fn get_model_path() -> String {
    "Model GGUF: ".to_string()
}
