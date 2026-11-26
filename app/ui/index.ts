// Index page — list of notes, graph view, and views (table/kanban/list/calendar)
export const Index = () => {
  return (
    <main className="index">
      {/* Graph View */}
      <section className="graph-view">
        <h2>Grafo de Notas</h2>
        <div className="nodes">{/* nodes from graph module: get_graph_nodes() */}</div>
        <div className="edges">{/* edges from graph module: find_edges() */}</div>
      </section>

      {/* Views Section — dispatch based on query param or command */}
      <section className="views">
        <h2>Visões do Banco de Dados</h2>
        <div className="view-table">{/* view_table() */}</div>
        <div className="view-kanban">{/* view_kanban() */}</div>
        <div className="view-list">{/* view_list() */}</div>
        <div className="view-calendar">{/* view_calendar() */}</div>
      </section>

      {/* Quick Switcher */}
      <aside className="quick-switcher">
        <button onClick={() => {}}>Notas</button>
        <a href="#graph" className="graph-link">Grafo de Notas</a>
      </aside>

      {/* Sidebar */}
      <aside className="sidebar">
        <h2>Notas</h2>
        <ul>{/* list of notes from index_notes() */}</ul>
        <a href="#graph" className="graph-link">Grafo de Notas</a>
      </aside>
    </main>
  );
};
