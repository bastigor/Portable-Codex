import React, { useState } from 'react';

function App() {
  const [vaultPath, setVaultPath] = useState<string | null>(null);

  return (
    <div style={{ padding: '20px', fontFamily: 'sans-serif' }}>
      <h1>Codex Portátil</h1>
      <p>Ainda em desenvolvimento - Fase 0</p>
      <input
        type="file"
        accept=".md,.txt"
        onChange={(e) => {
          if (e.target.files && e.target.files[0]) {
            setVaultPath(e.target.files[0].name);
            alert(`Vault selecionado: ${e.target.files[0].name}`);
          }
        }}
      />
    </div>
  );
}

export default App;