# Codex Portátil - Instalação Rust

## Opção 1: Winget (Recomendado)

```powershell
winget install Rustlang.Rustup
```

## Opção 2: Chocolatey

```powershell
choco install rust -y
```

## Opção 3: Rustup Manual

```powershell
$url = "https://win.rustup.rs/a"
Invoke-WebRequest -Uri $url -OutFile "$TMPRUST.exe"
& $TMPRUST
Add-Content -Path $env:PATH -Value "$env:LOCALAPPDATA\rustup\bin;"
rustup default stable
```

## Verificação após Instalação

Execute os seguintes comandos para verificar:

```powershell
cargo --version
rustc --version
```

## Instalação do LLVM (Necessário para SQLite bindings)

Execute primeiro, depois o Rust:

```powershell
choco install llvm -y
```
