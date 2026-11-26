# File Format Specification

## Primary Format: Markdown (.md)

- **Standard:** CommonMark + GitHub Flavored Markdown (GFM)
- **Frontmatter:** YAML block at top, delimited by `---`
- **Block IDs:** `[[nota]]`, `[[nota#sec]]`, `[[nota^bloco]]` — Obsidian-compatible syntax
- **Links:** `[text](url)` or `[[wikilink target]]`

## Round-trip Guarantee

Opening and saving a file must produce byte-identical content. Tests on real Obsidian vault corpus.

## Extensions Compatibility

- Callouts, block IDs, embeds: use syntax equivalent to Obsidian when available
- Backlinks: separate table in SQLite + wikilinks in .md files
