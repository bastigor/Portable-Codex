// Quick Switcher — toggle notes list/collapse + graph link
export const QuickSwitcher = () => {
  return (
    <aside className="quick-switcher">
      {/* Toggle button to expand/collapse notes and open graph */}
      <button onClick={() => {}}>
        Notas
      </button>
      <a href="#graph" className="graph-link">Grafo de Notas</a>
    </aside>
  );
};
