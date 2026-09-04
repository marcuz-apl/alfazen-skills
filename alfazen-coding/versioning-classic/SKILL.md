---
name: versioning-classic
description: Strict Conventional Commits standard with Git trailers (Alfazen-Build). Use ONLY when the user explicitly requests "classic versioning", "trailer mode", or "unprefixed commit messages" for external third-party CI tools.
---

# Classic Versioning (SemVer 2.0.0 & Git Trailers)

A clean Git versioning standard for repositories that strictly require unadorned **Conventional Commits** (e.g., standard `commitlint`, automated semantic-release, or external open-source contributors), pairing clean subjects with **Git trailers** for Alfazen UTC build traceability.

---

## 1. The Version Contract

### 1.1 Base Semantic Version (`m.n.p`)
- Stored in a tracked root `VERSION` file as pure `m.n.p` (e.g., `0.1.0`, `1.0.0`).
- **Unbounded SemVer Rules**:
  - `m`, `n`, and `p` are non-negative decimal integers (`0.1.0` → `0.1.9` → `0.1.10`). Never clamp to single digits.
  - Increment `p` (PATCH) for backward-compatible bug fixes and internal refinements.
  - Increment `n` (MINOR) for backward-compatible new features.
  - Increment `m` (MAJOR) strictly for breaking public API changes.

### 1.2 Alfazen Build Identifier (`+yymmddc`)
- Formatted as SemVer **build metadata** using the `+` delimiter: `v<m.n.p>+<yymmddc>` (e.g., `v1.0.0+2609041`).
- The `yymmddc` suffix is exactly 7 characters:
  - 6 UTC date digits: `YYMMDD` (e.g., `260904` for 2026-09-04 UTC).
  - 1 daily sequence counter `c`: rolls `1` through `9`, then `a` through `z`.
  - Resets to `1` when the UTC calendar date advances.
- **Package Manager Compliance**: Under SemVer 2.0.0 (Rule #10), build metadata is ignored for version precedence. Package managers (PyPI, npm, Go proxy, Cargo) treat `1.0.0+2609041` as fully compatible with `1.0.0`.

---

## 2. Git & Commit Integration

### 2.1 Commit Message Subject (Row 1)
- The first line must be a pure **Conventional Commit** without version prefixes:
  ```text
  feat: add markdown converter
  fix: handle nil pointer in browser lease
  ```
- **Rationale**: 100% compatible with off-the-shelf tooling (`commitlint`, `standard-version`, automated changelogs) without requiring custom regex.

### 2.2 Commit Trailer (Git Footer)
- Place the build identifier in a standard Git trailer at the end of the commit message:
  ```text
  feat: add markdown converter

  Alfazen-Build: v1.0.0+2609041
  ```
- Automated via `.githooks/prepare-commit-msg`.
- Inspectable using standard Git commands:
  ```sh
  git log --format="%(trailers:key=Alfazen-Build)"
  ```

---

## 3. Application & CLI Runtime Stamping

Binaries and libraries report their full build identifier when invoked with `--version` or `-v`:

```text
<app> version v1.0.0+2609041 (commit 9a3b1de, built 2026-09-04T10:00:00Z)
```

### Go Projects
```sh
go build -ldflags "-X main.version=v$(./.githooks/alfazen-version id) -X main.commit=$(GIT_SHA) -X main.date=$(BUILD_DATE)" -o bin/<app> ./cmd/<app>
```

### Python Projects
Standardize package version in `pyproject.toml` (`version = "1.0.0"`) and read build info dynamically via `importlib.metadata`.

---

## 4. Repository Configuration Checklist

1. **Root `VERSION` File**: Contains the base semantic version (e.g. `1.0.0`).
2. **Unified Version Engine (`.githooks/alfazen-version`)**: Single source of truth for computing build identifiers and stamping trailers:
   - `alfazen-version id` -> prints `1.0.0+2609041`
   - `alfazen-version hook "$@"` -> stamps `Alfazen-Build:` trailer on commit messages.
3. **Git Hook Entrypoint (`.githooks/prepare-commit-msg`)**:
   ```sh
   #!/bin/sh
   exec "$(dirname "$0")/alfazen-version" hook "$@"
   ```
4. **Hook Activation**:
   ```sh
   git config core.hooksPath .githooks
   ```
