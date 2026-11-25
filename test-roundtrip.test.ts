# Codex Portátil - Markdown Round-Trip Test Suite

## Purpose

Verify that saving and reopening notes produces byte-identical files (excluding provenance tracking fields). This ensures:
1. Data sovereignty - original content preserved
2. Editor compatibility - works outside Codex
3. No silent modifications by the app

## Test Strategy

### 1. Core Markdown Round-Trip

```typescript
// test-roundtrip.test.ts
import { readFileSync, writeFileSync } from 'fs';
import { diffLines } from 'diff';

function roundTripTest(markdown: string): boolean {
  const tempFiles = [
    '/tmp/codex-test-1.md',
    '/tmp/codex-test-2.md'
  ];
  
  // Write original
  writeFileSync(tempFiles[0], markdown, 'utf8');
  
  // Simulate save (Codex would serialize)
  const saved = serializeMarkdown(markdown);
  
  // Read back
  const loaded = readFileSync(tempFiles[1], 'utf8');
  
  // Compare
  return diffLines(saved, loaded).length === 0;
}

describe('Round-Trip Tests', () => {
  test('Basic paragraph preservation', () => {
    const content = `# My Note

This is a paragraph.

> A quote.
`;
    expect(roundTripTest(content)).toBe(true);
  });

  test('Code block preservation', () => {
    const content = `\`\`\`python
print("hello")
\`\`\`
`;
    expect(roundTripTest(content)).toBe(true);
  });
});
```

### 2. Wikilink Handling

```typescript
test('Wikilinks preserved exactly', () => {
  const content = `[[notes/related-note]] and [[notes/other^block]].
`;
  const saved = serializeMarkdown(content);
  expect(saved).toBe(content); // Exact byte match
});
```

### 3. Callout Preservation

```typescript
test('Callouts preserved', () => {
  const content = `> [!NOTE]
> Important info.
`;
  expect(roundTripTest(content)).toBe(true);
});
```

### 4. Frontmatter Round-Trip

```typescript
test('Frontmatter serialization/deserialization', () => {
  const yaml = `---
id: test-123
created: 2026-11-24T10:00:00Z
tags: [important, review]
---

Content here.
`;
  
  const parsed = parseFrontmatter(yaml);
  const regenerated = serializeFrontmatter(parsed);
  
  expect(regenerated).toBe(yaml.split('\n').slice(0, -1).join('\n') + '\n');
});
```

### 5. Empty and Edge Cases

```typescript
test('Empty file round-trip', () => {
  const empty = '';
  expect(roundTripTest(empty)).toBe(true);
});

test('Whitespace-only preservation', () => {
  const whitespace = '\n\n\n';
  expect(roundTripTest(whitespace)).toBe(true);
});

test('Special characters preserved', () => {
  const special = `# Unicode: café, naïve, 日本語，中文
# HTML entities: &lt;script&gt;
`;
  expect(roundTripTest(special)).toBe(true);
});
```

## Test Coverage Goals

| Category | Test Count | Target |
|----------|------------|--------|
| Basic blocks | 10 | ✓ |
| Wikilinks | 5 | ✓ |
| Frontmatter | 8 | ✓ |
| Callouts | 4 | ✓ |
| Tables | 3 | ✓ |
| Code blocks | 5 | ✓ |
| Special chars | 4 | ✓ |
| Edge cases | 6 | ✓ |
| **Total** | **45** | **100% coverage** |

## Performance Testing

```typescript
describe('Performance', () => {
  test('Large file round-trip < 100ms', async () => {
    const largeContent = generateLargeNote(50000); // 50KB note
    const start = performance.now();
    
    const saved = serializeMarkdown(largeContent);
    const loaded = deserializeMarkdown(saved);
    
    const elapsed = performance.now() - start;
    expect(elapsed).toBeLessThan(100);
    
    diffLines(saved, serializeMarkdown(loaded)).length === 0;
  });
});
```

## Integration Test with SQLite Index

```typescript
test('Index update preserves note content', async () => {
  const db = await openDatabase('/tmp/test.db');
  const noteId = 'notes/test-123';
  
  const originalContent = `# Test Note
Content here.
`;
  
  // Insert into SQLite index
  await insertNote(db, noteId, originalContent);
  
  // Simulate save (index updated again)
  await updateNoteIndex(db, noteId, originalContent);
  
  const retrieved = await getNoteContent(db, noteId);
  expect(retrieved).toBe(originalContent);
});
```

## Known Limitations

1. **Provenance fields**: Intentionally excluded from round-trip comparison (tracking purpose)
2. **Frontmatter sorting**: YAML keys may be reordered; compare semantically, not byte-for-byte
3. **Timestamps**: Auto-updated on save; compare original vs modified timestamps only

## CI Configuration

```yaml
# .github/workflows/test-roundtrip.yml
name: Round-Trip Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - run: npm ci
      
      - run: npm test -- --testPathPattern=roundtrip --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## Acceptance Criteria

- All 45+ unit tests pass
- Integration tests with SQLite pass
- Performance benchmarks < 100ms for notes up to 50KB
- No byte-differences in preserved content (excluding provenance)
- CI pipeline configured and passing
