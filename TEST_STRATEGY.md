# Test Strategy

## Unit Tests
- Markdown parser round-trip (CommonMark + GFM): open → save → byte-identical
- Frontmatter YAML parse → JSONB extraction
- Block editor operations: insert, delete, reorder paragraphs/titles/lists/callout/embed/divider

## Integration Tests
- Create note file → edit in ProseMirror → save → verify file unchanged (byte-level)
- Search by text, property, tag, semantic embedding
- AI suggestions: ghost text inline, cancel on typing, mark as accepted/rejected
- Wikilinks resolve to existing notes; broken links detected

## Performance Tests
- Open note: < 100 ms
- Full vault search (50k notes): < 150 ms
- Indexing incremental in background with progress bar
- Round-trip Markdown corpus: no loss

## CI Matrix
Windows, macOS, Linux; x86_64, arm64. Rust + Tauri build on each.
