// Graph page — nodes (notes) + edges (wikilinks)
export const Graph = () => {
  return (
    <main className="graph">
      <h2>Grafo de Notas</h2>
      {/* Nodes: list of notes */}
      <div className="nodes">
        {/* Rendered by index.ts / graph module */}
      </div>
      {/* Edges: wikilinks between notes */}
      <div className="edges">
        {/* Rendered by find_edges */}
      </div>
    </main>
  );
};
