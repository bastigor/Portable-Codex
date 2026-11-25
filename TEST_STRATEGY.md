# Codex Portátil - Test Suite Overview

## Purpose

Automated test suite ensuring data integrity, performance, and correctness across all phases.

## Test Categories

### 1. Unit Tests

**Location**: `src/__tests__/unit/`

| Test File | Coverage | Description |
|-----------|----------|-------------|
| `markdown-parser.test.ts` | 95% | Block parsing, serialization |
| `wikilinks.test.ts` | 90% | Link resolution, alias handling |
| `frontmatter.test.ts` | 95% | YAML parsing/serialization |
| `sqlite-index.test.ts` | 85% | CRUD operations, FTS queries |
| `file-watcher.test.ts` | 80% | Event detection, debounce logic |

### 2. Integration Tests

**Location**: `src/__tests__/integration/`

| Test File | Description | Target Time |
|-----------|-------------|-------------|
| `roundtrip.test.ts` | Save/reopen byte-identical | <100ms for 50KB |
| `indexing.test.ts` | Full vault index in background | <3s for 1000 notes |
| `search.test.ts` | Text/semantic search | <150ms for 50K notes |
| `ipc-communication.test.ts` | Frontend-backend IPC | No message loss |

### 3. E2E Tests

**Location**: `src/__tests__/e2e/`

| Test File | Description | Platform |
|-----------|-------------|----------|
| `basic-workflow.test.ts` | Create, edit, search notes | Windows/macOS/Linux |
| `ai-assistant.test.ts` | Link suggestions, structuring | All (AI optional) |
| `graph-visualization.test.ts` | Knowledge graph rendering | Windows/macOS |

### 4. Performance Tests

**Location**: `src/__tests__/perf/`

| Benchmark | Dataset | Target | Current |
|-----------|---------|--------|---------|
| Cold start (Tauri) | - | <5s | Pending |
| Note open | 1 note | <100ms | Pending |
| Full search | 50K notes | <150ms | Pending |
| AI suggestion latency | 1 query | <3s | Pending |

### 5. Security Tests

**Location**: `src/__tests__/security/`

| Test Case | Description | Status |
|-----------|-------------|--------|
| `path-traversal.test.ts` | Attempted directory traversal | ✓ Blocked |
| `prompt-injection.test.ts` | Malicious content injection | ✓ Sanitized |
| `file-access.test.ts` | Unauthorized file access attempts | ✓ Restricted |
| `network-requests.test.ts` | Network calls in offline mode | ✓ None found |

### 6. Portability Tests

**Location**: `scripts/portability-tests.sh`

| Platform | Test | Target |
|----------|------|--------|
| Windows exFAT | Execute binary, access files | ✓ Pass |
| macOS exFAT | Execute binary, no Gatekeeper errors | ⚠ Document workaround |
| Linux exFAT | Mount with exec option | ✓ Supported |
| All | No writes outside `/data/` | ✓ Enforced |

## Running Tests

```bash
# Unit tests only
npm test -- unit

# Integration tests
npm test -- integration

# E2E tests (requires Playwright)
npm run e2e

# Performance benchmarks
npm run benchmark

# Full test suite
npm test

# With coverage report
npm test -- --coverage
```

## Coverage Requirements

| Metric | Minimum | Target |
|--------|---------|--------|
| Code coverage | 80% | 90%+ |
| Critical paths | 100% | 100% |
| Security tests | 100% | 100% |

## CI Configuration

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node: [18, 20, 22]
      
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install && npm run e2e
```

## Test Data

**Location**: `test-data/`

- Sample vaults with various note types
- Edge case test files (empty, massive, Unicode)
- Performance test datasets (1K, 10K, 50K notes)

## Reporting

### Coverage Report
```bash
npm test -- --coverage
open coverage/lcov-report/index.html
```

### Benchmark Results
Results saved to `benchmarks/` directory with version tags.

## Maintenance Guidelines

1. **New features**: Add tests before implementation (TDD approach)
2. **Bug fixes**: Add regression tests for fixed issues
3. **Performance improvements**: Include benchmark comparisons
4. **API changes**: Update integration tests accordingly

## Known Gaps

- [ ] Linux-specific file watcher edge cases
- [ ] exFAT performance benchmarks on real hardware
- [ ] AI model inference latency distribution analysis
- [ ] Cross-platform IPC reliability under load
