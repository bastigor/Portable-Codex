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