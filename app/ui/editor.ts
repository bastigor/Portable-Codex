// Editor component (Tauri)
export const Editor = () => {
  // ProseMirror content via projs/editor or Tauri web integration
  return (
    <div className="editor" style={{ border: "1px solid #ccc", padding: "1rem" }}>
      {/* ProseMirror content */}
    </div>
  );
};

// Helper: insert text at cursor position
export const insertText = (state: EditorState, text: string) => {
  state.insertTextAt(0, text);
};

// Helper: delete from cursor to index
export const deleteText = (state: EditorState, start: number, end: number) => {
  state.deleteRange(start, end);
};

// Copiloto — LLM suggestions (silent)
export const getSuggestions = (state: EditorState, note_id: Option<&str>) => {
  if (note_id === null || note_id.is_empty()) {
    "Nenhuma nota selecionada para sugerir."
  } else {
    // Placeholder — real implementation calls run_llama_sidecar() + detect_and_get_embeddings(id)
    "Sugestão do LLM para [{}]: ".format(note_id ?? "não especificado")
  }
};

// Ghost text toggle (shows generated content as plain text instead of inline)
export const ghostTextToggle = () => {
  // Placeholder — real implementation toggles a CSS class or ProseMirror ghost mode
  "Ghost text: ativo"
};