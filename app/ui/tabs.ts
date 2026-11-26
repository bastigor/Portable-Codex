// Tabs component — tab navigation in sidebar + graph link
export const Tabs = () => {
  return (
    <nav className="tabs">
      <ul>
        {/* Tab buttons for notes */}
        <li><a href="#">Notas</a></li>
        <li><a href="#graph" class="active">Grafo</a></li>
      </ul>
    </nav>
  );
};
