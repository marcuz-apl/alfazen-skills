---
name: alfazen-versioning
description: Establish or audit modern Semantic Versioning (SemVer 2.0.0) with Alfazen UTC yymmddc build traceability, Git trailers, and CLI build injection.
---

# Alfazen Versioning (v2.0)

A developer- and open-source-friendly versioning standard that combines **Semantic Versioning (SemVer 2.0.0)** with Alfazen's signature **UTC daily build counter (`yymmddc`)**, clean Git trailers, and runtime CLI version stamping.

---

## 1. The Version Contract

### 1.1 Base Semantic Version (`m.n.p`)
- Stored in a tracked root `VERSION` file as `m.n.p` (e.g., `0.1.0`).
- **Initial Development**: New repositories begin at `0.1.0`. Major version zero signifies rapid, iterative development where APIs may evolve without breaking SemVer promises.
- **Production Baseline**: Increment to `1.0.0` when the public API is stable, feature-complete, and production-ready.
- **Unbounded SemVer Rules**:
  - `m`, `n`, and `p` are non-negative decimal integers (`0.1.0` → `0.1.9` → `0.1.10`). Never clamp to single digits.
  - Increment `p` (PATCH) for backward-compatible bug fixes and internal refinements.
  - Increment `n` (MINOR) for backward-compatible new features.
  - Increment `m` (MAJOR) strictly for breaking public API changes.

### 1.2 Alfazen Build Identifier (`+yymmddc`)
- Formatted as SemVer **build metadata** using the `+` delimiter: `v<m.n.p>+<yymmddc>` (e.g., `v0.1.0+2609031`).
- The `yymmddc` suffix is exactly 7 characters:
  - 6 UTC date digits: `YYMMDD` (e.g., `260903` for 2026-09-03 UTC).
  - 1 daily sequence counter `c`: rolls `1` through `9`, then `a` through `z`.
  - Resets to `1` when the UTC calendar date advances.
- **Package Manager Compliance**: Under SemVer 2.0.0 (Rule #10), build metadata is ignored for version precedence. Package managers (Go proxy, Cargo, npm) treat `0.1.0+2609031` as fully compatible with `0.1.0`.

---

## 2. Git & Commit Integration

### 2.1 Commit Message Subject (Row 1)
- The first line must be a pure **Conventional Commit** without version prefixes:
  ```text
  feat: add markdown converter
  fix: handle nil pointer in browser lease
  ```
- **Rationale**: Ensures 100% compatibility with standard open-source tooling (`commitlint`, automated changelogs, GitHub PR merge squashers) and creates zero friction for external contributors.

### 2.2 Commit Trailer (Git Footer)
- Place the build identifier in a standard Git trailer at the end of the commit message:
  ```text
  feat: add markdown converter

  Alfazen-Build: v0.1.0+2609031
  ```
- Automated via `.githooks/prepare-commit-msg` (or local release script).
- Inspectable using standard Git commands:
  ```sh
  git log --format="%(trailers:key=Alfazen-Build)"
  ```

---

## 3. Application / CLI Runtime Stamping

Binaries and libraries report their full build identifier when invoked with `--version` or `-v`:

```text
<app> version v0.1.0+2609031 (commit 9a3b1de, built 2026-09-03T10:00:00Z)
```

In Go, inject this at compile time via `-ldflags`:
```sh
go build -ldflags "-X main.version=v0.1.0+$(BUILD_ID) -X main.commit=$(GIT_SHA) -X main.date=$(BUILD_DATE)" -o bin/<app> ./cmd/<app>
```
When built via `go install`, fall back gracefully to `runtime/debug.ReadBuildInfo()`.

---

## 4. Repository Configuration Checklist

1. **Root `VERSION` File**:
   Create a tracked `VERSION` containing the base version (e.g. `0.1.0`).
2. **Git Hook (`.githooks/prepare-commit-msg`)**:
   Reads `VERSION`, determines today's UTC counter `c`, and appends `Alfazen-Build: v<m.n.p>+<yymmddc>` to the commit trailer without altering the subject line.
3. **Hook Activation**:
   ```sh
   git config core.hooksPath .githooks
   ```
   *Note: Local hooks are optional for external PR contributors and can be verified or stamped by CI.*
4. **Build Automation**:
   Provide a `Makefile` or build script that calculates `BUILD_ID` (`yymmddc`) and passes `-ldflags` to the compiler.
