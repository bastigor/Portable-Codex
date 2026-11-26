// Index page — list of notes, graph view, and views (table/kanban/list/calendar)
export const Index = () => {
  return (
    <main className="index">
      {/* Graph View */}
      <section className="graph-view">
        <h2>Grafo de Notas</h2>
        <div className="nodes">{/* nodes from graph module */}</div>
        <div className="edges">{/* edges from graph module */}</div>
      </section>

      {/* Views Section */}
      <section className="views">
        <h2>Visões do Banco de Dados</h2>
        <div className="view-table">{/* table view */}</div>
        <div className="view-kanban">{/* kanban board */}</div>
        <div className="view-list">{/* list view */}</div>
        <div className="view-calendar">{/* calendar view */}</div>
      </section>

      {/* Quick Switcher */}
      <aside className="quick-switcher">
        {/* Toggle notes list/collapse */}
      </aside>

      {/* Sidebar */}
      <aside className="sidebar">
        <h2>Notas</h2>
        {/* List of notes */}
      </aside>
    </main>
  );
};
