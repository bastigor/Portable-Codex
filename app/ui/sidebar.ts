// Sidebar component (Tauri)
export const Sidebar = () => {
  return (
    <aside className="sidebar">
      <h2>Notas</h2>
      {/* List of notes */}
      <ul>
        {/* Rendered by index.ts / graph module */}
      </ul>
      <a href="#graph" className="graph-link">Grafo de Notas</a>
    </aside>
  );
};
